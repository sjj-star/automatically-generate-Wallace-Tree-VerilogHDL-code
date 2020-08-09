`define INDEX (width+2)*(i/2+1)-1:(width+2)*i/2

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
wire  s_3_0,  s_3_1,  s_4_0,  s_4_1,  s_4_2,  s_4_3; 
wire  s_5_0,  s_5_1,  s_5_2,  s_6_0,  s_6_1,  s_6_2; 
wire  s_6_3,  s_6_4,  s_7_0,  s_7_1,  s_7_2,  s_7_3; 
wire  s_8_0,  s_8_1,  s_8_2,  s_8_3,  s_8_4,  s_9_0; 
wire  s_9_1,  s_9_2,  s_9_3,  s_9_4, s_10_0, s_10_1; 
wire s_10_2, s_10_3, s_11_0, s_11_1, s_11_2, s_11_3; 
wire s_12_0, s_12_1, s_12_2, s_13_0, s_13_1, s_13_2; 
wire s_14_0, s_14_1, s_15_0, s_15_1;

assign {
   s_6_4,    s_4_3,    s_2_2,    s_0_1  
} = carry;

assign {
   s_9_0,    s_8_0,    s_7_0,    s_6_0,    s_5_0,    s_4_0, 
   s_3_0,    s_2_0,    s_1_0,    s_0_0  
} = partial_products[(width+2)*(0+1)-1:(width+2)*0];

assign {
  s_11_0,   s_10_0,    s_9_1,    s_8_1,    s_7_1,    s_6_1, 
   s_5_1,    s_4_1,    s_3_1,    s_2_1  
} = partial_products[(width+2)*(1+1)-1:(width+2)*1];

assign {
  s_13_0,   s_12_0,   s_11_1,   s_10_1,    s_9_2,    s_8_2, 
   s_7_2,    s_6_2,    s_5_2,    s_4_2  
} = partial_products[(width+2)*(2+1)-1:(width+2)*2];

assign {
  s_15_0,   s_14_0,   s_13_1,   s_12_1,   s_11_2,   s_10_2, 
   s_9_3,    s_8_3,    s_7_3,    s_6_3  
} = partial_products[(width+2)*(3+1)-1:(width+2)*3];

assign {
  s_15_1,   s_14_1,   s_13_2,   s_12_2,   s_11_3,   s_10_3, 
   s_9_4,    s_8_4  
} = partial_products[(width+2)*(width/2+1)-1:(width+2)*width/2+2];

/* u0_1 Output nets */
wire    t_0,   t_1;
/* u1_2 Output nets */
wire    t_2,   t_3;
/* u0_3 Output nets */
wire    t_4,   t_5;
/* u1_4 Output nets */
wire    t_6,   t_7;
/* u1_5 Output nets */
wire    t_8,   t_9;
/* u2_6 Output nets */
wire   t_10,  t_11,  t_12;
/* u2_7 Output nets */
wire   t_13,  t_14,  t_15;
/* u2_8 Output nets */
wire   t_16,  t_17,  t_18;
/* u2_9 Output nets */
wire   t_19,  t_20,  t_21;
/* u2_10 Output nets */
wire   t_22,  t_23,  t_24;
/* u2_11 Output nets */
wire   t_25,  t_26,  t_27;
/* u1_12 Output nets */
wire   t_28,  t_29;
/* u1_13 Output nets */
wire   t_30,  t_31;
/* u0_14 Output nets */
wire   t_32,  t_33;
/* u0_15 Output nets */
wire   t_34;

/* compress stage 1 */
half_adder u0_1(.a(s_0_1), .b(s_0_0), .o(t_0), .cout(t_1));
compressor_3_2 u1_2(.a(s_2_2), .b(s_2_1), .cin(s_2_0), .o(t_2), .cout(t_3));
half_adder u0_3(.a(s_3_1), .b(s_3_0), .o(t_4), .cout(t_5));
compressor_3_2 u1_4(.a(s_4_2), .b(s_4_1), .cin(s_4_0), .o(t_6), .cout(t_7));
compressor_3_2 u1_5(.a(s_5_2), .b(s_5_1), .cin(s_5_0), .o(t_8), .cout(t_9));
compressor_4_2 u2_6(.a(s_6_4), .b(s_6_3), .c(s_6_2), .d(s_6_1), .cin(s_6_0), .o(t_10), .co(t_11), .cout(t_12));
compressor_4_2 u2_7(.a(s_7_3), .b(s_7_2), .c(s_7_1), .d(s_7_0), .cin(t_12), .o(t_13), .co(t_14), .cout(t_15));
compressor_4_2 u2_8(.a(s_8_3), .b(s_8_2), .c(s_8_1), .d(s_8_0), .cin(t_15), .o(t_16), .co(t_17), .cout(t_18));
compressor_4_2 u2_9(.a(s_9_3), .b(s_9_2), .c(s_9_1), .d(s_9_0), .cin(t_18), .o(t_19), .co(t_20), .cout(t_21));
compressor_4_2 u2_10(.a(s_10_3), .b(s_10_2), .c(s_10_1), .d(s_10_0), .cin(t_21), .o(t_22), .co(t_23), .cout(t_24));
compressor_4_2 u2_11(.a(s_11_3), .b(s_11_2), .c(s_11_1), .d(s_11_0), .cin(t_24), .o(t_25), .co(t_26), .cout(t_27));
compressor_3_2 u1_12(.a(s_12_1), .b(s_12_0), .cin(t_27), .o(t_28), .cout(t_29));
compressor_3_2 u1_13(.a(s_13_2), .b(s_13_1), .cin(s_13_0), .o(t_30), .cout(t_31));
half_adder u0_14(.a(s_14_1), .b(s_14_0), .o(t_32), .cout(t_33));
half_adder u0_15(.a(s_15_1), .b(s_15_0), .o(t_34), .cout());

/* u0_16 Output nets */
wire   t_35,  t_36;
/* u0_17 Output nets */
wire   t_37,  t_38;
/* u1_18 Output nets */
wire   t_39,  t_40;
/* u0_19 Output nets */
wire   t_41,  t_42;
/* u0_20 Output nets */
wire   t_43,  t_44;
/* u0_21 Output nets */
wire   t_45,  t_46;
/* u1_22 Output nets */
wire   t_47,  t_48;
/* u1_23 Output nets */
wire   t_49,  t_50;
/* u0_24 Output nets */
wire   t_51,  t_52;
/* u0_25 Output nets */
wire   t_53,  t_54;
/* u1_26 Output nets */
wire   t_55,  t_56;
/* u0_27 Output nets */
wire   t_57,  t_58;
/* u0_28 Output nets */
wire   t_59,  t_60;
/* u0_29 Output nets */
wire   t_61;

/* compress stage 2 */
half_adder u0_16(.a(t_1), .b(s_1_0), .o(t_35), .cout(t_36));
half_adder u0_17(.a(t_4), .b(t_3), .o(t_37), .cout(t_38));
compressor_3_2 u1_18(.a(t_6), .b(t_5), .cin(s_4_3), .o(t_39), .cout(t_40));
half_adder u0_19(.a(t_8), .b(t_7), .o(t_41), .cout(t_42));
half_adder u0_20(.a(t_10), .b(t_9), .o(t_43), .cout(t_44));
half_adder u0_21(.a(t_13), .b(t_11), .o(t_45), .cout(t_46));
compressor_3_2 u1_22(.a(t_16), .b(t_14), .cin(s_8_4), .o(t_47), .cout(t_48));
compressor_3_2 u1_23(.a(t_19), .b(t_17), .cin(s_9_4), .o(t_49), .cout(t_50));
half_adder u0_24(.a(t_22), .b(t_20), .o(t_51), .cout(t_52));
half_adder u0_25(.a(t_25), .b(t_23), .o(t_53), .cout(t_54));
compressor_3_2 u1_26(.a(t_28), .b(t_26), .cin(s_12_2), .o(t_55), .cout(t_56));
half_adder u0_27(.a(t_30), .b(t_29), .o(t_57), .cout(t_58));
half_adder u0_28(.a(t_32), .b(t_31), .o(t_59), .cout(t_60));
half_adder u0_29(.a(t_34), .b(t_33), .o(t_61), .cout());

/* Output nets Compression result */
assign compress_a = {
    t_60,    t_58,    t_56,    t_54,
    t_52,    t_50,    t_48,    t_46,
    t_44,    t_42,    t_40,    t_38,
    t_37,     t_2,    t_35,     t_0
};
assign compress_b = {
    t_61,    t_59,    t_57,    t_55,
    t_53,    t_51,    t_49,    t_47,
    t_45,    t_43,    t_41,    t_39,
    1'b0,    t_36,    1'b0,    1'b0
};

endmodule

/********************************************************************************/

module _16_wallace_tree(
//inputs
	partial_products,
	carry,
//outputs
	compress_a,
	compress_b
);

localparam width = 16;

input wire [(width+2)*(width/2+1)-1:0] partial_products;
input wire [width/2-1:0] carry;
output wire [2*width-1:0] compress_a;
output wire [2*width-1:0] compress_b;

/* Input nets */
wire    s_0_0,    s_0_1,    s_1_0,    s_2_0,    s_2_1,    s_2_2;  
wire    s_3_0,    s_3_1,    s_4_0,    s_4_1,    s_4_2,    s_4_3;  
wire    s_5_0,    s_5_1,    s_5_2,    s_6_0,    s_6_1,    s_6_2;  
wire    s_6_3,    s_6_4,    s_7_0,    s_7_1,    s_7_2,    s_7_3;  
wire    s_8_0,    s_8_1,    s_8_2,    s_8_3,    s_8_4,    s_8_5;  
wire    s_9_0,    s_9_1,    s_9_2,    s_9_3,    s_9_4,   s_10_0;  
wire   s_10_1,   s_10_2,   s_10_3,   s_10_4,   s_10_5,   s_10_6;  
wire   s_11_0,   s_11_1,   s_11_2,   s_11_3,   s_11_4,   s_11_5;  
wire   s_12_0,   s_12_1,   s_12_2,   s_12_3,   s_12_4,   s_12_5;  
wire   s_12_6,   s_12_7,   s_13_0,   s_13_1,   s_13_2,   s_13_3;  
wire   s_13_4,   s_13_5,   s_13_6,   s_14_0,   s_14_1,   s_14_2;  
wire   s_14_3,   s_14_4,   s_14_5,   s_14_6,   s_14_7,   s_14_8;  
wire   s_15_0,   s_15_1,   s_15_2,   s_15_3,   s_15_4,   s_15_5;  
wire   s_15_6,   s_15_7,   s_16_0,   s_16_1,   s_16_2,   s_16_3;  
wire   s_16_4,   s_16_5,   s_16_6,   s_16_7,   s_16_8,   s_17_0;  
wire   s_17_1,   s_17_2,   s_17_3,   s_17_4,   s_17_5,   s_17_6;  
wire   s_17_7,   s_17_8,   s_18_0,   s_18_1,   s_18_2,   s_18_3;  
wire   s_18_4,   s_18_5,   s_18_6,   s_18_7,   s_19_0,   s_19_1;  
wire   s_19_2,   s_19_3,   s_19_4,   s_19_5,   s_19_6,   s_19_7;  
wire   s_20_0,   s_20_1,   s_20_2,   s_20_3,   s_20_4,   s_20_5;  
wire   s_20_6,   s_21_0,   s_21_1,   s_21_2,   s_21_3,   s_21_4;  
wire   s_21_5,   s_21_6,   s_22_0,   s_22_1,   s_22_2,   s_22_3;  
wire   s_22_4,   s_22_5,   s_23_0,   s_23_1,   s_23_2,   s_23_3;  
wire   s_23_4,   s_23_5,   s_24_0,   s_24_1,   s_24_2,   s_24_3;  
wire   s_24_4,   s_25_0,   s_25_1,   s_25_2,   s_25_3,   s_25_4;  
wire   s_26_0,   s_26_1,   s_26_2,   s_26_3,   s_27_0,   s_27_1;  
wire   s_27_2,   s_27_3,   s_28_0,   s_28_1,   s_28_2,   s_29_0;  
wire   s_29_1,   s_29_2,   s_30_0,   s_30_1,   s_31_0,   s_31_1;  

assign {
  s_14_8,   s_12_7,   s_10_6,    s_8_5,    s_6_4,    s_4_3, 
   s_2_2,    s_0_1  
} = carry;

assign {
  s_17_0,   s_16_0,   s_15_0,   s_14_0,   s_13_0,   s_12_0, 
  s_11_0,   s_10_0,    s_9_0,    s_8_0,    s_7_0,    s_6_0, 
   s_5_0,    s_4_0,    s_3_0,    s_2_0,    s_1_0,    s_0_0
} = partial_products[(width+2)*(0+1)-1:(width+2)*0];

assign {
  s_19_0,   s_18_0,   s_17_1,   s_16_1,   s_15_1,   s_14_1, 
  s_13_1,   s_12_1,   s_11_1,   s_10_1,    s_9_1,    s_8_1, 
   s_7_1,    s_6_1,    s_5_1,    s_4_1,    s_3_1,    s_2_1
} = partial_products[(width+2)*(1+1)-1:(width+2)*1];

assign {
  s_21_0,   s_20_0,   s_19_1,   s_18_1,   s_17_2,   s_16_2, 
  s_15_2,   s_14_2,   s_13_2,   s_12_2,   s_11_2,   s_10_2, 
   s_9_2,    s_8_2,    s_7_2,    s_6_2,    s_5_2,    s_4_2
} = partial_products[(width+2)*(2+1)-1:(width+2)*2];

assign {
  s_23_0,   s_22_0,   s_21_1,   s_20_1,   s_19_2,   s_18_2, 
  s_17_3,   s_16_3,   s_15_3,   s_14_3,   s_13_3,   s_12_3, 
  s_11_3,   s_10_3,    s_9_3,    s_8_3,    s_7_3,    s_6_3
} = partial_products[(width+2)*(3+1)-1:(width+2)*3];

assign {
  s_25_0,   s_24_0,   s_23_1,   s_22_1,   s_21_2,   s_20_2, 
  s_19_3,   s_18_3,   s_17_4,   s_16_4,   s_15_4,   s_14_4, 
  s_13_4,   s_12_4,   s_11_4,   s_10_4,    s_9_4,    s_8_4
} = partial_products[(width+2)*(4+1)-1:(width+2)*4];

assign {
  s_27_0,   s_26_0,   s_25_1,   s_24_1,   s_23_2,   s_22_2, 
  s_21_3,   s_20_3,   s_19_4,   s_18_4,   s_17_5,   s_16_5, 
  s_15_5,   s_14_5,   s_13_5,   s_12_5,   s_11_5,   s_10_5
} = partial_products[(width+2)*(5+1)-1:(width+2)*5];

assign {
  s_29_0,   s_28_0,   s_27_1,   s_26_1,   s_25_2,   s_24_2, 
  s_23_3,   s_22_3,   s_21_4,   s_20_4,   s_19_5,   s_18_5, 
  s_17_6,   s_16_6,   s_15_6,   s_14_6,   s_13_6,   s_12_6
} = partial_products[(width+2)*(6+1)-1:(width+2)*6];

assign {
  s_31_0,   s_30_0,   s_29_1,   s_28_1,   s_27_2,   s_26_2, 
  s_25_3,   s_24_3,   s_23_4,   s_22_4,   s_21_5,   s_20_5, 
  s_19_6,   s_18_6,   s_17_7,   s_16_7,   s_15_7,   s_14_7
} = partial_products[(width+2)*(7+1)-1:(width+2)*7];

assign {
  s_31_1,   s_30_1,   s_29_2,   s_28_2,   s_27_3,   s_26_3, 
  s_25_4,   s_24_4,   s_23_5,   s_22_5,   s_21_6,   s_20_6, 
  s_19_7,   s_18_7,   s_17_8,   s_16_8  
} = partial_products[(width+2)*(width/2+1)-1:(width+2)*width/2+2];

/* u0_1 Output nets */
wire      t_0,     t_1;  
/* u1_2 Output nets */
wire      t_2,     t_3;  
/* u0_3 Output nets */
wire      t_4,     t_5;  
/* u1_4 Output nets */
wire      t_6,     t_7;  
/* u1_5 Output nets */
wire      t_8,     t_9;  
/* u2_6 Output nets */
wire     t_10,    t_11,    t_12;  
/* u2_7 Output nets */
wire     t_13,    t_14,    t_15;  
/* u2_8 Output nets */
wire     t_16,    t_17,    t_18;  
/* u0_9 Output nets */
wire     t_19,    t_20;  
/* u2_10 Output nets */
wire     t_21,    t_22,    t_23;  
/* u2_11 Output nets */
wire     t_24,    t_25,    t_26;  
/* u1_12 Output nets */
wire     t_27,    t_28;  
/* u2_13 Output nets */
wire     t_29,    t_30,    t_31;  
/* u0_14 Output nets */
wire     t_32,    t_33;  
/* u2_15 Output nets */
wire     t_34,    t_35,    t_36;  
/* u1_16 Output nets */
wire     t_37,    t_38;  
/* u2_17 Output nets */
wire     t_39,    t_40,    t_41;  
/* u1_18 Output nets */
wire     t_42,    t_43;  
/* u2_19 Output nets */
wire     t_44,    t_45,    t_46;  
/* u2_20 Output nets */
wire     t_47,    t_48,    t_49;  
/* u2_21 Output nets */
wire     t_50,    t_51,    t_52;  
/* u2_22 Output nets */
wire     t_53,    t_54,    t_55;  
/* u2_23 Output nets */
wire     t_56,    t_57,    t_58;  
/* u2_24 Output nets */
wire     t_59,    t_60,    t_61;  
/* u2_25 Output nets */
wire     t_62,    t_63,    t_64;  
/* u2_26 Output nets */
wire     t_65,    t_66,    t_67;  
/* u2_27 Output nets */
wire     t_68,    t_69,    t_70;  
/* u2_28 Output nets */
wire     t_71,    t_72,    t_73;  
/* u2_29 Output nets */
wire     t_74,    t_75,    t_76;  
/* u2_30 Output nets */
wire     t_77,    t_78,    t_79;  
/* u2_31 Output nets */
wire     t_80,    t_81,    t_82;  
/* u1_32 Output nets */
wire     t_83,    t_84;  
/* u2_33 Output nets */
wire     t_85,    t_86,    t_87;  
/* u1_34 Output nets */
wire     t_88,    t_89;  
/* u2_35 Output nets */
wire     t_90,    t_91,    t_92;  
/* u0_36 Output nets */
wire     t_93,    t_94;  
/* u2_37 Output nets */
wire     t_95,    t_96,    t_97;  
/* u0_38 Output nets */
wire     t_98,    t_99;  
/* u2_39 Output nets */
wire    t_100,   t_101,   t_102;  
/* u2_40 Output nets */
wire    t_103,   t_104,   t_105;  
/* u2_41 Output nets */
wire    t_106,   t_107,   t_108;  
/* u2_42 Output nets */
wire    t_109,   t_110,   t_111;  
/* u1_43 Output nets */
wire    t_112,   t_113;  
/* u1_44 Output nets */
wire    t_114,   t_115;  
/* u0_45 Output nets */
wire    t_116,   t_117;  
/* u0_46 Output nets */
wire    t_118;  

/* compress stage 1 */
half_adder u0_1(.a(s_0_1), .b(s_0_0), .o(t_0), .cout(t_1)); 
compressor_3_2 u1_2(.a(s_2_2), .b(s_2_1), .cin(s_2_0), .o(t_2), .cout(t_3)); 
half_adder u0_3(.a(s_3_1), .b(s_3_0), .o(t_4), .cout(t_5)); 
compressor_3_2 u1_4(.a(s_4_2), .b(s_4_1), .cin(s_4_0), .o(t_6), .cout(t_7)); 
compressor_3_2 u1_5(.a(s_5_2), .b(s_5_1), .cin(s_5_0), .o(t_8), .cout(t_9)); 
compressor_4_2 u2_6(.a(s_6_4), .b(s_6_3), .c(s_6_2), .d(s_6_1), .cin(s_6_0), .o(t_10), .co(t_11), .cout(t_12)); 
compressor_4_2 u2_7(.a(s_7_3), .b(s_7_2), .c(s_7_1), .d(s_7_0), .cin(t_12), .o(t_13), .co(t_14), .cout(t_15)); 
compressor_4_2 u2_8(.a(s_8_3), .b(s_8_2), .c(s_8_1), .d(s_8_0), .cin(t_15), .o(t_16), .co(t_17), .cout(t_18)); 
half_adder u0_9(.a(s_8_5), .b(s_8_4), .o(t_19), .cout(t_20)); 
compressor_4_2 u2_10(.a(s_9_3), .b(s_9_2), .c(s_9_1), .d(s_9_0), .cin(t_18), .o(t_21), .co(t_22), .cout(t_23)); 
compressor_4_2 u2_11(.a(s_10_3), .b(s_10_2), .c(s_10_1), .d(s_10_0), .cin(t_23), .o(t_24), .co(t_25), .cout(t_26)); 
compressor_3_2 u1_12(.a(s_10_6), .b(s_10_5), .cin(s_10_4), .o(t_27), .cout(t_28)); 
compressor_4_2 u2_13(.a(s_11_3), .b(s_11_2), .c(s_11_1), .d(s_11_0), .cin(t_26), .o(t_29), .co(t_30), .cout(t_31)); 
half_adder u0_14(.a(s_11_5), .b(s_11_4), .o(t_32), .cout(t_33)); 
compressor_4_2 u2_15(.a(s_12_3), .b(s_12_2), .c(s_12_1), .d(s_12_0), .cin(t_31), .o(t_34), .co(t_35), .cout(t_36)); 
compressor_3_2 u1_16(.a(s_12_6), .b(s_12_5), .cin(s_12_4), .o(t_37), .cout(t_38)); 
compressor_4_2 u2_17(.a(s_13_3), .b(s_13_2), .c(s_13_1), .d(s_13_0), .cin(t_36), .o(t_39), .co(t_40), .cout(t_41)); 
compressor_3_2 u1_18(.a(s_13_6), .b(s_13_5), .cin(s_13_4), .o(t_42), .cout(t_43)); 
compressor_4_2 u2_19(.a(s_14_3), .b(s_14_2), .c(s_14_1), .d(s_14_0), .cin(t_41), .o(t_44), .co(t_45), .cout(t_46)); 
compressor_4_2 u2_20(.a(s_14_8), .b(s_14_7), .c(s_14_6), .d(s_14_5), .cin(s_14_4), .o(t_47), .co(t_48), .cout(t_49)); 
compressor_4_2 u2_21(.a(s_15_3), .b(s_15_2), .c(s_15_1), .d(s_15_0), .cin(t_46), .o(t_50), .co(t_51), .cout(t_52)); 
compressor_4_2 u2_22(.a(s_15_7), .b(s_15_6), .c(s_15_5), .d(s_15_4), .cin(t_49), .o(t_53), .co(t_54), .cout(t_55)); 
compressor_4_2 u2_23(.a(s_16_3), .b(s_16_2), .c(s_16_1), .d(s_16_0), .cin(t_52), .o(t_56), .co(t_57), .cout(t_58)); 
compressor_4_2 u2_24(.a(s_16_7), .b(s_16_6), .c(s_16_5), .d(s_16_4), .cin(t_55), .o(t_59), .co(t_60), .cout(t_61)); 
compressor_4_2 u2_25(.a(s_17_3), .b(s_17_2), .c(s_17_1), .d(s_17_0), .cin(t_58), .o(t_62), .co(t_63), .cout(t_64)); 
compressor_4_2 u2_26(.a(s_17_7), .b(s_17_6), .c(s_17_5), .d(s_17_4), .cin(t_61), .o(t_65), .co(t_66), .cout(t_67)); 
compressor_4_2 u2_27(.a(s_18_3), .b(s_18_2), .c(s_18_1), .d(s_18_0), .cin(t_64), .o(t_68), .co(t_69), .cout(t_70)); 
compressor_4_2 u2_28(.a(s_18_7), .b(s_18_6), .c(s_18_5), .d(s_18_4), .cin(t_67), .o(t_71), .co(t_72), .cout(t_73)); 
compressor_4_2 u2_29(.a(s_19_3), .b(s_19_2), .c(s_19_1), .d(s_19_0), .cin(t_70), .o(t_74), .co(t_75), .cout(t_76)); 
compressor_4_2 u2_30(.a(s_19_7), .b(s_19_6), .c(s_19_5), .d(s_19_4), .cin(t_73), .o(t_77), .co(t_78), .cout(t_79)); 
compressor_4_2 u2_31(.a(s_20_3), .b(s_20_2), .c(s_20_1), .d(s_20_0), .cin(t_76), .o(t_80), .co(t_81), .cout(t_82)); 
compressor_3_2 u1_32(.a(s_20_5), .b(s_20_4), .cin(t_79), .o(t_83), .cout(t_84)); 
compressor_4_2 u2_33(.a(s_21_3), .b(s_21_2), .c(s_21_1), .d(s_21_0), .cin(t_82), .o(t_85), .co(t_86), .cout(t_87)); 
compressor_3_2 u1_34(.a(s_21_6), .b(s_21_5), .cin(s_21_4), .o(t_88), .cout(t_89)); 
compressor_4_2 u2_35(.a(s_22_3), .b(s_22_2), .c(s_22_1), .d(s_22_0), .cin(t_87), .o(t_90), .co(t_91), .cout(t_92)); 
half_adder u0_36(.a(s_22_5), .b(s_22_4), .o(t_93), .cout(t_94)); 
compressor_4_2 u2_37(.a(s_23_3), .b(s_23_2), .c(s_23_1), .d(s_23_0), .cin(t_92), .o(t_95), .co(t_96), .cout(t_97)); 
half_adder u0_38(.a(s_23_5), .b(s_23_4), .o(t_98), .cout(t_99)); 
compressor_4_2 u2_39(.a(s_24_3), .b(s_24_2), .c(s_24_1), .d(s_24_0), .cin(t_97), .o(t_100), .co(t_101), .cout(t_102)); 
compressor_4_2 u2_40(.a(s_25_3), .b(s_25_2), .c(s_25_1), .d(s_25_0), .cin(t_102), .o(t_103), .co(t_104), .cout(t_105)); 
compressor_4_2 u2_41(.a(s_26_3), .b(s_26_2), .c(s_26_1), .d(s_26_0), .cin(t_105), .o(t_106), .co(t_107), .cout(t_108)); 
compressor_4_2 u2_42(.a(s_27_3), .b(s_27_2), .c(s_27_1), .d(s_27_0), .cin(t_108), .o(t_109), .co(t_110), .cout(t_111)); 
compressor_3_2 u1_43(.a(s_28_1), .b(s_28_0), .cin(t_111), .o(t_112), .cout(t_113)); 
compressor_3_2 u1_44(.a(s_29_2), .b(s_29_1), .cin(s_29_0), .o(t_114), .cout(t_115)); 
half_adder u0_45(.a(s_30_1), .b(s_30_0), .o(t_116), .cout(t_117)); 
half_adder u0_46(.a(s_31_1), .b(s_31_0), .o(t_118), .cout()); 

/* u0_47 Output nets */
wire    t_119,   t_120;  
/* u0_48 Output nets */
wire    t_121,   t_122;  
/* u1_49 Output nets */
wire    t_123,   t_124;  
/* u0_50 Output nets */
wire    t_125,   t_126;  
/* u0_51 Output nets */
wire    t_127,   t_128;  
/* u0_52 Output nets */
wire    t_129,   t_130;  
/* u1_53 Output nets */
wire    t_131,   t_132;  
/* u1_54 Output nets */
wire    t_133,   t_134;  
/* u1_55 Output nets */
wire    t_135,   t_136;  
/* u1_56 Output nets */
wire    t_137,   t_138;  
/* u2_57 Output nets */
wire    t_139,   t_140,   t_141;  
/* u2_58 Output nets */
wire    t_142,   t_143,   t_144;  
/* u2_59 Output nets */
wire    t_145,   t_146,   t_147;  
/* u2_60 Output nets */
wire    t_148,   t_149,   t_150;  
/* u2_61 Output nets */
wire    t_151,   t_152,   t_153;  
/* u2_62 Output nets */
wire    t_154,   t_155,   t_156;  
/* u2_63 Output nets */
wire    t_157,   t_158,   t_159;  
/* u2_64 Output nets */
wire    t_160,   t_161,   t_162;  
/* u2_65 Output nets */
wire    t_163,   t_164,   t_165;  
/* u2_66 Output nets */
wire    t_166,   t_167,   t_168;  
/* u2_67 Output nets */
wire    t_169,   t_170,   t_171;  
/* u2_68 Output nets */
wire    t_172,   t_173,   t_174;  
/* u2_69 Output nets */
wire    t_175,   t_176,   t_177;  
/* u1_70 Output nets */
wire    t_178,   t_179;  
/* u0_71 Output nets */
wire    t_180,   t_181;  
/* u0_72 Output nets */
wire    t_182,   t_183;  
/* u1_73 Output nets */
wire    t_184,   t_185;  
/* u0_74 Output nets */
wire    t_186,   t_187;  
/* u0_75 Output nets */
wire    t_188,   t_189;  
/* u0_76 Output nets */
wire    t_190;  

/* compress stage 2 */
half_adder u0_47(.a(t_1), .b(s_1_0), .o(t_119), .cout(t_120)); 
half_adder u0_48(.a(t_4), .b(t_3), .o(t_121), .cout(t_122)); 
compressor_3_2 u1_49(.a(t_6), .b(t_5), .cin(s_4_3), .o(t_123), .cout(t_124)); 
half_adder u0_50(.a(t_8), .b(t_7), .o(t_125), .cout(t_126)); 
half_adder u0_51(.a(t_10), .b(t_9), .o(t_127), .cout(t_128)); 
half_adder u0_52(.a(t_13), .b(t_11), .o(t_129), .cout(t_130)); 
compressor_3_2 u1_53(.a(t_19), .b(t_16), .cin(t_14), .o(t_131), .cout(t_132)); 
compressor_3_2 u1_54(.a(t_20), .b(t_17), .cin(s_9_4), .o(t_133), .cout(t_134)); 
compressor_3_2 u1_55(.a(t_27), .b(t_24), .cin(t_22), .o(t_135), .cout(t_136)); 
compressor_3_2 u1_56(.a(t_29), .b(t_28), .cin(t_25), .o(t_137), .cout(t_138)); 
compressor_4_2 u2_57(.a(t_37), .b(t_34), .c(t_33), .d(t_30), .cin(s_12_7), .o(t_139), .co(t_140), .cout(t_141)); 
compressor_4_2 u2_58(.a(t_42), .b(t_39), .c(t_38), .d(t_35), .cin(t_141), .o(t_142), .co(t_143), .cout(t_144)); 
compressor_4_2 u2_59(.a(t_47), .b(t_44), .c(t_43), .d(t_40), .cin(t_144), .o(t_145), .co(t_146), .cout(t_147)); 
compressor_4_2 u2_60(.a(t_53), .b(t_50), .c(t_48), .d(t_45), .cin(t_147), .o(t_148), .co(t_149), .cout(t_150)); 
compressor_4_2 u2_61(.a(t_56), .b(t_54), .c(t_51), .d(s_16_8), .cin(t_150), .o(t_151), .co(t_152), .cout(t_153)); 
compressor_4_2 u2_62(.a(t_62), .b(t_60), .c(t_57), .d(s_17_8), .cin(t_153), .o(t_154), .co(t_155), .cout(t_156)); 
compressor_4_2 u2_63(.a(t_71), .b(t_68), .c(t_66), .d(t_63), .cin(t_156), .o(t_157), .co(t_158), .cout(t_159)); 
compressor_4_2 u2_64(.a(t_77), .b(t_74), .c(t_72), .d(t_69), .cin(t_159), .o(t_160), .co(t_161), .cout(t_162)); 
compressor_4_2 u2_65(.a(t_80), .b(t_78), .c(t_75), .d(s_20_6), .cin(t_162), .o(t_163), .co(t_164), .cout(t_165)); 
compressor_4_2 u2_66(.a(t_88), .b(t_85), .c(t_84), .d(t_81), .cin(t_165), .o(t_166), .co(t_167), .cout(t_168)); 
compressor_4_2 u2_67(.a(t_93), .b(t_90), .c(t_89), .d(t_86), .cin(t_168), .o(t_169), .co(t_170), .cout(t_171)); 
compressor_4_2 u2_68(.a(t_98), .b(t_95), .c(t_94), .d(t_91), .cin(t_171), .o(t_172), .co(t_173), .cout(t_174)); 
compressor_4_2 u2_69(.a(t_100), .b(t_99), .c(t_96), .d(s_24_4), .cin(t_174), .o(t_175), .co(t_176), .cout(t_177)); 
compressor_3_2 u1_70(.a(t_101), .b(s_25_4), .cin(t_177), .o(t_178), .cout(t_179)); 
half_adder u0_71(.a(t_106), .b(t_104), .o(t_180), .cout(t_181)); 
half_adder u0_72(.a(t_109), .b(t_107), .o(t_182), .cout(t_183)); 
compressor_3_2 u1_73(.a(t_112), .b(t_110), .cin(s_28_2), .o(t_184), .cout(t_185)); 
half_adder u0_74(.a(t_114), .b(t_113), .o(t_186), .cout(t_187)); 
half_adder u0_75(.a(t_116), .b(t_115), .o(t_188), .cout(t_189)); 
half_adder u0_76(.a(t_118), .b(t_117), .o(t_190), .cout()); 

/* u0_77 Output nets */
wire    t_191,   t_192;  
/* u0_78 Output nets */
wire    t_193,   t_194;  
/* u0_79 Output nets */
wire    t_195,   t_196;  
/* u0_80 Output nets */
wire    t_197,   t_198;  
/* u0_81 Output nets */
wire    t_199,   t_200;  
/* u0_82 Output nets */
wire    t_201,   t_202;  
/* u1_83 Output nets */
wire    t_203,   t_204;  
/* u0_84 Output nets */
wire    t_205,   t_206;  
/* u1_85 Output nets */
wire    t_207,   t_208;  
/* u0_86 Output nets */
wire    t_209,   t_210;  
/* u0_87 Output nets */
wire    t_211,   t_212;  
/* u0_88 Output nets */
wire    t_213,   t_214;  
/* u0_89 Output nets */
wire    t_215,   t_216;  
/* u1_90 Output nets */
wire    t_217,   t_218;  
/* u1_91 Output nets */
wire    t_219,   t_220;  
/* u0_92 Output nets */
wire    t_221,   t_222;  
/* u0_93 Output nets */
wire    t_223,   t_224;  
/* u1_94 Output nets */
wire    t_225,   t_226;  
/* u0_95 Output nets */
wire    t_227,   t_228;  
/* u0_96 Output nets */
wire    t_229,   t_230;  
/* u0_97 Output nets */
wire    t_231,   t_232;  
/* u0_98 Output nets */
wire    t_233,   t_234;  
/* u1_99 Output nets */
wire    t_235,   t_236;  
/* u0_100 Output nets */
wire    t_237,   t_238;  
/* u0_101 Output nets */
wire    t_239,   t_240;  
/* u0_102 Output nets */
wire    t_241,   t_242;  
/* u0_103 Output nets */
wire    t_243,   t_244;  
/* u0_104 Output nets */
wire    t_245,   t_246;  
/* u0_105 Output nets */
wire    t_247;  

/* compress stage 3 */
half_adder u0_77(.a(t_120), .b(t_2), .o(t_191), .cout(t_192)); 
half_adder u0_78(.a(t_123), .b(t_122), .o(t_193), .cout(t_194)); 
half_adder u0_79(.a(t_125), .b(t_124), .o(t_195), .cout(t_196)); 
half_adder u0_80(.a(t_127), .b(t_126), .o(t_197), .cout(t_198)); 
half_adder u0_81(.a(t_129), .b(t_128), .o(t_199), .cout(t_200)); 
half_adder u0_82(.a(t_131), .b(t_130), .o(t_201), .cout(t_202)); 
compressor_3_2 u1_83(.a(t_133), .b(t_132), .cin(t_21), .o(t_203), .cout(t_204)); 
half_adder u0_84(.a(t_135), .b(t_134), .o(t_205), .cout(t_206)); 
compressor_3_2 u1_85(.a(t_137), .b(t_136), .cin(t_32), .o(t_207), .cout(t_208)); 
half_adder u0_86(.a(t_139), .b(t_138), .o(t_209), .cout(t_210)); 
half_adder u0_87(.a(t_142), .b(t_140), .o(t_211), .cout(t_212)); 
half_adder u0_88(.a(t_145), .b(t_143), .o(t_213), .cout(t_214)); 
half_adder u0_89(.a(t_148), .b(t_146), .o(t_215), .cout(t_216)); 
compressor_3_2 u1_90(.a(t_151), .b(t_149), .cin(t_59), .o(t_217), .cout(t_218)); 
compressor_3_2 u1_91(.a(t_154), .b(t_152), .cin(t_65), .o(t_219), .cout(t_220)); 
half_adder u0_92(.a(t_157), .b(t_155), .o(t_221), .cout(t_222)); 
half_adder u0_93(.a(t_160), .b(t_158), .o(t_223), .cout(t_224)); 
compressor_3_2 u1_94(.a(t_163), .b(t_161), .cin(t_83), .o(t_225), .cout(t_226)); 
half_adder u0_95(.a(t_166), .b(t_164), .o(t_227), .cout(t_228)); 
half_adder u0_96(.a(t_169), .b(t_167), .o(t_229), .cout(t_230)); 
half_adder u0_97(.a(t_172), .b(t_170), .o(t_231), .cout(t_232)); 
half_adder u0_98(.a(t_175), .b(t_173), .o(t_233), .cout(t_234)); 
compressor_3_2 u1_99(.a(t_178), .b(t_176), .cin(t_103), .o(t_235), .cout(t_236)); 
half_adder u0_100(.a(t_180), .b(t_179), .o(t_237), .cout(t_238)); 
half_adder u0_101(.a(t_182), .b(t_181), .o(t_239), .cout(t_240)); 
half_adder u0_102(.a(t_184), .b(t_183), .o(t_241), .cout(t_242)); 
half_adder u0_103(.a(t_186), .b(t_185), .o(t_243), .cout(t_244)); 
half_adder u0_104(.a(t_188), .b(t_187), .o(t_245), .cout(t_246)); 
half_adder u0_105(.a(t_190), .b(t_189), .o(t_247), .cout()); 

/* Output nets Compression result */
assign compress_a = {
   t_246,   t_244,   t_242,   t_240,
   t_238,   t_236,   t_234,   t_232,
   t_230,   t_228,   t_226,   t_224,
   t_222,   t_220,   t_218,   t_216,
   t_214,   t_212,   t_210,   t_208,
   t_206,   t_204,   t_202,   t_200,
   t_198,   t_196,   t_194,   t_193,
   t_121,   t_191,   t_119,     t_0
};
assign compress_b = {
   t_247,   t_245,   t_243,   t_241,
   t_239,   t_237,   t_235,   t_233,
   t_231,   t_229,   t_227,   t_225,
   t_223,   t_221,   t_219,   t_217,
   t_215,   t_213,   t_211,   t_209,
   t_207,   t_205,   t_203,   t_201,
   t_199,   t_197,   t_195,    1'b0,
   t_192,    1'b0,    1'b0,    1'b0
};

endmodule

/********************************************************************************/

module _32_wallace_tree(
//inputs
	partial_products,
	carry,
//outputs
	compress_a,
	compress_b
);

localparam width = 32;

input wire [(width+2)*(width/2+1)-1:0] partial_products;
input wire [width/2-1:0] carry;
output wire [2*width-1:0] compress_a;
output wire [2*width-1:0] compress_b;

/* Input nets */
wire  s_0_0,  s_0_1,  s_1_0,  s_2_0,  s_2_1,  s_2_2;  
wire  s_3_0,  s_3_1,  s_4_0,  s_4_1,  s_4_2,  s_4_3;  
wire  s_5_0,  s_5_1,  s_5_2,  s_6_0,  s_6_1,  s_6_2;  
wire  s_6_3,  s_6_4,  s_7_0,  s_7_1,  s_7_2,  s_7_3;  
wire  s_8_0,  s_8_1,  s_8_2,  s_8_3,  s_8_4,  s_8_5;  
wire  s_9_0,  s_9_1,  s_9_2,  s_9_3,  s_9_4, s_10_0;  
wire s_10_1, s_10_2, s_10_3, s_10_4, s_10_5, s_10_6;  
wire s_11_0, s_11_1, s_11_2, s_11_3, s_11_4, s_11_5;  
wire s_12_0, s_12_1, s_12_2, s_12_3, s_12_4, s_12_5;  
wire s_12_6, s_12_7, s_13_0, s_13_1, s_13_2, s_13_3;  
wire s_13_4, s_13_5, s_13_6, s_14_0, s_14_1, s_14_2;  
wire s_14_3, s_14_4, s_14_5, s_14_6, s_14_7, s_14_8;  
wire s_15_0, s_15_1, s_15_2, s_15_3, s_15_4, s_15_5;  
wire s_15_6, s_15_7, s_16_0, s_16_1, s_16_2, s_16_3;  
wire s_16_4, s_16_5, s_16_6, s_16_7, s_16_8, s_16_9;  
wire s_17_0, s_17_1, s_17_2, s_17_3, s_17_4, s_17_5;  
wire s_17_6, s_17_7, s_17_8, s_18_0, s_18_1, s_18_2;  
wire s_18_3, s_18_4, s_18_5, s_18_6, s_18_7, s_18_8;  
wire s_18_9, s_18_10, s_19_0, s_19_1, s_19_2, s_19_3;  
wire s_19_4, s_19_5, s_19_6, s_19_7, s_19_8, s_19_9;  
wire s_20_0, s_20_1, s_20_2, s_20_3, s_20_4, s_20_5;  
wire s_20_6, s_20_7, s_20_8, s_20_9, s_20_10, s_20_11;  
wire s_21_0, s_21_1, s_21_2, s_21_3, s_21_4, s_21_5;  
wire s_21_6, s_21_7, s_21_8, s_21_9, s_21_10, s_22_0;  
wire s_22_1, s_22_2, s_22_3, s_22_4, s_22_5, s_22_6;  
wire s_22_7, s_22_8, s_22_9, s_22_10, s_22_11, s_22_12;  
wire s_23_0, s_23_1, s_23_2, s_23_3, s_23_4, s_23_5;  
wire s_23_6, s_23_7, s_23_8, s_23_9, s_23_10, s_23_11;  
wire s_24_0, s_24_1, s_24_2, s_24_3, s_24_4, s_24_5;  
wire s_24_6, s_24_7, s_24_8, s_24_9, s_24_10, s_24_11;  
wire s_24_12, s_24_13, s_25_0, s_25_1, s_25_2, s_25_3;  
wire s_25_4, s_25_5, s_25_6, s_25_7, s_25_8, s_25_9;  
wire s_25_10, s_25_11, s_25_12, s_26_0, s_26_1, s_26_2;  
wire s_26_3, s_26_4, s_26_5, s_26_6, s_26_7, s_26_8;  
wire s_26_9, s_26_10, s_26_11, s_26_12, s_26_13, s_26_14;  
wire s_27_0, s_27_1, s_27_2, s_27_3, s_27_4, s_27_5;  
wire s_27_6, s_27_7, s_27_8, s_27_9, s_27_10, s_27_11;  
wire s_27_12, s_27_13, s_28_0, s_28_1, s_28_2, s_28_3;  
wire s_28_4, s_28_5, s_28_6, s_28_7, s_28_8, s_28_9;  
wire s_28_10, s_28_11, s_28_12, s_28_13, s_28_14, s_28_15;  
wire s_29_0, s_29_1, s_29_2, s_29_3, s_29_4, s_29_5;  
wire s_29_6, s_29_7, s_29_8, s_29_9, s_29_10, s_29_11;  
wire s_29_12, s_29_13, s_29_14, s_30_0, s_30_1, s_30_2;  
wire s_30_3, s_30_4, s_30_5, s_30_6, s_30_7, s_30_8;  
wire s_30_9, s_30_10, s_30_11, s_30_12, s_30_13, s_30_14;  
wire s_30_15, s_30_16, s_31_0, s_31_1, s_31_2, s_31_3;  
wire s_31_4, s_31_5, s_31_6, s_31_7, s_31_8, s_31_9;  
wire s_31_10, s_31_11, s_31_12, s_31_13, s_31_14, s_31_15;  
wire s_32_0, s_32_1, s_32_2, s_32_3, s_32_4, s_32_5;  
wire s_32_6, s_32_7, s_32_8, s_32_9, s_32_10, s_32_11;  
wire s_32_12, s_32_13, s_32_14, s_32_15, s_32_16, s_33_0;  
wire s_33_1, s_33_2, s_33_3, s_33_4, s_33_5, s_33_6;  
wire s_33_7, s_33_8, s_33_9, s_33_10, s_33_11, s_33_12;  
wire s_33_13, s_33_14, s_33_15, s_33_16, s_34_0, s_34_1;  
wire s_34_2, s_34_3, s_34_4, s_34_5, s_34_6, s_34_7;  
wire s_34_8, s_34_9, s_34_10, s_34_11, s_34_12, s_34_13;  
wire s_34_14, s_34_15, s_35_0, s_35_1, s_35_2, s_35_3;  
wire s_35_4, s_35_5, s_35_6, s_35_7, s_35_8, s_35_9;  
wire s_35_10, s_35_11, s_35_12, s_35_13, s_35_14, s_35_15;  
wire s_36_0, s_36_1, s_36_2, s_36_3, s_36_4, s_36_5;  
wire s_36_6, s_36_7, s_36_8, s_36_9, s_36_10, s_36_11;  
wire s_36_12, s_36_13, s_36_14, s_37_0, s_37_1, s_37_2;  
wire s_37_3, s_37_4, s_37_5, s_37_6, s_37_7, s_37_8;  
wire s_37_9, s_37_10, s_37_11, s_37_12, s_37_13, s_37_14;  
wire s_38_0, s_38_1, s_38_2, s_38_3, s_38_4, s_38_5;  
wire s_38_6, s_38_7, s_38_8, s_38_9, s_38_10, s_38_11;  
wire s_38_12, s_38_13, s_39_0, s_39_1, s_39_2, s_39_3;  
wire s_39_4, s_39_5, s_39_6, s_39_7, s_39_8, s_39_9;  
wire s_39_10, s_39_11, s_39_12, s_39_13, s_40_0, s_40_1;  
wire s_40_2, s_40_3, s_40_4, s_40_5, s_40_6, s_40_7;  
wire s_40_8, s_40_9, s_40_10, s_40_11, s_40_12, s_41_0;  
wire s_41_1, s_41_2, s_41_3, s_41_4, s_41_5, s_41_6;  
wire s_41_7, s_41_8, s_41_9, s_41_10, s_41_11, s_41_12;  
wire s_42_0, s_42_1, s_42_2, s_42_3, s_42_4, s_42_5;  
wire s_42_6, s_42_7, s_42_8, s_42_9, s_42_10, s_42_11;  
wire s_43_0, s_43_1, s_43_2, s_43_3, s_43_4, s_43_5;  
wire s_43_6, s_43_7, s_43_8, s_43_9, s_43_10, s_43_11;  
wire s_44_0, s_44_1, s_44_2, s_44_3, s_44_4, s_44_5;  
wire s_44_6, s_44_7, s_44_8, s_44_9, s_44_10, s_45_0;  
wire s_45_1, s_45_2, s_45_3, s_45_4, s_45_5, s_45_6;  
wire s_45_7, s_45_8, s_45_9, s_45_10, s_46_0, s_46_1;  
wire s_46_2, s_46_3, s_46_4, s_46_5, s_46_6, s_46_7;  
wire s_46_8, s_46_9, s_47_0, s_47_1, s_47_2, s_47_3;  
wire s_47_4, s_47_5, s_47_6, s_47_7, s_47_8, s_47_9;  
wire s_48_0, s_48_1, s_48_2, s_48_3, s_48_4, s_48_5;  
wire s_48_6, s_48_7, s_48_8, s_49_0, s_49_1, s_49_2;  
wire s_49_3, s_49_4, s_49_5, s_49_6, s_49_7, s_49_8;  
wire s_50_0, s_50_1, s_50_2, s_50_3, s_50_4, s_50_5;  
wire s_50_6, s_50_7, s_51_0, s_51_1, s_51_2, s_51_3;  
wire s_51_4, s_51_5, s_51_6, s_51_7, s_52_0, s_52_1;  
wire s_52_2, s_52_3, s_52_4, s_52_5, s_52_6, s_53_0;  
wire s_53_1, s_53_2, s_53_3, s_53_4, s_53_5, s_53_6;  
wire s_54_0, s_54_1, s_54_2, s_54_3, s_54_4, s_54_5;  
wire s_55_0, s_55_1, s_55_2, s_55_3, s_55_4, s_55_5;  
wire s_56_0, s_56_1, s_56_2, s_56_3, s_56_4, s_57_0;  
wire s_57_1, s_57_2, s_57_3, s_57_4, s_58_0, s_58_1;  
wire s_58_2, s_58_3, s_59_0, s_59_1, s_59_2, s_59_3;  
wire s_60_0, s_60_1, s_60_2, s_61_0, s_61_1, s_61_2;  
wire s_62_0, s_62_1, s_63_0, s_63_1;  

assign {
 s_30_16,  s_28_15,  s_26_14,  s_24_13,  s_22_12,  s_20_11, 
 s_18_10,   s_16_9,   s_14_8,   s_12_7,   s_10_6,    s_8_5, 
   s_6_4,    s_4_3,    s_2_2,    s_0_1  
} = carry;

assign {
  s_33_0,   s_32_0,   s_31_0,   s_30_0,   s_29_0,   s_28_0, 
  s_27_0,   s_26_0,   s_25_0,   s_24_0,   s_23_0,   s_22_0, 
  s_21_0,   s_20_0,   s_19_0,   s_18_0,   s_17_0,   s_16_0, 
  s_15_0,   s_14_0,   s_13_0,   s_12_0,   s_11_0,   s_10_0, 
   s_9_0,    s_8_0,    s_7_0,    s_6_0,    s_5_0,    s_4_0, 
   s_3_0,    s_2_0,    s_1_0,    s_0_0  
} = partial_products[(width+2)*(0+1)-1:(width+2)*0];

assign {
  s_35_0,   s_34_0,   s_33_1,   s_32_1,   s_31_1,   s_30_1, 
  s_29_1,   s_28_1,   s_27_1,   s_26_1,   s_25_1,   s_24_1, 
  s_23_1,   s_22_1,   s_21_1,   s_20_1,   s_19_1,   s_18_1, 
  s_17_1,   s_16_1,   s_15_1,   s_14_1,   s_13_1,   s_12_1, 
  s_11_1,   s_10_1,    s_9_1,    s_8_1,    s_7_1,    s_6_1, 
   s_5_1,    s_4_1,    s_3_1,    s_2_1  
} = partial_products[(width+2)*(1+1)-1:(width+2)*1];

assign {
  s_37_0,   s_36_0,   s_35_1,   s_34_1,   s_33_2,   s_32_2, 
  s_31_2,   s_30_2,   s_29_2,   s_28_2,   s_27_2,   s_26_2, 
  s_25_2,   s_24_2,   s_23_2,   s_22_2,   s_21_2,   s_20_2, 
  s_19_2,   s_18_2,   s_17_2,   s_16_2,   s_15_2,   s_14_2, 
  s_13_2,   s_12_2,   s_11_2,   s_10_2,    s_9_2,    s_8_2, 
   s_7_2,    s_6_2,    s_5_2,    s_4_2  
} = partial_products[(width+2)*(2+1)-1:(width+2)*2];

assign {
  s_39_0,   s_38_0,   s_37_1,   s_36_1,   s_35_2,   s_34_2, 
  s_33_3,   s_32_3,   s_31_3,   s_30_3,   s_29_3,   s_28_3, 
  s_27_3,   s_26_3,   s_25_3,   s_24_3,   s_23_3,   s_22_3, 
  s_21_3,   s_20_3,   s_19_3,   s_18_3,   s_17_3,   s_16_3, 
  s_15_3,   s_14_3,   s_13_3,   s_12_3,   s_11_3,   s_10_3, 
   s_9_3,    s_8_3,    s_7_3,    s_6_3  
} = partial_products[(width+2)*(3+1)-1:(width+2)*3];

assign {
  s_41_0,   s_40_0,   s_39_1,   s_38_1,   s_37_2,   s_36_2, 
  s_35_3,   s_34_3,   s_33_4,   s_32_4,   s_31_4,   s_30_4, 
  s_29_4,   s_28_4,   s_27_4,   s_26_4,   s_25_4,   s_24_4, 
  s_23_4,   s_22_4,   s_21_4,   s_20_4,   s_19_4,   s_18_4, 
  s_17_4,   s_16_4,   s_15_4,   s_14_4,   s_13_4,   s_12_4, 
  s_11_4,   s_10_4,    s_9_4,    s_8_4  
} = partial_products[(width+2)*(4+1)-1:(width+2)*4];

assign {
  s_43_0,   s_42_0,   s_41_1,   s_40_1,   s_39_2,   s_38_2, 
  s_37_3,   s_36_3,   s_35_4,   s_34_4,   s_33_5,   s_32_5, 
  s_31_5,   s_30_5,   s_29_5,   s_28_5,   s_27_5,   s_26_5, 
  s_25_5,   s_24_5,   s_23_5,   s_22_5,   s_21_5,   s_20_5, 
  s_19_5,   s_18_5,   s_17_5,   s_16_5,   s_15_5,   s_14_5, 
  s_13_5,   s_12_5,   s_11_5,   s_10_5  
} = partial_products[(width+2)*(5+1)-1:(width+2)*5];

assign {
  s_45_0,   s_44_0,   s_43_1,   s_42_1,   s_41_2,   s_40_2, 
  s_39_3,   s_38_3,   s_37_4,   s_36_4,   s_35_5,   s_34_5, 
  s_33_6,   s_32_6,   s_31_6,   s_30_6,   s_29_6,   s_28_6, 
  s_27_6,   s_26_6,   s_25_6,   s_24_6,   s_23_6,   s_22_6, 
  s_21_6,   s_20_6,   s_19_6,   s_18_6,   s_17_6,   s_16_6, 
  s_15_6,   s_14_6,   s_13_6,   s_12_6  
} = partial_products[(width+2)*(6+1)-1:(width+2)*6];

assign {
  s_47_0,   s_46_0,   s_45_1,   s_44_1,   s_43_2,   s_42_2, 
  s_41_3,   s_40_3,   s_39_4,   s_38_4,   s_37_5,   s_36_5, 
  s_35_6,   s_34_6,   s_33_7,   s_32_7,   s_31_7,   s_30_7, 
  s_29_7,   s_28_7,   s_27_7,   s_26_7,   s_25_7,   s_24_7, 
  s_23_7,   s_22_7,   s_21_7,   s_20_7,   s_19_7,   s_18_7, 
  s_17_7,   s_16_7,   s_15_7,   s_14_7  
} = partial_products[(width+2)*(7+1)-1:(width+2)*7];

assign {
  s_49_0,   s_48_0,   s_47_1,   s_46_1,   s_45_2,   s_44_2, 
  s_43_3,   s_42_3,   s_41_4,   s_40_4,   s_39_5,   s_38_5, 
  s_37_6,   s_36_6,   s_35_7,   s_34_7,   s_33_8,   s_32_8, 
  s_31_8,   s_30_8,   s_29_8,   s_28_8,   s_27_8,   s_26_8, 
  s_25_8,   s_24_8,   s_23_8,   s_22_8,   s_21_8,   s_20_8, 
  s_19_8,   s_18_8,   s_17_8,   s_16_8  
} = partial_products[(width+2)*(8+1)-1:(width+2)*8];

assign {
  s_51_0,   s_50_0,   s_49_1,   s_48_1,   s_47_2,   s_46_2, 
  s_45_3,   s_44_3,   s_43_4,   s_42_4,   s_41_5,   s_40_5, 
  s_39_6,   s_38_6,   s_37_7,   s_36_7,   s_35_8,   s_34_8, 
  s_33_9,   s_32_9,   s_31_9,   s_30_9,   s_29_9,   s_28_9, 
  s_27_9,   s_26_9,   s_25_9,   s_24_9,   s_23_9,   s_22_9, 
  s_21_9,   s_20_9,   s_19_9,   s_18_9  
} = partial_products[(width+2)*(9+1)-1:(width+2)*9];

assign {
  s_53_0,   s_52_0,   s_51_1,   s_50_1,   s_49_2,   s_48_2, 
  s_47_3,   s_46_3,   s_45_4,   s_44_4,   s_43_5,   s_42_5, 
  s_41_6,   s_40_6,   s_39_7,   s_38_7,   s_37_8,   s_36_8, 
  s_35_9,   s_34_9,  s_33_10,  s_32_10,  s_31_10,  s_30_10, 
 s_29_10,  s_28_10,  s_27_10,  s_26_10,  s_25_10,  s_24_10, 
 s_23_10,  s_22_10,  s_21_10,  s_20_10  
} = partial_products[(width+2)*(10+1)-1:(width+2)*10];

assign {
  s_55_0,   s_54_0,   s_53_1,   s_52_1,   s_51_2,   s_50_2, 
  s_49_3,   s_48_3,   s_47_4,   s_46_4,   s_45_5,   s_44_5, 
  s_43_6,   s_42_6,   s_41_7,   s_40_7,   s_39_8,   s_38_8, 
  s_37_9,   s_36_9,  s_35_10,  s_34_10,  s_33_11,  s_32_11, 
 s_31_11,  s_30_11,  s_29_11,  s_28_11,  s_27_11,  s_26_11, 
 s_25_11,  s_24_11,  s_23_11,  s_22_11  
} = partial_products[(width+2)*(11+1)-1:(width+2)*11];

assign {
  s_57_0,   s_56_0,   s_55_1,   s_54_1,   s_53_2,   s_52_2, 
  s_51_3,   s_50_3,   s_49_4,   s_48_4,   s_47_5,   s_46_5, 
  s_45_6,   s_44_6,   s_43_7,   s_42_7,   s_41_8,   s_40_8, 
  s_39_9,   s_38_9,  s_37_10,  s_36_10,  s_35_11,  s_34_11, 
 s_33_12,  s_32_12,  s_31_12,  s_30_12,  s_29_12,  s_28_12, 
 s_27_12,  s_26_12,  s_25_12,  s_24_12  
} = partial_products[(width+2)*(12+1)-1:(width+2)*12];

assign {
  s_59_0,   s_58_0,   s_57_1,   s_56_1,   s_55_2,   s_54_2, 
  s_53_3,   s_52_3,   s_51_4,   s_50_4,   s_49_5,   s_48_5, 
  s_47_6,   s_46_6,   s_45_7,   s_44_7,   s_43_8,   s_42_8, 
  s_41_9,   s_40_9,  s_39_10,  s_38_10,  s_37_11,  s_36_11, 
 s_35_12,  s_34_12,  s_33_13,  s_32_13,  s_31_13,  s_30_13, 
 s_29_13,  s_28_13,  s_27_13,  s_26_13  
} = partial_products[(width+2)*(13+1)-1:(width+2)*13];

assign {
  s_61_0,   s_60_0,   s_59_1,   s_58_1,   s_57_2,   s_56_2, 
  s_55_3,   s_54_3,   s_53_4,   s_52_4,   s_51_5,   s_50_5, 
  s_49_6,   s_48_6,   s_47_7,   s_46_7,   s_45_8,   s_44_8, 
  s_43_9,   s_42_9,  s_41_10,  s_40_10,  s_39_11,  s_38_11, 
 s_37_12,  s_36_12,  s_35_13,  s_34_13,  s_33_14,  s_32_14, 
 s_31_14,  s_30_14,  s_29_14,  s_28_14  
} = partial_products[(width+2)*(14+1)-1:(width+2)*14];

assign {
  s_63_0,   s_62_0,   s_61_1,   s_60_1,   s_59_2,   s_58_2, 
  s_57_3,   s_56_3,   s_55_4,   s_54_4,   s_53_5,   s_52_5, 
  s_51_6,   s_50_6,   s_49_7,   s_48_7,   s_47_8,   s_46_8, 
  s_45_9,   s_44_9,  s_43_10,  s_42_10,  s_41_11,  s_40_11, 
 s_39_12,  s_38_12,  s_37_13,  s_36_13,  s_35_14,  s_34_14, 
 s_33_15,  s_32_15,  s_31_15,  s_30_15  
} = partial_products[(width+2)*(15+1)-1:(width+2)*15];

assign {
  s_63_1,   s_62_1,   s_61_2,   s_60_2,   s_59_3,   s_58_3, 
  s_57_4,   s_56_4,   s_55_5,   s_54_5,   s_53_6,   s_52_6, 
  s_51_7,   s_50_7,   s_49_8,   s_48_8,   s_47_9,   s_46_9, 
 s_45_10,  s_44_10,  s_43_11,  s_42_11,  s_41_12,  s_40_12, 
 s_39_13,  s_38_13,  s_37_14,  s_36_14,  s_35_15,  s_34_15, 
 s_33_16,  s_32_16  
} = partial_products[(width+2)*(width/2+1)-1:(width+2)*width/2+2];

/* u0_1 Output nets */
wire    t_0,   t_1;  
/* u1_2 Output nets */
wire    t_2,   t_3;  
/* u0_3 Output nets */
wire    t_4,   t_5;  
/* u1_4 Output nets */
wire    t_6,   t_7;  
/* u1_5 Output nets */
wire    t_8,   t_9;  
/* u2_6 Output nets */
wire   t_10,  t_11,  t_12;  
/* u2_7 Output nets */
wire   t_13,  t_14,  t_15;  
/* u2_8 Output nets */
wire   t_16,  t_17,  t_18;  
/* u0_9 Output nets */
wire   t_19,  t_20;  
/* u2_10 Output nets */
wire   t_21,  t_22,  t_23;  
/* u2_11 Output nets */
wire   t_24,  t_25,  t_26;  
/* u1_12 Output nets */
wire   t_27,  t_28;  
/* u2_13 Output nets */
wire   t_29,  t_30,  t_31;  
/* u0_14 Output nets */
wire   t_32,  t_33;  
/* u2_15 Output nets */
wire   t_34,  t_35,  t_36;  
/* u1_16 Output nets */
wire   t_37,  t_38;  
/* u2_17 Output nets */
wire   t_39,  t_40,  t_41;  
/* u1_18 Output nets */
wire   t_42,  t_43;  
/* u2_19 Output nets */
wire   t_44,  t_45,  t_46;  
/* u2_20 Output nets */
wire   t_47,  t_48,  t_49;  
/* u2_21 Output nets */
wire   t_50,  t_51,  t_52;  
/* u2_22 Output nets */
wire   t_53,  t_54,  t_55;  
/* u2_23 Output nets */
wire   t_56,  t_57,  t_58;  
/* u2_24 Output nets */
wire   t_59,  t_60,  t_61;  
/* u0_25 Output nets */
wire   t_62,  t_63;  
/* u2_26 Output nets */
wire   t_64,  t_65,  t_66;  
/* u2_27 Output nets */
wire   t_67,  t_68,  t_69;  
/* u2_28 Output nets */
wire   t_70,  t_71,  t_72;  
/* u2_29 Output nets */
wire   t_73,  t_74,  t_75;  
/* u1_30 Output nets */
wire   t_76,  t_77;  
/* u2_31 Output nets */
wire   t_78,  t_79,  t_80;  
/* u2_32 Output nets */
wire   t_81,  t_82,  t_83;  
/* u0_33 Output nets */
wire   t_84,  t_85;  
/* u2_34 Output nets */
wire   t_86,  t_87,  t_88;  
/* u2_35 Output nets */
wire   t_89,  t_90,  t_91;  
/* u1_36 Output nets */
wire   t_92,  t_93;  
/* u2_37 Output nets */
wire   t_94,  t_95,  t_96;  
/* u2_38 Output nets */
wire   t_97,  t_98,  t_99;  
/* u1_39 Output nets */
wire  t_100, t_101;  
/* u2_40 Output nets */
wire  t_102, t_103, t_104;  
/* u2_41 Output nets */
wire  t_105, t_106, t_107;  
/* u2_42 Output nets */
wire  t_108, t_109, t_110;  
/* u2_43 Output nets */
wire  t_111, t_112, t_113;  
/* u2_44 Output nets */
wire  t_114, t_115, t_116;  
/* u2_45 Output nets */
wire  t_117, t_118, t_119;  
/* u2_46 Output nets */
wire  t_120, t_121, t_122;  
/* u2_47 Output nets */
wire  t_123, t_124, t_125;  
/* u2_48 Output nets */
wire  t_126, t_127, t_128;  
/* u0_49 Output nets */
wire  t_129, t_130;  
/* u2_50 Output nets */
wire  t_131, t_132, t_133;  
/* u2_51 Output nets */
wire  t_134, t_135, t_136;  
/* u2_52 Output nets */
wire  t_137, t_138, t_139;  
/* u2_53 Output nets */
wire  t_140, t_141, t_142;  
/* u2_54 Output nets */
wire  t_143, t_144, t_145;  
/* u2_55 Output nets */
wire  t_146, t_147, t_148;  
/* u1_56 Output nets */
wire  t_149, t_150;  
/* u2_57 Output nets */
wire  t_151, t_152, t_153;  
/* u2_58 Output nets */
wire  t_154, t_155, t_156;  
/* u2_59 Output nets */
wire  t_157, t_158, t_159;  
/* u0_60 Output nets */
wire  t_160, t_161;  
/* u2_61 Output nets */
wire  t_162, t_163, t_164;  
/* u2_62 Output nets */
wire  t_165, t_166, t_167;  
/* u2_63 Output nets */
wire  t_168, t_169, t_170;  
/* u1_64 Output nets */
wire  t_171, t_172;  
/* u2_65 Output nets */
wire  t_173, t_174, t_175;  
/* u2_66 Output nets */
wire  t_176, t_177, t_178;  
/* u2_67 Output nets */
wire  t_179, t_180, t_181;  
/* u1_68 Output nets */
wire  t_182, t_183;  
/* u2_69 Output nets */
wire  t_184, t_185, t_186;  
/* u2_70 Output nets */
wire  t_187, t_188, t_189;  
/* u2_71 Output nets */
wire  t_190, t_191, t_192;  
/* u2_72 Output nets */
wire  t_193, t_194, t_195;  
/* u2_73 Output nets */
wire  t_196, t_197, t_198;  
/* u2_74 Output nets */
wire  t_199, t_200, t_201;  
/* u2_75 Output nets */
wire  t_202, t_203, t_204;  
/* u2_76 Output nets */
wire  t_205, t_206, t_207;  
/* u2_77 Output nets */
wire  t_208, t_209, t_210;  
/* u2_78 Output nets */
wire  t_211, t_212, t_213;  
/* u2_79 Output nets */
wire  t_214, t_215, t_216;  
/* u2_80 Output nets */
wire  t_217, t_218, t_219;  
/* u2_81 Output nets */
wire  t_220, t_221, t_222;  
/* u2_82 Output nets */
wire  t_223, t_224, t_225;  
/* u2_83 Output nets */
wire  t_226, t_227, t_228;  
/* u2_84 Output nets */
wire  t_229, t_230, t_231;  
/* u2_85 Output nets */
wire  t_232, t_233, t_234;  
/* u2_86 Output nets */
wire  t_235, t_236, t_237;  
/* u2_87 Output nets */
wire  t_238, t_239, t_240;  
/* u2_88 Output nets */
wire  t_241, t_242, t_243;  
/* u2_89 Output nets */
wire  t_244, t_245, t_246;  
/* u2_90 Output nets */
wire  t_247, t_248, t_249;  
/* u2_91 Output nets */
wire  t_250, t_251, t_252;  
/* u2_92 Output nets */
wire  t_253, t_254, t_255;  
/* u2_93 Output nets */
wire  t_256, t_257, t_258;  
/* u2_94 Output nets */
wire  t_259, t_260, t_261;  
/* u2_95 Output nets */
wire  t_262, t_263, t_264;  
/* u1_96 Output nets */
wire  t_265, t_266;  
/* u2_97 Output nets */
wire  t_267, t_268, t_269;  
/* u2_98 Output nets */
wire  t_270, t_271, t_272;  
/* u2_99 Output nets */
wire  t_273, t_274, t_275;  
/* u1_100 Output nets */
wire  t_276, t_277;  
/* u2_101 Output nets */
wire  t_278, t_279, t_280;  
/* u2_102 Output nets */
wire  t_281, t_282, t_283;  
/* u2_103 Output nets */
wire  t_284, t_285, t_286;  
/* u0_104 Output nets */
wire  t_287, t_288;  
/* u2_105 Output nets */
wire  t_289, t_290, t_291;  
/* u2_106 Output nets */
wire  t_292, t_293, t_294;  
/* u2_107 Output nets */
wire  t_295, t_296, t_297;  
/* u0_108 Output nets */
wire  t_298, t_299;  
/* u2_109 Output nets */
wire  t_300, t_301, t_302;  
/* u2_110 Output nets */
wire  t_303, t_304, t_305;  
/* u2_111 Output nets */
wire  t_306, t_307, t_308;  
/* u2_112 Output nets */
wire  t_309, t_310, t_311;  
/* u2_113 Output nets */
wire  t_312, t_313, t_314;  
/* u2_114 Output nets */
wire  t_315, t_316, t_317;  
/* u2_115 Output nets */
wire  t_318, t_319, t_320;  
/* u2_116 Output nets */
wire  t_321, t_322, t_323;  
/* u2_117 Output nets */
wire  t_324, t_325, t_326;  
/* u2_118 Output nets */
wire  t_327, t_328, t_329;  
/* u2_119 Output nets */
wire  t_330, t_331, t_332;  
/* u2_120 Output nets */
wire  t_333, t_334, t_335;  
/* u2_121 Output nets */
wire  t_336, t_337, t_338;  
/* u2_122 Output nets */
wire  t_339, t_340, t_341;  
/* u1_123 Output nets */
wire  t_342, t_343;  
/* u2_124 Output nets */
wire  t_344, t_345, t_346;  
/* u2_125 Output nets */
wire  t_347, t_348, t_349;  
/* u1_126 Output nets */
wire  t_350, t_351;  
/* u2_127 Output nets */
wire  t_352, t_353, t_354;  
/* u2_128 Output nets */
wire  t_355, t_356, t_357;  
/* u0_129 Output nets */
wire  t_358, t_359;  
/* u2_130 Output nets */
wire  t_360, t_361, t_362;  
/* u2_131 Output nets */
wire  t_363, t_364, t_365;  
/* u0_132 Output nets */
wire  t_366, t_367;  
/* u2_133 Output nets */
wire  t_368, t_369, t_370;  
/* u2_134 Output nets */
wire  t_371, t_372, t_373;  
/* u2_135 Output nets */
wire  t_374, t_375, t_376;  
/* u2_136 Output nets */
wire  t_377, t_378, t_379;  
/* u2_137 Output nets */
wire  t_380, t_381, t_382;  
/* u2_138 Output nets */
wire  t_383, t_384, t_385;  
/* u2_139 Output nets */
wire  t_386, t_387, t_388;  
/* u2_140 Output nets */
wire  t_389, t_390, t_391;  
/* u2_141 Output nets */
wire  t_392, t_393, t_394;  
/* u1_142 Output nets */
wire  t_395, t_396;  
/* u2_143 Output nets */
wire  t_397, t_398, t_399;  
/* u1_144 Output nets */
wire  t_400, t_401;  
/* u2_145 Output nets */
wire  t_402, t_403, t_404;  
/* u0_146 Output nets */
wire  t_405, t_406;  
/* u2_147 Output nets */
wire  t_407, t_408, t_409;  
/* u0_148 Output nets */
wire  t_410, t_411;  
/* u2_149 Output nets */
wire  t_412, t_413, t_414;  
/* u2_150 Output nets */
wire  t_415, t_416, t_417;  
/* u2_151 Output nets */
wire  t_418, t_419, t_420;  
/* u2_152 Output nets */
wire  t_421, t_422, t_423;  
/* u1_153 Output nets */
wire  t_424, t_425;  
/* u1_154 Output nets */
wire  t_426, t_427;  
/* u0_155 Output nets */
wire  t_428, t_429;  
/* u0_156 Output nets */
wire  t_430;  

/* compress stage 1 */
half_adder u0_1(.a(s_0_1), .b(s_0_0), .o(t_0), .cout(t_1)); 
compressor_3_2 u1_2(.a(s_2_2), .b(s_2_1), .cin(s_2_0), .o(t_2), .cout(t_3)); 
half_adder u0_3(.a(s_3_1), .b(s_3_0), .o(t_4), .cout(t_5)); 
compressor_3_2 u1_4(.a(s_4_2), .b(s_4_1), .cin(s_4_0), .o(t_6), .cout(t_7)); 
compressor_3_2 u1_5(.a(s_5_2), .b(s_5_1), .cin(s_5_0), .o(t_8), .cout(t_9)); 
compressor_4_2 u2_6(.a(s_6_4), .b(s_6_3), .c(s_6_2), .d(s_6_1), .cin(s_6_0), .o(t_10), .co(t_11), .cout(t_12)); 
compressor_4_2 u2_7(.a(s_7_3), .b(s_7_2), .c(s_7_1), .d(s_7_0), .cin(t_12), .o(t_13), .co(t_14), .cout(t_15)); 
compressor_4_2 u2_8(.a(s_8_3), .b(s_8_2), .c(s_8_1), .d(s_8_0), .cin(t_15), .o(t_16), .co(t_17), .cout(t_18)); 
half_adder u0_9(.a(s_8_5), .b(s_8_4), .o(t_19), .cout(t_20)); 
compressor_4_2 u2_10(.a(s_9_3), .b(s_9_2), .c(s_9_1), .d(s_9_0), .cin(t_18), .o(t_21), .co(t_22), .cout(t_23)); 
compressor_4_2 u2_11(.a(s_10_3), .b(s_10_2), .c(s_10_1), .d(s_10_0), .cin(t_23), .o(t_24), .co(t_25), .cout(t_26)); 
compressor_3_2 u1_12(.a(s_10_6), .b(s_10_5), .cin(s_10_4), .o(t_27), .cout(t_28)); 
compressor_4_2 u2_13(.a(s_11_3), .b(s_11_2), .c(s_11_1), .d(s_11_0), .cin(t_26), .o(t_29), .co(t_30), .cout(t_31)); 
half_adder u0_14(.a(s_11_5), .b(s_11_4), .o(t_32), .cout(t_33)); 
compressor_4_2 u2_15(.a(s_12_3), .b(s_12_2), .c(s_12_1), .d(s_12_0), .cin(t_31), .o(t_34), .co(t_35), .cout(t_36)); 
compressor_3_2 u1_16(.a(s_12_6), .b(s_12_5), .cin(s_12_4), .o(t_37), .cout(t_38)); 
compressor_4_2 u2_17(.a(s_13_3), .b(s_13_2), .c(s_13_1), .d(s_13_0), .cin(t_36), .o(t_39), .co(t_40), .cout(t_41)); 
compressor_3_2 u1_18(.a(s_13_6), .b(s_13_5), .cin(s_13_4), .o(t_42), .cout(t_43)); 
compressor_4_2 u2_19(.a(s_14_3), .b(s_14_2), .c(s_14_1), .d(s_14_0), .cin(t_41), .o(t_44), .co(t_45), .cout(t_46)); 
compressor_4_2 u2_20(.a(s_14_8), .b(s_14_7), .c(s_14_6), .d(s_14_5), .cin(s_14_4), .o(t_47), .co(t_48), .cout(t_49)); 
compressor_4_2 u2_21(.a(s_15_3), .b(s_15_2), .c(s_15_1), .d(s_15_0), .cin(t_46), .o(t_50), .co(t_51), .cout(t_52)); 
compressor_4_2 u2_22(.a(s_15_7), .b(s_15_6), .c(s_15_5), .d(s_15_4), .cin(t_49), .o(t_53), .co(t_54), .cout(t_55)); 
compressor_4_2 u2_23(.a(s_16_3), .b(s_16_2), .c(s_16_1), .d(s_16_0), .cin(t_52), .o(t_56), .co(t_57), .cout(t_58)); 
compressor_4_2 u2_24(.a(s_16_7), .b(s_16_6), .c(s_16_5), .d(s_16_4), .cin(t_55), .o(t_59), .co(t_60), .cout(t_61)); 
half_adder u0_25(.a(s_16_9), .b(s_16_8), .o(t_62), .cout(t_63)); 
compressor_4_2 u2_26(.a(s_17_3), .b(s_17_2), .c(s_17_1), .d(s_17_0), .cin(t_58), .o(t_64), .co(t_65), .cout(t_66)); 
compressor_4_2 u2_27(.a(s_17_7), .b(s_17_6), .c(s_17_5), .d(s_17_4), .cin(t_61), .o(t_67), .co(t_68), .cout(t_69)); 
compressor_4_2 u2_28(.a(s_18_3), .b(s_18_2), .c(s_18_1), .d(s_18_0), .cin(t_66), .o(t_70), .co(t_71), .cout(t_72)); 
compressor_4_2 u2_29(.a(s_18_7), .b(s_18_6), .c(s_18_5), .d(s_18_4), .cin(t_69), .o(t_73), .co(t_74), .cout(t_75)); 
compressor_3_2 u1_30(.a(s_18_10), .b(s_18_9), .cin(s_18_8), .o(t_76), .cout(t_77)); 
compressor_4_2 u2_31(.a(s_19_3), .b(s_19_2), .c(s_19_1), .d(s_19_0), .cin(t_72), .o(t_78), .co(t_79), .cout(t_80)); 
compressor_4_2 u2_32(.a(s_19_7), .b(s_19_6), .c(s_19_5), .d(s_19_4), .cin(t_75), .o(t_81), .co(t_82), .cout(t_83)); 
half_adder u0_33(.a(s_19_9), .b(s_19_8), .o(t_84), .cout(t_85)); 
compressor_4_2 u2_34(.a(s_20_3), .b(s_20_2), .c(s_20_1), .d(s_20_0), .cin(t_80), .o(t_86), .co(t_87), .cout(t_88)); 
compressor_4_2 u2_35(.a(s_20_7), .b(s_20_6), .c(s_20_5), .d(s_20_4), .cin(t_83), .o(t_89), .co(t_90), .cout(t_91)); 
compressor_3_2 u1_36(.a(s_20_10), .b(s_20_9), .cin(s_20_8), .o(t_92), .cout(t_93)); 
compressor_4_2 u2_37(.a(s_21_3), .b(s_21_2), .c(s_21_1), .d(s_21_0), .cin(t_88), .o(t_94), .co(t_95), .cout(t_96)); 
compressor_4_2 u2_38(.a(s_21_7), .b(s_21_6), .c(s_21_5), .d(s_21_4), .cin(t_91), .o(t_97), .co(t_98), .cout(t_99)); 
compressor_3_2 u1_39(.a(s_21_10), .b(s_21_9), .cin(s_21_8), .o(t_100), .cout(t_101)); 
compressor_4_2 u2_40(.a(s_22_3), .b(s_22_2), .c(s_22_1), .d(s_22_0), .cin(t_96), .o(t_102), .co(t_103), .cout(t_104)); 
compressor_4_2 u2_41(.a(s_22_7), .b(s_22_6), .c(s_22_5), .d(s_22_4), .cin(t_99), .o(t_105), .co(t_106), .cout(t_107)); 
compressor_4_2 u2_42(.a(s_22_12), .b(s_22_11), .c(s_22_10), .d(s_22_9), .cin(s_22_8), .o(t_108), .co(t_109), .cout(t_110)); 
compressor_4_2 u2_43(.a(s_23_3), .b(s_23_2), .c(s_23_1), .d(s_23_0), .cin(t_104), .o(t_111), .co(t_112), .cout(t_113)); 
compressor_4_2 u2_44(.a(s_23_7), .b(s_23_6), .c(s_23_5), .d(s_23_4), .cin(t_107), .o(t_114), .co(t_115), .cout(t_116)); 
compressor_4_2 u2_45(.a(s_23_11), .b(s_23_10), .c(s_23_9), .d(s_23_8), .cin(t_110), .o(t_117), .co(t_118), .cout(t_119)); 
compressor_4_2 u2_46(.a(s_24_3), .b(s_24_2), .c(s_24_1), .d(s_24_0), .cin(t_113), .o(t_120), .co(t_121), .cout(t_122)); 
compressor_4_2 u2_47(.a(s_24_7), .b(s_24_6), .c(s_24_5), .d(s_24_4), .cin(t_116), .o(t_123), .co(t_124), .cout(t_125)); 
compressor_4_2 u2_48(.a(s_24_11), .b(s_24_10), .c(s_24_9), .d(s_24_8), .cin(t_119), .o(t_126), .co(t_127), .cout(t_128)); 
half_adder u0_49(.a(s_24_13), .b(s_24_12), .o(t_129), .cout(t_130)); 
compressor_4_2 u2_50(.a(s_25_3), .b(s_25_2), .c(s_25_1), .d(s_25_0), .cin(t_122), .o(t_131), .co(t_132), .cout(t_133)); 
compressor_4_2 u2_51(.a(s_25_7), .b(s_25_6), .c(s_25_5), .d(s_25_4), .cin(t_125), .o(t_134), .co(t_135), .cout(t_136)); 
compressor_4_2 u2_52(.a(s_25_11), .b(s_25_10), .c(s_25_9), .d(s_25_8), .cin(t_128), .o(t_137), .co(t_138), .cout(t_139)); 
compressor_4_2 u2_53(.a(s_26_3), .b(s_26_2), .c(s_26_1), .d(s_26_0), .cin(t_133), .o(t_140), .co(t_141), .cout(t_142)); 
compressor_4_2 u2_54(.a(s_26_7), .b(s_26_6), .c(s_26_5), .d(s_26_4), .cin(t_136), .o(t_143), .co(t_144), .cout(t_145)); 
compressor_4_2 u2_55(.a(s_26_11), .b(s_26_10), .c(s_26_9), .d(s_26_8), .cin(t_139), .o(t_146), .co(t_147), .cout(t_148)); 
compressor_3_2 u1_56(.a(s_26_14), .b(s_26_13), .cin(s_26_12), .o(t_149), .cout(t_150)); 
compressor_4_2 u2_57(.a(s_27_3), .b(s_27_2), .c(s_27_1), .d(s_27_0), .cin(t_142), .o(t_151), .co(t_152), .cout(t_153)); 
compressor_4_2 u2_58(.a(s_27_7), .b(s_27_6), .c(s_27_5), .d(s_27_4), .cin(t_145), .o(t_154), .co(t_155), .cout(t_156)); 
compressor_4_2 u2_59(.a(s_27_11), .b(s_27_10), .c(s_27_9), .d(s_27_8), .cin(t_148), .o(t_157), .co(t_158), .cout(t_159)); 
half_adder u0_60(.a(s_27_13), .b(s_27_12), .o(t_160), .cout(t_161)); 
compressor_4_2 u2_61(.a(s_28_3), .b(s_28_2), .c(s_28_1), .d(s_28_0), .cin(t_153), .o(t_162), .co(t_163), .cout(t_164)); 
compressor_4_2 u2_62(.a(s_28_7), .b(s_28_6), .c(s_28_5), .d(s_28_4), .cin(t_156), .o(t_165), .co(t_166), .cout(t_167)); 
compressor_4_2 u2_63(.a(s_28_11), .b(s_28_10), .c(s_28_9), .d(s_28_8), .cin(t_159), .o(t_168), .co(t_169), .cout(t_170)); 
compressor_3_2 u1_64(.a(s_28_14), .b(s_28_13), .cin(s_28_12), .o(t_171), .cout(t_172)); 
compressor_4_2 u2_65(.a(s_29_3), .b(s_29_2), .c(s_29_1), .d(s_29_0), .cin(t_164), .o(t_173), .co(t_174), .cout(t_175)); 
compressor_4_2 u2_66(.a(s_29_7), .b(s_29_6), .c(s_29_5), .d(s_29_4), .cin(t_167), .o(t_176), .co(t_177), .cout(t_178)); 
compressor_4_2 u2_67(.a(s_29_11), .b(s_29_10), .c(s_29_9), .d(s_29_8), .cin(t_170), .o(t_179), .co(t_180), .cout(t_181)); 
compressor_3_2 u1_68(.a(s_29_14), .b(s_29_13), .cin(s_29_12), .o(t_182), .cout(t_183)); 
compressor_4_2 u2_69(.a(s_30_3), .b(s_30_2), .c(s_30_1), .d(s_30_0), .cin(t_175), .o(t_184), .co(t_185), .cout(t_186)); 
compressor_4_2 u2_70(.a(s_30_7), .b(s_30_6), .c(s_30_5), .d(s_30_4), .cin(t_178), .o(t_187), .co(t_188), .cout(t_189)); 
compressor_4_2 u2_71(.a(s_30_11), .b(s_30_10), .c(s_30_9), .d(s_30_8), .cin(t_181), .o(t_190), .co(t_191), .cout(t_192)); 
compressor_4_2 u2_72(.a(s_30_16), .b(s_30_15), .c(s_30_14), .d(s_30_13), .cin(s_30_12), .o(t_193), .co(t_194), .cout(t_195)); 
compressor_4_2 u2_73(.a(s_31_3), .b(s_31_2), .c(s_31_1), .d(s_31_0), .cin(t_186), .o(t_196), .co(t_197), .cout(t_198)); 
compressor_4_2 u2_74(.a(s_31_7), .b(s_31_6), .c(s_31_5), .d(s_31_4), .cin(t_189), .o(t_199), .co(t_200), .cout(t_201)); 
compressor_4_2 u2_75(.a(s_31_11), .b(s_31_10), .c(s_31_9), .d(s_31_8), .cin(t_192), .o(t_202), .co(t_203), .cout(t_204)); 
compressor_4_2 u2_76(.a(s_31_15), .b(s_31_14), .c(s_31_13), .d(s_31_12), .cin(t_195), .o(t_205), .co(t_206), .cout(t_207)); 
compressor_4_2 u2_77(.a(s_32_3), .b(s_32_2), .c(s_32_1), .d(s_32_0), .cin(t_198), .o(t_208), .co(t_209), .cout(t_210)); 
compressor_4_2 u2_78(.a(s_32_7), .b(s_32_6), .c(s_32_5), .d(s_32_4), .cin(t_201), .o(t_211), .co(t_212), .cout(t_213)); 
compressor_4_2 u2_79(.a(s_32_11), .b(s_32_10), .c(s_32_9), .d(s_32_8), .cin(t_204), .o(t_214), .co(t_215), .cout(t_216)); 
compressor_4_2 u2_80(.a(s_32_15), .b(s_32_14), .c(s_32_13), .d(s_32_12), .cin(t_207), .o(t_217), .co(t_218), .cout(t_219)); 
compressor_4_2 u2_81(.a(s_33_3), .b(s_33_2), .c(s_33_1), .d(s_33_0), .cin(t_210), .o(t_220), .co(t_221), .cout(t_222)); 
compressor_4_2 u2_82(.a(s_33_7), .b(s_33_6), .c(s_33_5), .d(s_33_4), .cin(t_213), .o(t_223), .co(t_224), .cout(t_225)); 
compressor_4_2 u2_83(.a(s_33_11), .b(s_33_10), .c(s_33_9), .d(s_33_8), .cin(t_216), .o(t_226), .co(t_227), .cout(t_228)); 
compressor_4_2 u2_84(.a(s_33_15), .b(s_33_14), .c(s_33_13), .d(s_33_12), .cin(t_219), .o(t_229), .co(t_230), .cout(t_231)); 
compressor_4_2 u2_85(.a(s_34_3), .b(s_34_2), .c(s_34_1), .d(s_34_0), .cin(t_222), .o(t_232), .co(t_233), .cout(t_234)); 
compressor_4_2 u2_86(.a(s_34_7), .b(s_34_6), .c(s_34_5), .d(s_34_4), .cin(t_225), .o(t_235), .co(t_236), .cout(t_237)); 
compressor_4_2 u2_87(.a(s_34_11), .b(s_34_10), .c(s_34_9), .d(s_34_8), .cin(t_228), .o(t_238), .co(t_239), .cout(t_240)); 
compressor_4_2 u2_88(.a(s_34_15), .b(s_34_14), .c(s_34_13), .d(s_34_12), .cin(t_231), .o(t_241), .co(t_242), .cout(t_243)); 
compressor_4_2 u2_89(.a(s_35_3), .b(s_35_2), .c(s_35_1), .d(s_35_0), .cin(t_234), .o(t_244), .co(t_245), .cout(t_246)); 
compressor_4_2 u2_90(.a(s_35_7), .b(s_35_6), .c(s_35_5), .d(s_35_4), .cin(t_237), .o(t_247), .co(t_248), .cout(t_249)); 
compressor_4_2 u2_91(.a(s_35_11), .b(s_35_10), .c(s_35_9), .d(s_35_8), .cin(t_240), .o(t_250), .co(t_251), .cout(t_252)); 
compressor_4_2 u2_92(.a(s_35_15), .b(s_35_14), .c(s_35_13), .d(s_35_12), .cin(t_243), .o(t_253), .co(t_254), .cout(t_255)); 
compressor_4_2 u2_93(.a(s_36_3), .b(s_36_2), .c(s_36_1), .d(s_36_0), .cin(t_246), .o(t_256), .co(t_257), .cout(t_258)); 
compressor_4_2 u2_94(.a(s_36_7), .b(s_36_6), .c(s_36_5), .d(s_36_4), .cin(t_249), .o(t_259), .co(t_260), .cout(t_261)); 
compressor_4_2 u2_95(.a(s_36_11), .b(s_36_10), .c(s_36_9), .d(s_36_8), .cin(t_252), .o(t_262), .co(t_263), .cout(t_264)); 
compressor_3_2 u1_96(.a(s_36_13), .b(s_36_12), .cin(t_255), .o(t_265), .cout(t_266)); 
compressor_4_2 u2_97(.a(s_37_3), .b(s_37_2), .c(s_37_1), .d(s_37_0), .cin(t_258), .o(t_267), .co(t_268), .cout(t_269)); 
compressor_4_2 u2_98(.a(s_37_7), .b(s_37_6), .c(s_37_5), .d(s_37_4), .cin(t_261), .o(t_270), .co(t_271), .cout(t_272)); 
compressor_4_2 u2_99(.a(s_37_11), .b(s_37_10), .c(s_37_9), .d(s_37_8), .cin(t_264), .o(t_273), .co(t_274), .cout(t_275)); 
compressor_3_2 u1_100(.a(s_37_14), .b(s_37_13), .cin(s_37_12), .o(t_276), .cout(t_277)); 
compressor_4_2 u2_101(.a(s_38_3), .b(s_38_2), .c(s_38_1), .d(s_38_0), .cin(t_269), .o(t_278), .co(t_279), .cout(t_280)); 
compressor_4_2 u2_102(.a(s_38_7), .b(s_38_6), .c(s_38_5), .d(s_38_4), .cin(t_272), .o(t_281), .co(t_282), .cout(t_283)); 
compressor_4_2 u2_103(.a(s_38_11), .b(s_38_10), .c(s_38_9), .d(s_38_8), .cin(t_275), .o(t_284), .co(t_285), .cout(t_286)); 
half_adder u0_104(.a(s_38_13), .b(s_38_12), .o(t_287), .cout(t_288)); 
compressor_4_2 u2_105(.a(s_39_3), .b(s_39_2), .c(s_39_1), .d(s_39_0), .cin(t_280), .o(t_289), .co(t_290), .cout(t_291)); 
compressor_4_2 u2_106(.a(s_39_7), .b(s_39_6), .c(s_39_5), .d(s_39_4), .cin(t_283), .o(t_292), .co(t_293), .cout(t_294)); 
compressor_4_2 u2_107(.a(s_39_11), .b(s_39_10), .c(s_39_9), .d(s_39_8), .cin(t_286), .o(t_295), .co(t_296), .cout(t_297)); 
half_adder u0_108(.a(s_39_13), .b(s_39_12), .o(t_298), .cout(t_299)); 
compressor_4_2 u2_109(.a(s_40_3), .b(s_40_2), .c(s_40_1), .d(s_40_0), .cin(t_291), .o(t_300), .co(t_301), .cout(t_302)); 
compressor_4_2 u2_110(.a(s_40_7), .b(s_40_6), .c(s_40_5), .d(s_40_4), .cin(t_294), .o(t_303), .co(t_304), .cout(t_305)); 
compressor_4_2 u2_111(.a(s_40_11), .b(s_40_10), .c(s_40_9), .d(s_40_8), .cin(t_297), .o(t_306), .co(t_307), .cout(t_308)); 
compressor_4_2 u2_112(.a(s_41_3), .b(s_41_2), .c(s_41_1), .d(s_41_0), .cin(t_302), .o(t_309), .co(t_310), .cout(t_311)); 
compressor_4_2 u2_113(.a(s_41_7), .b(s_41_6), .c(s_41_5), .d(s_41_4), .cin(t_305), .o(t_312), .co(t_313), .cout(t_314)); 
compressor_4_2 u2_114(.a(s_41_11), .b(s_41_10), .c(s_41_9), .d(s_41_8), .cin(t_308), .o(t_315), .co(t_316), .cout(t_317)); 
compressor_4_2 u2_115(.a(s_42_3), .b(s_42_2), .c(s_42_1), .d(s_42_0), .cin(t_311), .o(t_318), .co(t_319), .cout(t_320)); 
compressor_4_2 u2_116(.a(s_42_7), .b(s_42_6), .c(s_42_5), .d(s_42_4), .cin(t_314), .o(t_321), .co(t_322), .cout(t_323)); 
compressor_4_2 u2_117(.a(s_42_11), .b(s_42_10), .c(s_42_9), .d(s_42_8), .cin(t_317), .o(t_324), .co(t_325), .cout(t_326)); 
compressor_4_2 u2_118(.a(s_43_3), .b(s_43_2), .c(s_43_1), .d(s_43_0), .cin(t_320), .o(t_327), .co(t_328), .cout(t_329)); 
compressor_4_2 u2_119(.a(s_43_7), .b(s_43_6), .c(s_43_5), .d(s_43_4), .cin(t_323), .o(t_330), .co(t_331), .cout(t_332)); 
compressor_4_2 u2_120(.a(s_43_11), .b(s_43_10), .c(s_43_9), .d(s_43_8), .cin(t_326), .o(t_333), .co(t_334), .cout(t_335)); 
compressor_4_2 u2_121(.a(s_44_3), .b(s_44_2), .c(s_44_1), .d(s_44_0), .cin(t_329), .o(t_336), .co(t_337), .cout(t_338)); 
compressor_4_2 u2_122(.a(s_44_7), .b(s_44_6), .c(s_44_5), .d(s_44_4), .cin(t_332), .o(t_339), .co(t_340), .cout(t_341)); 
compressor_3_2 u1_123(.a(s_44_9), .b(s_44_8), .cin(t_335), .o(t_342), .cout(t_343)); 
compressor_4_2 u2_124(.a(s_45_3), .b(s_45_2), .c(s_45_1), .d(s_45_0), .cin(t_338), .o(t_344), .co(t_345), .cout(t_346)); 
compressor_4_2 u2_125(.a(s_45_7), .b(s_45_6), .c(s_45_5), .d(s_45_4), .cin(t_341), .o(t_347), .co(t_348), .cout(t_349)); 
compressor_3_2 u1_126(.a(s_45_10), .b(s_45_9), .cin(s_45_8), .o(t_350), .cout(t_351)); 
compressor_4_2 u2_127(.a(s_46_3), .b(s_46_2), .c(s_46_1), .d(s_46_0), .cin(t_346), .o(t_352), .co(t_353), .cout(t_354)); 
compressor_4_2 u2_128(.a(s_46_7), .b(s_46_6), .c(s_46_5), .d(s_46_4), .cin(t_349), .o(t_355), .co(t_356), .cout(t_357)); 
half_adder u0_129(.a(s_46_9), .b(s_46_8), .o(t_358), .cout(t_359)); 
compressor_4_2 u2_130(.a(s_47_3), .b(s_47_2), .c(s_47_1), .d(s_47_0), .cin(t_354), .o(t_360), .co(t_361), .cout(t_362)); 
compressor_4_2 u2_131(.a(s_47_7), .b(s_47_6), .c(s_47_5), .d(s_47_4), .cin(t_357), .o(t_363), .co(t_364), .cout(t_365)); 
half_adder u0_132(.a(s_47_9), .b(s_47_8), .o(t_366), .cout(t_367)); 
compressor_4_2 u2_133(.a(s_48_3), .b(s_48_2), .c(s_48_1), .d(s_48_0), .cin(t_362), .o(t_368), .co(t_369), .cout(t_370)); 
compressor_4_2 u2_134(.a(s_48_7), .b(s_48_6), .c(s_48_5), .d(s_48_4), .cin(t_365), .o(t_371), .co(t_372), .cout(t_373)); 
compressor_4_2 u2_135(.a(s_49_3), .b(s_49_2), .c(s_49_1), .d(s_49_0), .cin(t_370), .o(t_374), .co(t_375), .cout(t_376)); 
compressor_4_2 u2_136(.a(s_49_7), .b(s_49_6), .c(s_49_5), .d(s_49_4), .cin(t_373), .o(t_377), .co(t_378), .cout(t_379)); 
compressor_4_2 u2_137(.a(s_50_3), .b(s_50_2), .c(s_50_1), .d(s_50_0), .cin(t_376), .o(t_380), .co(t_381), .cout(t_382)); 
compressor_4_2 u2_138(.a(s_50_7), .b(s_50_6), .c(s_50_5), .d(s_50_4), .cin(t_379), .o(t_383), .co(t_384), .cout(t_385)); 
compressor_4_2 u2_139(.a(s_51_3), .b(s_51_2), .c(s_51_1), .d(s_51_0), .cin(t_382), .o(t_386), .co(t_387), .cout(t_388)); 
compressor_4_2 u2_140(.a(s_51_7), .b(s_51_6), .c(s_51_5), .d(s_51_4), .cin(t_385), .o(t_389), .co(t_390), .cout(t_391)); 
compressor_4_2 u2_141(.a(s_52_3), .b(s_52_2), .c(s_52_1), .d(s_52_0), .cin(t_388), .o(t_392), .co(t_393), .cout(t_394)); 
compressor_3_2 u1_142(.a(s_52_5), .b(s_52_4), .cin(t_391), .o(t_395), .cout(t_396)); 
compressor_4_2 u2_143(.a(s_53_3), .b(s_53_2), .c(s_53_1), .d(s_53_0), .cin(t_394), .o(t_397), .co(t_398), .cout(t_399)); 
compressor_3_2 u1_144(.a(s_53_6), .b(s_53_5), .cin(s_53_4), .o(t_400), .cout(t_401)); 
compressor_4_2 u2_145(.a(s_54_3), .b(s_54_2), .c(s_54_1), .d(s_54_0), .cin(t_399), .o(t_402), .co(t_403), .cout(t_404)); 
half_adder u0_146(.a(s_54_5), .b(s_54_4), .o(t_405), .cout(t_406)); 
compressor_4_2 u2_147(.a(s_55_3), .b(s_55_2), .c(s_55_1), .d(s_55_0), .cin(t_404), .o(t_407), .co(t_408), .cout(t_409)); 
half_adder u0_148(.a(s_55_5), .b(s_55_4), .o(t_410), .cout(t_411)); 
compressor_4_2 u2_149(.a(s_56_3), .b(s_56_2), .c(s_56_1), .d(s_56_0), .cin(t_409), .o(t_412), .co(t_413), .cout(t_414)); 
compressor_4_2 u2_150(.a(s_57_3), .b(s_57_2), .c(s_57_1), .d(s_57_0), .cin(t_414), .o(t_415), .co(t_416), .cout(t_417)); 
compressor_4_2 u2_151(.a(s_58_3), .b(s_58_2), .c(s_58_1), .d(s_58_0), .cin(t_417), .o(t_418), .co(t_419), .cout(t_420)); 
compressor_4_2 u2_152(.a(s_59_3), .b(s_59_2), .c(s_59_1), .d(s_59_0), .cin(t_420), .o(t_421), .co(t_422), .cout(t_423)); 
compressor_3_2 u1_153(.a(s_60_1), .b(s_60_0), .cin(t_423), .o(t_424), .cout(t_425)); 
compressor_3_2 u1_154(.a(s_61_2), .b(s_61_1), .cin(s_61_0), .o(t_426), .cout(t_427)); 
half_adder u0_155(.a(s_62_1), .b(s_62_0), .o(t_428), .cout(t_429)); 
half_adder u0_156(.a(s_63_1), .b(s_63_0), .o(t_430), .cout()); 

/* u0_157 Output nets */
wire  t_431, t_432;  
/* u0_158 Output nets */
wire  t_433, t_434;  
/* u1_159 Output nets */
wire  t_435, t_436;  
/* u0_160 Output nets */
wire  t_437, t_438;  
/* u0_161 Output nets */
wire  t_439, t_440;  
/* u0_162 Output nets */
wire  t_441, t_442;  
/* u1_163 Output nets */
wire  t_443, t_444;  
/* u1_164 Output nets */
wire  t_445, t_446;  
/* u1_165 Output nets */
wire  t_447, t_448;  
/* u1_166 Output nets */
wire  t_449, t_450;  
/* u2_167 Output nets */
wire  t_451, t_452, t_453;  
/* u2_168 Output nets */
wire  t_454, t_455, t_456;  
/* u2_169 Output nets */
wire  t_457, t_458, t_459;  
/* u2_170 Output nets */
wire  t_460, t_461, t_462;  
/* u2_171 Output nets */
wire  t_463, t_464, t_465;  
/* u2_172 Output nets */
wire  t_466, t_467, t_468;  
/* u0_173 Output nets */
wire  t_469, t_470;  
/* u2_174 Output nets */
wire  t_471, t_472, t_473;  
/* u2_175 Output nets */
wire  t_474, t_475, t_476;  
/* u0_176 Output nets */
wire  t_477, t_478;  
/* u2_177 Output nets */
wire  t_479, t_480, t_481;  
/* u1_178 Output nets */
wire  t_482, t_483;  
/* u2_179 Output nets */
wire  t_484, t_485, t_486;  
/* u0_180 Output nets */
wire  t_487, t_488;  
/* u2_181 Output nets */
wire  t_489, t_490, t_491;  
/* u0_182 Output nets */
wire  t_492, t_493;  
/* u2_183 Output nets */
wire  t_494, t_495, t_496;  
/* u0_184 Output nets */
wire  t_497, t_498;  
/* u2_185 Output nets */
wire  t_499, t_500, t_501;  
/* u1_186 Output nets */
wire  t_502, t_503;  
/* u2_187 Output nets */
wire  t_504, t_505, t_506;  
/* u1_188 Output nets */
wire  t_507, t_508;  
/* u2_189 Output nets */
wire  t_509, t_510, t_511;  
/* u1_190 Output nets */
wire  t_512, t_513;  
/* u2_191 Output nets */
wire  t_514, t_515, t_516;  
/* u1_192 Output nets */
wire  t_517, t_518;  
/* u2_193 Output nets */
wire  t_519, t_520, t_521;  
/* u2_194 Output nets */
wire  t_522, t_523, t_524;  
/* u2_195 Output nets */
wire  t_525, t_526, t_527;  
/* u2_196 Output nets */
wire  t_528, t_529, t_530;  
/* u2_197 Output nets */
wire  t_531, t_532, t_533;  
/* u2_198 Output nets */
wire  t_534, t_535, t_536;  
/* u2_199 Output nets */
wire  t_537, t_538, t_539;  
/* u2_200 Output nets */
wire  t_540, t_541, t_542;  
/* u2_201 Output nets */
wire  t_543, t_544, t_545;  
/* u2_202 Output nets */
wire  t_546, t_547, t_548;  
/* u2_203 Output nets */
wire  t_549, t_550, t_551;  
/* u2_204 Output nets */
wire  t_552, t_553, t_554;  
/* u2_205 Output nets */
wire  t_555, t_556, t_557;  
/* u2_206 Output nets */
wire  t_558, t_559, t_560;  
/* u2_207 Output nets */
wire  t_561, t_562, t_563;  
/* u2_208 Output nets */
wire  t_564, t_565, t_566;  
/* u2_209 Output nets */
wire  t_567, t_568, t_569;  
/* u2_210 Output nets */
wire  t_570, t_571, t_572;  
/* u2_211 Output nets */
wire  t_573, t_574, t_575;  
/* u2_212 Output nets */
wire  t_576, t_577, t_578;  
/* u2_213 Output nets */
wire  t_579, t_580, t_581;  
/* u2_214 Output nets */
wire  t_582, t_583, t_584;  
/* u2_215 Output nets */
wire  t_585, t_586, t_587;  
/* u2_216 Output nets */
wire  t_588, t_589, t_590;  
/* u2_217 Output nets */
wire  t_591, t_592, t_593;  
/* u2_218 Output nets */
wire  t_594, t_595, t_596;  
/* u2_219 Output nets */
wire  t_597, t_598, t_599;  
/* u1_220 Output nets */
wire  t_600, t_601;  
/* u2_221 Output nets */
wire  t_602, t_603, t_604;  
/* u0_222 Output nets */
wire  t_605, t_606;  
/* u2_223 Output nets */
wire  t_607, t_608, t_609;  
/* u0_224 Output nets */
wire  t_610, t_611;  
/* u2_225 Output nets */
wire  t_612, t_613, t_614;  
/* u1_226 Output nets */
wire  t_615, t_616;  
/* u2_227 Output nets */
wire  t_617, t_618, t_619;  
/* u0_228 Output nets */
wire  t_620, t_621;  
/* u2_229 Output nets */
wire  t_622, t_623, t_624;  
/* u0_230 Output nets */
wire  t_625, t_626;  
/* u2_231 Output nets */
wire  t_627, t_628, t_629;  
/* u0_232 Output nets */
wire  t_630, t_631;  
/* u2_233 Output nets */
wire  t_632, t_633, t_634;  
/* u0_234 Output nets */
wire  t_635, t_636;  
/* u2_235 Output nets */
wire  t_637, t_638, t_639;  
/* u2_236 Output nets */
wire  t_640, t_641, t_642;  
/* u2_237 Output nets */
wire  t_643, t_644, t_645;  
/* u2_238 Output nets */
wire  t_646, t_647, t_648;  
/* u2_239 Output nets */
wire  t_649, t_650, t_651;  
/* u2_240 Output nets */
wire  t_652, t_653, t_654;  
/* u2_241 Output nets */
wire  t_655, t_656, t_657;  
/* u2_242 Output nets */
wire  t_658, t_659, t_660;  
/* u1_243 Output nets */
wire  t_661, t_662;  
/* u0_244 Output nets */
wire  t_663, t_664;  
/* u0_245 Output nets */
wire  t_665, t_666;  
/* u1_246 Output nets */
wire  t_667, t_668;  
/* u0_247 Output nets */
wire  t_669, t_670;  
/* u0_248 Output nets */
wire  t_671, t_672;  
/* u0_249 Output nets */
wire  t_673;  

/* compress stage 2 */
half_adder u0_157(.a(t_1), .b(s_1_0), .o(t_431), .cout(t_432)); 
half_adder u0_158(.a(t_4), .b(t_3), .o(t_433), .cout(t_434)); 
compressor_3_2 u1_159(.a(t_6), .b(t_5), .cin(s_4_3), .o(t_435), .cout(t_436)); 
half_adder u0_160(.a(t_8), .b(t_7), .o(t_437), .cout(t_438)); 
half_adder u0_161(.a(t_10), .b(t_9), .o(t_439), .cout(t_440)); 
half_adder u0_162(.a(t_13), .b(t_11), .o(t_441), .cout(t_442)); 
compressor_3_2 u1_163(.a(t_19), .b(t_16), .cin(t_14), .o(t_443), .cout(t_444)); 
compressor_3_2 u1_164(.a(t_20), .b(t_17), .cin(s_9_4), .o(t_445), .cout(t_446)); 
compressor_3_2 u1_165(.a(t_27), .b(t_24), .cin(t_22), .o(t_447), .cout(t_448)); 
compressor_3_2 u1_166(.a(t_29), .b(t_28), .cin(t_25), .o(t_449), .cout(t_450)); 
compressor_4_2 u2_167(.a(t_37), .b(t_34), .c(t_33), .d(t_30), .cin(s_12_7), .o(t_451), .co(t_452), .cout(t_453)); 
compressor_4_2 u2_168(.a(t_42), .b(t_39), .c(t_38), .d(t_35), .cin(t_453), .o(t_454), .co(t_455), .cout(t_456)); 
compressor_4_2 u2_169(.a(t_47), .b(t_44), .c(t_43), .d(t_40), .cin(t_456), .o(t_457), .co(t_458), .cout(t_459)); 
compressor_4_2 u2_170(.a(t_53), .b(t_50), .c(t_48), .d(t_45), .cin(t_459), .o(t_460), .co(t_461), .cout(t_462)); 
compressor_4_2 u2_171(.a(t_59), .b(t_56), .c(t_54), .d(t_51), .cin(t_462), .o(t_463), .co(t_464), .cout(t_465)); 
compressor_4_2 u2_172(.a(t_63), .b(t_60), .c(t_57), .d(s_17_8), .cin(t_465), .o(t_466), .co(t_467), .cout(t_468)); 
half_adder u0_173(.a(t_67), .b(t_64), .o(t_469), .cout(t_470)); 
compressor_4_2 u2_174(.a(t_73), .b(t_70), .c(t_68), .d(t_65), .cin(t_468), .o(t_471), .co(t_472), .cout(t_473)); 
compressor_4_2 u2_175(.a(t_78), .b(t_77), .c(t_74), .d(t_71), .cin(t_473), .o(t_474), .co(t_475), .cout(t_476)); 
half_adder u0_176(.a(t_84), .b(t_81), .o(t_477), .cout(t_478)); 
compressor_4_2 u2_177(.a(t_85), .b(t_82), .c(t_79), .d(s_20_11), .cin(t_476), .o(t_479), .co(t_480), .cout(t_481)); 
compressor_3_2 u1_178(.a(t_92), .b(t_89), .cin(t_86), .o(t_482), .cout(t_483)); 
compressor_4_2 u2_179(.a(t_94), .b(t_93), .c(t_90), .d(t_87), .cin(t_481), .o(t_484), .co(t_485), .cout(t_486)); 
half_adder u0_180(.a(t_100), .b(t_97), .o(t_487), .cout(t_488)); 
compressor_4_2 u2_181(.a(t_102), .b(t_101), .c(t_98), .d(t_95), .cin(t_486), .o(t_489), .co(t_490), .cout(t_491)); 
half_adder u0_182(.a(t_108), .b(t_105), .o(t_492), .cout(t_493)); 
compressor_4_2 u2_183(.a(t_111), .b(t_109), .c(t_106), .d(t_103), .cin(t_491), .o(t_494), .co(t_495), .cout(t_496)); 
half_adder u0_184(.a(t_117), .b(t_114), .o(t_497), .cout(t_498)); 
compressor_4_2 u2_185(.a(t_120), .b(t_118), .c(t_115), .d(t_112), .cin(t_496), .o(t_499), .co(t_500), .cout(t_501)); 
compressor_3_2 u1_186(.a(t_129), .b(t_126), .cin(t_123), .o(t_502), .cout(t_503)); 
compressor_4_2 u2_187(.a(t_127), .b(t_124), .c(t_121), .d(s_25_12), .cin(t_501), .o(t_504), .co(t_505), .cout(t_506)); 
compressor_3_2 u1_188(.a(t_134), .b(t_131), .cin(t_130), .o(t_507), .cout(t_508)); 
compressor_4_2 u2_189(.a(t_140), .b(t_138), .c(t_135), .d(t_132), .cin(t_506), .o(t_509), .co(t_510), .cout(t_511)); 
compressor_3_2 u1_190(.a(t_149), .b(t_146), .cin(t_143), .o(t_512), .cout(t_513)); 
compressor_4_2 u2_191(.a(t_150), .b(t_147), .c(t_144), .d(t_141), .cin(t_511), .o(t_514), .co(t_515), .cout(t_516)); 
compressor_3_2 u1_192(.a(t_157), .b(t_154), .cin(t_151), .o(t_517), .cout(t_518)); 
compressor_4_2 u2_193(.a(t_158), .b(t_155), .c(t_152), .d(s_28_15), .cin(t_516), .o(t_519), .co(t_520), .cout(t_521)); 
compressor_4_2 u2_194(.a(t_171), .b(t_168), .c(t_165), .d(t_162), .cin(t_161), .o(t_522), .co(t_523), .cout(t_524)); 
compressor_4_2 u2_195(.a(t_172), .b(t_169), .c(t_166), .d(t_163), .cin(t_521), .o(t_525), .co(t_526), .cout(t_527)); 
compressor_4_2 u2_196(.a(t_182), .b(t_179), .c(t_176), .d(t_173), .cin(t_524), .o(t_528), .co(t_529), .cout(t_530)); 
compressor_4_2 u2_197(.a(t_183), .b(t_180), .c(t_177), .d(t_174), .cin(t_527), .o(t_531), .co(t_532), .cout(t_533)); 
compressor_4_2 u2_198(.a(t_193), .b(t_190), .c(t_187), .d(t_184), .cin(t_530), .o(t_534), .co(t_535), .cout(t_536)); 
compressor_4_2 u2_199(.a(t_194), .b(t_191), .c(t_188), .d(t_185), .cin(t_533), .o(t_537), .co(t_538), .cout(t_539)); 
compressor_4_2 u2_200(.a(t_205), .b(t_202), .c(t_199), .d(t_196), .cin(t_536), .o(t_540), .co(t_541), .cout(t_542)); 
compressor_4_2 u2_201(.a(t_203), .b(t_200), .c(t_197), .d(s_32_16), .cin(t_539), .o(t_543), .co(t_544), .cout(t_545)); 
compressor_4_2 u2_202(.a(t_214), .b(t_211), .c(t_208), .d(t_206), .cin(t_542), .o(t_546), .co(t_547), .cout(t_548)); 
compressor_4_2 u2_203(.a(t_215), .b(t_212), .c(t_209), .d(s_33_16), .cin(t_545), .o(t_549), .co(t_550), .cout(t_551)); 
compressor_4_2 u2_204(.a(t_226), .b(t_223), .c(t_220), .d(t_218), .cin(t_548), .o(t_552), .co(t_553), .cout(t_554)); 
compressor_4_2 u2_205(.a(t_230), .b(t_227), .c(t_224), .d(t_221), .cin(t_551), .o(t_555), .co(t_556), .cout(t_557)); 
compressor_4_2 u2_206(.a(t_241), .b(t_238), .c(t_235), .d(t_232), .cin(t_554), .o(t_558), .co(t_559), .cout(t_560)); 
compressor_4_2 u2_207(.a(t_242), .b(t_239), .c(t_236), .d(t_233), .cin(t_557), .o(t_561), .co(t_562), .cout(t_563)); 
compressor_4_2 u2_208(.a(t_253), .b(t_250), .c(t_247), .d(t_244), .cin(t_560), .o(t_564), .co(t_565), .cout(t_566)); 
compressor_4_2 u2_209(.a(t_251), .b(t_248), .c(t_245), .d(s_36_14), .cin(t_563), .o(t_567), .co(t_568), .cout(t_569)); 
compressor_4_2 u2_210(.a(t_262), .b(t_259), .c(t_256), .d(t_254), .cin(t_566), .o(t_570), .co(t_571), .cout(t_572)); 
compressor_4_2 u2_211(.a(t_266), .b(t_263), .c(t_260), .d(t_257), .cin(t_569), .o(t_573), .co(t_574), .cout(t_575)); 
compressor_4_2 u2_212(.a(t_276), .b(t_273), .c(t_270), .d(t_267), .cin(t_572), .o(t_576), .co(t_577), .cout(t_578)); 
compressor_4_2 u2_213(.a(t_277), .b(t_274), .c(t_271), .d(t_268), .cin(t_575), .o(t_579), .co(t_580), .cout(t_581)); 
compressor_4_2 u2_214(.a(t_287), .b(t_284), .c(t_281), .d(t_278), .cin(t_578), .o(t_582), .co(t_583), .cout(t_584)); 
compressor_4_2 u2_215(.a(t_288), .b(t_285), .c(t_282), .d(t_279), .cin(t_581), .o(t_585), .co(t_586), .cout(t_587)); 
compressor_4_2 u2_216(.a(t_298), .b(t_295), .c(t_292), .d(t_289), .cin(t_584), .o(t_588), .co(t_589), .cout(t_590)); 
compressor_4_2 u2_217(.a(t_296), .b(t_293), .c(t_290), .d(s_40_12), .cin(t_587), .o(t_591), .co(t_592), .cout(t_593)); 
compressor_4_2 u2_218(.a(t_306), .b(t_303), .c(t_300), .d(t_299), .cin(t_590), .o(t_594), .co(t_595), .cout(t_596)); 
compressor_4_2 u2_219(.a(t_307), .b(t_304), .c(t_301), .d(s_41_12), .cin(t_593), .o(t_597), .co(t_598), .cout(t_599)); 
compressor_3_2 u1_220(.a(t_312), .b(t_309), .cin(t_596), .o(t_600), .cout(t_601)); 
compressor_4_2 u2_221(.a(t_318), .b(t_316), .c(t_313), .d(t_310), .cin(t_599), .o(t_602), .co(t_603), .cout(t_604)); 
half_adder u0_222(.a(t_324), .b(t_321), .o(t_605), .cout(t_606)); 
compressor_4_2 u2_223(.a(t_327), .b(t_325), .c(t_322), .d(t_319), .cin(t_604), .o(t_607), .co(t_608), .cout(t_609)); 
half_adder u0_224(.a(t_333), .b(t_330), .o(t_610), .cout(t_611)); 
compressor_4_2 u2_225(.a(t_334), .b(t_331), .c(t_328), .d(s_44_10), .cin(t_609), .o(t_612), .co(t_613), .cout(t_614)); 
compressor_3_2 u1_226(.a(t_342), .b(t_339), .cin(t_336), .o(t_615), .cout(t_616)); 
compressor_4_2 u2_227(.a(t_344), .b(t_343), .c(t_340), .d(t_337), .cin(t_614), .o(t_617), .co(t_618), .cout(t_619)); 
half_adder u0_228(.a(t_350), .b(t_347), .o(t_620), .cout(t_621)); 
compressor_4_2 u2_229(.a(t_352), .b(t_351), .c(t_348), .d(t_345), .cin(t_619), .o(t_622), .co(t_623), .cout(t_624)); 
half_adder u0_230(.a(t_358), .b(t_355), .o(t_625), .cout(t_626)); 
compressor_4_2 u2_231(.a(t_360), .b(t_359), .c(t_356), .d(t_353), .cin(t_624), .o(t_627), .co(t_628), .cout(t_629)); 
half_adder u0_232(.a(t_366), .b(t_363), .o(t_630), .cout(t_631)); 
compressor_4_2 u2_233(.a(t_367), .b(t_364), .c(t_361), .d(s_48_8), .cin(t_629), .o(t_632), .co(t_633), .cout(t_634)); 
half_adder u0_234(.a(t_371), .b(t_368), .o(t_635), .cout(t_636)); 
compressor_4_2 u2_235(.a(t_374), .b(t_372), .c(t_369), .d(s_49_8), .cin(t_634), .o(t_637), .co(t_638), .cout(t_639)); 
compressor_4_2 u2_236(.a(t_383), .b(t_380), .c(t_378), .d(t_375), .cin(t_639), .o(t_640), .co(t_641), .cout(t_642)); 
compressor_4_2 u2_237(.a(t_389), .b(t_386), .c(t_384), .d(t_381), .cin(t_642), .o(t_643), .co(t_644), .cout(t_645)); 
compressor_4_2 u2_238(.a(t_392), .b(t_390), .c(t_387), .d(s_52_6), .cin(t_645), .o(t_646), .co(t_647), .cout(t_648)); 
compressor_4_2 u2_239(.a(t_400), .b(t_397), .c(t_396), .d(t_393), .cin(t_648), .o(t_649), .co(t_650), .cout(t_651)); 
compressor_4_2 u2_240(.a(t_405), .b(t_402), .c(t_401), .d(t_398), .cin(t_651), .o(t_652), .co(t_653), .cout(t_654)); 
compressor_4_2 u2_241(.a(t_410), .b(t_407), .c(t_406), .d(t_403), .cin(t_654), .o(t_655), .co(t_656), .cout(t_657)); 
compressor_4_2 u2_242(.a(t_412), .b(t_411), .c(t_408), .d(s_56_4), .cin(t_657), .o(t_658), .co(t_659), .cout(t_660)); 
compressor_3_2 u1_243(.a(t_413), .b(s_57_4), .cin(t_660), .o(t_661), .cout(t_662)); 
half_adder u0_244(.a(t_418), .b(t_416), .o(t_663), .cout(t_664)); 
half_adder u0_245(.a(t_421), .b(t_419), .o(t_665), .cout(t_666)); 
compressor_3_2 u1_246(.a(t_424), .b(t_422), .cin(s_60_2), .o(t_667), .cout(t_668)); 
half_adder u0_247(.a(t_426), .b(t_425), .o(t_669), .cout(t_670)); 
half_adder u0_248(.a(t_428), .b(t_427), .o(t_671), .cout(t_672)); 
half_adder u0_249(.a(t_430), .b(t_429), .o(t_673), .cout()); 

/* u0_250 Output nets */
wire  t_674, t_675;  
/* u0_251 Output nets */
wire  t_676, t_677;  
/* u0_252 Output nets */
wire  t_678, t_679;  
/* u0_253 Output nets */
wire  t_680, t_681;  
/* u0_254 Output nets */
wire  t_682, t_683;  
/* u0_255 Output nets */
wire  t_684, t_685;  
/* u1_256 Output nets */
wire  t_686, t_687;  
/* u0_257 Output nets */
wire  t_688, t_689;  
/* u1_258 Output nets */
wire  t_690, t_691;  
/* u0_259 Output nets */
wire  t_692, t_693;  
/* u0_260 Output nets */
wire  t_694, t_695;  
/* u0_261 Output nets */
wire  t_696, t_697;  
/* u0_262 Output nets */
wire  t_698, t_699;  
/* u1_263 Output nets */
wire  t_700, t_701;  
/* u1_264 Output nets */
wire  t_702, t_703;  
/* u1_265 Output nets */
wire  t_704, t_705;  
/* u1_266 Output nets */
wire  t_706, t_707;  
/* u1_267 Output nets */
wire  t_708, t_709;  
/* u1_268 Output nets */
wire  t_710, t_711;  
/* u1_269 Output nets */
wire  t_712, t_713;  
/* u1_270 Output nets */
wire  t_714, t_715;  
/* u1_271 Output nets */
wire  t_716, t_717;  
/* u2_272 Output nets */
wire  t_718, t_719, t_720;  
/* u2_273 Output nets */
wire  t_721, t_722, t_723;  
/* u2_274 Output nets */
wire  t_724, t_725, t_726;  
/* u2_275 Output nets */
wire  t_727, t_728, t_729;  
/* u2_276 Output nets */
wire  t_730, t_731, t_732;  
/* u2_277 Output nets */
wire  t_733, t_734, t_735;  
/* u2_278 Output nets */
wire  t_736, t_737, t_738;  
/* u2_279 Output nets */
wire  t_739, t_740, t_741;  
/* u2_280 Output nets */
wire  t_742, t_743, t_744;  
/* u2_281 Output nets */
wire  t_745, t_746, t_747;  
/* u2_282 Output nets */
wire  t_748, t_749, t_750;  
/* u2_283 Output nets */
wire  t_751, t_752, t_753;  
/* u2_284 Output nets */
wire  t_754, t_755, t_756;  
/* u2_285 Output nets */
wire  t_757, t_758, t_759;  
/* u2_286 Output nets */
wire  t_760, t_761, t_762;  
/* u2_287 Output nets */
wire  t_763, t_764, t_765;  
/* u2_288 Output nets */
wire  t_766, t_767, t_768;  
/* u2_289 Output nets */
wire  t_769, t_770, t_771;  
/* u2_290 Output nets */
wire  t_772, t_773, t_774;  
/* u2_291 Output nets */
wire  t_775, t_776, t_777;  
/* u2_292 Output nets */
wire  t_778, t_779, t_780;  
/* u2_293 Output nets */
wire  t_781, t_782, t_783;  
/* u2_294 Output nets */
wire  t_784, t_785, t_786;  
/* u2_295 Output nets */
wire  t_787, t_788, t_789;  
/* u2_296 Output nets */
wire  t_790, t_791, t_792;  
/* u1_297 Output nets */
wire  t_793, t_794;  
/* u0_298 Output nets */
wire  t_795, t_796;  
/* u1_299 Output nets */
wire  t_797, t_798;  
/* u0_300 Output nets */
wire  t_799, t_800;  
/* u0_301 Output nets */
wire  t_801, t_802;  
/* u0_302 Output nets */
wire  t_803, t_804;  
/* u0_303 Output nets */
wire  t_805, t_806;  
/* u1_304 Output nets */
wire  t_807, t_808;  
/* u0_305 Output nets */
wire  t_809, t_810;  
/* u0_306 Output nets */
wire  t_811, t_812;  
/* u0_307 Output nets */
wire  t_813, t_814;  
/* u0_308 Output nets */
wire  t_815, t_816;  
/* u0_309 Output nets */
wire  t_817, t_818;  
/* u0_310 Output nets */
wire  t_819;  

/* compress stage 3 */
half_adder u0_250(.a(t_432), .b(t_2), .o(t_674), .cout(t_675)); 
half_adder u0_251(.a(t_435), .b(t_434), .o(t_676), .cout(t_677)); 
half_adder u0_252(.a(t_437), .b(t_436), .o(t_678), .cout(t_679)); 
half_adder u0_253(.a(t_439), .b(t_438), .o(t_680), .cout(t_681)); 
half_adder u0_254(.a(t_441), .b(t_440), .o(t_682), .cout(t_683)); 
half_adder u0_255(.a(t_443), .b(t_442), .o(t_684), .cout(t_685)); 
compressor_3_2 u1_256(.a(t_445), .b(t_444), .cin(t_21), .o(t_686), .cout(t_687)); 
half_adder u0_257(.a(t_447), .b(t_446), .o(t_688), .cout(t_689)); 
compressor_3_2 u1_258(.a(t_449), .b(t_448), .cin(t_32), .o(t_690), .cout(t_691)); 
half_adder u0_259(.a(t_451), .b(t_450), .o(t_692), .cout(t_693)); 
half_adder u0_260(.a(t_454), .b(t_452), .o(t_694), .cout(t_695)); 
half_adder u0_261(.a(t_457), .b(t_455), .o(t_696), .cout(t_697)); 
half_adder u0_262(.a(t_460), .b(t_458), .o(t_698), .cout(t_699)); 
compressor_3_2 u1_263(.a(t_463), .b(t_461), .cin(t_62), .o(t_700), .cout(t_701)); 
compressor_3_2 u1_264(.a(t_469), .b(t_466), .cin(t_464), .o(t_702), .cout(t_703)); 
compressor_3_2 u1_265(.a(t_470), .b(t_467), .cin(t_76), .o(t_704), .cout(t_705)); 
compressor_3_2 u1_266(.a(t_477), .b(t_474), .cin(t_472), .o(t_706), .cout(t_707)); 
compressor_3_2 u1_267(.a(t_479), .b(t_478), .cin(t_475), .o(t_708), .cout(t_709)); 
compressor_3_2 u1_268(.a(t_484), .b(t_483), .cin(t_480), .o(t_710), .cout(t_711)); 
compressor_3_2 u1_269(.a(t_489), .b(t_488), .cin(t_485), .o(t_712), .cout(t_713)); 
compressor_3_2 u1_270(.a(t_494), .b(t_493), .cin(t_490), .o(t_714), .cout(t_715)); 
compressor_3_2 u1_271(.a(t_499), .b(t_498), .cin(t_495), .o(t_716), .cout(t_717)); 
compressor_4_2 u2_272(.a(t_507), .b(t_504), .c(t_503), .d(t_500), .cin(t_137), .o(t_718), .co(t_719), .cout(t_720)); 
compressor_4_2 u2_273(.a(t_512), .b(t_509), .c(t_508), .d(t_505), .cin(t_720), .o(t_721), .co(t_722), .cout(t_723)); 
compressor_4_2 u2_274(.a(t_514), .b(t_513), .c(t_510), .d(t_160), .cin(t_723), .o(t_724), .co(t_725), .cout(t_726)); 
compressor_4_2 u2_275(.a(t_522), .b(t_519), .c(t_518), .d(t_515), .cin(t_726), .o(t_727), .co(t_728), .cout(t_729)); 
compressor_4_2 u2_276(.a(t_528), .b(t_525), .c(t_523), .d(t_520), .cin(t_729), .o(t_730), .co(t_731), .cout(t_732)); 
compressor_4_2 u2_277(.a(t_534), .b(t_531), .c(t_529), .d(t_526), .cin(t_732), .o(t_733), .co(t_734), .cout(t_735)); 
compressor_4_2 u2_278(.a(t_540), .b(t_537), .c(t_535), .d(t_532), .cin(t_735), .o(t_736), .co(t_737), .cout(t_738)); 
compressor_4_2 u2_279(.a(t_543), .b(t_541), .c(t_538), .d(t_217), .cin(t_738), .o(t_739), .co(t_740), .cout(t_741)); 
compressor_4_2 u2_280(.a(t_549), .b(t_547), .c(t_544), .d(t_229), .cin(t_741), .o(t_742), .co(t_743), .cout(t_744)); 
compressor_4_2 u2_281(.a(t_558), .b(t_555), .c(t_553), .d(t_550), .cin(t_744), .o(t_745), .co(t_746), .cout(t_747)); 
compressor_4_2 u2_282(.a(t_564), .b(t_561), .c(t_559), .d(t_556), .cin(t_747), .o(t_748), .co(t_749), .cout(t_750)); 
compressor_4_2 u2_283(.a(t_567), .b(t_565), .c(t_562), .d(t_265), .cin(t_750), .o(t_751), .co(t_752), .cout(t_753)); 
compressor_4_2 u2_284(.a(t_576), .b(t_573), .c(t_571), .d(t_568), .cin(t_753), .o(t_754), .co(t_755), .cout(t_756)); 
compressor_4_2 u2_285(.a(t_582), .b(t_579), .c(t_577), .d(t_574), .cin(t_756), .o(t_757), .co(t_758), .cout(t_759)); 
compressor_4_2 u2_286(.a(t_588), .b(t_585), .c(t_583), .d(t_580), .cin(t_759), .o(t_760), .co(t_761), .cout(t_762)); 
compressor_4_2 u2_287(.a(t_594), .b(t_591), .c(t_589), .d(t_586), .cin(t_762), .o(t_763), .co(t_764), .cout(t_765)); 
compressor_4_2 u2_288(.a(t_597), .b(t_595), .c(t_592), .d(t_315), .cin(t_765), .o(t_766), .co(t_767), .cout(t_768)); 
compressor_4_2 u2_289(.a(t_605), .b(t_602), .c(t_601), .d(t_598), .cin(t_768), .o(t_769), .co(t_770), .cout(t_771)); 
compressor_4_2 u2_290(.a(t_610), .b(t_607), .c(t_606), .d(t_603), .cin(t_771), .o(t_772), .co(t_773), .cout(t_774)); 
compressor_4_2 u2_291(.a(t_615), .b(t_612), .c(t_611), .d(t_608), .cin(t_774), .o(t_775), .co(t_776), .cout(t_777)); 
compressor_4_2 u2_292(.a(t_620), .b(t_617), .c(t_616), .d(t_613), .cin(t_777), .o(t_778), .co(t_779), .cout(t_780)); 
compressor_4_2 u2_293(.a(t_625), .b(t_622), .c(t_621), .d(t_618), .cin(t_780), .o(t_781), .co(t_782), .cout(t_783)); 
compressor_4_2 u2_294(.a(t_630), .b(t_627), .c(t_626), .d(t_623), .cin(t_783), .o(t_784), .co(t_785), .cout(t_786)); 
compressor_4_2 u2_295(.a(t_635), .b(t_632), .c(t_631), .d(t_628), .cin(t_786), .o(t_787), .co(t_788), .cout(t_789)); 
compressor_4_2 u2_296(.a(t_637), .b(t_636), .c(t_633), .d(t_377), .cin(t_789), .o(t_790), .co(t_791), .cout(t_792)); 
compressor_3_2 u1_297(.a(t_640), .b(t_638), .cin(t_792), .o(t_793), .cout(t_794)); 
half_adder u0_298(.a(t_643), .b(t_641), .o(t_795), .cout(t_796)); 
compressor_3_2 u1_299(.a(t_646), .b(t_644), .cin(t_395), .o(t_797), .cout(t_798)); 
half_adder u0_300(.a(t_649), .b(t_647), .o(t_799), .cout(t_800)); 
half_adder u0_301(.a(t_652), .b(t_650), .o(t_801), .cout(t_802)); 
half_adder u0_302(.a(t_655), .b(t_653), .o(t_803), .cout(t_804)); 
half_adder u0_303(.a(t_658), .b(t_656), .o(t_805), .cout(t_806)); 
compressor_3_2 u1_304(.a(t_661), .b(t_659), .cin(t_415), .o(t_807), .cout(t_808)); 
half_adder u0_305(.a(t_663), .b(t_662), .o(t_809), .cout(t_810)); 
half_adder u0_306(.a(t_665), .b(t_664), .o(t_811), .cout(t_812)); 
half_adder u0_307(.a(t_667), .b(t_666), .o(t_813), .cout(t_814)); 
half_adder u0_308(.a(t_669), .b(t_668), .o(t_815), .cout(t_816)); 
half_adder u0_309(.a(t_671), .b(t_670), .o(t_817), .cout(t_818)); 
half_adder u0_310(.a(t_673), .b(t_672), .o(t_819), .cout()); 

/* u0_311 Output nets */
wire  t_820, t_821;  
/* u0_312 Output nets */
wire  t_822, t_823;  
/* u0_313 Output nets */
wire  t_824, t_825;  
/* u0_314 Output nets */
wire  t_826, t_827;  
/* u0_315 Output nets */
wire  t_828, t_829;  
/* u0_316 Output nets */
wire  t_830, t_831;  
/* u0_317 Output nets */
wire  t_832, t_833;  
/* u0_318 Output nets */
wire  t_834, t_835;  
/* u0_319 Output nets */
wire  t_836, t_837;  
/* u0_320 Output nets */
wire  t_838, t_839;  
/* u0_321 Output nets */
wire  t_840, t_841;  
/* u0_322 Output nets */
wire  t_842, t_843;  
/* u0_323 Output nets */
wire  t_844, t_845;  
/* u0_324 Output nets */
wire  t_846, t_847;  
/* u1_325 Output nets */
wire  t_848, t_849;  
/* u0_326 Output nets */
wire  t_850, t_851;  
/* u1_327 Output nets */
wire  t_852, t_853;  
/* u1_328 Output nets */
wire  t_854, t_855;  
/* u1_329 Output nets */
wire  t_856, t_857;  
/* u1_330 Output nets */
wire  t_858, t_859;  
/* u1_331 Output nets */
wire  t_860, t_861;  
/* u0_332 Output nets */
wire  t_862, t_863;  
/* u0_333 Output nets */
wire  t_864, t_865;  
/* u1_334 Output nets */
wire  t_866, t_867;  
/* u0_335 Output nets */
wire  t_868, t_869;  
/* u0_336 Output nets */
wire  t_870, t_871;  
/* u0_337 Output nets */
wire  t_872, t_873;  
/* u0_338 Output nets */
wire  t_874, t_875;  
/* u1_339 Output nets */
wire  t_876, t_877;  
/* u1_340 Output nets */
wire  t_878, t_879;  
/* u0_341 Output nets */
wire  t_880, t_881;  
/* u0_342 Output nets */
wire  t_882, t_883;  
/* u1_343 Output nets */
wire  t_884, t_885;  
/* u0_344 Output nets */
wire  t_886, t_887;  
/* u0_345 Output nets */
wire  t_888, t_889;  
/* u0_346 Output nets */
wire  t_890, t_891;  
/* u0_347 Output nets */
wire  t_892, t_893;  
/* u1_348 Output nets */
wire  t_894, t_895;  
/* u0_349 Output nets */
wire  t_896, t_897;  
/* u0_350 Output nets */
wire  t_898, t_899;  
/* u0_351 Output nets */
wire  t_900, t_901;  
/* u0_352 Output nets */
wire  t_902, t_903;  
/* u0_353 Output nets */
wire  t_904, t_905;  
/* u0_354 Output nets */
wire  t_906, t_907;  
/* u0_355 Output nets */
wire  t_908, t_909;  
/* u0_356 Output nets */
wire  t_910, t_911;  
/* u0_357 Output nets */
wire  t_912, t_913;  
/* u0_358 Output nets */
wire  t_914, t_915;  
/* u0_359 Output nets */
wire  t_916, t_917;  
/* u0_360 Output nets */
wire  t_918, t_919;  
/* u0_361 Output nets */
wire  t_920, t_921;  
/* u0_362 Output nets */
wire  t_922, t_923;  
/* u0_363 Output nets */
wire  t_924, t_925;  
/* u0_364 Output nets */
wire  t_926, t_927;  
/* u0_365 Output nets */
wire  t_928, t_929;  
/* u0_366 Output nets */
wire  t_930, t_931;  
/* u0_367 Output nets */
wire  t_932, t_933;  
/* u0_368 Output nets */
wire  t_934, t_935;  
/* u0_369 Output nets */
wire  t_936, t_937;  
/* u0_370 Output nets */
wire  t_938;  

/* compress stage 4 */
half_adder u0_311(.a(t_675), .b(t_433), .o(t_820), .cout(t_821)); 
half_adder u0_312(.a(t_678), .b(t_677), .o(t_822), .cout(t_823)); 
half_adder u0_313(.a(t_680), .b(t_679), .o(t_824), .cout(t_825)); 
half_adder u0_314(.a(t_682), .b(t_681), .o(t_826), .cout(t_827)); 
half_adder u0_315(.a(t_684), .b(t_683), .o(t_828), .cout(t_829)); 
half_adder u0_316(.a(t_686), .b(t_685), .o(t_830), .cout(t_831)); 
half_adder u0_317(.a(t_688), .b(t_687), .o(t_832), .cout(t_833)); 
half_adder u0_318(.a(t_690), .b(t_689), .o(t_834), .cout(t_835)); 
half_adder u0_319(.a(t_692), .b(t_691), .o(t_836), .cout(t_837)); 
half_adder u0_320(.a(t_694), .b(t_693), .o(t_838), .cout(t_839)); 
half_adder u0_321(.a(t_696), .b(t_695), .o(t_840), .cout(t_841)); 
half_adder u0_322(.a(t_698), .b(t_697), .o(t_842), .cout(t_843)); 
half_adder u0_323(.a(t_700), .b(t_699), .o(t_844), .cout(t_845)); 
half_adder u0_324(.a(t_702), .b(t_701), .o(t_846), .cout(t_847)); 
compressor_3_2 u1_325(.a(t_704), .b(t_703), .cin(t_471), .o(t_848), .cout(t_849)); 
half_adder u0_326(.a(t_706), .b(t_705), .o(t_850), .cout(t_851)); 
compressor_3_2 u1_327(.a(t_708), .b(t_707), .cin(t_482), .o(t_852), .cout(t_853)); 
compressor_3_2 u1_328(.a(t_710), .b(t_709), .cin(t_487), .o(t_854), .cout(t_855)); 
compressor_3_2 u1_329(.a(t_712), .b(t_711), .cin(t_492), .o(t_856), .cout(t_857)); 
compressor_3_2 u1_330(.a(t_714), .b(t_713), .cin(t_497), .o(t_858), .cout(t_859)); 
compressor_3_2 u1_331(.a(t_716), .b(t_715), .cin(t_502), .o(t_860), .cout(t_861)); 
half_adder u0_332(.a(t_718), .b(t_717), .o(t_862), .cout(t_863)); 
half_adder u0_333(.a(t_721), .b(t_719), .o(t_864), .cout(t_865)); 
compressor_3_2 u1_334(.a(t_724), .b(t_722), .cin(t_517), .o(t_866), .cout(t_867)); 
half_adder u0_335(.a(t_727), .b(t_725), .o(t_868), .cout(t_869)); 
half_adder u0_336(.a(t_730), .b(t_728), .o(t_870), .cout(t_871)); 
half_adder u0_337(.a(t_733), .b(t_731), .o(t_872), .cout(t_873)); 
half_adder u0_338(.a(t_736), .b(t_734), .o(t_874), .cout(t_875)); 
compressor_3_2 u1_339(.a(t_739), .b(t_737), .cin(t_546), .o(t_876), .cout(t_877)); 
compressor_3_2 u1_340(.a(t_742), .b(t_740), .cin(t_552), .o(t_878), .cout(t_879)); 
half_adder u0_341(.a(t_745), .b(t_743), .o(t_880), .cout(t_881)); 
half_adder u0_342(.a(t_748), .b(t_746), .o(t_882), .cout(t_883)); 
compressor_3_2 u1_343(.a(t_751), .b(t_749), .cin(t_570), .o(t_884), .cout(t_885)); 
half_adder u0_344(.a(t_754), .b(t_752), .o(t_886), .cout(t_887)); 
half_adder u0_345(.a(t_757), .b(t_755), .o(t_888), .cout(t_889)); 
half_adder u0_346(.a(t_760), .b(t_758), .o(t_890), .cout(t_891)); 
half_adder u0_347(.a(t_763), .b(t_761), .o(t_892), .cout(t_893)); 
compressor_3_2 u1_348(.a(t_766), .b(t_764), .cin(t_600), .o(t_894), .cout(t_895)); 
half_adder u0_349(.a(t_769), .b(t_767), .o(t_896), .cout(t_897)); 
half_adder u0_350(.a(t_772), .b(t_770), .o(t_898), .cout(t_899)); 
half_adder u0_351(.a(t_775), .b(t_773), .o(t_900), .cout(t_901)); 
half_adder u0_352(.a(t_778), .b(t_776), .o(t_902), .cout(t_903)); 
half_adder u0_353(.a(t_781), .b(t_779), .o(t_904), .cout(t_905)); 
half_adder u0_354(.a(t_784), .b(t_782), .o(t_906), .cout(t_907)); 
half_adder u0_355(.a(t_787), .b(t_785), .o(t_908), .cout(t_909)); 
half_adder u0_356(.a(t_790), .b(t_788), .o(t_910), .cout(t_911)); 
half_adder u0_357(.a(t_793), .b(t_791), .o(t_912), .cout(t_913)); 
half_adder u0_358(.a(t_795), .b(t_794), .o(t_914), .cout(t_915)); 
half_adder u0_359(.a(t_797), .b(t_796), .o(t_916), .cout(t_917)); 
half_adder u0_360(.a(t_799), .b(t_798), .o(t_918), .cout(t_919)); 
half_adder u0_361(.a(t_801), .b(t_800), .o(t_920), .cout(t_921)); 
half_adder u0_362(.a(t_803), .b(t_802), .o(t_922), .cout(t_923)); 
half_adder u0_363(.a(t_805), .b(t_804), .o(t_924), .cout(t_925)); 
half_adder u0_364(.a(t_807), .b(t_806), .o(t_926), .cout(t_927)); 
half_adder u0_365(.a(t_809), .b(t_808), .o(t_928), .cout(t_929)); 
half_adder u0_366(.a(t_811), .b(t_810), .o(t_930), .cout(t_931)); 
half_adder u0_367(.a(t_813), .b(t_812), .o(t_932), .cout(t_933)); 
half_adder u0_368(.a(t_815), .b(t_814), .o(t_934), .cout(t_935)); 
half_adder u0_369(.a(t_817), .b(t_816), .o(t_936), .cout(t_937)); 
half_adder u0_370(.a(t_819), .b(t_818), .o(t_938), .cout()); 

/* Output nets Compression result */
assign compress_a = {
   t_937,   t_935,   t_933,   t_931,
   t_929,   t_927,   t_925,   t_923,
   t_921,   t_919,   t_917,   t_915,
   t_913,   t_911,   t_909,   t_907,
   t_905,   t_903,   t_901,   t_899,
   t_897,   t_895,   t_893,   t_891,
   t_889,   t_887,   t_885,   t_883,
   t_881,   t_879,   t_877,   t_875,
   t_873,   t_871,   t_869,   t_867,
   t_865,   t_863,   t_861,   t_859,
   t_857,   t_855,   t_853,   t_851,
   t_849,   t_847,   t_845,   t_843,
   t_841,   t_839,   t_837,   t_835,
   t_833,   t_831,   t_829,   t_827,
   t_825,   t_823,   t_822,   t_676,
   t_820,   t_674,   t_431,     t_0
};
assign compress_b = {
   t_938,   t_936,   t_934,   t_932,
   t_930,   t_928,   t_926,   t_924,
   t_922,   t_920,   t_918,   t_916,
   t_914,   t_912,   t_910,   t_908,
   t_906,   t_904,   t_902,   t_900,
   t_898,   t_896,   t_894,   t_892,
   t_890,   t_888,   t_886,   t_884,
   t_882,   t_880,   t_878,   t_876,
   t_874,   t_872,   t_870,   t_868,
   t_866,   t_864,   t_862,   t_860,
   t_858,   t_856,   t_854,   t_852,
   t_850,   t_848,   t_846,   t_844,
   t_842,   t_840,   t_838,   t_836,
   t_834,   t_832,   t_830,   t_828,
   t_826,   t_824,    1'b0,   t_821,
    1'b0,    1'b0,    1'b0,    1'b0
};

endmodule

/********************************************************************************/

module booth_coder(
//inputs
	sign,
	a,
	b,
//outputs
	partial_products,
	carry
);

parameter width = 8;

input wire sign;
input wire [width-1:0] a;
input wire [width-1:0] b;
output wire [(width+2)*(width/2+1)-1:0] partial_products;
output reg [width/2-1:0] carry;

reg [(width+2)*(width/2)-1:0] codingdata;
wire [width:0] b_ = {sign&b[width-1], b};
wire [width:0] a_temp = {a, 1'b0};

generate
	genvar i;
	for (i=0; i<width; i=i+2)
	begin: encoder
		always @ (*)
		begin
			case (a_temp[i+2:i])
			3'b0, 3'd7: begin
				codingdata[`INDEX] = {1'b1, {(width+1){1'b0}}};
				carry[i/2] = 1'b0;
			end
			3'd1, 3'd2: begin
				codingdata[`INDEX] = {~b_[width], b_};
				carry[i/2] = 1'b0;
			end
			3'd3: begin
				codingdata[`INDEX] = {~b_[width], b, 1'b0};
				carry[i/2] = 1'b0;
			end
			3'd4: begin
				codingdata[`INDEX] = {b_[width], ~b, 1'b1};
				carry[i/2] = 1'b1;
			end
			3'd5, 3'd6: begin
				codingdata[`INDEX] = {b_[width], ~b_};
				carry[i/2] = 1'b1;
			end
			default: begin
				codingdata[`INDEX] = {(width+2){1'b0}};
				carry[i/2] = 1'b0;
			end
			endcase
		end
	end
endgenerate

function [255:0] sign_sum(input integer n);
integer i;
begin
	sign_sum = 256'b0;
	for (i=0; i<n; i=i+2)
		sign_sum = sign_sum + ({256{1'b1}} << (n-i-2));
	sign_sum = sign_sum << 3;
end
endfunction

wire [width+1:0] signsum = sign_sum(width);
wire [width-1:0] unsign_correct = {width{ a[width-1]&(~sign) }} & b;
wire [width+1:0] extra_product = {signsum[width+1:2]+unsign_correct, signsum[1:0]};

assign partial_products = {extra_product, codingdata};

endmodule

module multer(
//inputs
    sign,
    A,
    B,
//outputs
    P
);

parameter width = 8;

input wire sign;
input wire [width-1:0] A;
input wire [width-1:0] B;
output wire [2*width-1:0] P;

wire [(width+2)*(width/2+1)-1:0] partial_products;
wire [width/2-1:0] carry;
wire [2*width-1:0] compress_a;
wire [2*width-1:0] compress_b;

booth_coder encoder(.sign(sign), .a(A), .b(B), .partial_products(partial_products), .carry(carry));
defparam
    encoder.width=width;

generate
	case (width)
	    8 : _8_wallace_tree compressor(.partial_products(partial_products), .carry(carry), .compress_a(compress_a), .compress_b(compress_b));
	    16: _16_wallace_tree compressor(.partial_products(partial_products), .carry(carry), .compress_a(compress_a), .compress_b(compress_b));
		32: _32_wallace_tree compressor(.partial_products(partial_products), .carry(carry), .compress_a(compress_a), .compress_b(compress_b));
		default: _8_wallace_tree compressor(.partial_products(partial_products), .carry(carry), .compress_a(compress_a), .compress_b(compress_b));
	endcase
endgenerate

assign P = compress_a + compress_b;

endmodule

`undef INDEX
