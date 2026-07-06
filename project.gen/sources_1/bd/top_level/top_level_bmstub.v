// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module top_level (
  UART_rxd,
  UART_txd,
  CLK100MHZ,
  CPU_RESETN
);

  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART RxD" *)
  (* X_INTERFACE_MODE = "master UART" *)
  input UART_rxd;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART TxD" *)
  output UART_txd;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK100MHZ CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.CLK100MHZ" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK100MHZ, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN top_level_CLK100MHZ, INSERT_VIP 0" *)
  input CLK100MHZ;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.CPU_RESETN RST" *)
  (* X_INTERFACE_MODE = "slave RST.CPU_RESETN" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.CPU_RESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
  input CPU_RESETN;

  // stub module has no contents

endmodule
