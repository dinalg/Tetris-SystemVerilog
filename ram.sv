/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameROMSq
(
		input [18:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [2:0] mem [0:399];

initial
begin
	 $readmemh("tetris_I.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
