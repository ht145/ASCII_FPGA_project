`timescale 1ns / 1ps
//TODO COMMENTS
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2019 10:58:13 AM
// Design Name: 
// Module Name: camera_decoder
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


module decoder(
    input reg PCLK,
    input reg vsync, //active high vsync
    input reg hsync, //active high hsync
    input reg reset, //active high reset
    input reg [3:0] din,
    output reg [31:0] addra, //pix counter (address) to write to 1D BRAM
    output reg [3:0] dout, //TODO I should just make this 8 bits
    output reg we,
    output reg [31:0] col,
    output reg [31:0] row
    );
    
    reg [31:0] pix_cnt;
    
    parameter COLS = 640, ROWS = 480;
    
    assign we = ((col <= COLS) && (row <= ROWS)) ? 1'b1 : 1'b0;
    
    
    always @(posedge PCLK)
        if (hsync & vsync)
            col <= col + 1;
        else 
            col <= 0;
            
        
    always @(posedge PCLK)
        if (~vsync)
            row <= 0;
        else if (col == COLS - 1)
            row <= row + 1;
    
    always @(posedge PCLK) begin
     
        addra <= pix_cnt;
        
        if (reset) begin
            pix_cnt <= 0;
            dout <= 0;
        end 
        
         
        else if (!vsync) begin
            pix_cnt <= 0;
            dout <= 4'hf; 
        end
        
       
        else if (!vsync && hsync && ((col <= COLS - 1) && (row <= ROWS - 1))) begin
            pix_cnt <= pix_cnt + 32'b1;
            dout <= din;        
        end
        
    end
endmodule