
module sensor_s
(
	input [3:0] sensors,
	output error
);

wire Y1;
wire Y2;
wire Y3;


AND2X1 A1 (.Y(Y1), .A(sensors[2]), .B(sensors[1]));
AND2X1 A2 (.Y(Y2), .A(sensors[1]), .B(sensors[3]));

OR2X1 A3 (.Y(Y3), .A(Y1), .B(Y2));
OR2X1 A4 (.Y(error), .A(Y3), .B(sensors[0]));


endmodule


