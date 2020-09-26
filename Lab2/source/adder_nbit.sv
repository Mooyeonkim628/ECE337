module adder_nbit
#(
	parameter BIT_WIDTH = 4
)
(
	input wire [BIT_WIDTH-1:0]a,
	input wire [BIT_WIDTH-1:0]b,
	input wire carry_in,
	output wire [BIT_WIDTH-1:0] sum,
	output wire overflow
);

wire [BIT_WIDTH:0] c;
    
assign c[0] = carry_in;

genvar i;
generate 
	for(i=0;i<BIT_WIDTH;i=i+1) begin: nbit
		adder_1bit f(.a(a[i]),.b(b[i]),.carry_in(c[i]),.sum(sum[i]),.carry_out(c[i+1]));
	end
endgenerate

assign overflow = c[BIT_WIDTH-1];

endmodule
