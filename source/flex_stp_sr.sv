`timescale 1ns / 10ps

module flex_stp_sr
#(
  	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
  	input wire clk,
  	input wire n_rst,
  	input wire serial_in,
  	input wire shift_enable,
  	output wire [NUM_BITS-1:0] parallel_out 
);

reg [NUM_BITS-1:0] Q;
reg [NUM_BITS-1:0] Q_next;

always_ff @ (posedge clk,negedge n_rst) begin
	if(!n_rst)begin
		Q <= '1;
	end
	else begin
		Q <= Q_next;
	end 
end

always_comb begin
	Q_next = Q;
	if(SHIFT_MSB == 1 && shift_enable) begin
		Q_next[NUM_BITS-1:0] = {serial_in,Q[NUM_BITS-1:1]};
	end
	else if(SHIFT_MSB == 0 && shift_enable) begin
		Q_next[NUM_BITS-1:0] = {Q[NUM_BITS-2:0],serial_in};
	end
end

assign parallel_out = Q;

endmodule
