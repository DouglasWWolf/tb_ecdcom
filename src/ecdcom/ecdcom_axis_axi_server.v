//=============================================================================
//                ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 11-Jul-26  DWW     1  Initial creation
//=============================================================================

/*
    This is an AXI4-Lite master, intended to be connected to a CMAC
*/

module ecdcom_axis_axi_server # (parameter DW=32, AW=32)
(
    (* X_INTERFACE_INFO      = "xilinx.com:signal:clock:1.0 clk CLK"           *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET resetn, ASSOCIATED_BUSIF axis_in:axis_out:M_AXI" *)
    input   clk,
    input   resetn,

    // AXI read/write requests arrive on this stream
    input[511:0]    axis_in_tdata,
    input           axis_in_tvalid,
    input           axis_in_tlast,

    // AXI read/write responses are emitted on this stream
    output[511:0]   axis_out_tdata,
    output          axis_out_tlast,
    output          axis_out_tvalid,
    input           axis_out_tready,


    //====================  An AXI-Lite Master Interface  =====================
    // "Specify write address"          -- Master --    -- Slave --
    output [AW-1:0]                     M_AXI_AWADDR,
    output                              M_AXI_AWVALID,
    output    [2:0]                     M_AXI_AWPROT,
    input                                               M_AXI_AWREADY,

    // "Write Data"                     -- Master --    -- Slave --
    output [DW-1:0]                     M_AXI_WDATA,
    output [DW/8-1:0]                   M_AXI_WSTRB,
    output                              M_AXI_WVALID,
    input                                               M_AXI_WREADY,

    // "Send Write Response"            -- Master --    -- Slave --
    input  [1:0]                                        M_AXI_BRESP,
    input                                               M_AXI_BVALID,
    output                              M_AXI_BREADY,

    // "Specify read address"           -- Master --    -- Slave --
    output [AW-1:0]                     M_AXI_ARADDR,
    output [   2:0]                     M_AXI_ARPROT,
    output                              M_AXI_ARVALID,
    input                                               M_AXI_ARREADY,

    // "Read data back to master"       -- Master --    -- Slave --
    input [DW-1:0]                                      M_AXI_RDATA,
    input                                               M_AXI_RVALID,
    input [1:0]                                         M_AXI_RRESP,
    output                              M_AXI_RREADY
    //=========================================================================
);

// Bring in the packet-types
`include "ecdcom_settings.vh"

//==================  The AXI Master Control Interface  =======================
// AMCI signals for performing AXI writes
reg [AW-1:0]  AMCI_WADDR;
reg [DW-1:0]  AMCI_WDATA;
reg           AMCI_WRITE;
wire[   1:0]  AMCI_WRESP;
wire          AMCI_WIDLE;

// AMCI signals for performing AXI reads
reg [AW-1:0]  AMCI_RADDR;
reg           AMCI_READ ;
wire[DW-1:0]  AMCI_RDATA;
wire[   1:0]  AMCI_RRESP;
wire          AMCI_RIDLE;
//=============================================================================

localparam[7:0] AXI_WR = 1;
localparam[7:0] AXI_RD = 0;

//=============================================================================
// This watches for incoming packets (they should be of type PT_AXI_REQ),
// issues the corresponding AXI transaction, and sends the result on "axis_out"
//=============================================================================
localparam FSM_WAIT_MESSAGE = 0;
localparam FSM_START_WRITE  = 1;
localparam FSM_WAIT_WRITE   = 2;
localparam FSM_START_READ   = 3;
localparam FSM_WAIT_READ    = 4;
localparam FSM_RESPOND      = 5;
reg [ 2:0] fsm_state;
reg [31:0] addr, wdata, rdata;
reg [ 1:0] resp;
wire[63:0] in_rdmx_address;
wire[31:0] in_rdmx_user_field;
wire[ 7:0] in_pkt_type, in_axi_type;
reg [ 7:0] axi_req_type;
//-----------------------------------------------------------------------------

always @(posedge clk) begin

    // These strobe high for a single cycle at a time
    AMCI_READ  <= 0;
    AMCI_WRITE <= 0;

    if (resetn == 0) begin
        fsm_state <= 0;
    end

    else case(fsm_state)

        // If we have an incoming packet...
        FSM_WAIT_MESSAGE:
            if (axis_in_tvalid && axis_in_tlast && in_pkt_type == PT_AXI_REQ) begin
                addr         <= in_rdmx_address[31:0];
                wdata        <= in_rdmx_address[63:32];
                axi_req_type <= in_axi_type;
                if (in_axi_type[0] == AXI_WR)
                    fsm_state <= FSM_START_WRITE;
                else
                    fsm_state <= FSM_START_READ;
            end

        FSM_START_WRITE:
            if (AMCI_WIDLE) begin
                AMCI_WADDR <= addr;
                AMCI_WDATA <= wdata;
                AMCI_WRITE <= 1;                
                fsm_state  <= FSM_WAIT_WRITE;
            end

        FSM_WAIT_WRITE:
            if (AMCI_WIDLE) begin
                resp      <= AMCI_WRESP;
                rdata     <= 32'hDEAD_DEAD;
                fsm_state <= FSM_RESPOND;
            end

        FSM_START_READ:
            if (AMCI_RIDLE) begin
                AMCI_RADDR <= addr;
                AMCI_READ  <= 1;                
                fsm_state  <= FSM_WAIT_READ;
            end

        FSM_WAIT_READ:
            if (AMCI_RIDLE) begin
                resp      <= AMCI_RRESP;
                rdata     <= (AMCI_RRESP) ? 32'hDEAD_DEAD : AMCI_RDATA;
                fsm_state <= FSM_RESPOND;
            end

        FSM_RESPOND:
            if (axis_out_tvalid & axis_out_tready)
                fsm_state <= FSM_WAIT_MESSAGE;

    endcase

end

assign axis_out_tlast = 1;
assign axis_out_tvalid = (fsm_state == FSM_RESPOND);
//=============================================================================






//=============================================================================
// This decode an RDMX header in individual fields
//=============================================================================
ecdcom_rdmx_decoder u_rdmx_decoder
(
    .le_rdmx_header     (axis_in_tdata),
    .is_rdmx            (),
    .rdmx_address       (in_rdmx_address),
    .rdmx_flags         (),
    .rdmx_user_field    ({in_axi_type, in_pkt_type}),
    .payload_bytes      (),
    .payload_cycles     ()
);
//=============================================================================


//=============================================================================
// This creates an RDMX header in little-endian order
//=============================================================================
ecdcom_rdmx_encoder # (.SRC_MAC(0)) u_rdmx_encoder
(
    .rdmx_target_addr   ({rdata, 30'b0, resp}),
    .rdmx_flags         (0),
    .rdmx_seq_num       (0),
    .rdmx_user_field    ({axi_req_type, PT_AXI_RSP[7:0]}),
    .rdmx_reserved      (0),
    .payload_length     (0),
    .le_rdmx_header     (axis_out_tdata)
);
//=============================================================================





//=============================================================================
// This instantiates an AXI4-Lite master
//=============================================================================
ecdcom_axi4_lite_master # (.DW(DW), .AW(AW)) axi4_master
(
    // Clock and reset
    .clk            (clk),
    .resetn         (resetn),

    // AXI Master Control Interface for performing writes
    .AMCI_WADDR     (AMCI_WADDR),
    .AMCI_WDATA     (AMCI_WDATA),
    .AMCI_WRITE     (AMCI_WRITE),
    .AMCI_WRESP     (AMCI_WRESP),
    .AMCI_WIDLE     (AMCI_WIDLE),

    // AXI Master Control Interface for performing reads
    .AMCI_RADDR     (AMCI_RADDR),
    .AMCI_READ      (AMCI_READ ),
    .AMCI_RDATA     (AMCI_RDATA),
    .AMCI_RRESP     (AMCI_RRESP),
    .AMCI_RIDLE     (AMCI_RIDLE),

    // AXI4-Lite AW channel
    .AXI_AWADDR     (M_AXI_AWADDR ),
    .AXI_AWVALID    (M_AXI_AWVALID),
    .AXI_AWPROT     (M_AXI_AWPROT ),
    .AXI_AWREADY    (M_AXI_AWREADY),

    // AXI4-Lite W channel
    .AXI_WDATA      (M_AXI_WDATA  ),
    .AXI_WSTRB      (M_AXI_WSTRB  ),
    .AXI_WVALID     (M_AXI_WVALID ),
    .AXI_WREADY     (M_AXI_WREADY ),

    // AXI4-Lite B channel
    .AXI_BRESP      (M_AXI_BRESP  ),
    .AXI_BVALID     (M_AXI_BVALID ),
    .AXI_BREADY     (M_AXI_BREADY ),

    // AXI4-Lite AR channel
    .AXI_ARADDR     (M_AXI_ARADDR ),
    .AXI_ARPROT     (M_AXI_ARPROT ),
    .AXI_ARVALID    (M_AXI_ARVALID),
    .AXI_ARREADY    (M_AXI_ARREADY),

    // AXI4-Lite R channel
    .AXI_RDATA      (M_AXI_RDATA  ),
    .AXI_RVALID     (M_AXI_RVALID ),
    .AXI_RRESP      (M_AXI_RRESP  ),
    .AXI_RREADY     (M_AXI_RREADY )
);
//=============================================================================

endmodule
