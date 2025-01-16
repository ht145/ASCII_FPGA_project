`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abhijeet Prem
// 
// Create Date: 11/30/2022 04:22:23 PM
// Design Name: Mini character ROM
// Module Name: mini_char_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//
//   This module provides a set of 15 charaters that can be used for the ascii art filter. Its a set of 16 x 16 bitmap of character.
      
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 module mini_char_rom (
	input 	wire 			clk,
	input 	wire [3:0] 		addr,
	input 	wire 			w_en,
	input 	wire [255:0] 	in_data,
	output 	reg [255:0] 	char_out
);

reg [255:0] char [0:15];

// iitial block to preset the character rom
initial begin
	// get the eq
	char[0] 	= 256'h0000000000000000000000000000000000000000000000000000000000000000;	// - -
	char[1] 	= 256'h0000000000000000000000000000000000000000000003000300000000000000;	// -.-
	char[2] 	= 256'h0000000000000000000000000000000000000000030003000100010002000000;	// -,-
	char[3] 	= 256'h0000000000000000000000000000000003E003E0000000000000000000000000;	// ---
	char[4] 	= 256'h0000000000000180018000000000000000000000018001800080008001000000;	// -;-
	char[5] 	= 256'h0000000000000000000000C000C000C007F807F800C000C000C0000000000000;	// -+-
	char[6] 	= 256'h000000000180038007800D800980018001800180018001800180018000000000;	// -1-
	char[7] 	= 256'h000000000000000003C007E00E600C000C000C000E6007E003C0000000000000;	// -c-
	char[8] 	= 256'h000000000000000007C00FE00C6001E007E00E600C600FE007B0000000000000;	// -a-
	char[9] 	= 256'h0000000003E007F00E30003001E001E0007000300C300E7007E003C000000000;	// -3-
	char[10] 	= 256'h0000000007E007E006000C000FC00FE00C7000300C300E7007E003C000000000;	// -5-
	char[11] 	= 256'h000000000FF00FF0006000C000C0018001800180038003000300030000000000;	// -7-
	char[12] 	= 256'h0000000003C007E00C600C300C300E7007F003B000300C600FE007C000000000;	// -9-
	char[13] 	= 256'h000000000000000031C631C619CC1B6C1B6C1B6C0E380E380E38000000000000;	// -w-
	char[14] 	= 256'h000000000360036006C03FF03FF006C00D803FF03FF00D801B001B0000000000;	// -#-
	char[15] 	= 256'h000007C00C30137817E82CC82CC82CC82FD026E01008081007E0000000000000;  	// -@- 
		

end 

// case statement to select the character and drive the output

always @(posedge clk) begin

case(addr)

	0	: char_out = char[addr];
	1	: char_out = char[addr];
	2	: char_out = char[addr];
	3	: char_out = char[addr];
	4	: char_out = char[addr];
	5	: char_out = char[addr];
	6	: char_out = char[addr];
	7	: char_out = char[addr];
	8	: char_out = char[addr];
	9	: char_out = char[addr];
	10	: char_out = char[addr];
	11	: char_out = char[addr];
	12	: char_out = char[addr];
	13	: char_out = char[addr];
	14	: char_out = char[addr];
	15	: char_out = char[addr];

endcase

end

endmodule