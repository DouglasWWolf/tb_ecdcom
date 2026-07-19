//=============================================================================
//                  ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 04-Jul-26  DWW     1  Initial creation
//=============================================================================

/*
    Provides control and status registers for an ECD simulator
*/


module ecdcom_ctl # (parameter AW=8)
(
    input clk,
    input resetn,

    // Strobe high to instruct ecdcom_mgr to request enough packets
    // to fill its frame-data FIFOs
    output reg start_stb,

    // Reset ouput control and status
    output reg reset_stb,
    input      reset_done,

    // This is a software controlled reset
    output reg soft_resetn_out,

    // The number of frame-data packets received on each channel
    input[63:0]  fd0_rcvd, fd1_rcvd,

    // If this is asserted, the userwave-data FIFO suffered an overflow
    input       uw_overflow,

    // The number of malformed packets dropped from each QSFP port
    input[31:0] qsfp0_malformed, qsfp1_malformed,

    // Asserted when ecdcom_mgr's frame-data FIFOs are full
    input       fd_fifo_full,

    // When this is asserted, LVDS underflow occured
    input       lvds_underflow,

    // Ethernet link state
    input[1:0] eth_link_state,

    // Output bus for generating userwave-data 
    output reg[31:0]  uw_limit,
    output reg[31:0]  uw_ipg,
    output reg[ 1:0]  uw_start_stb,

    //================== This is an AXI4-Lite slave interface =================
        
    // "Specify write address"              -- Master --    -- Slave --
    input[AW-1:0]                           S_AXI_AWADDR,   
    input                                   S_AXI_AWVALID,  
    input[   2:0]                           S_AXI_AWPROT,
    output                                                  S_AXI_AWREADY,


    // "Write Data"                         -- Master --    -- Slave --
    input[31:0]                             S_AXI_WDATA,      
    input                                   S_AXI_WVALID,
    input[ 3:0]                             S_AXI_WSTRB,
    output                                                  S_AXI_WREADY,

    // "Send Write Response"                -- Master --    -- Slave --
    output[1:0]                                             S_AXI_BRESP,
    output                                                  S_AXI_BVALID,
    input                                   S_AXI_BREADY,

    // "Specify read address"               -- Master --    -- Slave --
    input[AW-1:0]                           S_AXI_ARADDR,     
    input[   2:0]                           S_AXI_ARPROT,     
    input                                   S_AXI_ARVALID,
    output                                                  S_AXI_ARREADY,

    // "Read data back to master"           -- Master --    -- Slave --
    output[31:0]                                            S_AXI_RDATA,
    output                                                  S_AXI_RVALID,
    output[ 1:0]                                            S_AXI_RRESP,
    input                                   S_AXI_RREADY
    //=========================================================================
);  

//=========================  AXI Register Map  ================================
localparam REG_START          = 0;
localparam REG_READY          = 1;
localparam REG_RESET          = 2;
localparam REG_LVDS_UNDERFLOW = 3;
localparam REG_UW_LIMIT       = 4;
localparam REG_UW_IPG         = 5;
localparam REG_UW_START       = 6;
localparam REG_UW_OVERFLOW    = 7;
localparam REG_MALFORMED0     = 8;
localparam REG_MALFORMED1     = 9;
localparam REG_LINK_STATE     = 10;

localparam REG_FD0_RCVD_H     = 16;
localparam REG_FD0_RCVD_L     = 17;
localparam REG_FD1_RCVD_H     = 18;
localparam REG_FD1_RCVD_L     = 19;
//=============================================================================


//=============================================================================
// We'll communicate with the AXI4-Lite Slave core with these signals.
//=============================================================================
// AXI Slave Handler Interface for write requests
wire[  31:0]  ashi_windx;     // Input   Write register-index
wire[AW-1:0]  ashi_waddr;     // Input:  Write-address
wire[  31:0]  ashi_wdata;     // Input:  Write-data
wire          ashi_write;     // Input:  1 = Handle a write request
reg [   1:0]  ashi_wresp;     // Output: Write-response (OKAY, DECERR, SLVERR)
wire          ashi_widle;     // Output: 1 = Write state machine is idle

