module timer
(
	input wire clk,
	input wire n_rst,
	input wire enable_timer,
	output reg shift_strobe,
	output reg packet_done
);

wire [3:0] rollover_value;
reg [3:0] clock_count;

always_comb
begin
	shift_strobe = clock_count == 1;
end

flex_counter cnt1 (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(enable_timer), .rollover_val(4'd10), .rollover_flag(), .count_out(clock_count));
flex_counter cnt2 (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(shift_strobe), .rollover_val(4'd10), .rollover_flag(packet_done), .count_out());

endmodule
