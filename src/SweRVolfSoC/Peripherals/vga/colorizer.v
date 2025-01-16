`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Engineers: Mahika, Abhijeet
// Create Date: 12/06/2022 03:59:28 PM
// Module Name: colorizer
// Project Name: Ascii Art Video
// Description: 
//      - The module receives a single bit pixel value from the ascii filter moudle
//      - Based on the states of the select switchs for each color channel, appropriate color is added

// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////////////////////////////////


module colorizer(
input  wire       clk,              // input clock
input  wire       ascii_pix,        // inpit pixel value
input  wire [6:0] switches,         // input switch states
input  wire [5:0] color_reg,
output reg  [3:0] c_vga_r,          // output red channel value
output reg  [3:0] c_vga_g,          // output green channel value
output reg  [3:0] c_vga_b           // output blue channel value
);
	  

always @(posedge clk) begin

// case statemets for Red channel		
case ((switches[6] == 1'd0)? switches[5:4]:color_reg[5:4])
	2'b00: c_vga_r = {1'b0,1'b0,1'b0,ascii_pix};                   // ~1% intensity 
	2'b01: c_vga_r = {1'b0,ascii_pix,1'b0,1'b0};                   // ~25% intensity 
	2'b10: c_vga_r = {ascii_pix,1'b0,ascii_pix,1'b0};              // ~70% intensity
	2'b11: c_vga_r = {ascii_pix,ascii_pix,ascii_pix,ascii_pix};    // ~100% intensity
	   												
endcase            

// case statemets for green channel	
case ((switches[6] == 1'd0)? switches[3:2]:color_reg[3:2] )
	2'b00: c_vga_g = {1'b0,1'b0,1'b0,ascii_pix};                     // ~1% intensity  
	2'b01: c_vga_g = {1'b0,1'b0,ascii_pix,ascii_pix};                // ~25% intensity 
	2'b10: c_vga_g = {ascii_pix,1'b0,ascii_pix,1'b0};                // ~70% intensity 
	2'b11: c_vga_g = {ascii_pix,ascii_pix,ascii_pix,ascii_pix};      // ~100% intensity
endcase

// case statemets for blue channel		 
case ((switches[6] == 1'd0)? switches[1:0]:color_reg[1:0])
	2'b00: c_vga_b = {1'b0,1'b0,1'b0,ascii_pix};                      // ~1% intensity  
	2'b01: c_vga_b = {1'b0,1'b0,ascii_pix,ascii_pix};                 // ~25% intensity 
	2'b10: c_vga_b = {ascii_pix,1'b0,ascii_pix,1'b0};                 // ~70% intensity 
	2'b11: c_vga_b = {ascii_pix,ascii_pix,ascii_pix,ascii_pix};       // ~100% intensity
endcase

end
endmodule

