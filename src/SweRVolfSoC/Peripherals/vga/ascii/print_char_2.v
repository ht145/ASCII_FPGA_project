`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abhijeet Prem
// 
// Create Date: 11/30/2022 04:53:24 PM
// Design Name: 
// Module Name: print_char
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module print_char_2(
    input  wire        vga_clk,               // input vga clock signal
   // input  wire        video_on, 
	input  wire [11:0] pixel_row, 
	input  wire [11:0] pixel_column,
	input  wire  [3:0] char_sel, 
	output reg         char_pix              // the vale of the averaged pixel value
 ); 
 
 //integer i, j;
 
 wire [63:0] char_1;

 mini_char_rom_2 c_rom3 (
    .clk     (vga_clk),
	.addr    (char_sel),      // outputting -5-
	.w_en    (1'b0),
	.in_data (1'b0),
	.char_out(char_1)); 

    always @(posedge vga_clk) begin
    
        char_pix = char_1[63 -((8 *(pixel_row % 8)) + (pixel_column % 8) ) ];
    
    end
  
 endmodule
