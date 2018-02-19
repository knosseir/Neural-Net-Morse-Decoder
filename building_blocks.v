// EEM16 - Logic Design
// Design Assignment #3 - Building blocks
// dassign3_blocks.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs, etc.

// ***************
// Building blocks
// ***************

// CMOS gates (declarative Verilog)                                              
// t_PD = 1                                                                      
module inverter(a,y);                                                            
    input a;                                                                     
    output y;                                                                    
                                                                                 
    assign #1 y = ~a;                                                            
endmodule                                                                        
                                                                                 
module fa_gate_1(a,b,c,y);                                                       
    input a,b,c;                                                                 
    output y;                                                                    
                                                                                 
    assign #1 y = ~((a&b) | (c&(b|a)));                                          
endmodule                                                                        
                                                                                 
module fa_gate_2(a,b,c,m,y);                                                     
    input a,b,c,m;                                                               
    output y;                                                                    
                                                                                 
    assign #1 y = ~((a&b&c) | ((a|b|c)&m));                                      
endmodule                                                                        

// Full adder (structural Verilog)
module fa(a,b,ci,co,s);
    input a,b,ci;
    output s,co;

    wire nco, ns;

    fa_gate_1   fa_gate_1_1(a,b,ci, nco);
    fa_gate_2   fa_gate_2_1(a,b,ci,nco, ns);
    inverter    inverter_1(nco, co);
    inverter    inverter_2(ns, s);
endmodule

// D-register (flipflop).  Width set via parameter.
// Includes propagation delay t_PD = 3
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= #3 d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux2(a, b, sel, y);
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign #3 y = sel ? b : a;
endmodule

// 4-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux4(a, b, c, d, sel, y);
    parameter width = 1;
    input [width-1:0] a, b, c, d;
    input [1:0] sel;
    output [width-1:0] y;
    reg [width-1:0] y;

    always @(*) begin
        case (sel)
            2'b00:    y <= #3 a;
            2'b01:    y <= #3 b;
            2'b10:    y <= #3 c;
            default:  y <= #3 d;
        endcase
    end
endmodule

// Left-shifter
// No propagation delay, it's just wires really
module shl(a, y);
    parameter width = 2;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {a[width-2:0], 1'b0};
endmodule

// Right-shifter
// more wires 
module shr(a, y);
    parameter width = 2;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {1'b0, a[width-1:1]};
endmodule

// 16-bit adder (declarative Verilog)
// Includes propagation delay t_PD = 3n = 48
module adder16(a, b, sum);
    input [15:0] a, b;
    output [15:0] sum;

    assign #48 sum = a+b;
endmodule
