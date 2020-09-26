module sync_low
(
	input clk,
	input n_rst,
	input async_in,
	output reg sync_out
);

reg n;

always_ff@(posedge clk, negedge n_rst)
begin
	if(1'b0 == n_rst)begin
		n <= 0;
		sync_out <= 0;
	end
	else begin
		n <= async_in;
		sync_out <= n;
	end

end

endmodule
