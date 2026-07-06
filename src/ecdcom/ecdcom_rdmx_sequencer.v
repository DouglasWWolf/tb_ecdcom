//=============================================================================
//                    ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 19-Jun-26  DWW    1  Initial
//=============================================================================

/*
    This stamps sequential values in the RDMX "sequence number" field in
    packets that pass through
*/

module ecdcom_rdmx_sequencer # (parameter DW=512)
(
    input               clk, resetn,

    input[DW-1:0]       axis_in_tdata,
    input               axis_in_tvalid,
    input               axis_in_tlast,
    output              axis_in_tready,

    output reg[DW-1:0]  axis_out_tdata,
    output              axis_out_tvalid,
    output              axis_out_tlast,
    input               axis_out_tready
);

//=============================================================================
// This function swaps big-endian to little-endian or vice-versa
//=============================================================================
function [15:0] byte_swap (input [15:0] value);
    byte_swap = {value[7:0], value[15:8]};
endfunction
//=============================================================================


reg       new_packet;
reg[15:0] rdmx_seq_num;

// Connect the output stream to the input stream
assign axis_out_tvalid = axis_in_tvalid;
assign axis_out_tlast  = axis_in_tlast;
assign axis_in_tready  = axis_out_tready;

//=============================================================================
// Here we stamp the rdmx_seq_num into the RDMX packet header on the first
// cycle of every packet
//=============================================================================
always @* begin
    if (new_packet)
        axis_out_tdata = axis_in_tdata | (byte_swap(rdmx_seq_num) << 52*8);
    else
        axis_out_tdata = axis_in_tdata;
end
//=============================================================================


//=============================================================================
// Keep track of when the first cycle of a packet occurs
//=============================================================================
always @(posedge clk) begin
    if (resetn == 0) begin
        rdmx_seq_num <= 1;
        new_packet   <= 1;
    end

    else if (axis_out_tvalid & axis_out_tready) begin
        new_packet   <= axis_out_tlast;
        rdmx_seq_num <= rdmx_seq_num + axis_out_tlast;
    end
end
//=============================================================================


endmodule
