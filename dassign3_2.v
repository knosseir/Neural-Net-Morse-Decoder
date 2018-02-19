// EEM16 - Logic Design
// Design Assignment #3.2
// dassign3_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************

// 3.2a) Inter-layer module
// four sets of inputs: 8 bit value, 1 bit input ready
// one 1 bit input new (from input layer of neurons)
// four sets of 8 bits output
// one 1 bit output ready
module interlayer(clk, new, in1, ready1, in2, ready2, in3, ready3, in4, ready4,
                  out1, out2, out3, out4, ready_out);
    input clk;
    input new;
    input [7:0] in1, in2, in3, in4;
    input ready1, ready2, ready3, ready4;
    output [7:0] out1, out2, out3, out4;
    output ready_out;

    wire ready1_out, ready2_out, ready3_out, ready4_out, valid, ready_out_temp;
    wire [7:0] out1_temp, out2_temp, out3_temp, out4_temp;

    assign out1_temp = ready1 ? in1 : out1_temp;
    assign out2_temp = ready2 ? in2 : out2_temp;
    assign out3_temp = ready3 ? in3 : out3_temp;
    assign out4_temp = ready4 ? in4 : out4_temp;

    assign ready1_out = ((out1_temp == in1) & !new & ready1) ? 1 : (ready1_out & !new);
    assign ready2_out = ((out2_temp == in2) & !new & ready2) ? 1 : (ready2_out & !new);
    assign ready3_out = ((out3_temp == in3) & !new & ready3) ? 1 : (ready3_out & !new);
    assign ready4_out = ((out4_temp == in4) & !new & ready4) ? 1 : (ready4_out & !new);

    assign ready_out_temp = valid & ready1_out & ready2_out & ready3_out & ready4_out;

    dreg 		done(clk, !(ready1 & ready2 & ready3 & ready4), valid);
    dreg #(8) 	d1(clk, out1_temp, out1);
    dreg #(8) 	d2(clk, out2_temp, out2);
    dreg #(8) 	d3(clk, out3_temp, out3);
    dreg #(8) 	d4(clk, out4_temp, out4);
    dreg 		out(clk, ready_out_temp, ready_out);
endmodule