// AXI Slave Handler Interface for read requests
wire[  31:0]  ashi_rindx;     // Input   Read register-index
wire[AW-1:0]  ashi_raddr;     // Input:  Read-address
wire          ashi_read;      // Input:  1 = Handle a read request
reg [  31:0]  ashi_rdata;     // Output: Read data
reg [   1:0]  ashi_rresp;     // Output: Read-response (OKAY, DECERR, SLVERR);
wire          ashi_ridle;     // Output: 1 = Read state machine is idle
//=============================================================================

// The state of the state-machines that handle AXI4-Lite read and AXI4-Lite write
reg ashi_write_state, ashi_read_state;

// The AXI4 slave state machines are idle when state 0 and "start" signals are low
assign ashi_widle = (ashi_write == 0) && (ashi_write_state == 0);
assign ashi_ridle = (ashi_read  == 0) && (ashi_read_state  == 0);
   
// These are the valid values for ashi_rresp and ashi_wresp
localparam OKAY   = 0;
localparam SLVERR = 2;
localparam DECERR = 3;

//=============================================================================
// Here we're sensing the rising edge of "reset_done"
//=============================================================================
reg prior_reset_done;
always @(posedge clk) prior_reset_done <= reset_done;
wire reset_done_rising_edge = (prior_reset_done == 0) & (reset_done == 1);
//=============================================================================

//=============================================================================
// Keep track of whether ecdcom is currently in reset or is about to be in
// reset
//=============================================================================
reg ecdcom_in_reset;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0)
        ecdcom_in_reset <= 1;
    else if (reset_trigger)
        ecdcom_in_reset <= 1;
    else if (reset_done_rising_edge)
        ecdcom_in_reset <= 0;
end
//=============================================================================


//=============================================================================
// When "reset_trigger" is strobed, a counter begins counting down.  When
// that counter reaches "1" (which it will be at for exactly one clock cycle),
// "reset_stb" is strobed high.
//
// We do this to allow some clock cycles between the time that a register
// write says "reset the system please" and the time that we actually issue
// the reset (by strobing reset_stb).  This delay gives ecdcom an opportunity
// to transmit its AXI write-response message before we reset everything
//=============================================================================
reg      reset_trigger;
reg[9:0] reset_delay_ctr;
//-----------------------------------------------------------------------------
always @(posedge clk) begin

    // Assert reset_stb while we're in reset!
    if (resetn == 0)
        reset_stb <= 1;
    else
        reset_stb <= (reset_delay_ctr == 1);

    if (resetn == 0)
        reset_delay_ctr <= 0;
    else if (reset_trigger)
        reset_delay_ctr <= -1;
    else if (reset_delay_ctr)
        reset_delay_ctr <= reset_delay_ctr - 1;

end
//=============================================================================


//=============================================================================
// Keep track of whether or not ecdcom has been started
//=============================================================================
reg started;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0 || reset_trigger)
        started <= 0;
    else if (start_stb)
        started <= 1;
end
//=============================================================================


//=============================================================================
// This state machine handles AXI4-Lite write requests
//=============================================================================
always @(posedge clk) begin

    start_stb     <= 0;
    reset_trigger <= 0;
    uw_start_stb  <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state  <= 0;
        uw_ipg            <= 64;
        uw_limit          <= 1;
    end

    // Otherwise, we're not in reset...
    else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)
               
                    REG_START:      start_stb     <= (ashi_wdata != 0);
                    REG_RESET:      reset_trigger <= (ashi_wdata != 0);
                    REG_UW_LIMIT:   uw_limit      <= (ashi_wdata == 0) ? 1 : ashi_wdata;
                    REG_UW_IPG:     uw_ipg        <= ashi_wdata;
                    REG_UW_START:   uw_start_stb  <= ashi_wdata;


                    // Writes to any other register are a decode-error
                    default: ashi_wresp <= DECERR;
                endcase
            end

        // Dummy state, doesn't do anything
        1: ashi_write_state <= 0;

    endcase
end
//=============================================================================



