//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 04-Jul-26  DWW     1  Initial creation
//====================================================================================

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

    //================== This is an AXI4-Lite slave interface ==================
        
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
    //==========================================================================
);  

//=========================  AXI Register Map  =============================
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
//==========================================================================


//==========================================================================
// We'll communicate with the AXI4-Lite Slave core with these signals.
//==========================================================================
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
//==========================================================================

// The state of the state-machines that handle AXI4-Lite read and AXI4-Lite write
reg ashi_write_state, ashi_read_state;

// The AXI4 slave state machines are idle when in state 0 and their "start" signals are low
assign ashi_widle = (ashi_write == 0) && (ashi_write_state == 0);
assign ashi_ridle = (ashi_read  == 0) && (ashi_read_state  == 0);
   
// These are the valid values for ashi_rresp and ashi_wresp
localparam OKAY   = 0;
localparam SLVERR = 2;
localparam DECERR = 3;


//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    start_stb    <= 0;
    reset_stb    <= 0;
    uw_start_stb <= 0;

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
               
                    REG_START:      start_stb    <= (ashi_wdata != 0);
                    REG_RESET:      reset_stb    <= (ashi_wdata != 0);
                    REG_UW_LIMIT:   uw_limit     <= (ashi_wdata == 0) ? 1 : ashi_wdata;
                    REG_UW_IPG:     uw_ipg       <= ashi_wdata;
                    REG_UW_START:   uw_start_stb <= ashi_wdata;


                    // Writes to any other register are a decode-error
                    default: ashi_wresp <= DECERR;
                endcase
            end

        // Dummy state, doesn't do anything
        1: ashi_write_state <= 0;

    endcase
end
//==========================================================================



//==========================================================================
// World's simplest state machine for handling AXI4-Lite read requests
//==========================================================================
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
            REG_START:           ashi_rdata <= 42;
            REG_READY:           ashi_rdata <= fd_fifo_full;
            REG_RESET:           ashi_rdata <= (reset_done) ? 0 : 1;
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
//==========================================================================



//==========================================================================
// This connects us to an AXI4-Lite slave core
//==========================================================================
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
//==========================================================================



endmodule
