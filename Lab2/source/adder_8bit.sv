// 337 TA Provided Lab 2 8-bit adder wrapper file template
// This code serves as a template for the 8-bit adder design wrapper file 
// STUDENT: Replace this message and the above header section with an
// appropriate header based on your other code files

module adder_8bit
(
	input wire [7:0] a,
	input wire [7:0] b,
	input wire carry_in,
	output wire [7:0] sum,
	output wire overflow
);

wire c1;

adder_nbit a1(.a(a[3:0]),.b(b[3:0]),.carry_in(carry_in),.sum(sum[3:0]),.overflow(c1));
adder_nbit a2(.a(a[7:4]),.b(b[7:4]),.carry_in(c1),.sum(sum[7:4]),.overflow(overflow));

endmodule

