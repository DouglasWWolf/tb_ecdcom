//=============================================================================
//                ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 04-Jul-26  DWW     1  Initial creation
//=============================================================================

/*
    This module manages communications with between the ECD and the ECD-feeder
*/


module ecdcom_mgr
(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF fd_in0:fd_in1:packet_req, ASSOCIATED_RESET resetn" *)
    input clk,
    input resetn,

    // Strobing this high causes the frame-data FIFOs to fill
    input start_stb,

    // This enables the input routers
    output reg enable,

    // If this is asserted, an underflow occured on the LVDS output 
    output lvds_underflow,

    // Input stream from QSFP_0
    input[511:0]        fd_in0_tdata,
    input               fd_in0_tlast,
    input               fd_in0_tvalid,

    // Input stream from QSFP_1
    input[511:0]        fd_in1_tdata,
    input               fd_in1_tlast,
    input               fd_in1_tvalid,

    // We count incoming frame-data packets
    output reg [63:0]   fd0_packet_count, fd1_packet_count,

    // This is asserted when the frame-data FIFOs are both full
    output              fd_fifo_full,

    // We use this output stream to issue packet requests
    output[511:0]       packet_req_tdata,
    output              packet_req_tlast,
    output reg          packet_req_tvalid,

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 lvds_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF lvds_out" *)
    input lvds_clk,

    // The LVDS output stream, synchronous with lvds_clk
    output [511:0]      lvds_out_tdata,
    output              lvds_out_tvalid,
    input               lvds_out_tready     
);

genvar i;

