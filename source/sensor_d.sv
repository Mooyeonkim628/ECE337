
module sensor_d
(
	input [3:0] sensors,
	output error
);

wire Y1;
wire Y2;
wire Y3;

assign Y1 = sensors[3]&sensors[1];
assign Y2 = sensors[1]&sensors[2];
assign Y3 = sensors[0];


assign error = Y1|Y2|Y3;

endmodule


