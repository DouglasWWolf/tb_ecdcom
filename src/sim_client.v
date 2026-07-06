

module sim_client
(
    input   clk,
    input   resetn,

    input[31:0] packet_req_cnt,
    input       packet_req_stb,

    output reg[511:0] axis_out0_tdata,
    output            axis_out0_tvalid,
    output            axis_out0_tlast,

    output reg [511:0] axis_out1_tdata,
    output             axis_out1_tvalid,
    output             axis_out1_tlast
);

reg[31:0] total_packets_reqd;
reg[31:0] total_packets_sent;


// Keep track of the total number of packets requested
always @(posedge clk) begin
    if (resetn == 0)
        total_packets_reqd <= 0;
    else if (packet_req_stb)
        total_packets_reqd <= total_packets_reqd + packet_req_cnt;
end


reg         fsm_state;
reg [ 33:0] data0;
reg [ 33:0] data1;
reg [  7:0] cycle;
wire[511:0] le_rdmx_header;

always @* begin
    if (fsm_state == 0) begin
        axis_out0_tdata = 0;
        axis_out1_tdata = 0;
    end
    
    else if (cycle == 0) begin
        axis_out0_tdata = le_rdmx_header;
        axis_out1_tdata = le_rdmx_header;
    end
    
    else begin
        axis_out0_tdata = data0;
        axis_out1_tdata = data1;
    end
end



always @(posedge clk) begin

    if (resetn == 0) begin
        fsm_state          <= 0;
        data0              <= 32'h0000;
        data1              <= 32'h1000;
        total_packets_sent <= 0;
    end 

    else case(fsm_state)

        0:  if (total_packets_sent < total_packets_reqd) begin
                cycle      <= 0;
                fsm_state  <= 1;
            end

        1:  begin
                if (cycle) begin
                    data0 <= data0 + 64;
                    data1 <= data1 + 64;
                end

                if (cycle < 64)
                    cycle <= cycle + 1;
                else begin
                    total_packets_sent <= total_packets_sent + 1;                    
                    data0              <= data0 + 64 + 4096;
                    data1              <= data1 + 64 + 4096;
                    fsm_state          <= 0;
                end
            end

    endcase

end

assign axis_out0_tvalid = (fsm_state == 1);
assign axis_out1_tvalid = (fsm_state == 1);

assign axis_out0_tlast = (fsm_state == 1 && cycle == 64);
assign axis_out1_tlast = (fsm_state == 1 && cycle == 64);


//=============================================================================
// This creates an RDMX header in little-endian order
//=============================================================================
rdmx_encoder # (.SRC_MAC(0)) u_rdmx_encoder
(
    .rdmx_target_addr   (0),
    .rdmx_flags         (0),
    .rdmx_seq_num       (0),
    .rdmx_user_field    (0),
    .rdmx_reserved      (0),
    .payload_length     (0),
    .le_rdmx_header     (le_rdmx_header)
);
//=============================================================================



endmodule
