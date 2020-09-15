module adder_1bit
(
	input wire a,
	input wire b,
	input wire carry_in,
	output wire sum,
	output wire carry_out
);

wire s1, s2, c1;

assign s1=a^b;
assign c1=a&b;
assign sum=s1^carry_in;
assign s2=s1&carry_in;
assign carry_out=s2^c1;

endmodule
