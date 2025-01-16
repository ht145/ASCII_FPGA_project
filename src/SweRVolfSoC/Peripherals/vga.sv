//VGA module contains the DTG and block ram allowing 
//the user to control a sprite and laod a background
//the module can take two sprite position registers

module vga(
        input logic  reset,             //active high reset
        input logic [31:0] vga_row, vga_col,   //active high test mode enable
        input logic vga_clk,             // vga clk @ 31.5MHz for 640x480
        input logic [15:0]switches,
        input logic [3:0] vga_o,
        input logic HREF, 
        input logic PCLK, 
        input logic we, 
        input logic [19:0] addra,
        output logic [3:0] vga_r, vga_g, vga_b, 
        output logic vga_vs, vga_hs // vga output 
        );
        
        logic video_on; 
        logic [31:0] pix_num; 
        logic[11:0] pixel_row, pixel_column;
        logic[3:0] doutb;
        logic [2:0][2:0] pix; 
        logic [3:0] Lsum; 
        logic ascii_pix;
         
        dtg dtg(
        .clock(vga_clk),
        .rst(reset), 
        .video_on(video_on), 
        .horiz_sync(vga_hs), 
        .vert_sync(vga_vs),
        .pixel_row(pixel_row), 
        .pixel_column(pixel_column),
        .pix_num(pix_num)
        );
        
        
// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
blk_mem_gen_0 image_rom1(
  .clka(PCLK),    // input wire clka
  .wea(we),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [18 : 0] addra
  .dina(vga_o),    // input wire [3 : 0] dina
  .clkb(vga_clk),    // input wire clkb
  .addrb(pix_num[18:0]),  // input wire [18 : 0] addrb
  .doutb(doutb)  // output wire [3 : 0] doutb
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

//instantiation of the image processing module that creates laplacian sum output
image_processing imageproc1(.video_on(video_on), .doutb(doutb), .clock(vga_clk), .Lsum(Lsum)); 

ascii_filter_2 ascii_1
   (
    .vga_clk        (vga_clk), 
    .pix_val        (doutb),   
    .video_on       (video_on),
    .pixel_row       (pixel_row),
    .pixel_column    (pixel_column),
    .ascii_pix      (ascii_pix)
   );

// internal wires
wire [3:0] c_vga_r;
wire [3:0] c_vga_g;
wire [3:0] c_vga_b;

colorizer color1(
.clk        (vga_clk),
.ascii_pix  (ascii_pix),
.switches   (switches[15:9]),
.color_reg  (vga_col[5:0]),
.c_vga_r      (c_vga_r),
.c_vga_g      (c_vga_g),
.c_vga_b      (c_vga_b)
);


//switches mux to control the output of the VGA cable.
always@(posedge vga_clk) 
unique case(switches[3:0])
    1:  begin 
        //vertical bars created using pix_num[4]
        //vga_r = doutb & {4{pix_num[4]}};
        //vga_g = doutb & {4{pix_num[4]}};
        //vga_b = doutb & {4{pix_num[4]}};

        vga_r = 4'd0;//{ascii_pix,ascii_pix,ascii_pix,ascii_pix};
        vga_g = {ascii_pix,ascii_pix,ascii_pix,ascii_pix};
        vga_b = 4'd0;//{ascii_pix,ascii_pix,ascii_pix,ascii_pix};

        end
    2: begin
        //thresholded normal image
        if(doutb > {switches[6:4], 1'b0})
        begin
        vga_r = doutb & {4{video_on}};          
        vga_b = doutb & {4{video_on}};          
        vga_g = doutb & {4{video_on}};
        end 
        else
        begin
        vga_r = 0;         
        vga_b = 0;          
        vga_g = 0;
        end
        end
    4:  begin 
         //laplacian sum with no thresholding
         //vga_r = Lsum;              
         //vga_b = Lsum;              
         //vga_g = Lsum;
           vga_r = c_vga_r;              
           vga_b = c_vga_b;              
           vga_g = c_vga_g;
       end
    8: begin 
        //thresholding with laplacian sum
        if(Lsum > {switches[6:4], 1'b0})
        begin
         vga_r = {4{video_on}} ;             
         vga_b = {4{video_on}} ;              
         vga_g = {4{video_on}} ;
         end
        else
        begin
        vga_r = 0;          
        vga_b = 0;          
        vga_g = 0;
        end
        end
endcase 
        
endmodule

