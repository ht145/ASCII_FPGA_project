
/* 
	Hayden Galante
    11/16/2022 
    I2C Bus Master Module
*/

module i2cMaster( 
  input logic clk, 
  input logic reset,
  output logic i2c_sda,
  output wire i2c_scl
); 
  
  //write to device at address 0x50 write command 0xAA
localparam  IDLE  = 0;
localparam  START = 1;
localparam  ADDR  = 2;
localparam  RW    = 3; 
localparam  WACK  = 4;
localparam  DATA  = 5; 
localparam  STOP  = 6;
localparam  WACK2 = 7;
  
 
  reg [7:0] state; 
  reg [6:0] addr; 
  reg [7:0] count;
  reg [7:0] data; 
  logic i2c_scl_enable = 0; 
  
assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;

always @(negedge clk) begin 
    if (reset == 1) begin 
    i2c_scl_enable <= 0; 
    end else begin
	if((state == IDLE) || (state == START) || (state == STOP)) begin 
	i2c_scl_enable <= 0; 
	end else begin 
	i2c_scl_enable <= 1;
	end  
end  
end

  always @(posedge clk) begin
    if (reset == 1) begin 
      state <= 0; 
      i2c_sda <= 1;   
      addr <= 7'h50; 
      count <= 8'd0; 
      data <= 8'haa; 
    end
    
    else begin 
      unique case(state)

      IDLE: begin 			
         	i2c_sda <= 1; 
         	state <= START;
         	end
        
      START: begin 			
         	 i2c_sda <= 0; 
         	 state <= ADDR; 
         	 count <= 6; 
       		 end 
        
      ADDR: begin 
        i2c_sda <= addr[count];
        if(count == 0) state <= RW;
        else count <= count - 1;
            end
        
      RW: begin 
          i2c_sda <= 1;
          state <= WACK;
          end 
      
      WACK: begin
        	state <= DATA ; 
        	count <= 7 ; 
            end
        
      DATA: begin 
            i2c_sda <= data[count];
        if (count == 0) state <= WACK2;
            else count <= count - 1;
            end
      
      WACK2: begin 
             state <= STOP; 
             end 
        
       STOP: begin 
             i2c_sda <= 1; 
             state <= IDLE;
             end 

      endcase
    end 
  end
endmodule 