//=============================================================================
//                    ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 05-Jul-26  DWW    1  Initial
//=============================================================================

/*
    This accepts incoming data, drops any packets that won't fit into
    the FIFO, and sends the packets out the output stream with RDMX headers
    on them.
*/


module ecdcom_uw_buffer
(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF axis_in:axis_out, ASSOCIATED_RESET resetn" *)
    input   clk,
    input   resetn,

    // Input stream of userwave-data 
    input[511:0]        axis_in_tdata,
    input               axis_in_tlast,
    input               axis_in_tvalid,
    
    // Output stream of RDMX packets containing userwave data
    output reg[511:0]   axis_out_tdata,
    output reg          axis_out_tlast,
    output reg          axis_out_tvalid,
    input               axis_out_tready,

    // If this is asserted, we dropped one or more packets from the FIFO
    output reg          fifo_overflow
);

// Pull in various system configuration definitions
`include "ecdcom_settings.vh"

// The number of data-cycles in a packet payload
localparam PAYLOAD_CYCLES = 64;

// The input bus to the FIFO
reg[511:0]  fifo_in_tdata;
reg         fifo_in_tvalid;

// The output bus from the FIFO
wire[511:0] fifo_out_tdata;
wire        fifo_out_tvalid;
reg         fifo_out_tready;

// Little-endian RDMX header
wire[511:0] le_rdmx_header;

// How many entries in the FIFO are free?
reg[31:0] fifo_free;


//=============================================================================
// This block ensure that "sop" is asserted on the first cycle of every packet.
//=============================================================================
reg waiting_for_sop;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0) begin
        waiting_for_sop <= 1;
    end else if (axis_in_tvalid)
        waiting_for_sop <= axis_in_tlast;
end

wire sop = (axis_in_tvalid & waiting_for_sop);
//=============================================================================


//=============================================================================
// Here we read in data-cycles from an incoming packet and either drop the 
// entire packet, or write the packet payload to the FIFO
//=============================================================================
reg drop_packet;
wire fifo_has_room = (fifo_free >= PAYLOAD_CYCLES);
//-----------------------------------------------------------------------------
always @(posedge clk) begin

    // This will strobe high for a single-cycle at a time
    fifo_in_tvalid <= 0;
    
    // The input to the FIFO comes from our input stream
    fifo_in_tdata <= axis_in_tdata;

    if (resetn == 0) begin
        drop_packet     <= 1;
        fifo_overflow   <= 0;
    end

    // If this is the first data-cycle of the packet, determine whether
    // or not want to keep the packet
    else if (sop) begin
        if (fifo_has_room) begin
            fifo_in_tvalid <= 1;
            drop_packet    <= 0;
        end else begin
            drop_packet    <= 1;
            fifo_overflow  <= 1;
        end
    end
    
    // Here we deal with payload data-cycles
    else if (axis_in_tvalid) begin
        fifo_in_tvalid <= !drop_packet;
    end

end
//=============================================================================


//=============================================================================
// Keep track of how many entries in the FIFO are free
//=============================================================================
always @(posedge clk) begin
    if (resetn == 0) 
        fifo_free <= UW_FIFO_DEPTH;
    else
        fifo_free <= fifo_free - (fifo_in_tvalid)
                               + (fifo_out_tvalid & fifo_out_tready);
end
//=============================================================================

//=============================================================================
// Here we keep track of the data-cycle number coming out of the FIFO
//=============================================================================
reg[7:0] output_cycle;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0) begin
        output_cycle <= 0;
    end 

    else if (axis_out_tvalid & axis_out_tready) begin
        if (output_cycle < PAYLOAD_CYCLES)
            output_cycle <= output_cycle + 1;
        else
            output_cycle <= 0;
    end
end
//=============================================================================


//=============================================================================
// Here we drive the output bus with either an RDMX header or with the
// output of the FIFO
//=============================================================================
always @* begin
   
    // If the FIFO isn't presenting output data...
    if (fifo_out_tvalid == 0) begin
        axis_out_tdata  = 0;
        axis_out_tlast  = 0;
        axis_out_tvalid = 0;
        fifo_out_tready = 0;
    end

    // If the FIFO is presenting output data on cycle 0,
    // we'll output an RDMX header
    else if (output_cycle == 0) begin
        axis_out_tdata  = le_rdmx_header;
        axis_out_tlast  = 0;
        axis_out_tvalid = 1;
        fifo_out_tready = 0;
    end

    // If the FIFO is presenting data on data-cycles 1 thru 64,
    // we output the contents of the FIFO
    else begin
        axis_out_tdata  = fifo_out_tdata;
        axis_out_tlast  = (output_cycle == PAYLOAD_CYCLES);
        axis_out_tvalid = 1;
        fifo_out_tready = axis_out_tready;
    end
end
//=============================================================================


//=============================================================================
// This creates an RDMX header in little-endian order
//=============================================================================
ecdcom_rdmx_encoder # (.SRC_MAC(1)) u_rdmx_encoder
(
    .rdmx_target_addr   (0),
    .rdmx_flags         (0),
    .rdmx_seq_num       (0),
    .rdmx_user_field    (PT_UW_DATA),
    .rdmx_reserved      (0),
    .payload_length     (PAYLOAD_CYCLES * 64),
    .le_rdmx_header     (le_rdmx_header)
);
//=============================================================================


//=============================================================================
// This is the frame-data FIFO for QSFP_0
//=============================================================================
xpm_fifo_axis #
(
   .TDATA_WIDTH     (FIFO_WIDTH),
   .FIFO_DEPTH      (UW_FIFO_DEPTH),
   .FIFO_MEMORY_TYPE(UW_FIFO_MEMORY_TYPE),
   .PACKET_FIFO     ("false"),
   .USE_ADV_FEATURES("0000"),
   .CLOCKING_MODE   ("common_clock")
)
i_uw_fifo
(
    // Clock and reset
    .s_aclk   (clk   ),
    .m_aclk   (clk   ),
    .s_aresetn(resetn),

    // The input bus of the FIFO
    .s_axis_tdata (fifo_in_tdata ),
    .s_axis_tvalid(fifo_in_tvalid),
    .s_axis_tready(              ),

    // The output bus of the FIFO
    .m_axis_tdata (fifo_out_tdata ),
    .m_axis_tvalid(fifo_out_tvalid),
    .m_axis_tready(fifo_out_tready),

    // Unused input stream signals
    .s_axis_tuser(),
    .s_axis_tkeep(),
    .s_axis_tlast(),
    .s_axis_tdest(),
    .s_axis_tid  (),
    .s_axis_tstrb(),

    // Unused output stream signals
    .m_axis_tuser(),
    .m_axis_tdest(),
    .m_axis_tid  (),
    .m_axis_tstrb(),
    .m_axis_tkeep(),
    .m_axis_tlast(),

    // Other unused signals
    .almost_empty_axis (),
    .almost_full_axis  (),
    .dbiterr_axis      (),
    .prog_empty_axis   (),
    .prog_full_axis    (),
    .rd_data_count_axis(),
    .sbiterr_axis      (),
    .wr_data_count_axis(),
    .injectdbiterr_axis(),
    .injectsbiterr_axis()
);
//=============================================================================



endmodule