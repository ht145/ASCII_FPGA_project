`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2022 07:56:54 PM
// Design Name: 
// Module Name: ascii_filter
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


module ascii_filter_2(

    input  wire        vga_clk,               // input vga clock signal
	input  wire [3:0]  pix_val,               // input vixel value from the block ram
	input  wire        video_on,              // input video on singnal
	input  wire [11:0] pixel_row, 
	input  wire [11:0] pixel_column,
	//input  wire  [3:0] char_sel, 
	output wire        ascii_pix              // the vale of the averaged pixel value
    );
    
    reg [3:0] vid_buffer [4487:0];    			// viedo buffer register
    reg [3:0] avg_arr [0:79];                   // array to store the average valuees
    reg [3:0] char_addr;                        // internal signal for the character address
    integer i;                                  // integer to cycle through the values in the buffer
    reg [9:0] clm_count = 9'd0;                     // counter to keep track of the number of columns processed
    reg [9:0] row_count = 9'd0;                     // counter to keep track of the number of columns processed
    reg [5:0] avg_count = 6'd0;                 // counter to keep track of averages
    
    
    print_char_2 print_char_3
   (
       .vga_clk         (vga_clk),
      // .video_on        (vga_video_on),
       .pixel_row       (pixel_row),
       .pixel_column    (pixel_column),
       .char_sel        (char_addr),
       .char_pix        (ascii_pix)
   );
   
   always @(posedge vga_clk) begin
   
        if( video_on) begin
        // implimenting the shifting operation for the video buffer      
            //for (i=1283; i>0; i = i-1) begin
            for (i=4487; i>0; i = i-1) begin
                
                vid_buffer[i] = vid_buffer[i-1];    // shifting the values in the buffer
            
            end
        
            vid_buffer[0] = pix_val;            // updateing the input for the vifor buffer
            clm_count = clm_count + 1;
            
            if (clm_count == 640) begin
                clm_count = 0;
            end
             
            if (avg_count == 80)
                avg_count = 0;    
                
            
        end                                     // end of the video on condition
    
    
                                          
                                          
      if (clm_count % 8 == 0)	begin			 // store the avg in the array
	
   
        avg_arr[avg_count] =  (
        
            vid_buffer[(640*0)+0]  + vid_buffer[(640*0)+1] 	+ vid_buffer[(640*0)+2]   + vid_buffer[(640*0)+3]   + vid_buffer[(640*0)+4]   + vid_buffer[(640*0)+5]   + vid_buffer[(640*0)+6]   + vid_buffer[(640*0)+7]   + 
            vid_buffer[(640*1)+0]  + vid_buffer[(640*1)+1] 	+ vid_buffer[(640*1)+2]   + vid_buffer[(640*1)+3]   + vid_buffer[(640*1)+4]   + vid_buffer[(640*1)+5]   + vid_buffer[(640*1)+6]   + vid_buffer[(640*1)+7]   + 
            vid_buffer[(640*2)+0]  + vid_buffer[(640*2)+1] 	+ vid_buffer[(640*2)+2]   + vid_buffer[(640*2)+3]   + vid_buffer[(640*2)+4]   + vid_buffer[(640*2)+5]   + vid_buffer[(640*2)+6]   + vid_buffer[(640*2)+7]   + 
            vid_buffer[(640*3)+0]  + vid_buffer[(640*3)+1] 	+ vid_buffer[(640*3)+2]   + vid_buffer[(640*3)+3]   + vid_buffer[(640*3)+4]   + vid_buffer[(640*3)+5]   + vid_buffer[(640*3)+6]   + vid_buffer[(640*3)+7]   + 
            vid_buffer[(640*4)+0]  + vid_buffer[(640*4)+1] 	+ vid_buffer[(640*4)+2]   + vid_buffer[(640*4)+3]   + vid_buffer[(640*4)+4]   + vid_buffer[(640*4)+5]   + vid_buffer[(640*4)+6]   + vid_buffer[(640*4)+7]   + 
            vid_buffer[(640*5)+0]  + vid_buffer[(640*5)+1] 	+ vid_buffer[(640*5)+2]   + vid_buffer[(640*5)+3]   + vid_buffer[(640*5)+4]   + vid_buffer[(640*5)+5]   + vid_buffer[(640*5)+6]   + vid_buffer[(640*5)+7]   + 
            vid_buffer[(640*6)+0]  + vid_buffer[(640*6)+1] 	+ vid_buffer[(640*6)+2]   + vid_buffer[(640*6)+3]   + vid_buffer[(640*6)+4]   + vid_buffer[(640*6)+5]   + vid_buffer[(640*6)+6]   + vid_buffer[(640*6)+7]   + 
            vid_buffer[(640*7)+0]  + vid_buffer[(640*7)+1] 	+ vid_buffer[(640*7)+2]   + vid_buffer[(640*7)+3]   + vid_buffer[(640*7)+4]   + vid_buffer[(640*7)+5]   + vid_buffer[(640*7)+6]   + pix_val

          		
            ) / 64 ;
    
        char_addr = avg_arr[avg_count];
        avg_count = avg_count+ 1'b1; 
        
	    end                                          
	
    end	   // end of the always block
    
    
        
endmodule
