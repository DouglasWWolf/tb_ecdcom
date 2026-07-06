//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 04-Jul-26  DWW     1  Initial creation
//====================================================================================

/*
    Provides control and status registers for an LVDS client
*/

module lvds_ctl # (parameter AW=8)
(
    input clk,
    input resetn,

    // The input LVDS bus
    input[511:0]   lvds_in_tdata,
    input          lvds_in_tvalid,
    output         lvds_in_tready,

    // The size of ecd-feeder's host-RAM frame-data buffer
    output reg[63:0] fd_host_size,

    // If this is asserted, the LVDS self-test failed
    input  lvds_error,
    
    // This strobes high reset the self-test mechanisms
    output reg reset_selftest_stb,

    //================== This is an AXI4-Lite slave interface ==================

    // "Specify write address"                      -- Master --    -- Slave --
    (* keep = "true" *) input[AW-1:0]               S_AXI_AWADDR,
    (* keep = "true" *) input                       S_AXI_AWVALID,
    (* keep = "true" *) input[   2:0]               S_AXI_AWPROT,
    (* keep = "true" *) output                                      S_AXI_AWREADY,

    // "Write Data"                                 -- Master --    -- Slave --
    (* keep = "true" *) input[31:0]                 S_AXI_WDATA,
    (* keep = "true" *) input                       S_AXI_WVALID,
    (* keep = "true" *) input[ 3:0]                 S_AXI_WSTRB,
    (* keep = "true" *) output                                      S_AXI_WREADY,

    // "Send Write Response"                        -- Master --    -- Slave --
    (* keep = "true" *) output[1:0]                                 S_AXI_BRESP,
    (* keep = "true" *) output                                      S_AXI_BVALID,
    (* keep = "true" *) input                       S_AXI_BREADY,

    // "Specify read address"                       -- Master --    -- Slave --
    (* keep = "true" *) input[AW-1:0]               S_AXI_ARADDR,
    (* keep = "true" *) input[   2:0]               S_AXI_ARPROT,
    (* keep = "true" *) input                       S_AXI_ARVALID,
    (* keep = "true" *) output                                      S_AXI_ARREADY,

    // "Read data back to master"                   -- Master --    -- Slave --
    (* keep = "true" *) output[31:0]                                S_AXI_RDATA,
    (* keep = "true" *) output                                      S_AXI_RVALID,
    (* keep = "true" *) output[ 1:0]                                S_AXI_RRESP,
    (* keep = "true" *) input                       S_AXI_RREADY
    //==========================================================================
);  

//=========================  AXI Register Map  =============================
localparam REG_ADMIT_PACKETS  = 0;
localparam REG_ADMIT_FRAMES   = 1;
localparam REG_SELFTEST_ERR   = 2;
localparam REG_FD_HOST_SIZE_H = 3;
localparam REG_FD_HOST_SIZE_L = 4;
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

reg       admit_stb;
reg[63:0] admit_limit;
reg[63:0] admit_count;
reg       fsm_state;
always @(posedge clk) begin

    if (resetn == 0)
        admit_count <= 0;
    else begin
        if (admit_count) admit_count <= admit_count - 1;

        if (admit_stb) begin
            admit_count <= admit_limit;
        end
    end
end

assign lvds_in_tready = (admit_count != 0);

//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    admit_stb          <= 0;
    reset_selftest_stb <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state  <= 0;
        fd_host_size      <= 64'h4_0000_0000;
    end

    // Otherwise, we're not in reset...
    else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)

                    REG_FD_HOST_SIZE_H: fd_host_size[63:32] <= ashi_wdata;
                    REG_FD_HOST_SIZE_L: fd_host_size[31:00] <= ashi_wdata;
                    REG_SELFTEST_ERR:   reset_selftest_stb  <= (ashi_wdata == 0);
                    REG_ADMIT_PACKETS: 
                        begin
                            admit_limit <= {ashi_wdata, 6'b0};
                            admit_stb   <= 1;
                        end

                    REG_ADMIT_FRAMES:
                        begin
                            admit_limit <= {ashi_wdata, 16'b0};
                            admit_stb   <= 1;
                        end

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
            REG_ADMIT_PACKETS:  ashi_rdata <= lvds_in_tready;
            REG_ADMIT_FRAMES:   ashi_rdata <= lvds_in_tready;
            REG_SELFTEST_ERR:   ashi_rdata <= lvds_error;
            REG_FD_HOST_SIZE_H: ashi_rdata <= fd_host_size[63:32];
            REG_FD_HOST_SIZE_L: ashi_rdata <= fd_host_size[31:00];

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
