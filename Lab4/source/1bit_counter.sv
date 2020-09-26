module 1bitcounter
(
	input clk,
	input n_rst,
	input clear,
	input count_enable,
	input rollover_val,
	output reg count_out,
	output reg rollover_flag
);

always_ff @ (posedge clk,negedge n_rst) begin
	if(!n_rst)begin
		count_out <= 0;
		rollover_flag <= 0;
	end
	else if(clear)begin
		count_out <= 0;
		rollover_flag <= 0;
	end
	else if(count_enable && count_out == rollover_val)begin
		rollover_flag <= 1;
		count_out <= 1;
	end 
    	else if(count_enable && !rollover_flag) begin
      		count_out <= count_out + 1'b1;
	end
    	else if(count_enable &&  rollover_flag) begin
      		count_out <= count_out + 1'b1;
		rollover_flag <= 0;
	end
end

endmodule
