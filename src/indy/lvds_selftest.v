
//=============================================================================
//                ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 05-Jul-26  DWW     1  Initial creation
//=============================================================================

/*
    This module performs self-test on the data arriving on the LVDS bus
*/


module lvds_selftest
(
    input   clk,
    input   resetn,

    // On any given clock-cycle, this is the data we expect to see
    output[63:0] expected_data,

    // The size of the frame-data buffer in host-RAM.  We need this
    // to accurately compute the simulation-data that we expect
    // to see.
    input[63:0] fd_host_size,

    // When this strobes high, we clear the error 
    input reset_selftest_stb,

    // Error flag
    output reg error,

    (* X_INTERFACE_MODE = "monitor" *)
    input[511:0] lvds_in_tdata,
    input        lvds_in_tvalid,
    input        lvds_in_tready
);

// This is the address of the last 64-byte word in this bank
wire[63:0] last_offset = fd_host_size - 64;

// This is the simulation data that we expect to see on the input stream
reg[63:0] sim_data, next_sim_data;

// This is the handshake on "lvds_in"
wire lvds_in_hsk = lvds_in_tvalid & lvds_in_tready;

//=============================================================================
// This computes the *next* value for "sim_data"
//=============================================================================
always @* begin
    if (sim_data == last_offset)
        next_sim_data = 0;
    else
        next_sim_data = sim_data + 64;
end
//=============================================================================


//=============================================================================
// sim_data always holds the RAM offset of the next data-cycle to be returned
// from host-RAM. 
//=============================================================================
always @(posedge clk) begin
    if (resetn == 0 || reset_selftest_stb)
        sim_data <= 0;
    else if (lvds_in_hsk)
        sim_data <= next_sim_data;
end
//=============================================================================

//=============================================================================
// Here we monitor for the condition where we don't see the expected data
// on the LVDS bus
//=============================================================================
always @(posedge clk) begin
    if (resetn == 0 || reset_selftest_stb)
        error <= 0;
    else if (lvds_in_hsk && lvds_in_tdata[63:0] != sim_data)
        error <= 1;
end
//=============================================================================

// Tell the outside world what data we expected to see
assign expected_data = sim_data;

endmodule



