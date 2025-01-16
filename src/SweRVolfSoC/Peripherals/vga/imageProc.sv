//Hayden Galante
//Testbench for Verilog

`define ROW 12
`define COL 12


module imageProctb(); 


int doutb; 
int sum = 1;
int count = 0;
int toggle = 1;
int i, j, k, l; 

wire video_on;
reg clk, rst; 
wire[11:0]pixel_row, pixel_column;
wire pix_num;
reg [3:0] average;

image_processing uut(
                    .clock(clk), 
                    .doutb(doutb),
                    .video_on(video_on),
		            .pixel_row(pixel_row),
		            .pixel_column(pixel_column), 
                    .average(average)
                    );
 dtg dtg1(
	.clock(clk),
	.rst(rst), 
	.horiz_sync(hsync), 
	.vert_sync(vsync),
	.video_on(video_on),	
	.pixel_row(pixel_row),
	.pixel_column(pixel_column),
	.pix_num(pix_num)
	);
	
initial begin 
 	clk = 0;
	rst = 0; 
	
end 
     
 always 
 #5  clk =  ! clk; 

    
initial begin

    for( i = 0; i < `ROW; i = i + 1)
    begin
        for( j = 0; j < `COL; j = j + 1)
        begin
        if(count % 3 == 0) 
            begin
               if(toggle == 1)
               begin
                   toggle = 0;
                   sum = sum -1;
               end
               else
               begin
                   toggle = 1;
                   sum = sum + 1;
               end
            end
        if (count % (`ROW*3) == 0 && count != 0)
        begin
            sum = sum + 2; 
        end
            count = count + 1;
            doutb = sum;
            
        end
    end
end
endmodule