
module sensor_b
(
	input [3:0] sensors,
	output reg error
);

reg Y1;
reg Y2;
reg Y3;

always@(sensors) begin
	Y1 = 0;
	Y2 = 0;
	Y3 = 0;

	if((sensors[1]==1)&(sensors[3]==1))
		Y1 = 1;	
	if((sensors[1]==1)&(sensors[2]==1))
		Y2 = 1;	
	if(sensors[0]==1)
		Y3 = 1;	

	error = Y1|Y2|Y3; 

end

endmodule