// Bring in various definitions we need
`include "ecdcom_settings.vh"

// The number of payload bytes in a frame-data packet
localparam FD_PAYLOAD_SIZE = 4096;

// There are 64 data-cycles in a frame-data packet
localparam FD_PACKET_CYCLES = FD_PAYLOAD_SIZE / 64;

// This is the number of bytes of frame-data that we request at a time
localparam FRAME_DATA_REQ_SIZE = FD_PAYLOAD_SIZE * 4;

// Synchronous to lvds_clk
wire lvds_resetn;

// We're going to map the two input streams to an array
wire[511:0] fd_in_tdata [0:1];
wire        fd_in_tlast [0:1];
wire        fd_in_tvalid[0:1];

// Map the input stream from QSFP_0 into the array
assign fd_in_tdata [0] = fd_in0_tdata;
assign fd_in_tlast [0] = fd_in0_tlast;
assign fd_in_tvalid[0] = fd_in0_tvalid;

// Map the input stream from QSFP_1 into the array
assign fd_in_tdata [1] = fd_in1_tdata;
assign fd_in_tlast [1] = fd_in1_tlast;
assign fd_in_tvalid[1] = fd_in1_tvalid;

// Declare the input streams to the two frame-data FIFOs
reg [FIFO_WIDTH-1:0] fifo_in_tdata [0:1];
reg                  fifo_in_tvalid[0:1];

// Declare the output streams of the two frame-data FIFOs
wire [FIFO_WIDTH-1:0] fifo_out_tdata [0:1];
wire                  fifo_out_tvalid[0:1];
reg                   fifo_out_tready[0:1];

// One "start of packet" marker for each input stream
reg sop[0:1];

// The input to the LVDS fifo, synchonous to clk
reg[FIFO_WIDTH-1:0] lvds_in_tdata;
reg                 lvds_in_tvalid;
wire                lvds_in_tready;

// How many entries are free in each of the frame-data FIFOs?
reg[31:0] fd_fifo_occy[0:1];

// This strobes high in order to initiate a frame-data request
reg request_group_stb;

//=============================================================================
// Count the number of frame-data packets we receive on each channel
//=============================================================================
always @(posedge clk) begin
    if (resetn == 0) begin
        fd0_packet_count <= 0;
        fd1_packet_count <= 0;
    end

    else begin
        if (fd_in0_tvalid & fd_in0_tlast)
            fd0_packet_count <= fd0_packet_count + 1;

        if (fd_in1_tvalid & fd_in1_tlast)
            fd1_packet_count <= fd1_packet_count + 1;
    end
end
//=============================================================================


//=============================================================================
// Data flows into the two input FIFOS with the RDMX headers stripped out
//=============================================================================
for (i=0; i<2; i=i+1) begin
    always @(posedge clk) begin
        fifo_in_tvalid[i] <= 0;
        if (resetn == 0)
            sop[i] <= 1;
        else if (fd_in_tvalid[i]) begin
            fifo_in_tdata [i] <= fd_in_tdata[i];
            fifo_in_tvalid[i] <= !sop[i];
            sop[i]            <= fd_in_tlast[i];
        end
    end
end
//=============================================================================


//=============================================================================
// This counts data-cycles output on the LVDS bus.  Bit 6 will alternate
// every 64 data-cycles, which is the size of a single packet within one
// of the frame-data FIFOs
//=============================================================================
reg[6:0] lvds_data_cycle;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0)
        lvds_data_cycle <= 0;
    else if (lvds_in_tvalid & lvds_in_tready)
        lvds_data_cycle <= lvds_data_cycle + 1;
end

// This bit alternates between 0 and 1 every 64 data-cycles
wire fifo_select = lvds_data_cycle[6];

// The lvds_in bus is always driven from one of the frame-data FIFOs
always @* begin
    lvds_in_tdata      = fifo_out_tdata [fifo_select];
    lvds_in_tvalid     = fifo_out_tvalid[fifo_select];
    fifo_out_tready[0] = (fifo_select == 0) ? lvds_in_tready : 0;
    fifo_out_tready[1] = (fifo_select == 1) ? lvds_in_tready : 0;
end
//=============================================================================


//=============================================================================
// Here we keep track of the amount of data flowing into the LVDS FIFO.   Every 
// "FRAME_DATA_REQ_SIZE" bytes, we will request another frame-data packet group
//=============================================================================
reg[15:0] lvds_bytes_sent;
//=============================================================================
always @(posedge clk) begin
    
    // This strobes high for a single cycle at a time
    request_group_stb <= 0;
    
    // If we're in reset, we've sent no bytes to the LVDS FIFO
    if (resetn == 0)
        lvds_bytes_sent <= 0;
    
    // Keep track of how many bytes we've sent to the LVDS FIFO,
    // and generate a "request_group_stb" every time FRAME_DATA_REQ_SIZE
    // bytes have been sent to the LVDS FIFO.
    else if (lvds_in_tvalid & lvds_in_tready) begin
        if (lvds_bytes_sent < (FRAME_DATA_REQ_SIZE - 64))
            lvds_bytes_sent <= lvds_bytes_sent + 64;
        else begin
            lvds_bytes_sent   <= 0;
            request_group_stb <= 1;
        end
    end
end
//=============================================================================


//=============================================================================
// Here we keep track of the number of elements in each frame-data FIFO
//=============================================================================
wire   fd_fifo_in_hsk [0:1];
wire   fd_fifo_out_hsk[0:1];
assign fd_fifo_in_hsk [0] = fifo_in_tvalid[0];
assign fd_fifo_in_hsk [1] = fifo_in_tvalid[1];
assign fd_fifo_out_hsk[0] = fifo_out_tvalid[0] & fifo_out_tready[0];
assign fd_fifo_out_hsk[1] = fifo_out_tvalid[1] & fifo_out_tready[1];
//-----------------------------------------------------------------------------
for (i=0; i<2; i=i+1) begin
    always @(posedge clk) begin
        if (resetn == 0)
            fd_fifo_occy[i] <= 0;
        else
            fd_fifo_occy[i] <= fd_fifo_occy   [i]
                             + fd_fifo_in_hsk [i]
                             - fd_fifo_out_hsk[i];
    end
end

// We declare the two frame-data FIFOs full when there is less than a 
// packet's worth of free space in them.  We can't simply compare to 
// "FD_FIFO_DEPTH" because we have to allow for the fact that some of the data
// will "leak out" into the clock-conversion FIFO
assign fd_fifo_full = (fd_fifo_occy[0] > (FD_FIFO_DEPTH - FD_PACKET_CYCLES))
                    & (fd_fifo_occy[1] > (FD_FIFO_DEPTH - FD_PACKET_CYCLES));
                    
//=============================================================================


//=============================================================================
// This state machine sends packet requests
//=============================================================================
reg[31:0] packets_requested;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    packet_req_tvalid <= 0;

    // Do we need to request enough packets to fill both FIFOs?
    if (start_stb && fd_fifo_occy[0] == 0 && fd_fifo_occy[1] == 0) begin
        packets_requested <= FD_FIFO_DEPTH / FD_PACKET_CYCLES;
        packet_req_tvalid <= 1;
    end

    // Do we need to request just a few packets?
    if (request_group_stb) begin
        packets_requested <= FRAME_DATA_REQ_SIZE / (FD_PAYLOAD_SIZE * 2);
        packet_req_tvalid <= 1;
    end

end
assign packet_req_tlast = 1;
//=============================================================================


//=============================================================================
// This creates an RDMX header in little-endian order
//=============================================================================
ecdcom_rdmx_encoder # (.SRC_MAC(0)) u_rdmx_encoder
(
    .rdmx_target_addr   (packets_requested),
    .rdmx_flags         (0),
    .rdmx_seq_num       (0),
    .rdmx_user_field    (PT_COMMAND),
    .rdmx_reserved      (0),
    .payload_length     (0),
    .le_rdmx_header     (packet_req_tdata)
);
//=============================================================================


//=============================================================================
// The fd_in streams aren't enabled until a start_stb happens
//=============================================================================
always @(posedge clk) begin
    if (resetn == 0)
        enable <= 0;
    else if (start_stb)
        enable <= 1;
end
//=============================================================================

//=============================================================================
// This is the frame-data FIFO for QSFP_0
//=============================================================================
xpm_fifo_axis #
(
   .TDATA_WIDTH     (FIFO_WIDTH),
   .FIFO_DEPTH      (FD_FIFO_DEPTH),
   .FIFO_MEMORY_TYPE(FD_FIFO_MEMORY_TYPE),
   .PACKET_FIFO     ("false"),
   .USE_ADV_FEATURES("0000"),
   .CLOCKING_MODE   ("common_clock")
)
i_fd_fifo_0
(
    // Clock and reset
    .s_aclk   (clk   ),
    .m_aclk   (clk   ),
    .s_aresetn(resetn),

    // The input bus of the FIFO
    .s_axis_tdata (fifo_in_tdata [0]),
    .s_axis_tvalid(fifo_in_tvalid[0]),
    .s_axis_tready(                 ),

    // The output bus of the FIFO
    .m_axis_tdata (fifo_out_tdata [0]),
    .m_axis_tvalid(fifo_out_tvalid[0]),
    .m_axis_tready(fifo_out_tready[0]),

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


//=============================================================================
// This is the frame-data FIFO for QSFP_1
//=============================================================================
xpm_fifo_axis #
(
   .TDATA_WIDTH     (FIFO_WIDTH),
   .FIFO_DEPTH      (FD_FIFO_DEPTH),
   .FIFO_MEMORY_TYPE(FD_FIFO_MEMORY_TYPE),
   .PACKET_FIFO     ("false"),
   .USE_ADV_FEATURES("0000"),
   .CLOCKING_MODE   ("common_clock")
)
i_fd_fifo_1
(
    // Clock and reset
    .s_aclk   (clk   ),
    .m_aclk   (clk   ),
    .s_aresetn(resetn),

    // The input bus of the FIFO
    .s_axis_tdata (fifo_in_tdata [1]),
    .s_axis_tvalid(fifo_in_tvalid[1]),
    .s_axis_tready(                 ),

    // The output bus of the FIFO
    .m_axis_tdata (fifo_out_tdata [1]),
    .m_axis_tvalid(fifo_out_tvalid[1]),
    .m_axis_tready(fifo_out_tready[1]),

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



//=============================================================================
// This is the LVDS FIFO that performs clock-crossing from the "clk" doman
// to the "lvds_clk" domain
//=============================================================================
xpm_fifo_axis #
(
   .TDATA_WIDTH     (FIFO_WIDTH),
   .FIFO_DEPTH      (16),
   .FIFO_MEMORY_TYPE("auto"),
   .PACKET_FIFO     ("false"),
   .USE_ADV_FEATURES("0000"),
   .CLOCKING_MODE   ("independent_clock")
)
i_lvds_fifo
(
    // Clock and reset
    .s_aclk   (clk     ),
    .m_aclk   (lvds_clk),
    .s_aresetn(resetn  ),

    // The input bus of the FIFO
    .s_axis_tdata (lvds_in_tdata ),
    .s_axis_tvalid(lvds_in_tvalid),
    .s_axis_tready(lvds_in_tready),

    // The output bus of the FIFO
    .m_axis_tdata (lvds_out_tdata ),
    .m_axis_tvalid(lvds_out_tvalid),
    .m_axis_tready(lvds_out_tready),

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



//=============================================================================
// Create a reset signal that's synchronized to lvds_clk
//=============================================================================
xpm_cdc_async_rst #
(
    .DEST_SYNC_FF(4), .RST_ACTIVE_HIGH(0)           
)
i_sync_resetn_192
(
    .src_arst    (resetn),
    .dest_clk    (lvds_clk),
    .dest_arst   (lvds_resetn)
);
//=============================================================================


//=============================================================================
// Check for the situation where the LVDS output bus is ready for data, but
// there is no data available.   The user of this module will want to know 
// about data starvation
//=============================================================================
reg lvds_underflow_192;
//-----------------------------------------------------------------------------
always @(posedge lvds_clk) begin
    if (lvds_resetn == 0)
        lvds_underflow_192 <= 0;
    else if (lvds_out_tready & !lvds_out_tvalid)
        lvds_underflow_192 <= 1;
end
//=============================================================================



//=============================================================================
// Synchronize "lvds_underflow_192" into "lvds_underflow"
//=============================================================================
xpm_cdc_single #
(
    .DEST_SYNC_FF(4), .SRC_INPUT_REG(0) 
)
i_sync_lvds_underflow
(
    .src_clk    (lvds_clk),
    .src_in     (lvds_underflow_192),
    .dest_clk   (clk),
    .dest_out   (lvds_underflow)
);
//=============================================================================



endmodule