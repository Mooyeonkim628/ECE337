module timer
(
	input clk,
	input n_rst,
	input enable_timer,
	output reg shift_strobe,
	output reg packet_done
);

reg [3:0] clock_count;

wire clear;
wire [3:0] rval;

assign rval = 4'b1010;

always_comb begin
	shift_strobe = clock_count == 1;
end

flex_counter clkcnt(.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(enable_timer), 
.rollover_val(rval), .rollover_flag(), .count_out(clock_count));

flex_counter bitcnt(.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(shift_strobe), 
.rollover_val(rval), .rollover_flag(packet_done),.count_out());

endmodule
