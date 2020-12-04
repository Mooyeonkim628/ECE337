module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire serial_in,
	output reg [NUM_BITS-1:0] parallel_out 
);

reg [NUM_BITS-1:0] Q;
reg [NUM_BITS-1:0] next;

always_ff@(posedge clk, negedge n_rst) begin 
	if(!n_rst)
		Q <= '1;
	else
		Q <= next; 
end

always_comb begin
	next = Q;
	if(shift_enable) begin
		if(SHIFT_MSB)
			next = {Q[NUM_BITS-2:0], serial_in};
		else
			next = {serial_in, Q[NUM_BITS-1:1]};
	end
end

assign parallel_out = Q;

endmodule
