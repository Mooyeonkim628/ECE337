module rcv_block 
(
  	input wire clk,
  	input wire n_rst,
  	input wire serial_in,
 	input wire data_read,
   	output reg [7:0] rx_data,
    	output reg data_ready,
    	output reg overrun_error,
    	output reg framing_error
);

wire load;
wire clear;
wire enable;
wire sbd;
wire stop;
wire done;
wire strobe;
wire en_timer;
wire [7:0] packet;
	

rx_data_buff buffer(.clk(clk), .n_rst(n_rst), .load_buffer(load), .packet_data(packet), .data_read(data_read),
 .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

stop_bit_chk stop_bit(.clk(clk), .n_rst(n_rst), .sbc_clear(clear), .sbc_enable(enable), .stop_bit(stop), .framing_error(framing_error));

rcu reciver(.clk(clk), .n_rst(n_rst), .start_bit_detected(sbd), .packet_done(done), .framing_error(framing_error),
 .sbc_clear(clear), .sbc_enable(enable), .load_buffer(load), .enable_timer(en_timer));

timer timer(.clk(clk), .n_rst(n_rst), .enable_timer(en_timer), .shift_strobe(strobe), .packet_done(done)); 

sr_9bit shifter(.clk(clk), .n_rst(n_rst), .shift_strobe(strobe), .serial_in(serial_in), .packet_data(packet), .stop_bit(stop));

start_bit_det start(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(sbd));






endmodule
