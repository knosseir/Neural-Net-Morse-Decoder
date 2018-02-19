// EEM16 - Logic Design
// Design Assignment #3 
// dassign3_modules.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs, etc.

`include "constants3.vh"

// ***************
// Past lab modules
// ***************

// 5+2 input full adder
module fa5 (a,b,c,d,e,ci0,ci1, 
            co1,co0,s);

    input a,b,c,d,e,ci0,ci1;
    output co1, co0, s;
    // your code here
    // do not use any delays!
    wire s0, s1, c0, c1, cc;
    fa  fa_0( a,  b,   c,  c0,  s0);
    fa  fa_1( d,  e, ci1,  c1,  s1);
    fa  fa_2(s0, s1, ci0,  cc,   s);
    fa  fa_3(c0, c1,  cc, co1, co0);
endmodule

// 5-input 4-bit ripple-carry adder (with carries)
module adder5carry (a,b,c,d,e, ci1, ci0a, ci0b, co1, co0a, co0b, sum);
    input [3:0] a,b,c,d,e;
    input ci1, ci0a, ci0b;
    output [3:0] sum;
    output co1, co0a, co0b;

    wire c00, c01;
    wire c10, c11;
    wire c20;

    fa5  fa5_0(a[0], b[0], c[0], d[0], e[0], ci0a, ci0b,  c01,  c00, sum[0]);
    fa5  fa5_1(a[1], b[1], c[1], d[1], e[1],  c00,  ci1,  c11,  c10, sum[1]);
    fa5  fa5_2(a[2], b[2], c[2], d[2], e[2],  c10,  c01, co0a,  c20, sum[2]);
    fa5  fa5_3(a[3], b[3], c[3], d[3], e[3],  c20,  c11,  co1, co0b, sum[3]);
endmodule

// 5-input 4-bit ripple-carry adder 
module adder5 (a,b,c,d,e, sum);
    input [3:0] a,b,c,d,e;
    // your code here
    // do not use any delays!
    output [6:0] sum;

    wire c21;
    wire c30, c31;
    wire c40;

    adder5carry a5(a,b,c,d,e, 1'b0, 1'b0, 1'b0, c31, c30, c21, sum[3:0]);
    fa   fa_4(c30, c21, 1'b0,    c40, sum[4]);
    fa   fa_5(c40, c31, 1'b0, sum[6], sum[5]);
endmodule

// Max/argmax (declarative verilog)
module mam (in1_value, in1_label, in2_value, in2_label, out_value, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [7:0] out_value;
    output  [4:0] out_label;
    // your code here
    // do not use any delays!

    wire cmp;

    assign cmp = in1_value < in2_value;

    assign out_value = cmp ? in2_value : in1_value;
    assign out_label = cmp ? in2_label : in1_label;
endmodule

module maxindex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
    // your code here
    // do not use any delays!

    wire [255:0] ins;
    wire [7:0] max;
    wire [159:0] labels;
    
    assign ins = {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,48'b0};
    assign labels = {5'd0, 5'd1, 5'd2, 5'd3, 5'd4,
                     5'd5, 5'd6, 5'd7, 5'd8, 5'd9,
                     5'd10, 5'd11, 5'd12, 5'd13, 5'd14,
                     5'd15, 5'd16, 5'd17, 5'd18, 5'd19,
                     5'd20, 5'd21, 5'd22, 5'd23, 5'd24,
                     5'd25, 30'b0};

    mamn #(32) mam32(ins, labels, max, out);
endmodule

module mamn (ins_value, ins_label, out_value, out_label);
    parameter n = 2;

    localparam vw2 = 8*n-1;
    localparam lw2 = 5*n-1;
    localparam vw1 = 8*(n>>1)-1;
    localparam lw1 = 5*(n>>1)-1;
    localparam vw = 8*(n>>1);
    localparam lw = 5*(n>>1);

    output  [7:0] out_value;
    output  [4:0] out_label;

    input  [vw2:0] ins_value;
    input  [lw2:0] ins_label;

    wire    [vw1:0] in1_value, in2_value;
    wire    [lw1:0] in1_label, in2_label;

    wire  [7:0] out1_value, out2_value;
    wire  [4:0] out1_label, out2_label;

    assign in1_value = ins_value[vw2:vw];
    assign in2_value = ins_value[vw1:0];
    assign in1_label = ins_label[lw2:lw];
    assign in2_label = ins_label[lw1:0];

    generate 
      if (n == 2)
        mam mam(in1_value, in1_label, in2_value, in2_label, out_value, out_label);
      else begin
        mamn #(n>>1) mamn_1(in1_value, in1_label, out1_value, out1_label);
        mamn #(n>>1) mamn_2(in2_value, in2_label, out2_value, out2_label);
        mam mam(out1_value, out1_label, out2_value, out2_label, out_value, out_label);
      end
    endgenerate
endmodule

module display_rom (letter, display);
    input   [4:0] letter;
    output  [6:0] display;
    reg     [6:0] display;
    // your code here
    // do not use any delays!
    always @(letter) begin
        case (letter)
            5'd0:    display = 7'b1110111; // a
            5'd1:    display = 7'b1111100; // b
            5'd2:    display = 7'b1011000; // c
            5'd3:    display = 7'b1011110; // d
            5'd4:    display = 7'b1111001; // e
            5'd5:    display = 7'b1110001; // f
            5'd6:    display = 7'b1101111; // g
            5'd7:    display = 7'b1110110; // h
            5'd8:    display = 7'b0000110; // i
            5'd9:    display = 7'b0011110; // j
            5'd10:   display = 7'b1111000; // k
            5'd11:   display = 7'b0111000; // l
            5'd12:   display = 7'b0010101; // m
            5'd13:   display = 7'b1010100; // n
            5'd14:   display = 7'b1011100; // o
            5'd15:   display = 7'b1110011; // p
            5'd16:   display = 7'b1100111; // q
            5'd17:   display = 7'b1010000; // r
            5'd18:   display = 7'b1101101; // s
            5'd19:   display = 7'b1000110; // t
            5'd20:   display = 7'b0111110; // u
            5'd21:   display = 7'b0011100; // v
            5'd22:   display = 7'b0101010; // w
            5'd23:   display = 7'b1001001; // x
            5'd24:   display = 7'b1101110; // y
            5'd25:   display = 7'b1011011; // z
            default: display = 7'b1000000; // -
        endcase
    end
endmodule

module partial_product (a, b, pp);
    // your code here
    // Include a propagation delay of #1
    // assign #1 pp = ... ;

    input [15:0] a;
    input [7:0] b;
    output [15:0] pp;

    assign #1 pp = {(16){b[0]}} & a;
endmodule

module is_done (a, b, done);
    // your code here
    // Include a propagation delay of #4
    // assign #4 done = ... ;

    input [15:0] a;
    input [7:0] b;
    output done;

    assign #4 done = ~(|b);
endmodule

// 8 bit unsigned multiply (structural Verilog)
module multiply (clk, ain, bin, reset, prod, ready);
    input clk;
    input [7:0] ain, bin;
    input reset;
    output [15:0] prod;
    output ready;

    // your code here
    // do not use any delays!
    wire [15:0] a_d, a_q, a, acc_d, acc_q, acc;
    wire [7:0] b_d, b_q, b;
    wire done_d;
    wire [15:0] pp;

    mux2 #(16)   mux_a(a_q, {{8{a[7]}}, ain}, reset, a);
    mux2 #(8)    mux_b(b_q, bin, reset, b);
    mux2 #(16)   mux_acc(prod, 16'b0, reset, acc);

    shl #(16)   shl(a, a_d);
    shr #(8)    shr(b, b_d);

    partial_product pp1(a, b, pp);
    adder16         adder(acc, pp, acc_d);

    is_done         done1(a_d, b_d, done_d);

    dreg #(16)  dreg_a(clk, a_d, a_q);
    dreg #(8)   dreg_b(clk, b_d, b_q);
    dreg #(16)  dreg_acc(clk, acc_d, prod);
    dreg #(1)   dreg_done(clk, done_d, ready);
endmodule

module pulse_width(clk, in, pwidth, long, type, new);
    parameter width = 8;
    input clk, in;
    output [width-1:0] pwidth;
    output long, type, new;

    // your code here
    // do not use any delays!

    wire [width-1:0] pwidth_d;
    wire type_d, long_d, new_d;

    assign new_d = type ^ in;
    assign pwidth_d = new_d ? 1 : (pwidth + 1);
    assign long_d = pwidth_d > `THRESHOLD;
    assign type_d = in;

    dreg #(1)     dreg_new(clk, new_d, new);
    dreg #(width) dreg_pwidth(clk, pwidth_d, pwidth);
    dreg #(1)     dreg_long(clk, long_d, long);
    dreg #(1)     dreg_type(clk, type_d, type);
