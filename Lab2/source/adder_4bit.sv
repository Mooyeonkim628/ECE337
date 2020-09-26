module adder_4bit
(
	input wire [3:0]a,
	input wire [3:0]b,
	input wire carry_in,
	output wire [3:0] sum,
	output wire overflow
);

wire c1,c2,c3;

    

adder_1bit a0(.a(a[0]),.b(b[0]),.carry_in(carry_in),.sum(sum[0]),.carry_out(c1));

adder_1bit a1(.a(a[1]),.b(b[1]),.carry_in(c1),.sum(sum[1]),.carry_out(c2));

adder_1bit a2(.a(a[2]),.b(b[2]),.carry_in(c2),.sum(sum[2]),.carry_out(c3));

adder_1bit a3(.a(a[3]),.b(b[3]),.carry_in(c3),.sum(sum[3]),.carry_out(overflow));

endmodule
