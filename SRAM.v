module SRAM(SRAM_Data,sw17,SRAM_Address,SRAM_Write_Enable,SRAM_Output_Enable,HbMask,LbMask,CS,Clock,cnt,SRAM_Controller,full,Control_Data);

input  Clock;
inout  [15:0] SRAM_Data;
input  [2:0] cnt;
input  sw17;
input  [1:0]  SRAM_Controller;
output [17:0] SRAM_Address;
output reg [15:0] Control_Data;
output reg SRAM_Write_Enable;
output reg SRAM_Output_Enable;
output reg HbMask;
output reg LbMask;
output reg CS;
output reg full;

reg [17:0] address;
initial 
begin 
	CS = 1'b1;
	full = 1'b0;
	SRAM_Write_Enable = 1'b1;
	SRAM_Output_Enable = 1'b1;
	//SRAM_Address = 18'd1;
	HbMask  = 1'b1;
	LbMask  = 1'b1;
	delay   = 12'd0;
	address = 18'd1;
end
wire c0;
pll (Clock,c0);

reg [11:0] delay;
always @ (posedge c0)
	delay = delay+12'd1;

wire read;
wire write;

assign SRAM_Address = sw17 ? address : {15'd0,cnt};
assign write = SRAM_Controller[0];
assign read  = SRAM_Controller[1];

assign SRAM_Data 	  = write ? address[15:0] : 16'bZ ;

always @ (posedge delay[11])
begin
		if (write & ~full)
		begin
			if (address != 18'd0)
				address = address + 18'd1;
			else 
				full=1'b1;
			CS = 1'b0;
			HbMask = 1'b0;
			LbMask = 1'b0;
			SRAM_Write_Enable = 1'b0;
			SRAM_Output_Enable = 1'b1;
		end
		else if (read)
		begin
			address = address + 18'd1;
			CS     = 1'b0;
			HbMask = 1'b0;
			LbMask = 1'b0;
			SRAM_Write_Enable  = 1'b1;
			SRAM_Output_Enable = 1'b0;
			Control_Data = SRAM_Data;
		end
end

endmodule

