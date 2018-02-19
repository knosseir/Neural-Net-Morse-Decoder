// EEM16 - Logic Design
// Design Assignment #3 
// constants3.vh
// Verilog template

`ifndef _constants3_vh_
`define _constants3_vh_

`define THRESHOLD 5

`define CMD_WIDTH 2
`define CMD_CLEAR (`CMD_WIDTH'd0)
`define CMD_SHIFT (`CMD_WIDTH'd1)
`define CMD_LOAD (`CMD_WIDTH'd2)
`define CMD_HOLD (`CMD_WIDTH'd3)

`define STATE_WIDTH 2
`define STATE_DONE (`STATE_WIDTH'd0)
`define STATE_SHIFT (`STATE_WIDTH'd1)
`define STATE_LOAD (`STATE_WIDTH'd2)
`define STATE_HOLD (`STATE_WIDTH'd3)

`endif
