//=============================================================================
//                ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 14-Jun-26  DWW     1  Initial creation
//=============================================================================

/*
    This connects multiple input streams to a single output stream
*/


module ecdcom_axis_mux
(
    input   clk,
    input   resetn,

    input[511:0]    axis_in0_tdata,
    input           axis_in0_tlast,
    input           axis_in0_tvalid,
    output          axis_in0_tready,

    input[511:0]    axis_in1_tdata,
    input           axis_in1_tlast,
    input           axis_in1_tvalid,
    output          axis_in1_tready,

    output[511:0]   axis_out_tdata,
    output          axis_out_tlast,
    output          axis_out_tvalid,
    input           axis_out_tready
);

// We're going to connect the input streams to these arrays
wire[511:0] axis_in_tdata [0:1];
wire        axis_in_tlast [0:1];
wire        axis_in_tvalid[0:1];
reg         axis_in_tready[0:1];

// Connect input stream 0 to the array
assign axis_in_tdata [0] = axis_in0_tdata;
assign axis_in_tlast [0] = axis_in0_tlast;
assign axis_in_tvalid[0] = axis_in0_tvalid;
assign axis_in0_tready = axis_in_tready[0];

// Connect input stream 1 to the array
assign axis_in_tdata [1] = axis_in1_tdata;
assign axis_in_tlast [1] = axis_in1_tlast;
assign axis_in_tvalid[1] = axis_in1_tvalid;
assign axis_in1_tready = axis_in_tready[1];

// There's a slice on our output
reg [511:0] slice_in_tdata ;
reg         slice_in_tlast ;
reg         slice_in_tvalid;
wire        slice_in_tready;


//=============================================================================
// Simple state machine determines which input is connected to the output. Once
// connected, and input remains connected to the output for the duration of 
// the packet
//=============================================================================
reg fsm_state;
reg select;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0) begin
        fsm_state <= 0;
        select    <= 0;
    end
    
    else case(fsm_state)
        0:  if (axis_in_tvalid[0]) begin
                select    <= 0;
                fsm_state <= 1;
            end 

            else if (axis_in_tvalid[1]) begin
                select    <= 1;
                fsm_state <= 1;
            end

        1:  if (axis_in_tvalid[select] & axis_in_tready[select]) begin
                if (axis_in_tlast[select]) fsm_state <= 0;
            end

    endcase

end
//=============================================================================


//=============================================================================
// This connects one of the input buses to the slice, depending on the value
// of "select"
//=============================================================================
always @* begin

    slice_in_tdata  = 0;
    slice_in_tlast  = 0;
    slice_in_tvalid = 0;
    axis_in_tready[0] = 0;
    axis_in_tready[1] = 0;

    if (resetn == 1 && fsm_state == 1) begin
        slice_in_tdata  = axis_in_tdata [select];
        slice_in_tlast  = axis_in_tlast [select];
        slice_in_tvalid = axis_in_tvalid[select];
        axis_in_tready[select] = slice_in_tready;
    end

end
//=============================================================================


//=============================================================================
// This is an AXI-stream slice just before axis_out
//=============================================================================
ecdcom_axis_slice #
(
    .DATA_WIDTH     (512),
    .LAST_ENABLE    (1),
    .USER_ENABLE    (0),
    .USER_WIDTH     (1)
)
i_slice
(
    .clk          (clk),
    .rst          (~resetn),

    .s_axis_tdata (slice_in_tdata ),
    .s_axis_tlast (slice_in_tlast ),
    .s_axis_tvalid(slice_in_tvalid),
    .s_axis_tready(slice_in_tready),
    .s_axis_tkeep (0),
    .s_axis_tuser (0),
    .s_axis_tid   (0),
    .s_axis_tdest (0),

    .m_axis_tdata (axis_out_tdata ),
    .m_axis_tlast (axis_out_tlast ),
    .m_axis_tvalid(axis_out_tvalid),
    .m_axis_tready(axis_out_tready),
    .m_axis_tkeep (),
    .m_axis_tuser (),
    .m_axis_tid   (),
    .m_axis_tdest ()
);
//=============================================================================




endmodule