//=============================================================================
// World's simplest state machine for handling AXI4-Lite read requests
//=============================================================================
always @(posedge clk) begin

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_read_state <= 0;
    
    // If we're not in reset, and a read-request has occured...        
    end else if (ashi_read) begin
     
        // Assume for the moment that the result will be OKAY
        ashi_rresp <= OKAY;              
        
        // ashi_rindex = index of register to be read
        case (ashi_rindx)
            
            // Allow a read from any valid register                
            REG_START:           ashi_rdata <= started;
            REG_READY:           ashi_rdata <= fd_fifo_full;
            REG_RESET:           ashi_rdata <= ecdcom_in_reset;
            REG_LVDS_UNDERFLOW:  ashi_rdata <= lvds_underflow;
            REG_UW_LIMIT:        ashi_rdata <= uw_limit;
            REG_UW_IPG:          ashi_rdata <= uw_ipg;
            REG_FD0_RCVD_H:      ashi_rdata <= fd0_rcvd[63:32];
            REG_FD0_RCVD_L:      ashi_rdata <= fd0_rcvd[31:00];            
            REG_FD1_RCVD_H:      ashi_rdata <= fd1_rcvd[63:32];
            REG_FD1_RCVD_L:      ashi_rdata <= fd1_rcvd[31:00];   
            REG_UW_OVERFLOW:     ashi_rdata <= uw_overflow;        
            REG_MALFORMED0:      ashi_rdata <= qsfp0_malformed;
            REG_MALFORMED1:      ashi_rdata <= qsfp1_malformed; 
            REG_LINK_STATE:      ashi_rdata <= eth_link_state;

            // Reads of any other register are a decode-error
            default: ashi_rresp <= DECERR;

        endcase
    end
end
//=============================================================================

//=============================================================================
// Here we generate a software controllable reset output that asserts for
// a few cycles any time "reset_stb" goes high
//=============================================================================
reg[5:0] soft_resetn_ctr;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0)
        soft_resetn_ctr <= -1;
    else if (reset_stb)
        soft_resetn_ctr <= -1;
    else if (soft_resetn_ctr)
        soft_resetn_ctr <= soft_resetn_ctr - 1;

    // The external resetn is active while we're counting down
    soft_resetn_out <= (soft_resetn_ctr == 0);
end
//=============================================================================



//=============================================================================
// This connects us to an AXI4-Lite slave core
//=============================================================================
axi4_lite_slave#(.AW(AW)) i_axi4lite_slave
(
    .clk            (clk),
    .resetn         (resetn),
    
    // AXI AW channel
    .AXI_AWADDR     (S_AXI_AWADDR),
    .AXI_AWPROT     (S_AXI_AWPROT),
    .AXI_AWVALID    (S_AXI_AWVALID),   
    .AXI_AWREADY    (S_AXI_AWREADY),
    
    // AXI W channel
    .AXI_WDATA      (S_AXI_WDATA),
    .AXI_WVALID     (S_AXI_WVALID),
    .AXI_WSTRB      (S_AXI_WSTRB),
    .AXI_WREADY     (S_AXI_WREADY),

    // AXI B channel
    .AXI_BRESP      (S_AXI_BRESP),
    .AXI_BVALID     (S_AXI_BVALID),
    .AXI_BREADY     (S_AXI_BREADY),

    // AXI AR channel
    .AXI_ARADDR     (S_AXI_ARADDR), 
    .AXI_ARPROT     (S_AXI_ARPROT),
    .AXI_ARVALID    (S_AXI_ARVALID),
    .AXI_ARREADY    (S_AXI_ARREADY),

    // AXI R channel
    .AXI_RDATA      (S_AXI_RDATA),
    .AXI_RVALID     (S_AXI_RVALID),
    .AXI_RRESP      (S_AXI_RRESP),
    .AXI_RREADY     (S_AXI_RREADY),

    // ASHI write-request registers
    .ASHI_WADDR     (ashi_waddr),
    .ASHI_WINDX     (ashi_windx),
    .ASHI_WDATA     (ashi_wdata),
    .ASHI_WRITE     (ashi_write),
    .ASHI_WRESP     (ashi_wresp),
    .ASHI_WIDLE     (ashi_widle),

    // ASHI read registers
    .ASHI_RADDR     (ashi_raddr),
    .ASHI_RINDX     (ashi_rindx),
    .ASHI_RDATA     (ashi_rdata),
    .ASHI_READ      (ashi_read ),
    .ASHI_RRESP     (ashi_rresp),
    .ASHI_RIDLE     (ashi_ridle)
);
//=============================================================================



endmodule