endmodule

module shift4(clk, in, cmd, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input [`CMD_WIDTH-1:0] cmd;
    output [width-1:0] out3, out2, out1, out0;

    // your code here
    // do not use any delays!

    wire [width-1:0] out3_d, out2_d, out1_d, out0_d;

    mux4 #(width) mux4_3({(width){1'b0}}, out2, out3, out3, cmd, out3_d);
    mux4 #(width) mux4_2({(width){1'b0}}, out1, out2, out2, cmd, out2_d);
    mux4 #(width) mux4_1({(width){1'b0}}, out0, out1, out1, cmd, out1_d);
    mux4 #(width) mux4_0(in, in, in, out0, cmd, out0_d);

    dreg #(width) dreg_3(clk, out3_d, out3);
    dreg #(width) dreg_2(clk, out2_d, out2);
    dreg #(width) dreg_1(clk, out1_d, out1);
    dreg #(width) dreg_0(clk, out0_d, out0);

endmodule

module control_fsm(clk, long, type, cmd, done);
    input clk, long, type;
    output [`CMD_WIDTH-1:0] cmd;
    reg [`CMD_WIDTH-1:0] cmd;
    output done;

    // your code here
    // do not use any delays!

    wire [`STATE_WIDTH-1:0] state;

    reg [`STATE_WIDTH-1:0] state_d;
    reg done_d;

    dreg #(2) dreg_state(clk, state_d, state);
    dreg #(1) dreg_done(clk, done_d, done);

    always @(*) begin
        case (state)

            // A complete letter has been received
            `STATE_DONE: begin
                // Don't change the shift register
                done_d = 0;
                if (type) begin
                    cmd = `CMD_CLEAR;
                    state_d = `STATE_LOAD;
                end else begin
                    cmd = `CMD_CLEAR;
                    state_d = `STATE_DONE;
                end
            end

            `STATE_LOAD: begin
                done_d = 0;
                if (type) begin
                    state_d = `STATE_LOAD;
                    cmd = `CMD_LOAD;
                end else begin
                    state_d = `STATE_HOLD;
                    cmd = `CMD_HOLD;
                end
            end

            `STATE_SHIFT: begin
                done_d = 0;
                if (type) begin
                    state_d = `STATE_LOAD;
                    cmd = `CMD_LOAD;
                end else begin
                    state_d = `STATE_HOLD;
                    cmd = `CMD_HOLD;
                end
            end

            default: begin
                if (type) begin
                    state_d = `STATE_SHIFT;
                    cmd = `CMD_SHIFT;
                    done_d = 0;
                end else if (long) begin
                    state_d = `STATE_DONE;
                    cmd = `CMD_HOLD;
                    done_d = 1;
                end else begin
                    state_d = `STATE_HOLD;
                    cmd = `CMD_HOLD;
                    done_d = 0;
                end
            end
        endcase
    end

endmodule

module deserializer(clk, in, out3, out2, out1, out0, done);
    parameter width = 8;
    input clk, in;
    output [width-1:0] out3, out2, out1, out0;
    output done;

    wire [width-1:0] pwidth;
    wire long, type, new;
    wire [`CMD_WIDTH-1:0] cmd;

    pulse_width pulse_width(clk, in, pwidth, long, type, new);
    control_fsm control(clk, long, type, cmd, done);
    shift4 #(8) shift4(clk, pwidth, cmd, out3, out2, out1, out0);

endmodule