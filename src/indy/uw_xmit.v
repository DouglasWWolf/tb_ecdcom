module uw_xmit
(
    input   clk, resetn,

    input[1:0]  uw_start_stb,

    input[31:0] uw_limit,

    input[31:0] uw_ipg,

    // This is the output stream for simulated userwave-data packets
    output [511:0] axis_uw_tdata,
    output         axis_uw_tlast,
    output         axis_uw_tvalid
    
);


//=============================================================================
// Here we send the requested number of uw-packets with an RDMX header prefixed
// to each one
//=============================================================================
reg [ 1:0] uwsm_state;
reg [ 6:0] uw_cycle;
reg [31:0] uw_sent;
reg [31:0] uw_data;
reg [31:0] uw_ipg_counter;

//-----------------------------------------------------------------------------
always @(posedge clk) begin

    if (resetn == 0) begin
        uw_sent    <= 0;
        uw_data    <= 0;
        uwsm_state <= 0;
    end

    else case(uwsm_state)
    
        0:  if (uw_start_stb && uw_limit > 0) begin
                uw_sent    <= 1;
                uw_data    <= (uw_start_stb == 1) ? 0 : uw_data;
                uw_cycle   <= 1;
                uwsm_state <= 1;
            end


        // Send the packet payload
        1:  if (axis_uw_tvalid) begin
                uw_data <= uw_data + 1;
                if (uw_cycle < 64)
                    uw_cycle <= uw_cycle + 1;
                else if (uw_sent == uw_limit)
                     uwsm_state <= 0;
                else begin
                    uw_sent   <= uw_sent + 1;
                    uw_cycle  <= 1;
                    if (uw_ipg) begin
                        uw_ipg_counter <= uw_ipg - 1;
                        uwsm_state     <= 2;
                    end
                end
            end

        // Here we are just wasting cycles to create an inter-packet gap
        2:  if (uw_ipg_counter == 0) 
                uwsm_state <= 1;
            else
                uw_ipg_counter <= uw_ipg_counter - 1;

    endcase
end

assign axis_uw_tdata  = {16{uw_data}};
assign axis_uw_tvalid = (uwsm_state == 1);
assign axis_uw_tlast  = (uw_cycle == 64);
//=============================================================================




endmodule