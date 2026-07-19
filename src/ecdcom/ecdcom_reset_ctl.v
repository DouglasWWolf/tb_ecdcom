//=============================================================================
//                ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 04-Jul-26  DWW     1  Initial creation
//=============================================================================

/*
    This module manages resets for the "ecdcom" BDC.

    When a reset is requested, this will halt all communication with the
    CMACs prior to issuing the reset.  We do this because we want to
    ensure that we never send a partial packet to a CMAC
*/

module ecdcom_reset_ctl
(
    input   clk,

    // This is true when the uw_buffer is idle
    input   uw_buffer_halted,

    // Start the system
    input   start_stb,
    
    // Halt the system and reset it
    input   reset_stb,
    
    // Software controllable reset
    output  soft_resetn_out,
    
    // Hardware controlled reset
    output  resetn_out,
    
    // When this is asserted, the reset process is complete
    output  reset_done,

    // This is asserted to make the rest of the system operational
    output reg enable
);


// The system is halted when these components are halted
wire system_halted = uw_buffer_halted;

//=============================================================================
// This is a one-time, at boot, reset generator.  We do this because we want
// to hold the CMACs in reset for a moment at power up to give their clocks
// a chance to stabalize
//=============================================================================
reg[9:0] init_counter = -1;
reg      r_resetn_out = 0;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (init_counter)
        init_counter <= init_counter - 1;
    else
        r_resetn_out <= 1;
end
//=============================================================================


//==========================================================================
// This state machine controls the soft_resetn_out pin.
//
// When a halt-request is recieved (i.e., when reset_stb is strobed), we
// bring the system to a graceful halt before issuing the reset.  We do this
// in order to ensure that no partial packets are sent to the CMACs
//==========================================================================
reg[31:0] reset_counter;
reg       r_soft_resetn_out = 0;
reg[ 1:0] rsm_state;
//--------------------------------------------------------------------------
always @(posedge clk) begin

    if (reset_counter) reset_counter <= reset_counter - 1;

    if (r_resetn_out == 0) begin
        rsm_state         <= 0;
        r_soft_resetn_out <= 0;
    end

    else case(rsm_state)
        0:  begin
                r_soft_resetn_out <= 1;
                reset_counter     <= 1000000;
                rsm_state         <= reset_stb;
            end

        1:  if (system_halted || (reset_counter == 0)) begin
                r_soft_resetn_out <= 0;
                reset_counter     <= 256;
                rsm_state         <= 2;
            end

        2:  if (reset_counter < 32) begin
                r_soft_resetn_out <= 1;
                rsm_state         <= 3;
            end

        3:  if (reset_counter == 0)
                rsm_state <= 0;

    endcase
end

// Reset is complete when the state machine is idle
assign reset_done = (rsm_state == 0 && reset_stb == 0);
//==========================================================================


//==========================================================================
// This manages the "enable" port to tell the rest of the system whether
// or not it is safe to do I/O on the CMACs
//==========================================================================
always @(posedge clk) begin
    if (r_resetn_out == 0)
        enable <= 0;
    else if (reset_stb)
        enable <= 0;
    else if (start_stb)
        enable <= 1;
end
//==========================================================================


// Route the "soft_resetn_out" signal through a buffer for high-fanout routing
BUFG i_bufg_soft_resetn
(
   .I(r_soft_resetn_out),
   .O(soft_resetn_out)
);

// Route the "resetn_out" signal through a buffer for high-fanout routing
BUFG i_bufg_resetn
(
   .I(r_resetn_out),
   .O(resetn_out)
);



endmodule
