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


module ascii_filter(

    input  wire        vga_clk,               // input vga clock signal
	input  wire [3:0]  pix_val,               // input vixel value from the block ram
	input  wire        video_on,              // input video on singnal
	input  wire [11:0] pixel_row, 
	input  wire [11:0] pixel_column,
	//input  wire  [3:0] char_sel, 
	output wire        ascii_pix              // the vale of the averaged pixel value
    );
    
    reg [3:0] vid_buffer [9615:0];    			// viedo buffer register
    reg [3:0] avg_arr [0:39];                   // array to store the average valuees
    reg [3:0] char_addr;                        // internal signal for the character address
    integer i;                                  // integer to cycle through the values in the buffer
    reg [9:0] clm_count = 9'd0;                     // counter to keep track of the number of columns processed
    reg [9:0] row_count = 9'd0;                     // counter to keep track of the number of columns processed
    reg [5:0] avg_count = 6'd0;                 // counter to keep track of averages
    
    
    print_char print_char_2
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
            for (i=9615; i>0; i = i-1) begin
                
                vid_buffer[i] = vid_buffer[i-1];    // shifting the values in the buffer
            
            end
        
            vid_buffer[0] = pix_val;            // updateing the input for the vifor buffer
            clm_count = clm_count + 1;
            
            if (clm_count == 640) begin
                clm_count = 0;
            end
             
            if (avg_count == 40)
                avg_count = 0;    
                
            
        end                                     // end of the video on condition
    
    
                                          
                                          
      if (clm_count % 16 == 0)	begin			 // store the avg in the array
	
	   
        avg_arr[avg_count] =  (
          
            vid_buffer[(640*0)+0]  + vid_buffer[(640*0)+1] 	+ vid_buffer[(640*0)+2]   + vid_buffer[(640*0)+3]   + vid_buffer[(640*0)+4]   + vid_buffer[(640*0)+5]   + vid_buffer[(640*0)+6]   + vid_buffer[(640*0)+7]   + 
            vid_buffer[(640*0)+8]  + vid_buffer[(640*0)+9] 	+ vid_buffer[(640*0)+10]  + vid_buffer[(640*0)+11]  + vid_buffer[(640*0)+12]  + vid_buffer[(640*0)+13]  + vid_buffer[(640*0)+14]  + vid_buffer[(640*0)+15]  +
            vid_buffer[(640*1)+0]  + vid_buffer[(640*1)+1] 	+ vid_buffer[(640*1)+2]   + vid_buffer[(640*1)+3]   + vid_buffer[(640*1)+4]   + vid_buffer[(640*1)+5]   + vid_buffer[(640*1)+6]   + vid_buffer[(640*1)+7]   + 
            vid_buffer[(640*1)+8]  + vid_buffer[(640*1)+9] 	+ vid_buffer[(640*1)+10]  + vid_buffer[(640*1)+11]  + vid_buffer[(640*1)+12]  + vid_buffer[(640*1)+13]  + vid_buffer[(640*1)+14]  + vid_buffer[(640*1)+15]  +
            vid_buffer[(640*2)+0]  + vid_buffer[(640*2)+1] 	+ vid_buffer[(640*2)+2]   + vid_buffer[(640*2)+3]   + vid_buffer[(640*2)+4]   + vid_buffer[(640*2)+5]   + vid_buffer[(640*2)+6]   + vid_buffer[(640*2)+7]   + 
            vid_buffer[(640*2)+8]  + vid_buffer[(640*2)+9] 	+ vid_buffer[(640*2)+10]  + vid_buffer[(640*2)+11]  + vid_buffer[(640*2)+12]  + vid_buffer[(640*2)+13]  + vid_buffer[(640*2)+14]  + vid_buffer[(640*2)+15]  +
            vid_buffer[(640*3)+0]  + vid_buffer[(640*3)+1] 	+ vid_buffer[(640*3)+2]   + vid_buffer[(640*3)+3]   + vid_buffer[(640*3)+4]   + vid_buffer[(640*3)+5]   + vid_buffer[(640*3)+6]   + vid_buffer[(640*3)+7]   + 
            vid_buffer[(640*3)+8]  + vid_buffer[(640*3)+9] 	+ vid_buffer[(640*3)+10]  + vid_buffer[(640*3)+11]  + vid_buffer[(640*3)+12]  + vid_buffer[(640*3)+13]  + vid_buffer[(640*3)+14]  + vid_buffer[(640*3)+15]  +
            vid_buffer[(640*4)+0]  + vid_buffer[(640*4)+1] 	+ vid_buffer[(640*4)+2]   + vid_buffer[(640*4)+3]   + vid_buffer[(640*4)+4]   + vid_buffer[(640*4)+5]   + vid_buffer[(640*4)+6]   + vid_buffer[(640*4)+7]   + 
            vid_buffer[(640*4)+8]  + vid_buffer[(640*4)+9] 	+ vid_buffer[(640*4)+10]  + vid_buffer[(640*4)+11]  + vid_buffer[(640*4)+12]  + vid_buffer[(640*4)+13]  + vid_buffer[(640*4)+14]  + vid_buffer[(640*4)+15]  +
            vid_buffer[(640*5)+0]  + vid_buffer[(640*5)+1] 	+ vid_buffer[(640*5)+2]   + vid_buffer[(640*5)+3]   + vid_buffer[(640*5)+4]   + vid_buffer[(640*5)+5]   + vid_buffer[(640*5)+6]   + vid_buffer[(640*5)+7]   + 
            vid_buffer[(640*5)+8]  + vid_buffer[(640*5)+9] 	+ vid_buffer[(640*5)+10]  + vid_buffer[(640*5)+11]  + vid_buffer[(640*5)+12]  + vid_buffer[(640*5)+13]  + vid_buffer[(640*5)+14]  + vid_buffer[(640*5)+15]  +
            vid_buffer[(640*6)+0]  + vid_buffer[(640*6)+1] 	+ vid_buffer[(640*6)+2]   + vid_buffer[(640*6)+3]   + vid_buffer[(640*6)+4]   + vid_buffer[(640*6)+5]   + vid_buffer[(640*6)+6]   + vid_buffer[(640*6)+7]   + 
            vid_buffer[(640*6)+8]  + vid_buffer[(640*6)+9] 	+ vid_buffer[(640*6)+10]  + vid_buffer[(640*6)+11]  + vid_buffer[(640*6)+12]  + vid_buffer[(640*6)+13]  + vid_buffer[(640*6)+14]  + vid_buffer[(640*6)+15]  +
            vid_buffer[(640*7)+0]  + vid_buffer[(640*7)+1] 	+ vid_buffer[(640*7)+2]   + vid_buffer[(640*7)+3]   + vid_buffer[(640*7)+4]   + vid_buffer[(640*7)+5]   + vid_buffer[(640*7)+6]   + vid_buffer[(640*7)+7]   + 
            vid_buffer[(640*7)+8]  + vid_buffer[(640*7)+9] 	+ vid_buffer[(640*7)+10]  + vid_buffer[(640*7)+11]  + vid_buffer[(640*7)+12]  + vid_buffer[(640*7)+13]  + vid_buffer[(640*7)+14]  + vid_buffer[(640*7)+15]  +
            vid_buffer[(640*8)+0]  + vid_buffer[(640*8)+1] 	+ vid_buffer[(640*8)+2]   + vid_buffer[(640*8)+3]   + vid_buffer[(640*8)+4]   + vid_buffer[(640*8)+5]   + vid_buffer[(640*8)+6]   + vid_buffer[(640*8)+7]   + 
            vid_buffer[(640*8)+8]  + vid_buffer[(640*8)+9] 	+ vid_buffer[(640*8)+10]  + vid_buffer[(640*8)+11]  + vid_buffer[(640*8)+12]  + vid_buffer[(640*8)+13]  + vid_buffer[(640*8)+14]  + vid_buffer[(640*8)+15]  +
            vid_buffer[(640*9)+0]  + vid_buffer[(640*9)+1] 	+ vid_buffer[(640*9)+2]   + vid_buffer[(640*9)+3]   + vid_buffer[(640*9)+4]   + vid_buffer[(640*9)+5]   + vid_buffer[(640*9)+6]   + vid_buffer[(640*9)+7]   + 
            vid_buffer[(640*9)+8]  + vid_buffer[(640*9)+9] 	+ vid_buffer[(640*9)+10]  + vid_buffer[(640*9)+11]  + vid_buffer[(640*9)+12]  + vid_buffer[(640*9)+13]  + vid_buffer[(640*9)+14]  + vid_buffer[(640*9)+15]  +
            vid_buffer[(640*10)+0] + vid_buffer[(640*10)+1] + vid_buffer[(640*10)+2]  + vid_buffer[(640*10)+3]  + vid_buffer[(640*10)+4]  + vid_buffer[(640*10)+5]  + vid_buffer[(640*10)+6]  + vid_buffer[(640*10)+7]  + 
            vid_buffer[(640*10)+8] + vid_buffer[(640*10)+9] + vid_buffer[(640*10)+10] + vid_buffer[(640*10)+11] + vid_buffer[(640*10)+12] + vid_buffer[(640*10)+13] + vid_buffer[(640*10)+14] + vid_buffer[(640*10)+15] +
            vid_buffer[(640*11)+0] + vid_buffer[(640*11)+1] + vid_buffer[(640*11)+2]  + vid_buffer[(640*11)+3]  + vid_buffer[(640*11)+4]  + vid_buffer[(640*11)+5]  + vid_buffer[(640*11)+6]  + vid_buffer[(640*11)+7]  + 
            vid_buffer[(640*11)+8] + vid_buffer[(640*11)+9] + vid_buffer[(640*11)+10] + vid_buffer[(640*11)+11] + vid_buffer[(640*11)+12] + vid_buffer[(640*11)+13] + vid_buffer[(640*11)+14] + vid_buffer[(640*11)+15] +
            vid_buffer[(640*12)+0] + vid_buffer[(640*12)+1] + vid_buffer[(640*12)+2]  + vid_buffer[(640*12)+3]  + vid_buffer[(640*12)+4]  + vid_buffer[(640*12)+5]  + vid_buffer[(640*12)+6]  + vid_buffer[(640*12)+7]  + 
            vid_buffer[(640*12)+8] + vid_buffer[(640*12)+9] + vid_buffer[(640*12)+10] + vid_buffer[(640*12)+11] + vid_buffer[(640*12)+12] + vid_buffer[(640*12)+13] + vid_buffer[(640*12)+14] + vid_buffer[(640*12)+15] +
            vid_buffer[(640*13)+0] + vid_buffer[(640*13)+1] + vid_buffer[(640*13)+2]  + vid_buffer[(640*13)+3]  + vid_buffer[(640*13)+4]  + vid_buffer[(640*13)+5]  + vid_buffer[(640*13)+6]  + vid_buffer[(640*13)+7]  + 
            vid_buffer[(640*13)+8] + vid_buffer[(640*13)+9] + vid_buffer[(640*13)+10] + vid_buffer[(640*13)+11] + vid_buffer[(640*13)+12] + vid_buffer[(640*13)+13] + vid_buffer[(640*13)+14] + vid_buffer[(640*13)+15] +
            vid_buffer[(640*14)+0] + vid_buffer[(640*14)+1] + vid_buffer[(640*14)+2]  + vid_buffer[(640*14)+3]  + vid_buffer[(640*14)+4]  + vid_buffer[(640*14)+5]  + vid_buffer[(640*14)+6]  + vid_buffer[(640*14)+7]  + 
            vid_buffer[(640*14)+8] + vid_buffer[(640*14)+9] + vid_buffer[(640*14)+10] + vid_buffer[(640*14)+11] + vid_buffer[(640*14)+12] + vid_buffer[(640*14)+13] + vid_buffer[(640*14)+14] + vid_buffer[(640*14)+15] +
            vid_buffer[(640*15)+0] + vid_buffer[(640*15)+1] + vid_buffer[(640*15)+2]  + vid_buffer[(640*15)+3]  + vid_buffer[(640*15)+4]  + vid_buffer[(640*15)+5]  + vid_buffer[(640*15)+6]  + vid_buffer[(640*15)+7]  + 
            vid_buffer[(640*15)+8] + vid_buffer[(640*15)+9] + vid_buffer[(640*15)+10] + vid_buffer[(640*15)+11] + vid_buffer[(640*15)+12] + vid_buffer[(640*15)+13] + vid_buffer[(640*15)+14] + vid_buffer[(640*15)+15] +
            vid_buffer[(640*16)+0] + vid_buffer[(640*16)+1] + vid_buffer[(640*16)+2]  + vid_buffer[(640*16)+3]  + vid_buffer[(640*16)+4]  + vid_buffer[(640*16)+5]  + vid_buffer[(640*16)+6]  + vid_buffer[(640*16)+7]  + 
            vid_buffer[(640*16)+8] + vid_buffer[(640*16)+9] + vid_buffer[(640*16)+10] + vid_buffer[(640*16)+11] + vid_buffer[(640*16)+12] + vid_buffer[(640*16)+13] + vid_buffer[(640*16)+14] + pix_val 				
            ) / 256 ;
    
        char_addr = avg_arr[avg_count];
        avg_count = avg_count+ 1'b1; 
        

	    end                                          
	
    end	   // end of the always block
    
    
        
endmodule
