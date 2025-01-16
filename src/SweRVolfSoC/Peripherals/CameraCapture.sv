module CameraCapture(
						input logic PCLK,                 //clk from camera
						input logic HREF,                 //HREF signal from camera
						input logic VSYNC,                //vsync signal from camera
						input logic reset,
						input logic [3:0] D,
						output logic [3:0] vga_o,         //returns the data 
						output logic we,                  //returns write enable for the BRAM
						output logic [18:0]addra          //returns the address for the BRAM
						); 



localparam  BYTE1 = 0;
localparam  BYTE2 = 1;
localparam  BYTE3 = 2;

reg [7:0]state;
reg HREF_reg, HREF_reg2;
 
//First thing to notice, the D0-D7 must be sampled at the rising edge of the PCLK signal.
//Number two, D0-D7 must be sampled only when HREF is high.
// Also, the rising edge of HREF signals the start of a line, and the falling edge of HREF signals the end of the line.



always@(posedge PCLK) 
//if reset, clear the write enable and VGA_o and return to byte 1
	begin
	if(reset == 1)
	begin
	 state = BYTE1;
	 vga_o = 0;  
	 we = 0; 
	end
//if HREF is high and VSYNC is low skip the first byte and grab the 
//top four msb's of the second byte
	if(HREF_reg2 && !VSYNC)
	 begin
	  unique case(state)
		BYTE1: begin 
			we = 0;          //write enable == zero
		 	state = BYTE2;   
		       end
		BYTE2: 	begin
			 we = 1;                     //set WE of bram
			 addra = addra + 1;          //increment the address by 1
			 vga_o[3] = D[3];
			 vga_o[2] = D[2]; 
			 vga_o[1] = D[1];
			 vga_o[0] = D[0];  
			 state = BYTE1;
			end
		endcase 
	end
	else if(VSYNC) 
	begin  
		addra = 0;           //if VSYNC is high reset address to zero
		vga_o = 0;           //set vga_o = 0
		we = 0;              //set write 
		state = BYTE1; 
	end
end 

//Flip flop to wait a clk cycle to get rid of that annoying line.
always_ff@(posedge PCLK)
begin 
HREF_reg <= HREF; 
HREF_reg2 <= HREF_reg; 
end   


endmodule 


	
						