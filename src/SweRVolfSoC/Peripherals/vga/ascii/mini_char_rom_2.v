 module mini_char_rom_2 (
	input 	wire 			clk,
	input 	wire [3:0] 		addr,
	input 	wire 			w_en,
	input 	wire [63:0] 	in_data,
	output 	reg  [63:0] 	char_out
);

reg [63:0] char [0:15];

// iitial block to preset the character rom
initial begin
	// get the eq
	char[0] 	= 64'h0000000000000000;	// - -
	char[1] 	= 64'h0000000000303000;	// -.-
	char[2] 	= 64'h0000000000303060;	// -,-
	char[3] 	= 64'h000000FC00000000;	// ---
	char[4] 	= 64'h0030300000303060;	// -;-
	char[5] 	= 64'h003030FC30300000;	// -+-
	char[6] 	= 64'h307030303030FC00;	// -1-
	char[7] 	= 64'h000078CCC0CC7800;	// -c-
	char[8] 	= 64'h0000780C7CCC7600;	// -a-
	char[9] 	= 64'h78CC0C380CCC7800;	// -3-
	char[10] 	= 64'hFCC0F80C0CCC7800;	// -5-
	char[11] 	= 64'hFCCC0C1830303000;	// -7-
	char[12] 	= 64'h78CCCC7C0C187000;	// -9-
	char[13] 	= 64'h0000C6D6FEFE6C00;	// -w-
	char[14] 	= 64'h6C6CFE6CFE6C6C00;	// -#-
	char[15] 	= 64'h7CC6DEDEDEC07800; // -@- 
		

end 

// case statement to select the character and drive the output

always @(posedge clk) begin

case(addr)

	0	: char_out = char[addr];
	1	: char_out = char[addr];
	2	: char_out = char[addr];
	3	: char_out = char[addr];
	4	: char_out = char[addr];
	5	: char_out = char[addr];
	6	: char_out = char[addr];
	7	: char_out = char[addr];
	8	: char_out = char[addr];
	9	: char_out = char[addr];
	10	: char_out = char[addr];
	11	: char_out = char[addr];
	12	: char_out = char[addr];
	13	: char_out = char[addr];
	14	: char_out = char[addr];
	15	: char_out = char[addr];

endcase

if (w_en) begin
    char[addr] = in_data;
end 

end

endmodule