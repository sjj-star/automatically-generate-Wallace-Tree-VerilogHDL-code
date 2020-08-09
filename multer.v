`define INDEX (width+2)*(i/2+1)-1:(width+2)*i/2

`timescale 1ns / 1ps

module half_adder(
//inputs
	a,
	b,
//outputs
	o,
	cout
);

input wire a;
input wire b;
output wire o;
output wire cout;

assign o = a^b;
assign cout = a&b;

endmodule

module compressor_3_2(
//inputs
	a,
	b,
	cin,
//outputs
	o,
	cout
);
input wire a;
input wire b;
input wire cin;
output wire o;
output wire cout;

wire s = a^b;
wire g = a&b;

assign o = s^cin;
assign cout = s ? cin : g;

endmodule

module compressor_4_2(
//inputs
	a,
	b,
	c,
	d,
	cin,
//outputs
	o,
	co,
	cout
);

input wire a;
input wire b;
input wire c;
input wire d;
input wire cin;
output wire o;
output wire co;
output wire cout;
wire carry;

compressor_3_2 FULLADD1(a,b,c,carry,cout);
compressor_3_2 FULLADD2(carry,d,cin,o,co);

endmodule

/********************************************************************************/

module _8_wallace_tree(
//inputs
	partial_products,
	carry,
//outputs
	compress_a,
	compress_b
);

localparam width = 8;

input wire [(width+2)*(width/2+1)-1:0] partial_products;
input wire [width/2-1:0] carry;
output wire [2*width-1:0] compress_a;
output wire [2*width-1:0] compress_b;

/* Input nets */
wire  s_0_0,  s_0_1,  s_1_0,  s_2_0,  s_2_1,  s_2_2; 
wire  s_
