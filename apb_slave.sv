module apb_slave(
	input wire clk,
	input wire n_rst,
	input wire [7:0] rx_data,
	input wire data_ready,
	input wire overrun_error,
	input wire framing_error,
	output reg data_read,
	input wire psel,
	input wire [2:0] paddr,
	input wire penable,
	input wire pwrite,
	input wire [7:0] pwdata,
	output reg [7:0] prdata,
	output reg pslverr,
	output reg [3:0] data_size,
	output reg [13:0] bit_period
);
	
typedef enum bit [1:0] {IDLE, WRITE, READ, ERROR} state;

state curr;
state next;

reg [6:0][7:0] address;
reg [6:0][7:0] next_add;

always_ff @(posedge clk, negedge n_rst) begin
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
		IDLE: 
		begin if(psel) begin
			if(pwrite && (paddr == 3'b010 || paddr == 3'b011 || paddr == 3'b100)) 
				next = WRITE;
			else if(!pwrite && (paddr == 3'b000 || paddr == 3'b001 || paddr == 3'b010 
			|| paddr == 3'b011 || paddr == 3'b100| paddr == 3'b101 || paddr == 3'b110)) 
				next = READ;
			else
				next = ERROR;
		end
		else if(!psel)
			next = IDLE;
		end
		ERROR: next = IDLE;
		WRITE: next = IDLE;
		READ: next= IDLE;
	endcase
end

always_ff @(posedge clk, negedge n_rst) begin
	if(!n_rst) begin
		address<=  8'b0;
	end
	else begin
		address <= next_add;
	end
end

always_comb begin
	next_add = address;
	next_add[0] = data_ready;
	next_add[1] = overrun_error ? 2 :
	              framing_error ? 1 : 0;
	next_add[5] = 0;
	next_add[6] = rx_data;
	data_read = 0;
	
	case(curr)
		WRITE: begin
			if(penable)
				next_add[paddr] = pwdata;
			else
				next_add[paddr] = address[paddr];
		end
		READ: begin
			if(penable)begin	
				if(paddr == 6)
					data_read = 1;
			end
		end
	endcase

	bit_period = {address[3], address[2]};
	data_size = address[4];

end
	
always_comb begin
	prdata = 0;
	pslverr = 0;
	case(curr)
		READ: begin
			if (penable) begin
				if (paddr == 6) begin
					prdata = address[6];
					if(address[4]==8'd5)
						prdata = {3'b000, address[6][7:3]};
					else if(address[4]==8'd7)
						prdata = {1'b0, address[6][7:1]};
				end
				else
					prdata = address[paddr];
			end
		end
		ERROR: pslverr = 1;
	endcase
end

				
endmodule
