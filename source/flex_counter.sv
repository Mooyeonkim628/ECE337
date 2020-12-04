module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [NUM_CNT_BITS-1:0] rollover_val,
	output reg [NUM_CNT_BITS-1:0] count_out,
	output reg rollover_flag
);

reg [NUM_CNT_BITS-1:0] next;
reg next_flag;

always_ff@(posedge clk, negedge n_rst) begin
	if(!n_rst) begin
		count_out <= '0;
		rollover_flag <= 0;
	end
	else if(clear) begin
		count_out <= '0;
		rollover_flag <= 0;
	end
	else begin
		count_out <= next;
		rollover_flag <= next_flag;
	end
	
end

always_comb begin

	next = count_out;
	next_flag = rollover_flag;

	if(count_enable) begin
		if(rollover_flag)
			next = 1;
		else
			next = count_out + 1;

		if(next == rollover_val)
			next_flag = 1;
		else
			next_flag = 0;
	end	
end

endmodule
