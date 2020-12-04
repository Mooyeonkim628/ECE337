module apb_uart_rx(
	input wire clk,
	input wire n_rst,
	input wire psel,
	input wire serial_in,
	input wire [2:0] paddr,
	input wire penable,
	input wire pwrite,
	input wire [7:0] pwdata,
	output reg [7:0] prdata,
	output reg pslverr
);

reg [3:0] ds;
reg [13:0] bp;
reg [7:0] rd;
reg dr;
reg drd;
reg oerr;
reg ferr;

rcv_block rcv(.clk(clk), .n_rst(n_rst), .data_size(ds), .bit_period(bp), .serial_in(serial_in),
	       .data_read(dr), .rx_data(rd), .data_ready(drd), .overrun_error(oerr), .framing_error(ferr));
	
apb_slave slave(.clk(clk), .n_rst(n_rst), .rx_data(rd), .data_ready(drd), .overrun_error(oerr), .framing_error(ferr),
		.data_read(dr), .psel(psel), .paddr(paddr), .penable(penable), .pwrite(pwrite), .pwdata(pwdata),
		.prdata(prdata), .pslverr(pslverr), .data_size(ds), .bit_period(bp));

endmodule
