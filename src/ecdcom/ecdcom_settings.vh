`ifndef ecdcom_settings_vh
`define ecdcom_settings_vh

// Packet types
localparam  PT_FRAME_DATA = 0;
localparam  PT_COMMAND    = 1;
localparam  PT_UW_DATA    = 2;
localparam  PT_AXI_REQ    = 3;
localparam  PT_AXI_RSP    = 4;

// How wide are each of the frame-data FIFOs?
localparam FIFO_WIDTH = 64;

// How deep are each of the frame-data FIFOs?
localparam FD_FIFO_DEPTH = 2048;

// What kind of RAM are each of the frame-data FIFOS? 
// (should be "block" or "ultra")
localparam FD_FIFO_MEMORY_TYPE = "auto";

// How deep is the outgoing userwave-data FIFO?
localparam UW_FIFO_DEPTH = 512;

// What kind of RAM is the userwave-data FIFO?
// (should be "block" or "ultra")
localparam UW_FIFO_MEMORY_TYPE = "auto";

`endif

