//=============================================================================
//                    ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 20-Jun-26  DWW     1  Initial creation
//=============================================================================

/*
    This handles incoming commands from the ECD
*/


module cmd_handler
(
    input   clk, resetn,

    // This input stream arriving from the CMAC
    input[511:0] axis_in_tdata,
    input        axis_in_tlast,
    input        axis_in_tvalid,
    output       axis_in_tready,

    // We issue a packet request by strobing "packet_req_stb"
    output reg       packet_req_stb,
    output reg[31:0] packet_req_cnt

);

// Bring in the packet-type constants
localparam PT_COMMAND = 1;

// These are decoded from the RDMX header
wire[63:0] rdmx_address;
wire[31:0] rdmx_user_field;

// The command type is stored in the "user_field" in the RDMX header
wire[7:0] cmd_type = rdmx_user_field[7:0];

// State of the state machine
reg fsm_state;

//=============================================================================
// This state machine watches for incoming packets.   
//    Command type is stored in "rdmx_user_field"
// 
//    For command_type "PT_COMMAND":
//        Number of packets being requested is stored in "rdmx_address"
//=============================================================================
always @(posedge clk) begin
    
    packet_req_stb <= 0;

    if (resetn == 0) begin
        fsm_state <= 0;
    end 

    else case(fsm_state)

        // If we have an incoming packet...
        0:  if (axis_in_tvalid & axis_in_tready) begin
                
                // If this packet is a "packet_request" command...
                if (cmd_type == PT_COMMAND) begin
                    packet_req_cnt <= rdmx_address[31:0];
                    packet_req_stb <= 1;
                end

                // If this wasn't the end of the incoming packet, go 
                // wait for and throw away the rest of the packet 
                if (axis_in_tlast == 0) fsm_state <= 1;

            end


        // Here we throw away the rest of the incoming packet
        1:  if (axis_in_tvalid & axis_in_tready & axis_in_tlast)
                fsm_state <= 0;

    endcase

end

// We're ready to receive packets any time we're not in reset
assign axis_in_tready = (resetn == 1);
//=============================================================================


//=============================================================================
// This decode an RDMX header in individual fields
//=============================================================================
rdmx_decoder u_rdmx_decoder
(
    .le_rdmx_header     (axis_in_tdata),
    .is_rdmx            (),        
    .rdmx_address       (rdmx_address),
    .rdmx_flags         (),
    .rdmx_user_field    (rdmx_user_field),
    .payload_bytes      (),
    .payload_cycles     ()
);
//=============================================================================

endmodule



