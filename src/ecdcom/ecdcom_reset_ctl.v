//=============================================================================
//                ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 04-Jul-26  DWW     1  Initial creation
//=============================================================================

/*
    This module manages resets for the "ecdcom" BDC
*/

module ecdcom_reset_ctl
(
    input   clk,
    input   reset_stb,
    output  resetn_out,
    output  reset_done
);


// We want to hold the CMACs in reset for a moment at power up
// to give their clocks a chance to stabalize
reg[9:0] counter = -1;

// This just manages the countdown counter
always @(posedge clk) begin
    if (reset_stb)
        counter <= 512;
    else if (counter)
        counter <= counter - 1;
end

// resetn_out is asserted during *most* of the countdown.  This gives
// the system a chance to come out of reset before "reset_done" is
// asserted
wire internal_resetn_out = (counter < 32);

// Reset is complete when we're no longer counting down
assign reset_done = (counter == 0 && reset_stb == 0);

// Route the "resetn_out" signal through a buffer for high-fanout routing
BUFG i_bufg
(
   .I(internal_resetn_out),
   .O(resetn_out)
 );

endmodule
