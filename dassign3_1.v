// EEM16 - Logic Design
// Design Assignment #3.1
// dassign3_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************

// 3.1a) Rectified linear unit
// out = max(0, in/4)
// 16 bit signed input
// 8 bit unsigned output
module relu(in, out);
    input [15:0] in;
    output [7:0] out;

  	assign out = in[15] ? 8'b0 : in >> 2;
endmodule

// 3.1b) Pipelined 5 input ripple-carry adder
// 16 bit signed inputs
// 1 bit input: valid (when the other inputs are useful numbers)
// 16 bit signed output (truncated)
// 1 bit output: ready (when the output is the sum of valid inputs)
module piped_adder(clk, a, b, c, d, e, valid, sum, ready);
    input clk, valid;
    input [15:0] a, b, c, d, e;
    output [15:0] sum;
    output ready;
  
    wire valid1, valid2, valid3, valid4, valid5;
  wire [6:0] sum1, sum1_, sum2, sum2_, sum3, sum3_, sum4, sum4_, sum5, sum5_, sum6, sum6_, sum7, sum7_, sum8, sum8_;
  
  wire [3:0] sum_a, sum_b, sum_c,sum_d, sum_e, sum_f, sum_g, sum_h, sum_i, sum_j, sum_k, sum_l, sum_m, sum_n, sum_o, sum_p, sum_q, sum_r, sum_s, sum_t, sum_u, sum_v;
  
  wire [2:0] carry1, carry1_, carry2, carry2_, carry3, carry3_, carry3_b, carry4, carry4_, carry4_b, carry4_c, carry5, carry6, carry7;
 
  wire [15:0] sum_out;
  
  adder5 		a1(a[3:0], b[3:0], c[3:0], d[3:0], e[3:0], sum1);
  adder5 		a2(a[7:4], b[7:4], c[7:4], d[7:4], e[7:4], sum2);
  adder5 		a3(a[11:8], b[11:8], c[11:8], d[11:8], e[11:8], sum3);
  adder5 		a4(a[15:12], b[15:12], c[15:12], d[15:12], e[15:12], sum4);
  adder5 		a5(carry1, sum_p, 0, 0, 0, sum5);
  adder5 		a6(carry5, sum_s, carry2_, 0, 0, sum6);
  adder5 		a7(carry6, carry3_b, sum_v, 0, 0, sum7);
  adder5 		a8(carry7, carry4_c, 0, 0, 0, sum8);

  dreg #(7) 	d1(clk, sum1, sum1_);
  dreg #(7) 	d2(clk, sum2, sum2_);
  dreg #(7) 	d3(clk, sum3, sum3_);
  dreg #(7) 	d4(clk, sum4, sum4_);
  dreg #(7) 	d5(clk, sum5, sum5_);
  dreg #(4) 	d6(clk, sum_a, sum_b);
  dreg #(3) 	d7(clk, carry2, carry2_);
  dreg #(4) 	d8(clk, sum_r, sum_s);
  dreg #(3) 	d9(clk, carry3, carry3_);
  dreg #(4) 	d10(clk, sum_t, sum_u);
  dreg #(3) 	d11(clk, carry4, carry4_);
  dreg #(7) 	d12(clk, sum6, sum6_);
  dreg #(4) 	d13(clk, sum_b, sum_c);
  dreg #(4) 	d14(clk, sum_f, sum_g);
  dreg #(3) 	d15(clk, carry3_, carry3_b);
  dreg #(4) 	d16(clk, sum_u, sum_v);
  dreg #(3) 	d17(clk, carry4_, carry4_b);
  dreg #(7) 	d18(clk, sum7, sum7_); 
  dreg #(4) 	d19(clk, sum_c, sum_d);
  dreg #(4) 	d20(clk, sum_g, sum_h);
  dreg #(4) 	d21(clk, sum_j, sum_k);
  dreg #(3) 	d22(clk, carry4_b, carry4_c);
  dreg #(7) 	d23(clk, sum8, sum8_);
  dreg #(4) 	d24(clk, sum_d, sum[3:0]);
  dreg #(4) 	d25(clk, sum_h, sum[7:4]);
  dreg #(4) 	d26(clk, sum_k, sum[11:8]);
  dreg #(4) 	d27(clk, sum_m, sum[15:12]);
  
  dreg 			v1(clk, valid, valid1);
  dreg 			v2(clk, valid1, valid2);
  dreg 			v3(clk, valid2, valid3);
  dreg 			v4(clk, valid3, valid4);
  dreg 			v5(clk, valid4, ready);
  
  assign carry1 = sum1_[6:4];
  assign sum_a = sum1_[3:0];	
  assign carry2 = sum2_[6:4];
  assign sum_p = sum2_[3:0];
  assign carry3 = sum3_[6:4];
  assign sum_r = sum3_[3:0];
  assign carry4 = sum4_[6:4];
  assign sum_t = sum4_[3:0];
  
  assign sum_f = sum5_[3:0];	
  assign carry5 = sum5_[6:4];
  assign sum_j = sum6_[3:0];		
  assign carry6 = sum6_[6:4];
  assign sum_m = sum7_[3:0];	
  assign carry7 = sum7_[6:4];
endmodule

// 3.1c) Pipelined neuron
// 8 bit signed weights, bias (constant)
// 8 bit unsigned inputs 
// 1 bit input: new (when a set of inputs are available)
// 8 bit unsigned output 
// 1 bit output: ready (when the output is valid)
module neuron(clk, w1, w2, w3, w4, b, x1, x2, x3, x4, new, y, ready);
    input clk;
    input [7:0] w1, w2, w3, w4, b;  // signed 2s complement
    input [7:0] x1, x2, x3, x4;     // unsigned
    input new;
    output [7:0] y;                 // unsigned
    output ready;
  
  	wire [15:0] prod1, prod2, prod3, prod4, sum, sum_final, b_sign_extended, b_final, prod1_out, prod2_out, prod3_out, prod4_out;
  	wire [7:0] y_temp;
    wire ready1, ready1_out, ready2, ready2_out, ready3, ready3_out, ready4, ready4_out, m_ready, ready_temp;
  
  	assign b_sign_extended = {{8{b[7]}}, b};
  
 	dreg #(16)	d0(clk, b_sign_extended, b_final);

    multiply 	m1(clk, w1, x1, new, prod1, ready1);
    multiply 	m2(clk, w2, x2, new, prod2, ready2);
    multiply 	m3(clk, w3, x3, new, prod3, ready3);
    multiply 	m4(clk, w4, x4, new, prod4, ready4);
  
    dreg #(16)	p1(clk, prod1, prod1_out);
    dreg #(16)	p2(clk, prod2, prod2_out);
    dreg #(16)	p3(clk, prod3, prod3_out);
    dreg #(16)	p4(clk, prod4, prod4_out);

    dreg			r1(clk, ready1, ready1_out);
    dreg			r2(clk, ready2, ready2_out);
    dreg			r3(clk, ready3, ready3_out);
    dreg			r4(clk, ready4, ready4_out);  

    assign m_ready = ready1_out && ready2_out && ready3_out && ready4_out; // only start adding products when all multipliers are finished

    piped_adder	add(clk, prod1_out, prod2_out, prod3_out, prod4_out, b_final, m_ready, sum, ready_temp);

    relu			relu(sum, y_temp); 

    dreg #(8)	d2(clk, y_temp, y);
    dreg		d3(clk, ready_temp, ready);
endmodule
