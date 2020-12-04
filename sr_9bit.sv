module sr_9bit
(
	input wire clk,
	input wire n_rst,
	input wire shift_strobe,
	input wire serial_in,
	output reg [7:0] packet_data,
	output reg stop_bit
);

wire [8:0] p_o;

assign p_o = {stop_bit, packet_data};

flex_stp_sr #(.NUM_BITS(9), .SHIFT_MSB(0)) sr(.clk(clk), .n_rst(n_rst), .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out(p_o));

endmodule
