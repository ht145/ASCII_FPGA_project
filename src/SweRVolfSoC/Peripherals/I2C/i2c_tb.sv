module i2c_TB ();

  logic clk;
  
  logic SDA;
  logic i2c_clk;
  logic reset;
 
  i2cMaster uut(.clk(clk), 
                .reset(reset), 
                .i2c_scl(i2c_clk), 
                .i2c_sda(SDA));
  
  initial begin 
    clk = 0; 
    forever begin 
      clk = #1 ~clk; 
    end 
  end
 
  initial begin 
    reset = 1;
    #10 
    reset = 0;  
   #100;
    $stop; 
  end 
endmodule 
