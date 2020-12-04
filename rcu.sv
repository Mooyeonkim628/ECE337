module rcu
(
	input wire clk,
	input wire n_rst,
	input wire start_bit_detected,
	input wire packet_done,
	input wire framing_error,
	output reg sbc_clear,
	output reg sbc_enable,
	output reg load_buffer,
	output reg enable_timer
);

parameter IDLE 	= 0,
	  CLEAR = 1,
  	  START = 2,
  	  STOP 	= 3,
  	  WAIT 	= 4,
	  LOAD 	= 5;

reg [2:0] curr;
reg [2:0] next;

always_ff@(posedge clk, negedge n_rst)begin 
	if(!n_rst) begin
		curr <= IDLE;
	end
	else begin
		curr <= next;
	end
end

always_comb begin	
	next = curr;	
	case(curr)
		IDLE:begin
			if(start_bit_detected)
				next = CLEAR;
			else
				next = IDLE;
		end
		CLEAR:begin
			next = START;
		end
		START:begin
			if(packet_done)
				next = STOP;
			else
				next = START;
		end
		STOP:begin
			next = WAIT;
		end
		WAIT:begin
			if(!framing_error)
				next = LOAD;
			else
				next = IDLE;
		end
		LOAD:begin
			next = IDLE;
		end
		
	endcase
end

always_comb begin

	sbc_clear = 0;
	sbc_enable = 0;
	load_buffer = 0;
	enable_timer = 0;

	if(curr == IDLE) begin
		sbc_clear = 0;
		sbc_enable = 0;
		load_buffer = 0;
		enable_timer = 0;
	end
	else if(curr == CLEAR) begin
		sbc_clear = 1;
	end
	else if(curr == START) begin
		enable_timer = 1;
	end
	else if(curr == STOP) begin
		sbc_enable = 1;
	end
	else if(curr == WAIT) begin
		sbc_clear = 0;
		sbc_enable = 0;
		load_buffer = 0;
		enable_timer = 0;
	end
	else if(curr == LOAD)begin
		load_buffer = 1;
	end
end

endmodule
