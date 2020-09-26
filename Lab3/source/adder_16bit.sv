module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

wire [3:0]c;

adder_nbit a1(.a(a[3:0]),.b(b[3:0]),.carry_in(carry_in),.sum(sum[3:0]),.overflow(c[0]));
adder_nbit a2(.a(a[7:4]),.b(b[7:4]),.carry_in(c[0]),.sum(sum[7:4]),.overflow(c[1]));
adder_nbit a3(.a(a[11:8]),.b(b[11:8]),.carry_in(c[1]),.sum(sum[11:8]),.overflow(c[2]));
adder_nbit a4(.a(a[15:12]),.b(b[15:12]),.carry_in(c[2]),.sum(sum[15:12]),.overflow(c[3]));

assign overflow = c[3];

always @(a)
begin
	assert((a[3:0]<4'b10000)||(a[3:0]>=4'b0000))
	else $error("Input #1 'a' of component is not a digital logic value");
	assert((a[7:4]<4'b10000)||(a[7:4]>=4'b0000))
	else $error("Input #2 'a' of component is not a digital logic value");
	assert((a[11:8]<4'b10000)||(a[11:8]>=4'b0000))
	else $error("Input #3 'a' of component is not a digital logic value");
	assert((a[15:12]<4'b10000)||(a[15:12]>=4'b0000))
	else $error("Input #4 'a' of component is not a digital logic value");
end
always @(b)
begin
	assert((b[3:0]<4'b10000)||(b[3:0]>=4'b0000))
	else $error("Input #1 'b' of component is not a digital logic value");
	assert((b[7:4]<4'b10000)||(b[7:4]>=4'b0000))
	else $error("Input #2 'b' of component is not a digital logic value");
	assert((b[11:8]<4'b10000)||(b[11:8]>=4'b0000))
	else $error("Input #3 'b' of component is not a digital logic value");
	assert((b[15:12]<4'b10000)||(b[15:12]>=4'b0000))
	else $error("Input #4 'b' of component is not a digital logic value");
end


endmodule

