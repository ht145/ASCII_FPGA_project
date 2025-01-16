// By: Hayden Galante
// ECE 540
// image processing module
// takes input from ROM and converts the value to a laplacian edge detection filter.
module image_processing(
                    input logic clock, 
                    input logic [3:0] doutb,
                    input logic video_on, 
                    output logic [3:0] Lsum
                    );
     
logic signed [8:0] out, temp;
logic [1282:0][3:0] p;
int i;

//read in first two lines plus 2 bits and the new doutb input
always @(posedge clock) 
begin
        if ( video_on)
        begin
            for ( i = 1282; i > 0; i = i -1) 
                begin
                p[i] = p[i - 1];                //shift register
                end
        p[0] = doutb;
        end
end

//multiply by laplacian mask
always_comb
    begin
    out = p[1281]  * -1 + 
          p[1280]  * -1 +
          p[1279]  * -1 + 
          p[641]   * -1 +
          p[640]   *  8 + 
          p[639]   * -1 +
          p[2]     * -1 +
          p[1]     * -1 +
          p[0]     * -1 ; 
    end

always_comb
begin
    if(out <= 0) 
    begin
        Lsum = 0;               //if out is negative Lsum = 0
    end
    else  
    begin
        temp = out >> 3;        //shift out values to fit in 4 bit register
        Lsum = temp[3:0];       //send lowest 4 bits of temp register to sum
    end 
    end 



endmodule

