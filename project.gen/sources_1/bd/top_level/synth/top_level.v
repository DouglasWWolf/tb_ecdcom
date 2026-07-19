//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Sun Jul 19 02:44:36 2026
//Host        : wolf-super-server running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target top_level.bd
//Design      : top_level
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module client_side_imp_QYYH8Y
   (axis_out0_tdata,
    axis_out0_tlast,
    axis_out0_tready,
    axis_out0_tvalid,
    axis_out1_tdata,
    axis_out1_tlast,
    axis_out1_tready,
    axis_out1_tvalid,
    clk,
    resetn,
    tx0_tdata,
    tx0_tlast,
    tx0_tready,
    tx0_tvalid,
    tx1_tdata,
    tx1_tlast,
    tx1_tready,
    tx1_tvalid);
  output [511:0]axis_out0_tdata;
  output axis_out0_tlast;
  input axis_out0_tready;
  output axis_out0_tvalid;
  output [511:0]axis_out1_tdata;
  output axis_out1_tlast;
  input axis_out1_tready;
  output axis_out1_tvalid;
  input clk;
  input resetn;
  input [511:0]tx0_tdata;
  input tx0_tlast;
  output tx0_tready;
  input tx0_tvalid;
  input [511:0]tx1_tdata;
  input tx1_tlast;
  output tx1_tready;
  input tx1_tvalid;

  wire [31:0]cmd_handler_0_packet_req_cnt;
  wire cmd_handler_0_packet_req_stb;
  wire resetn;
  (* CONN_BUS_INFO = "sim_client_axis_out0 xilinx.com:interface:axis:1.0 None TDATA" *) (* DONT_TOUCH *) wire [511:0]sim_client_axis_out0_TDATA;
  (* CONN_BUS_INFO = "sim_client_axis_out0 xilinx.com:interface:axis:1.0 None TLAST" *) (* DONT_TOUCH *) wire sim_client_axis_out0_TLAST;
  (* CONN_BUS_INFO = "sim_client_axis_out0 xilinx.com:interface:axis:1.0 None TREADY" *) (* DONT_TOUCH *) wire sim_client_axis_out0_TREADY;
  (* CONN_BUS_INFO = "sim_client_axis_out0 xilinx.com:interface:axis:1.0 None TVALID" *) (* DONT_TOUCH *) wire sim_client_axis_out0_TVALID;
  (* CONN_BUS_INFO = "sim_client_axis_out1 xilinx.com:interface:axis:1.0 None TDATA" *) (* DONT_TOUCH *) wire [511:0]sim_client_axis_out1_TDATA;
  (* CONN_BUS_INFO = "sim_client_axis_out1 xilinx.com:interface:axis:1.0 None TLAST" *) (* DONT_TOUCH *) wire sim_client_axis_out1_TLAST;
  (* CONN_BUS_INFO = "sim_client_axis_out1 xilinx.com:interface:axis:1.0 None TREADY" *) (* DONT_TOUCH *) wire sim_client_axis_out1_TREADY;
  (* CONN_BUS_INFO = "sim_client_axis_out1 xilinx.com:interface:axis:1.0 None TVALID" *) (* DONT_TOUCH *) wire sim_client_axis_out1_TVALID;
  wire source_100mhz_sys_clk;
  wire [511:0]tx0_tdata;
  wire tx0_tlast;
  wire tx0_tready;
  wire tx0_tvalid;
  (* CONN_BUS_INFO = "tx1_1 xilinx.com:interface:axis:1.0 None TDATA" *) (* DONT_TOUCH *) wire [511:0]tx1_1_TDATA;
  (* CONN_BUS_INFO = "tx1_1 xilinx.com:interface:axis:1.0 None TLAST" *) (* DONT_TOUCH *) wire tx1_1_TLAST;
  (* CONN_BUS_INFO = "tx1_1 xilinx.com:interface:axis:1.0 None TREADY" *) (* DONT_TOUCH *) wire tx1_1_TREADY;
  (* CONN_BUS_INFO = "tx1_1 xilinx.com:interface:axis:1.0 None TVALID" *) (* DONT_TOUCH *) wire tx1_1_TVALID;

  assign axis_out0_tdata[511:0] = sim_client_axis_out0_TDATA;
  assign axis_out0_tlast = sim_client_axis_out0_TLAST;
  assign axis_out0_tvalid = sim_client_axis_out0_TVALID;
  assign axis_out1_tdata[511:0] = sim_client_axis_out1_TDATA;
  assign axis_out1_tlast = sim_client_axis_out1_TLAST;
  assign axis_out1_tvalid = sim_client_axis_out1_TVALID;
  assign sim_client_axis_out0_TREADY = axis_out0_tready;
  assign sim_client_axis_out1_TREADY = axis_out1_tready;
  assign source_100mhz_sys_clk = clk;
  assign tx1_1_TDATA = tx1_tdata[511:0];
  assign tx1_1_TLAST = tx1_tlast;
  assign tx1_1_TVALID = tx1_tvalid;
  assign tx1_tready = tx1_1_TREADY;
  top_level_system_ila_0_4 client_ila
       (.SLOT_0_AXIS_tdata(sim_client_axis_out0_TDATA[0]),
        .SLOT_0_AXIS_tdest(1'b0),
        .SLOT_0_AXIS_tid(1'b0),
        .SLOT_0_AXIS_tkeep(1'b1),
        .SLOT_0_AXIS_tlast(sim_client_axis_out0_TLAST),
        .SLOT_0_AXIS_tready(sim_client_axis_out0_TREADY),
        .SLOT_0_AXIS_tstrb(1'b1),
        .SLOT_0_AXIS_tuser(1'b0),
        .SLOT_0_AXIS_tvalid(sim_client_axis_out0_TVALID),
        .SLOT_1_AXIS_tdata(sim_client_axis_out1_TDATA[0]),
        .SLOT_1_AXIS_tdest(1'b0),
        .SLOT_1_AXIS_tid(1'b0),
        .SLOT_1_AXIS_tkeep(1'b1),
        .SLOT_1_AXIS_tlast(sim_client_axis_out1_TLAST),
        .SLOT_1_AXIS_tready(sim_client_axis_out1_TREADY),
        .SLOT_1_AXIS_tstrb(1'b1),
        .SLOT_1_AXIS_tuser(1'b0),
        .SLOT_1_AXIS_tvalid(sim_client_axis_out1_TVALID),
        .clk(source_100mhz_sys_clk),
        .resetn(1'b0));
  top_level_cmd_handler_0_0 cmd_handler
       (.axis_in_tdata(tx0_tdata),
        .axis_in_tlast(tx0_tlast),
        .axis_in_tready(tx0_tready),
        .axis_in_tvalid(tx0_tvalid),
        .clk(source_100mhz_sys_clk),
        .packet_req_cnt(cmd_handler_0_packet_req_cnt),
        .packet_req_stb(cmd_handler_0_packet_req_stb),
        .resetn(resetn));
  top_level_data_consumer_0_0 data_consumer
       (.AXIS_RX_TDATA(tx1_1_TDATA),
        .AXIS_RX_TKEEP({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .AXIS_RX_TLAST(tx1_1_TLAST),
        .AXIS_RX_TREADY(tx1_1_TREADY),
        .AXIS_RX_TVALID(tx1_1_TVALID),
        .clk(source_100mhz_sys_clk),
        .resetn(resetn));
  top_level_sim_client_0_0 sim_client
       (.axis_out0_tdata(sim_client_axis_out0_TDATA),
        .axis_out0_tlast(sim_client_axis_out0_TLAST),
        .axis_out0_tvalid(sim_client_axis_out0_TVALID),
        .axis_out1_tdata(sim_client_axis_out1_TDATA),
        .axis_out1_tlast(sim_client_axis_out1_TLAST),
        .axis_out1_tvalid(sim_client_axis_out1_TVALID),
        .clk(source_100mhz_sys_clk),
        .packet_req_cnt(cmd_handler_0_packet_req_cnt),
        .packet_req_stb(cmd_handler_0_packet_req_stb),
        .resetn(resetn));
  top_level_system_ila_0_3 uwdata_ila
       (.SLOT_0_AXIS_tdata(tx1_1_TDATA[0]),
        .SLOT_0_AXIS_tdest(1'b0),
        .SLOT_0_AXIS_tid(1'b0),
        .SLOT_0_AXIS_tkeep(1'b1),
        .SLOT_0_AXIS_tlast(tx1_1_TLAST),
        .SLOT_0_AXIS_tready(tx1_1_TREADY),
        .SLOT_0_AXIS_tstrb(1'b1),
        .SLOT_0_AXIS_tuser(1'b0),
        .SLOT_0_AXIS_tvalid(tx1_1_TVALID),
        .clk(source_100mhz_sys_clk),
        .resetn(1'b0));
endmodule

module ecdcom_imp_TQ7XOV
   (axis_in0_tdata,
    axis_in0_tlast,
    axis_in0_tready,
    axis_in0_tvalid,
    axis_in1_tdata,
    axis_in1_tlast,
    axis_in1_tready,
    axis_in1_tvalid,
    clk,
    eth_link_state,
    fd0_packet_count,
    fd1_packet_count,
    fd_fifo_full,
    lvds_clk,
    lvds_out_tdata,
    lvds_out_tready,
    lvds_out_tvalid,
    lvds_underflow,
    packet_req_tdata,
    packet_req_tlast,
    packet_req_tready,
    packet_req_tvalid,
    qsfp0_bad_packets,
    qsfp1_bad_packets,
    reset_done,
    reset_stb,
    start_stb,
    uw_overflow,
    uwdata_in_tdata,
    uwdata_in_tlast,
    uwdata_in_tvalid,
    uwdata_out_tdata,
    uwdata_out_tlast,
    uwdata_out_tready,
    uwdata_out_tvalid);
  input [511:0]axis_in0_tdata;
  input axis_in0_tlast;
  output axis_in0_tready;
  input axis_in0_tvalid;
  input [511:0]axis_in1_tdata;
  input axis_in1_tlast;
  output axis_in1_tready;
  input axis_in1_tvalid;
  input clk;
  output [1:0]eth_link_state;
  output [63:0]fd0_packet_count;
  output [63:0]fd1_packet_count;
  output fd_fifo_full;
  input lvds_clk;
  output [511:0]lvds_out_tdata;
  input lvds_out_tready;
  output lvds_out_tvalid;
  output lvds_underflow;
  output [511:0]packet_req_tdata;
  output packet_req_tlast;
  input packet_req_tready;
  output packet_req_tvalid;
  output [31:0]qsfp0_bad_packets;
  output [31:0]qsfp1_bad_packets;
  output reset_done;
  input reset_stb;
  input start_stb;
  output uw_overflow;
  input [511:0]uwdata_in_tdata;
  input uwdata_in_tlast;
  input uwdata_in_tvalid;
  output [511:0]uwdata_out_tdata;
  output uwdata_out_tlast;
  input uwdata_out_tready;
  output uwdata_out_tvalid;

  wire [511:0]axis_in0_tdata;
  wire axis_in0_tlast;
  wire axis_in0_tready;
  wire axis_in0_tvalid;
  wire [511:0]axis_in1_tdata;
  wire axis_in1_tlast;
  wire axis_in1_tready;
  wire axis_in1_tvalid;
  wire [511:0]bad_packet_filter0_AXIS_OUT_TDATA;
  wire bad_packet_filter0_AXIS_OUT_TLAST;
  wire bad_packet_filter0_AXIS_OUT_TVALID;
  wire [511:0]bad_packet_filter1_AXIS_OUT_TDATA;
  wire bad_packet_filter1_AXIS_OUT_TLAST;
  wire bad_packet_filter1_AXIS_OUT_TVALID;
  wire clk;
  wire [511:0]ecdcom_mgr_packet_req_TDATA;
  wire ecdcom_mgr_packet_req_TLAST;
  wire ecdcom_mgr_packet_req_TREADY;
  wire ecdcom_mgr_packet_req_TVALID;
  wire ecdcom_reset_ctl_enable;
  wire ecdcom_reset_ctl_soft_resetn_out;
  wire [511:0]ecdcom_router_0_axis_fdp_TDATA;
  wire ecdcom_router_0_axis_fdp_TLAST;
  wire ecdcom_router_0_axis_fdp_TVALID;
  wire [511:0]ecdcom_router_1_axis_fdp_TDATA;
  wire ecdcom_router_1_axis_fdp_TLAST;
  wire ecdcom_router_1_axis_fdp_TVALID;
  wire [511:0]ecdcom_uw_buffer_axis_out_TDATA;
  wire ecdcom_uw_buffer_axis_out_TLAST;
  wire ecdcom_uw_buffer_axis_out_TREADY;
  wire ecdcom_uw_buffer_axis_out_TVALID;
  wire ecdcom_uw_buffer_halted;
  wire [1:0]eth_link_state;
  wire [63:0]fd0_packet_count;
  wire [63:0]fd1_packet_count;
  wire fd_fifo_full;
  wire lvds_clk;
  wire [511:0]lvds_out_tdata;
  wire lvds_out_tready;
  wire lvds_out_tvalid;
  wire lvds_underflow;
  wire [0:0]one_dout;
  wire [511:0]packet_req_tdata;
  wire packet_req_tlast;
  wire packet_req_tready;
  wire packet_req_tvalid;
  wire [31:0]qsfp0_bad_packets;
  wire [31:0]qsfp1_bad_packets;
  wire reset_done;
  wire reset_stb;
  wire source_100mhz_sys_resetn;
  wire start_stb;
  wire uw_overflow;
  wire [511:0]uwdata_in_tdata;
  wire uwdata_in_tlast;
  wire uwdata_in_tvalid;
  wire [511:0]uwdata_out_tdata;
  wire uwdata_out_tlast;
  wire uwdata_out_tready;
  wire uwdata_out_tvalid;

  top_level_ecdcom_bad_packet_fi_0_0 bad_packet_filter0
       (.AXIS_IN_TDATA(axis_in0_tdata),
        .AXIS_IN_TKEEP({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .AXIS_IN_TLAST(axis_in0_tlast),
        .AXIS_IN_TREADY(axis_in0_tready),
        .AXIS_IN_TUSER(1'b0),
        .AXIS_IN_TVALID(axis_in0_tvalid),
        .AXIS_OUT_TDATA(bad_packet_filter0_AXIS_OUT_TDATA),
        .AXIS_OUT_TLAST(bad_packet_filter0_AXIS_OUT_TLAST),
        .AXIS_OUT_TREADY(1'b1),
        .AXIS_OUT_TVALID(bad_packet_filter0_AXIS_OUT_TVALID),
        .bad_packet_count(qsfp0_bad_packets),
        .clk(clk),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_bad_packet_fi_1_0 bad_packet_filter1
       (.AXIS_IN_TDATA(axis_in1_tdata),
        .AXIS_IN_TKEEP({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .AXIS_IN_TLAST(axis_in1_tlast),
        .AXIS_IN_TREADY(axis_in1_tready),
        .AXIS_IN_TUSER(1'b0),
        .AXIS_IN_TVALID(axis_in1_tvalid),
        .AXIS_OUT_TDATA(bad_packet_filter1_AXIS_OUT_TDATA),
        .AXIS_OUT_TLAST(bad_packet_filter1_AXIS_OUT_TLAST),
        .AXIS_OUT_TREADY(1'b1),
        .AXIS_OUT_TVALID(bad_packet_filter1_AXIS_OUT_TVALID),
        .bad_packet_count(qsfp1_bad_packets),
        .clk(clk),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_link_state_0_0 ecdcom_link_state
       (.clk(clk),
        .link_state(eth_link_state),
        .rx0_aligned(one_dout),
        .rx1_aligned(one_dout));
  top_level_ecdcom_mgr_0_0 ecdcom_mgr
       (.clk(clk),
        .enable(ecdcom_reset_ctl_enable),
        .fd0_packet_count(fd0_packet_count),
        .fd1_packet_count(fd1_packet_count),
        .fd_fifo_full(fd_fifo_full),
        .fd_in0_tdata(ecdcom_router_0_axis_fdp_TDATA),
        .fd_in0_tlast(ecdcom_router_0_axis_fdp_TLAST),
        .fd_in0_tvalid(ecdcom_router_0_axis_fdp_TVALID),
        .fd_in1_tdata(ecdcom_router_1_axis_fdp_TDATA),
        .fd_in1_tlast(ecdcom_router_1_axis_fdp_TLAST),
        .fd_in1_tvalid(ecdcom_router_1_axis_fdp_TVALID),
        .lvds_clk(lvds_clk),
        .lvds_out_tdata(lvds_out_tdata),
        .lvds_out_tready(lvds_out_tready),
        .lvds_out_tvalid(lvds_out_tvalid),
        .lvds_underflow(lvds_underflow),
        .packet_req_tdata(ecdcom_mgr_packet_req_TDATA),
        .packet_req_tlast(ecdcom_mgr_packet_req_TLAST),
        .packet_req_tready(ecdcom_mgr_packet_req_TREADY),
        .packet_req_tvalid(ecdcom_mgr_packet_req_TVALID),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_rdmx_sequencer_0_0 ecdcom_rdmx_sequencer_0
       (.axis_in_tdata(ecdcom_mgr_packet_req_TDATA),
        .axis_in_tlast(ecdcom_mgr_packet_req_TLAST),
        .axis_in_tready(ecdcom_mgr_packet_req_TREADY),
        .axis_in_tvalid(ecdcom_mgr_packet_req_TVALID),
        .axis_out_tdata(packet_req_tdata),
        .axis_out_tlast(packet_req_tlast),
        .axis_out_tready(packet_req_tready),
        .axis_out_tvalid(packet_req_tvalid),
        .clk(clk),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_rdmx_sequencer_1_0 ecdcom_rdmx_sequencer_1
       (.axis_in_tdata(ecdcom_uw_buffer_axis_out_TDATA),
        .axis_in_tlast(ecdcom_uw_buffer_axis_out_TLAST),
        .axis_in_tready(ecdcom_uw_buffer_axis_out_TREADY),
        .axis_in_tvalid(ecdcom_uw_buffer_axis_out_TVALID),
        .axis_out_tdata(uwdata_out_tdata),
        .axis_out_tlast(uwdata_out_tlast),
        .axis_out_tready(uwdata_out_tready),
        .axis_out_tvalid(uwdata_out_tvalid),
        .clk(clk),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_reset_ctl_0_0 ecdcom_reset_ctl
       (.clk(clk),
        .enable(ecdcom_reset_ctl_enable),
        .reset_done(reset_done),
        .reset_stb(reset_stb),
        .resetn_out(source_100mhz_sys_resetn),
        .soft_resetn_out(ecdcom_reset_ctl_soft_resetn_out),
        .start_stb(start_stb),
        .uw_buffer_halted(ecdcom_uw_buffer_halted));
  top_level_ecdcom_router_0_0 ecdcom_router_0
       (.axis_fdp_tdata(ecdcom_router_0_axis_fdp_TDATA),
        .axis_fdp_tlast(ecdcom_router_0_axis_fdp_TLAST),
        .axis_fdp_tvalid(ecdcom_router_0_axis_fdp_TVALID),
        .axis_in_tdata(bad_packet_filter0_AXIS_OUT_TDATA),
        .axis_in_tlast(bad_packet_filter0_AXIS_OUT_TLAST),
        .axis_in_tvalid(bad_packet_filter0_AXIS_OUT_TVALID),
        .clk(clk),
        .enable(ecdcom_reset_ctl_enable),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_router_1_0 ecdcom_router_1
       (.axis_fdp_tdata(ecdcom_router_1_axis_fdp_TDATA),
        .axis_fdp_tlast(ecdcom_router_1_axis_fdp_TLAST),
        .axis_fdp_tvalid(ecdcom_router_1_axis_fdp_TVALID),
        .axis_in_tdata(bad_packet_filter1_AXIS_OUT_TDATA),
        .axis_in_tlast(bad_packet_filter1_AXIS_OUT_TLAST),
        .axis_in_tvalid(bad_packet_filter1_AXIS_OUT_TVALID),
        .clk(clk),
        .enable(ecdcom_reset_ctl_enable),
        .resetn(source_100mhz_sys_resetn));
  top_level_ecdcom_uw_buffer_0_0 ecdcom_uw_buffer
       (.axis_in_tdata(uwdata_in_tdata),
        .axis_in_tlast(uwdata_in_tlast),
        .axis_in_tvalid(uwdata_in_tvalid),
        .axis_out_tdata(ecdcom_uw_buffer_axis_out_TDATA),
        .axis_out_tlast(ecdcom_uw_buffer_axis_out_TLAST),
        .axis_out_tready(ecdcom_uw_buffer_axis_out_TREADY),
        .axis_out_tvalid(ecdcom_uw_buffer_axis_out_TVALID),
        .clk(clk),
        .enable(ecdcom_reset_ctl_enable),
        .fifo_overflow(uw_overflow),
        .halted(ecdcom_uw_buffer_halted),
        .resetn(source_100mhz_sys_resetn),
        .soft_resetn(ecdcom_reset_ctl_soft_resetn_out));
  assign one_dout = 1'h1;
endmodule

module indy_design_imp_DGP45A
   (ECDCOM_S_AXI_araddr,
    ECDCOM_S_AXI_arprot,
    ECDCOM_S_AXI_arready,
    ECDCOM_S_AXI_arvalid,
    ECDCOM_S_AXI_awaddr,
    ECDCOM_S_AXI_awprot,
    ECDCOM_S_AXI_awready,
    ECDCOM_S_AXI_awvalid,
    ECDCOM_S_AXI_bready,
    ECDCOM_S_AXI_bresp,
    ECDCOM_S_AXI_bvalid,
    ECDCOM_S_AXI_rdata,
    ECDCOM_S_AXI_rready,
    ECDCOM_S_AXI_rresp,
    ECDCOM_S_AXI_rvalid,
    ECDCOM_S_AXI_wdata,
    ECDCOM_S_AXI_wready,
    ECDCOM_S_AXI_wstrb,
    ECDCOM_S_AXI_wvalid,
    LVDS_S_AXI_araddr,
    LVDS_S_AXI_arprot,
    LVDS_S_AXI_arready,
    LVDS_S_AXI_arvalid,
    LVDS_S_AXI_awaddr,
    LVDS_S_AXI_awprot,
    LVDS_S_AXI_awready,
    LVDS_S_AXI_awvalid,
    LVDS_S_AXI_bready,
    LVDS_S_AXI_bresp,
    LVDS_S_AXI_bvalid,
    LVDS_S_AXI_rdata,
    LVDS_S_AXI_rready,
    LVDS_S_AXI_rresp,
    LVDS_S_AXI_rvalid,
    LVDS_S_AXI_wdata,
    LVDS_S_AXI_wready,
    LVDS_S_AXI_wstrb,
    LVDS_S_AXI_wvalid,
    axis_uw_tdata,
    axis_uw_tlast,
    axis_uw_tvalid,
    clk,
    eth_link_state,
    fd0_rcvd,
    fd1_rcvd,
    fd_fifo_full,
    lvds_clk,
    lvds_in_tdata,
    lvds_in_tready,
    lvds_in_tvalid,
    lvds_underflow,
    qsfp0_malformed,
    qsfp1_malformed,
    reset_done,
    reset_stb,
    resetn,
    start_stb,
    uw_overflow);
  input [0:0]ECDCOM_S_AXI_araddr;
  input [2:0]ECDCOM_S_AXI_arprot;
  output ECDCOM_S_AXI_arready;
  input ECDCOM_S_AXI_arvalid;
  input [0:0]ECDCOM_S_AXI_awaddr;
  input [2:0]ECDCOM_S_AXI_awprot;
  output ECDCOM_S_AXI_awready;
  input ECDCOM_S_AXI_awvalid;
  input ECDCOM_S_AXI_bready;
  output [1:0]ECDCOM_S_AXI_bresp;
  output ECDCOM_S_AXI_bvalid;
  output [31:0]ECDCOM_S_AXI_rdata;
  input ECDCOM_S_AXI_rready;
  output [1:0]ECDCOM_S_AXI_rresp;
  output ECDCOM_S_AXI_rvalid;
  input [0:0]ECDCOM_S_AXI_wdata;
  output ECDCOM_S_AXI_wready;
  input [0:0]ECDCOM_S_AXI_wstrb;
  input ECDCOM_S_AXI_wvalid;
  input [0:0]LVDS_S_AXI_araddr;
  input [2:0]LVDS_S_AXI_arprot;
  output LVDS_S_AXI_arready;
  input LVDS_S_AXI_arvalid;
  input [0:0]LVDS_S_AXI_awaddr;
  input [2:0]LVDS_S_AXI_awprot;
  output LVDS_S_AXI_awready;
  input LVDS_S_AXI_awvalid;
  input LVDS_S_AXI_bready;
  output [1:0]LVDS_S_AXI_bresp;
  output LVDS_S_AXI_bvalid;
  output [31:0]LVDS_S_AXI_rdata;
  input LVDS_S_AXI_rready;
  output [1:0]LVDS_S_AXI_rresp;
  output LVDS_S_AXI_rvalid;
  input [0:0]LVDS_S_AXI_wdata;
  output LVDS_S_AXI_wready;
  input [0:0]LVDS_S_AXI_wstrb;
  input LVDS_S_AXI_wvalid;
  output [511:0]axis_uw_tdata;
  output axis_uw_tlast;
  output axis_uw_tvalid;
  input clk;
  input [1:0]eth_link_state;
  input [63:0]fd0_rcvd;
  input [63:0]fd1_rcvd;
  input fd_fifo_full;
  input lvds_clk;
  input [511:0]lvds_in_tdata;
  output lvds_in_tready;
  input lvds_in_tvalid;
  input lvds_underflow;
  input [31:0]qsfp0_malformed;
  input [31:0]qsfp1_malformed;
  input reset_done;
  output reset_stb;
  input resetn;
  output start_stb;
  input uw_overflow;

  wire [0:0]ECDCOM_S_AXI_araddr;
  wire [2:0]ECDCOM_S_AXI_arprot;
  wire ECDCOM_S_AXI_arready;
  wire ECDCOM_S_AXI_arvalid;
  wire [0:0]ECDCOM_S_AXI_awaddr;
  wire [2:0]ECDCOM_S_AXI_awprot;
  wire ECDCOM_S_AXI_awready;
  wire ECDCOM_S_AXI_awvalid;
  wire ECDCOM_S_AXI_bready;
  wire [1:0]ECDCOM_S_AXI_bresp;
  wire ECDCOM_S_AXI_bvalid;
  wire [31:0]ECDCOM_S_AXI_rdata;
  wire ECDCOM_S_AXI_rready;
  wire [1:0]ECDCOM_S_AXI_rresp;
  wire ECDCOM_S_AXI_rvalid;
  wire [0:0]ECDCOM_S_AXI_wdata;
  wire ECDCOM_S_AXI_wready;
  wire [0:0]ECDCOM_S_AXI_wstrb;
  wire ECDCOM_S_AXI_wvalid;
  wire [0:0]LVDS_S_AXI_araddr;
  wire [2:0]LVDS_S_AXI_arprot;
  wire LVDS_S_AXI_arready;
  wire LVDS_S_AXI_arvalid;
  wire [0:0]LVDS_S_AXI_awaddr;
  wire [2:0]LVDS_S_AXI_awprot;
  wire LVDS_S_AXI_awready;
  wire LVDS_S_AXI_awvalid;
  wire LVDS_S_AXI_bready;
  wire [1:0]LVDS_S_AXI_bresp;
  wire LVDS_S_AXI_bvalid;
  wire [31:0]LVDS_S_AXI_rdata;
  wire LVDS_S_AXI_rready;
  wire [1:0]LVDS_S_AXI_rresp;
  wire LVDS_S_AXI_rvalid;
  wire [0:0]LVDS_S_AXI_wdata;
  wire LVDS_S_AXI_wready;
  wire [0:0]LVDS_S_AXI_wstrb;
  wire LVDS_S_AXI_wvalid;
  wire [511:0]axis_uw_tdata;
  wire axis_uw_tlast;
  wire axis_uw_tvalid;
  wire clk;
  wire ecdcom_ctl_soft_resetn_out;
  wire [31:0]ecdcom_ctl_uw_ipg;
  wire [31:0]ecdcom_ctl_uw_limit;
  wire [1:0]ecdcom_ctl_uw_start_stb;
  wire [1:0]eth_link_state;
  wire [63:0]fd0_rcvd;
  wire [63:0]fd1_rcvd;
  wire fd_fifo_full;
  wire lvds_clk_1;
  wire [63:0]lvds_ctl_fd_host_size;
  wire lvds_ctl_reset_selftest_stb;
  (* CONN_BUS_INFO = "lvds_in_1 xilinx.com:interface:axis:1.0 None TDATA" *) (* DONT_TOUCH *) wire [511:0]lvds_in_1_TDATA;
  (* CONN_BUS_INFO = "lvds_in_1 xilinx.com:interface:axis:1.0 None TREADY" *) (* DONT_TOUCH *) wire lvds_in_1_TREADY;
  (* CONN_BUS_INFO = "lvds_in_1 xilinx.com:interface:axis:1.0 None TVALID" *) (* DONT_TOUCH *) wire lvds_in_1_TVALID;
  wire lvds_selftest_error;
  wire [63:0]lvds_selftest_expected_data;
  wire lvds_underflow;
  wire [31:0]qsfp0_malformed;
  wire [31:0]qsfp1_malformed;
  wire reset_done;
  wire reset_stb;
  wire resetn;
  wire start_stb;
  wire uw_overflow;
  wire xpm_cdc_gen_0_dest_arst;

  assign lvds_clk_1 = lvds_clk;
  assign lvds_in_1_TDATA = lvds_in_tdata[511:0];
  assign lvds_in_1_TVALID = lvds_in_tvalid;
  assign lvds_in_tready = lvds_in_1_TREADY;
  top_level_ecdcom_ctl_0_0 ecdcom_ctl
       (.S_AXI_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,ECDCOM_S_AXI_araddr}),
        .S_AXI_ARPROT(ECDCOM_S_AXI_arprot),
        .S_AXI_ARREADY(ECDCOM_S_AXI_arready),
        .S_AXI_ARVALID(ECDCOM_S_AXI_arvalid),
        .S_AXI_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,ECDCOM_S_AXI_awaddr}),
        .S_AXI_AWPROT(ECDCOM_S_AXI_awprot),
        .S_AXI_AWREADY(ECDCOM_S_AXI_awready),
        .S_AXI_AWVALID(ECDCOM_S_AXI_awvalid),
        .S_AXI_BREADY(ECDCOM_S_AXI_bready),
        .S_AXI_BRESP(ECDCOM_S_AXI_bresp),
        .S_AXI_BVALID(ECDCOM_S_AXI_bvalid),
        .S_AXI_RDATA(ECDCOM_S_AXI_rdata),
        .S_AXI_RREADY(ECDCOM_S_AXI_rready),
        .S_AXI_RRESP(ECDCOM_S_AXI_rresp),
        .S_AXI_RVALID(ECDCOM_S_AXI_rvalid),
        .S_AXI_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,ECDCOM_S_AXI_wdata}),
        .S_AXI_WREADY(ECDCOM_S_AXI_wready),
        .S_AXI_WSTRB({1'b1,1'b1,1'b1,ECDCOM_S_AXI_wstrb}),
        .S_AXI_WVALID(ECDCOM_S_AXI_wvalid),
        .clk(clk),
        .eth_link_state(eth_link_state),
        .fd0_rcvd(fd0_rcvd),
        .fd1_rcvd(fd1_rcvd),
        .fd_fifo_full(fd_fifo_full),
        .lvds_underflow(lvds_underflow),
        .qsfp0_malformed(qsfp0_malformed),
        .qsfp1_malformed(qsfp1_malformed),
        .reset_done(reset_done),
        .reset_stb(reset_stb),
        .resetn(resetn),
        .soft_resetn_out(ecdcom_ctl_soft_resetn_out),
        .start_stb(start_stb),
        .uw_ipg(ecdcom_ctl_uw_ipg),
        .uw_limit(ecdcom_ctl_uw_limit),
        .uw_overflow(uw_overflow),
        .uw_start_stb(ecdcom_ctl_uw_start_stb));
  top_level_lvds_ctl_0_0 lvds_ctl
       (.S_AXI_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,LVDS_S_AXI_araddr}),
        .S_AXI_ARPROT(LVDS_S_AXI_arprot),
        .S_AXI_ARREADY(LVDS_S_AXI_arready),
        .S_AXI_ARVALID(LVDS_S_AXI_arvalid),
        .S_AXI_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,LVDS_S_AXI_awaddr}),
        .S_AXI_AWPROT(LVDS_S_AXI_awprot),
        .S_AXI_AWREADY(LVDS_S_AXI_awready),
        .S_AXI_AWVALID(LVDS_S_AXI_awvalid),
        .S_AXI_BREADY(LVDS_S_AXI_bready),
        .S_AXI_BRESP(LVDS_S_AXI_bresp),
        .S_AXI_BVALID(LVDS_S_AXI_bvalid),
        .S_AXI_RDATA(LVDS_S_AXI_rdata),
        .S_AXI_RREADY(LVDS_S_AXI_rready),
        .S_AXI_RRESP(LVDS_S_AXI_rresp),
        .S_AXI_RVALID(LVDS_S_AXI_rvalid),
        .S_AXI_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,LVDS_S_AXI_wdata}),
        .S_AXI_WREADY(LVDS_S_AXI_wready),
        .S_AXI_WSTRB({1'b1,1'b1,1'b1,LVDS_S_AXI_wstrb}),
        .S_AXI_WVALID(LVDS_S_AXI_wvalid),
        .clk(lvds_clk_1),
        .fd_host_size(lvds_ctl_fd_host_size),
        .lvds_error(lvds_selftest_error),
        .lvds_in_tdata(lvds_in_1_TDATA),
        .lvds_in_tready(lvds_in_1_TREADY),
        .lvds_in_tvalid(lvds_in_1_TVALID),
        .reset_selftest_stb(lvds_ctl_reset_selftest_stb),
        .resetn(xpm_cdc_gen_0_dest_arst));
  top_level_system_ila_0_1 lvds_ila
       (.SLOT_0_AXIS_tdata(lvds_in_1_TDATA[0]),
        .SLOT_0_AXIS_tdest(1'b0),
        .SLOT_0_AXIS_tid(1'b0),
        .SLOT_0_AXIS_tkeep(1'b1),
        .SLOT_0_AXIS_tlast(1'b0),
        .SLOT_0_AXIS_tready(lvds_in_1_TREADY),
        .SLOT_0_AXIS_tstrb(1'b1),
        .SLOT_0_AXIS_tuser(1'b0),
        .SLOT_0_AXIS_tvalid(lvds_in_1_TVALID),
        .clk(lvds_clk_1),
        .probe0(lvds_selftest_error),
        .probe1(lvds_selftest_expected_data[0]),
        .resetn(1'b0));
  top_level_lvds_selftest_0_0 lvds_selftest
       (.clk(lvds_clk_1),
        .error(lvds_selftest_error),
        .expected_data(lvds_selftest_expected_data),
        .fd_host_size(lvds_ctl_fd_host_size),
        .lvds_in_tdata(lvds_in_1_TDATA),
        .lvds_in_tready(lvds_in_1_TREADY),
        .lvds_in_tvalid(lvds_in_1_TVALID),
        .reset_selftest_stb(lvds_ctl_reset_selftest_stb),
        .resetn(xpm_cdc_gen_0_dest_arst));
  top_level_xpm_cdc_gen_0_0 resetn_cdc
       (.dest_arst(xpm_cdc_gen_0_dest_arst),
        .dest_clk(lvds_clk_1),
        .src_arst(ecdcom_ctl_soft_resetn_out));
  top_level_uw_xmit_0_0 uw_xmit
       (.axis_uw_tdata(axis_uw_tdata),
        .axis_uw_tlast(axis_uw_tlast),
        .axis_uw_tvalid(axis_uw_tvalid),
        .clk(clk),
        .resetn(resetn),
        .uw_ipg(ecdcom_ctl_uw_ipg),
        .uw_limit(ecdcom_ctl_uw_limit),
        .uw_start_stb(ecdcom_ctl_uw_start_stb));
endmodule

module source_100mhz_imp_MSWE0P
   (clk_in,
    lvds_clk,
    resetn_in,
    sys_clk,
    sys_resetn);
  input clk_in;
  output lvds_clk;
  input resetn_in;
  output sys_clk;
  output [0:0]sys_resetn;

  wire clk_in;
  wire lvds_clk;
  wire resetn_in;
  wire sys_clk;
  wire [0:0]sys_resetn;

  top_level_clk_wiz_0_0 system_clock
       (.clk_100mhz(sys_clk),
        .clk_in1(clk_in),
        .clk_out2(lvds_clk));
  top_level_proc_sys_reset_0_0 system_reset
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(resetn_in),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(sys_resetn),
        .slowest_sync_clk(sys_clk));
endmodule

(* CORE_GENERATION_INFO = "top_level,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=top_level,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=32,numReposBlks=27,numNonXlnxBlks=0,numHierBlks=5,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=18,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=1,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "top_level.hwdef" *) 
module top_level
   (CLK100MHZ,
    CPU_RESETN,
    UART_rxd,
    UART_txd);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK100MHZ, CLK_DOMAIN top_level_CLK100MHZ, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input CLK100MHZ;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.CPU_RESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.CPU_RESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input CPU_RESETN;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART RxD" *) (* X_INTERFACE_MODE = "Master" *) input UART_rxd;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART TxD" *) output UART_txd;

  wire CLK100MHZ;
  wire CPU_RESETN;
  wire LVDS_S_AXI_1_ARADDR;
  wire [2:0]LVDS_S_AXI_1_ARPROT;
  wire LVDS_S_AXI_1_ARREADY;
  wire [0:0]LVDS_S_AXI_1_ARVALID;
  wire LVDS_S_AXI_1_AWADDR;
  wire [2:0]LVDS_S_AXI_1_AWPROT;
  wire LVDS_S_AXI_1_AWREADY;
  wire [0:0]LVDS_S_AXI_1_AWVALID;
  wire [0:0]LVDS_S_AXI_1_BREADY;
  wire [1:0]LVDS_S_AXI_1_BRESP;
  wire LVDS_S_AXI_1_BVALID;
  wire [31:0]LVDS_S_AXI_1_RDATA;
  wire [0:0]LVDS_S_AXI_1_RREADY;
  wire [1:0]LVDS_S_AXI_1_RRESP;
  wire LVDS_S_AXI_1_RVALID;
  wire LVDS_S_AXI_1_WDATA;
  wire LVDS_S_AXI_1_WREADY;
  wire LVDS_S_AXI_1_WSTRB;
  wire [0:0]LVDS_S_AXI_1_WVALID;
  wire Net;
  wire UART_rxd;
  wire UART_txd;
  wire ecdcom_ctl_start_stb;
  wire [1:0]ecdcom_eth_link_state;
  wire [63:0]ecdcom_fd0_packet_count;
  wire [63:0]ecdcom_fd1_packet_count;
  wire ecdcom_lvds_underflow;
  wire ecdcom_mgr_fd_fifo_full;
  wire [511:0]ecdcom_mgr_packet_req_TDATA;
  wire ecdcom_mgr_packet_req_TLAST;
  wire ecdcom_mgr_packet_req_TREADY;
  wire ecdcom_mgr_packet_req_TVALID;
  wire [31:0]ecdcom_qsfp0_bad_packets;
  wire [31:0]ecdcom_qsfp1_bad_packets;
  wire ecdcom_uw_overflow;
  wire [511:0]ecdcom_uwdata_out_TDATA;
  wire ecdcom_uwdata_out_TLAST;
  wire ecdcom_uwdata_out_TREADY;
  wire ecdcom_uwdata_out_TVALID;
  wire [511:0]indy_design_axis_uw_TDATA;
  wire indy_design_axis_uw_TLAST;
  wire indy_design_axis_uw_TVALID;
  wire indy_design_reset_stb;
  wire [511:0]lvds_in_1_TDATA;
  wire lvds_in_1_TREADY;
  wire lvds_in_1_TVALID;
  wire reset_done_1;
  wire [511:0]sim_client_axis_out0_TDATA;
  wire sim_client_axis_out0_TLAST;
  wire sim_client_axis_out0_TREADY;
  wire sim_client_axis_out0_TVALID;
  wire [511:0]sim_client_axis_out1_TDATA;
  wire sim_client_axis_out1_TLAST;
  wire sim_client_axis_out1_TREADY;
  wire sim_client_axis_out1_TVALID;
  wire source_100mhz_sys_clk;
  wire [0:0]source_100mhz_sys_resetn;
  wire system_interconnect_M00_AXI_ARADDR;
  wire [2:0]system_interconnect_M00_AXI_ARPROT;
  wire system_interconnect_M00_AXI_ARREADY;
  wire [0:0]system_interconnect_M00_AXI_ARVALID;
  wire system_interconnect_M00_AXI_AWADDR;
  wire [2:0]system_interconnect_M00_AXI_AWPROT;
  wire system_interconnect_M00_AXI_AWREADY;
  wire [0:0]system_interconnect_M00_AXI_AWVALID;
  wire [0:0]system_interconnect_M00_AXI_BREADY;
  wire [1:0]system_interconnect_M00_AXI_BRESP;
  wire system_interconnect_M00_AXI_BVALID;
  wire [31:0]system_interconnect_M00_AXI_RDATA;
  wire [0:0]system_interconnect_M00_AXI_RREADY;
  wire [1:0]system_interconnect_M00_AXI_RRESP;
  wire system_interconnect_M00_AXI_RVALID;
  wire system_interconnect_M00_AXI_WDATA;
  wire system_interconnect_M00_AXI_WREADY;
  wire system_interconnect_M00_AXI_WSTRB;
  wire [0:0]system_interconnect_M00_AXI_WVALID;
  wire uart_axi_bridge_M_AXI_ARADDR;
  wire [0:0]uart_axi_bridge_M_AXI_ARREADY;
  wire [0:0]uart_axi_bridge_M_AXI_ARVALID;
  wire uart_axi_bridge_M_AXI_AWADDR;
  wire [0:0]uart_axi_bridge_M_AXI_AWREADY;
  wire [0:0]uart_axi_bridge_M_AXI_AWVALID;
  wire [0:0]uart_axi_bridge_M_AXI_BREADY;
  wire [1:0]uart_axi_bridge_M_AXI_BRESP;
  wire [0:0]uart_axi_bridge_M_AXI_BVALID;
  wire uart_axi_bridge_M_AXI_RDATA;
  wire [0:0]uart_axi_bridge_M_AXI_RREADY;
  wire [1:0]uart_axi_bridge_M_AXI_RRESP;
  wire [0:0]uart_axi_bridge_M_AXI_RVALID;
  wire uart_axi_bridge_M_AXI_WDATA;
  wire [0:0]uart_axi_bridge_M_AXI_WREADY;
  wire uart_axi_bridge_M_AXI_WSTRB;
  wire [0:0]uart_axi_bridge_M_AXI_WVALID;

  client_side_imp_QYYH8Y client_side
       (.axis_out0_tdata(sim_client_axis_out0_TDATA),
        .axis_out0_tlast(sim_client_axis_out0_TLAST),
        .axis_out0_tready(sim_client_axis_out0_TREADY),
        .axis_out0_tvalid(sim_client_axis_out0_TVALID),
        .axis_out1_tdata(sim_client_axis_out1_TDATA),
        .axis_out1_tlast(sim_client_axis_out1_TLAST),
        .axis_out1_tready(sim_client_axis_out1_TREADY),
        .axis_out1_tvalid(sim_client_axis_out1_TVALID),
        .clk(source_100mhz_sys_clk),
        .resetn(source_100mhz_sys_resetn),
        .tx0_tdata(ecdcom_mgr_packet_req_TDATA),
        .tx0_tlast(ecdcom_mgr_packet_req_TLAST),
        .tx0_tready(ecdcom_mgr_packet_req_TREADY),
        .tx0_tvalid(ecdcom_mgr_packet_req_TVALID),
        .tx1_tdata(ecdcom_uwdata_out_TDATA),
        .tx1_tlast(ecdcom_uwdata_out_TLAST),
        .tx1_tready(ecdcom_uwdata_out_TREADY),
        .tx1_tvalid(ecdcom_uwdata_out_TVALID));
  ecdcom_imp_TQ7XOV ecdcom
       (.axis_in0_tdata(sim_client_axis_out0_TDATA),
        .axis_in0_tlast(sim_client_axis_out0_TLAST),
        .axis_in0_tready(sim_client_axis_out0_TREADY),
        .axis_in0_tvalid(sim_client_axis_out0_TVALID),
        .axis_in1_tdata(sim_client_axis_out1_TDATA),
        .axis_in1_tlast(sim_client_axis_out1_TLAST),
        .axis_in1_tready(sim_client_axis_out1_TREADY),
        .axis_in1_tvalid(sim_client_axis_out1_TVALID),
        .clk(source_100mhz_sys_clk),
        .eth_link_state(ecdcom_eth_link_state),
        .fd0_packet_count(ecdcom_fd0_packet_count),
        .fd1_packet_count(ecdcom_fd1_packet_count),
        .fd_fifo_full(ecdcom_mgr_fd_fifo_full),
        .lvds_clk(Net),
        .lvds_out_tdata(lvds_in_1_TDATA),
        .lvds_out_tready(lvds_in_1_TREADY),
        .lvds_out_tvalid(lvds_in_1_TVALID),
        .lvds_underflow(ecdcom_lvds_underflow),
        .packet_req_tdata(ecdcom_mgr_packet_req_TDATA),
        .packet_req_tlast(ecdcom_mgr_packet_req_TLAST),
        .packet_req_tready(ecdcom_mgr_packet_req_TREADY),
        .packet_req_tvalid(ecdcom_mgr_packet_req_TVALID),
        .qsfp0_bad_packets(ecdcom_qsfp0_bad_packets),
        .qsfp1_bad_packets(ecdcom_qsfp1_bad_packets),
        .reset_done(reset_done_1),
        .reset_stb(indy_design_reset_stb),
        .start_stb(ecdcom_ctl_start_stb),
        .uw_overflow(ecdcom_uw_overflow),
        .uwdata_in_tdata(indy_design_axis_uw_TDATA),
        .uwdata_in_tlast(indy_design_axis_uw_TLAST),
        .uwdata_in_tvalid(indy_design_axis_uw_TVALID),
        .uwdata_out_tdata(ecdcom_uwdata_out_TDATA),
        .uwdata_out_tlast(ecdcom_uwdata_out_TLAST),
        .uwdata_out_tready(ecdcom_uwdata_out_TREADY),
        .uwdata_out_tvalid(ecdcom_uwdata_out_TVALID));
  indy_design_imp_DGP45A indy_design
       (.ECDCOM_S_AXI_araddr(system_interconnect_M00_AXI_ARADDR),
        .ECDCOM_S_AXI_arprot(system_interconnect_M00_AXI_ARPROT),
        .ECDCOM_S_AXI_arready(system_interconnect_M00_AXI_ARREADY),
        .ECDCOM_S_AXI_arvalid(system_interconnect_M00_AXI_ARVALID),
        .ECDCOM_S_AXI_awaddr(system_interconnect_M00_AXI_AWADDR),
        .ECDCOM_S_AXI_awprot(system_interconnect_M00_AXI_AWPROT),
        .ECDCOM_S_AXI_awready(system_interconnect_M00_AXI_AWREADY),
        .ECDCOM_S_AXI_awvalid(system_interconnect_M00_AXI_AWVALID),
        .ECDCOM_S_AXI_bready(system_interconnect_M00_AXI_BREADY),
        .ECDCOM_S_AXI_bresp(system_interconnect_M00_AXI_BRESP),
        .ECDCOM_S_AXI_bvalid(system_interconnect_M00_AXI_BVALID),
        .ECDCOM_S_AXI_rdata(system_interconnect_M00_AXI_RDATA),
        .ECDCOM_S_AXI_rready(system_interconnect_M00_AXI_RREADY),
        .ECDCOM_S_AXI_rresp(system_interconnect_M00_AXI_RRESP),
        .ECDCOM_S_AXI_rvalid(system_interconnect_M00_AXI_RVALID),
        .ECDCOM_S_AXI_wdata(system_interconnect_M00_AXI_WDATA),
        .ECDCOM_S_AXI_wready(system_interconnect_M00_AXI_WREADY),
        .ECDCOM_S_AXI_wstrb(system_interconnect_M00_AXI_WSTRB),
        .ECDCOM_S_AXI_wvalid(system_interconnect_M00_AXI_WVALID),
        .LVDS_S_AXI_araddr(LVDS_S_AXI_1_ARADDR),
        .LVDS_S_AXI_arprot(LVDS_S_AXI_1_ARPROT),
        .LVDS_S_AXI_arready(LVDS_S_AXI_1_ARREADY),
        .LVDS_S_AXI_arvalid(LVDS_S_AXI_1_ARVALID),
        .LVDS_S_AXI_awaddr(LVDS_S_AXI_1_AWADDR),
        .LVDS_S_AXI_awprot(LVDS_S_AXI_1_AWPROT),
        .LVDS_S_AXI_awready(LVDS_S_AXI_1_AWREADY),
        .LVDS_S_AXI_awvalid(LVDS_S_AXI_1_AWVALID),
        .LVDS_S_AXI_bready(LVDS_S_AXI_1_BREADY),
        .LVDS_S_AXI_bresp(LVDS_S_AXI_1_BRESP),
        .LVDS_S_AXI_bvalid(LVDS_S_AXI_1_BVALID),
        .LVDS_S_AXI_rdata(LVDS_S_AXI_1_RDATA),
        .LVDS_S_AXI_rready(LVDS_S_AXI_1_RREADY),
        .LVDS_S_AXI_rresp(LVDS_S_AXI_1_RRESP),
        .LVDS_S_AXI_rvalid(LVDS_S_AXI_1_RVALID),
        .LVDS_S_AXI_wdata(LVDS_S_AXI_1_WDATA),
        .LVDS_S_AXI_wready(LVDS_S_AXI_1_WREADY),
        .LVDS_S_AXI_wstrb(LVDS_S_AXI_1_WSTRB),
        .LVDS_S_AXI_wvalid(LVDS_S_AXI_1_WVALID),
        .axis_uw_tdata(indy_design_axis_uw_TDATA),
        .axis_uw_tlast(indy_design_axis_uw_TLAST),
        .axis_uw_tvalid(indy_design_axis_uw_TVALID),
        .clk(source_100mhz_sys_clk),
        .eth_link_state(ecdcom_eth_link_state),
        .fd0_rcvd(ecdcom_fd0_packet_count),
        .fd1_rcvd(ecdcom_fd1_packet_count),
        .fd_fifo_full(ecdcom_mgr_fd_fifo_full),
        .lvds_clk(Net),
        .lvds_in_tdata(lvds_in_1_TDATA),
        .lvds_in_tready(lvds_in_1_TREADY),
        .lvds_in_tvalid(lvds_in_1_TVALID),
        .lvds_underflow(ecdcom_lvds_underflow),
        .qsfp0_malformed(ecdcom_qsfp0_bad_packets),
        .qsfp1_malformed(ecdcom_qsfp1_bad_packets),
        .reset_done(reset_done_1),
        .reset_stb(indy_design_reset_stb),
        .resetn(source_100mhz_sys_resetn),
        .start_stb(ecdcom_ctl_start_stb),
        .uw_overflow(ecdcom_uw_overflow));
  source_100mhz_imp_MSWE0P source_100mhz
       (.clk_in(CLK100MHZ),
        .lvds_clk(Net),
        .resetn_in(CPU_RESETN),
        .sys_clk(source_100mhz_sys_clk),
        .sys_resetn(source_100mhz_sys_resetn));
  top_level_smartconnect_0_0 system_interconnect
       (.M00_AXI_araddr(system_interconnect_M00_AXI_ARADDR),
        .M00_AXI_arprot(system_interconnect_M00_AXI_ARPROT),
        .M00_AXI_arready(system_interconnect_M00_AXI_ARREADY),
        .M00_AXI_arvalid(system_interconnect_M00_AXI_ARVALID),
        .M00_AXI_awaddr(system_interconnect_M00_AXI_AWADDR),
        .M00_AXI_awprot(system_interconnect_M00_AXI_AWPROT),
        .M00_AXI_awready(system_interconnect_M00_AXI_AWREADY),
        .M00_AXI_awvalid(system_interconnect_M00_AXI_AWVALID),
        .M00_AXI_bid(1'b0),
        .M00_AXI_bready(system_interconnect_M00_AXI_BREADY),
        .M00_AXI_bresp(system_interconnect_M00_AXI_BRESP),
        .M00_AXI_buser(1'b0),
        .M00_AXI_bvalid(system_interconnect_M00_AXI_BVALID),
        .M00_AXI_rdata(system_interconnect_M00_AXI_RDATA[0]),
        .M00_AXI_rid(1'b0),
        .M00_AXI_rlast(1'b0),
        .M00_AXI_rready(system_interconnect_M00_AXI_RREADY),
        .M00_AXI_rresp(system_interconnect_M00_AXI_RRESP),
        .M00_AXI_ruser(1'b0),
        .M00_AXI_rvalid(system_interconnect_M00_AXI_RVALID),
        .M00_AXI_wdata(system_interconnect_M00_AXI_WDATA),
        .M00_AXI_wready(system_interconnect_M00_AXI_WREADY),
        .M00_AXI_wstrb(system_interconnect_M00_AXI_WSTRB),
        .M00_AXI_wvalid(system_interconnect_M00_AXI_WVALID),
        .M01_AXI_araddr(LVDS_S_AXI_1_ARADDR),
        .M01_AXI_arprot(LVDS_S_AXI_1_ARPROT),
        .M01_AXI_arready(LVDS_S_AXI_1_ARREADY),
        .M01_AXI_arvalid(LVDS_S_AXI_1_ARVALID),
        .M01_AXI_awaddr(LVDS_S_AXI_1_AWADDR),
        .M01_AXI_awprot(LVDS_S_AXI_1_AWPROT),
        .M01_AXI_awready(LVDS_S_AXI_1_AWREADY),
        .M01_AXI_awvalid(LVDS_S_AXI_1_AWVALID),
        .M01_AXI_bid(1'b0),
        .M01_AXI_bready(LVDS_S_AXI_1_BREADY),
        .M01_AXI_bresp(LVDS_S_AXI_1_BRESP),
        .M01_AXI_buser(1'b0),
        .M01_AXI_bvalid(LVDS_S_AXI_1_BVALID),
        .M01_AXI_rdata(LVDS_S_AXI_1_RDATA[0]),
        .M01_AXI_rid(1'b0),
        .M01_AXI_rlast(1'b0),
        .M01_AXI_rready(LVDS_S_AXI_1_RREADY),
        .M01_AXI_rresp(LVDS_S_AXI_1_RRESP),
        .M01_AXI_ruser(1'b0),
        .M01_AXI_rvalid(LVDS_S_AXI_1_RVALID),
        .M01_AXI_wdata(LVDS_S_AXI_1_WDATA),
        .M01_AXI_wready(LVDS_S_AXI_1_WREADY),
        .M01_AXI_wstrb(LVDS_S_AXI_1_WSTRB),
        .M01_AXI_wvalid(LVDS_S_AXI_1_WVALID),
        .S00_AXI_araddr(uart_axi_bridge_M_AXI_ARADDR),
        .S00_AXI_arburst({1'b0,1'b1}),
        .S00_AXI_arcache({1'b0,1'b0,1'b1,1'b1}),
        .S00_AXI_arid(1'b0),
        .S00_AXI_arlen(1'b0),
        .S00_AXI_arlock(1'b0),
        .S00_AXI_arprot({1'b0,1'b0,1'b0}),
        .S00_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arready(uart_axi_bridge_M_AXI_ARREADY),
        .S00_AXI_arregion({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arsize({1'b0,1'b1,1'b0}),
        .S00_AXI_aruser(1'b0),
        .S00_AXI_arvalid(uart_axi_bridge_M_AXI_ARVALID),
        .S00_AXI_awaddr(uart_axi_bridge_M_AXI_AWADDR),
        .S00_AXI_awburst({1'b0,1'b1}),
        .S00_AXI_awcache({1'b0,1'b0,1'b1,1'b1}),
        .S00_AXI_awid(1'b0),
        .S00_AXI_awlen(1'b0),
        .S00_AXI_awlock(1'b0),
        .S00_AXI_awprot({1'b0,1'b0,1'b0}),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(uart_axi_bridge_M_AXI_AWREADY),
        .S00_AXI_awregion({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awsize({1'b0,1'b1,1'b0}),
        .S00_AXI_awuser(1'b0),
        .S00_AXI_awvalid(uart_axi_bridge_M_AXI_AWVALID),
        .S00_AXI_bready(uart_axi_bridge_M_AXI_BREADY),
        .S00_AXI_bresp(uart_axi_bridge_M_AXI_BRESP),
        .S00_AXI_bvalid(uart_axi_bridge_M_AXI_BVALID),
        .S00_AXI_rdata(uart_axi_bridge_M_AXI_RDATA),
        .S00_AXI_rready(uart_axi_bridge_M_AXI_RREADY),
        .S00_AXI_rresp(uart_axi_bridge_M_AXI_RRESP),
        .S00_AXI_rvalid(uart_axi_bridge_M_AXI_RVALID),
        .S00_AXI_wdata(uart_axi_bridge_M_AXI_WDATA),
        .S00_AXI_wid(1'b0),
        .S00_AXI_wlast(1'b0),
        .S00_AXI_wready(uart_axi_bridge_M_AXI_WREADY),
        .S00_AXI_wstrb(uart_axi_bridge_M_AXI_WSTRB),
        .S00_AXI_wuser(1'b0),
        .S00_AXI_wvalid(uart_axi_bridge_M_AXI_WVALID),
        .aclk(source_100mhz_sys_clk),
        .aclk1(Net),
        .aresetn(source_100mhz_sys_resetn));
  uart_axi_bridge_imp_1TNTD43 uart_axi_bridge
       (.M_AXI_araddr(uart_axi_bridge_M_AXI_ARADDR),
        .M_AXI_arready(uart_axi_bridge_M_AXI_ARREADY),
        .M_AXI_arvalid(uart_axi_bridge_M_AXI_ARVALID),
        .M_AXI_awaddr(uart_axi_bridge_M_AXI_AWADDR),
        .M_AXI_awready(uart_axi_bridge_M_AXI_AWREADY),
        .M_AXI_awvalid(uart_axi_bridge_M_AXI_AWVALID),
        .M_AXI_bready(uart_axi_bridge_M_AXI_BREADY),
        .M_AXI_bresp(uart_axi_bridge_M_AXI_BRESP),
        .M_AXI_bvalid(uart_axi_bridge_M_AXI_BVALID),
        .M_AXI_rdata(uart_axi_bridge_M_AXI_RDATA),
        .M_AXI_rready(uart_axi_bridge_M_AXI_RREADY),
        .M_AXI_rresp(uart_axi_bridge_M_AXI_RRESP),
        .M_AXI_rvalid(uart_axi_bridge_M_AXI_RVALID),
        .M_AXI_wdata(uart_axi_bridge_M_AXI_WDATA),
        .M_AXI_wready(uart_axi_bridge_M_AXI_WREADY),
        .M_AXI_wstrb(uart_axi_bridge_M_AXI_WSTRB),
        .M_AXI_wvalid(uart_axi_bridge_M_AXI_WVALID),
        .UART_rxd(UART_rxd),
        .UART_txd(UART_txd),
        .s_axi_aclk(source_100mhz_sys_clk),
        .s_axi_aresetn(source_100mhz_sys_resetn));
endmodule

module uart_axi_bridge_imp_1TNTD43
   (M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    UART_rxd,
    UART_txd,
    s_axi_aclk,
    s_axi_aresetn);
  output M_AXI_araddr;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output M_AXI_awaddr;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input UART_rxd;
  output UART_txd;
  input s_axi_aclk;
  input s_axi_aresetn;

  wire [63:0]\^M_AXI_araddr ;
  wire [0:0]M_AXI_arready;
  wire \^M_AXI_arvalid ;
  wire [63:0]\^M_AXI_awaddr ;
  wire [0:0]M_AXI_awready;
  wire \^M_AXI_awvalid ;
  wire \^M_AXI_bready ;
  wire [1:0]M_AXI_bresp;
  wire [0:0]M_AXI_bvalid;
  wire M_AXI_rdata;
  wire \^M_AXI_rready ;
  wire [1:0]M_AXI_rresp;
  wire [0:0]M_AXI_rvalid;
  wire [31:0]\^M_AXI_wdata ;
  wire [0:0]M_AXI_wready;
  wire [3:0]\^M_AXI_wstrb ;
  wire \^M_AXI_wvalid ;
  wire UART_rxd;
  wire UART_txd;
  wire [31:0]axi_uart_bridge_M_UART_ARADDR;
  wire axi_uart_bridge_M_UART_ARREADY;
  wire axi_uart_bridge_M_UART_ARVALID;
  wire [31:0]axi_uart_bridge_M_UART_AWADDR;
  wire axi_uart_bridge_M_UART_AWREADY;
  wire axi_uart_bridge_M_UART_AWVALID;
  wire axi_uart_bridge_M_UART_BREADY;
  wire [1:0]axi_uart_bridge_M_UART_BRESP;
  wire axi_uart_bridge_M_UART_BVALID;
  wire [31:0]axi_uart_bridge_M_UART_RDATA;
  wire axi_uart_bridge_M_UART_RREADY;
  wire [1:0]axi_uart_bridge_M_UART_RRESP;
  wire axi_uart_bridge_M_UART_RVALID;
  wire [31:0]axi_uart_bridge_M_UART_WDATA;
  wire axi_uart_bridge_M_UART_WREADY;
  wire [3:0]axi_uart_bridge_M_UART_WSTRB;
  wire axi_uart_bridge_M_UART_WVALID;
  wire axi_uartlite_interrupt;
  wire s_axi_aclk;
  wire s_axi_aresetn;

  assign M_AXI_araddr = \^M_AXI_araddr [0];
  assign M_AXI_arvalid[0] = \^M_AXI_arvalid ;
  assign M_AXI_awaddr = \^M_AXI_awaddr [0];
  assign M_AXI_awvalid[0] = \^M_AXI_awvalid ;
  assign M_AXI_bready[0] = \^M_AXI_bready ;
  assign M_AXI_rready[0] = \^M_AXI_rready ;
  assign M_AXI_wdata = \^M_AXI_wdata [0];
  assign M_AXI_wstrb = \^M_AXI_wstrb [0];
  assign M_AXI_wvalid[0] = \^M_AXI_wvalid ;
  top_level_axi_uart_bridge_0_0 axi_uart_bridge
       (.M_AXI_ARADDR(\^M_AXI_araddr ),
        .M_AXI_ARREADY(M_AXI_arready),
        .M_AXI_ARVALID(\^M_AXI_arvalid ),
        .M_AXI_AWADDR(\^M_AXI_awaddr ),
        .M_AXI_AWREADY(M_AXI_awready),
        .M_AXI_AWVALID(\^M_AXI_awvalid ),
        .M_AXI_BREADY(\^M_AXI_bready ),
        .M_AXI_BRESP(M_AXI_bresp),
        .M_AXI_BVALID(M_AXI_bvalid),
        .M_AXI_RDATA({M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata,M_AXI_rdata}),
        .M_AXI_RREADY(\^M_AXI_rready ),
        .M_AXI_RRESP(M_AXI_rresp),
        .M_AXI_RVALID(M_AXI_rvalid),
        .M_AXI_WDATA(\^M_AXI_wdata ),
        .M_AXI_WREADY(M_AXI_wready),
        .M_AXI_WSTRB(\^M_AXI_wstrb ),
        .M_AXI_WVALID(\^M_AXI_wvalid ),
        .M_UART_ARADDR(axi_uart_bridge_M_UART_ARADDR),
        .M_UART_ARREADY(axi_uart_bridge_M_UART_ARREADY),
        .M_UART_ARVALID(axi_uart_bridge_M_UART_ARVALID),
        .M_UART_AWADDR(axi_uart_bridge_M_UART_AWADDR),
        .M_UART_AWREADY(axi_uart_bridge_M_UART_AWREADY),
        .M_UART_AWVALID(axi_uart_bridge_M_UART_AWVALID),
        .M_UART_BREADY(axi_uart_bridge_M_UART_BREADY),
        .M_UART_BRESP(axi_uart_bridge_M_UART_BRESP),
        .M_UART_BVALID(axi_uart_bridge_M_UART_BVALID),
        .M_UART_RDATA(axi_uart_bridge_M_UART_RDATA),
        .M_UART_RREADY(axi_uart_bridge_M_UART_RREADY),
        .M_UART_RRESP(axi_uart_bridge_M_UART_RRESP),
        .M_UART_RVALID(axi_uart_bridge_M_UART_RVALID),
        .M_UART_WDATA(axi_uart_bridge_M_UART_WDATA),
        .M_UART_WREADY(axi_uart_bridge_M_UART_WREADY),
        .M_UART_WSTRB(axi_uart_bridge_M_UART_WSTRB),
        .M_UART_WVALID(axi_uart_bridge_M_UART_WVALID),
        .UART_INT(axi_uartlite_interrupt),
        .aclk(s_axi_aclk),
        .aresetn(s_axi_aresetn));
  top_level_axi_uartlite_0_0 axi_uartlite
       (.interrupt(axi_uartlite_interrupt),
        .rx(UART_rxd),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(axi_uart_bridge_M_UART_ARADDR[3:0]),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(axi_uart_bridge_M_UART_ARREADY),
        .s_axi_arvalid(axi_uart_bridge_M_UART_ARVALID),
        .s_axi_awaddr(axi_uart_bridge_M_UART_AWADDR[3:0]),
        .s_axi_awready(axi_uart_bridge_M_UART_AWREADY),
        .s_axi_awvalid(axi_uart_bridge_M_UART_AWVALID),
        .s_axi_bready(axi_uart_bridge_M_UART_BREADY),
        .s_axi_bresp(axi_uart_bridge_M_UART_BRESP),
        .s_axi_bvalid(axi_uart_bridge_M_UART_BVALID),
        .s_axi_rdata(axi_uart_bridge_M_UART_RDATA),
        .s_axi_rready(axi_uart_bridge_M_UART_RREADY),
        .s_axi_rresp(axi_uart_bridge_M_UART_RRESP),
        .s_axi_rvalid(axi_uart_bridge_M_UART_RVALID),
        .s_axi_wdata(axi_uart_bridge_M_UART_WDATA),
        .s_axi_wready(axi_uart_bridge_M_UART_WREADY),
        .s_axi_wstrb(axi_uart_bridge_M_UART_WSTRB),
        .s_axi_wvalid(axi_uart_bridge_M_UART_WVALID),
        .tx(UART_txd));
endmodule
