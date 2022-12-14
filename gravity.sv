module digital_clock(input clk, output [13:0] segsec);

	parameter N = 25;
	reg [N-1:0] slow_clk = 0;
	reg [7:0] countsec = 0;

	always_ff @ (posedge clk)
		 slow_clk <= slow_clk + 1'b1;

	always_ff @ (posedge slow_clk[N-1])
		 if (countsec == 8'b00111011) countsec <= 8'b0;
		 else  countsec <= countsec + 8'b1;

	assign segsec = (countsec == 8'h0 ) ? 16'b01111110111111:
		 (countsec == 8'h1) ? 16'b01111110000110: //1        0000110     0111111
		 (countsec == 8'h2) ? 16'b01111111011011: //2        1011011
		 (countsec == 8'h3) ? 16'b01111111001111: //3        1001111
		 (countsec == 8'h4) ? 16'b01111111100110: //4        1100110
		 (countsec == 8'h5) ? 16'b01111111101101: //5        1101101
		 (countsec == 8'h6) ? 16'b01111111111101: //6        1111101
		 (countsec == 8'h7) ? 16'b01111110000111: //7        0000111
		 (countsec == 8'h8) ? 16'b01111111111111: //8        1111111
		 (countsec == 8'h9) ? 16'b01111111101111: //9        1101111
		 (countsec == 8'ha) ? 16'b00001100111111: //10
		 (countsec == 8'hb) ? 16'b00001100000110://11
		 (countsec == 8'hc) ? 16'b00001101011011://12
		 (countsec == 8'hd) ? 16'b00001101001111://13
		 (countsec == 8'he) ? 16'b00001101100110: //14
		 (countsec == 8'hf) ? 16'b00001101101101: //15
		 (countsec == 8'h10) ? 16'b00001101111101://16
		 (countsec == 8'h11) ? 16'b00001100000111://17
		 (countsec == 8'h12) ? 16'b00001101111111://18
		 (countsec == 8'h13) ? 16'b00001101101111://19
		 (countsec == 8'h14) ? 16'b10110110111111://20
		 (countsec == 8'h15) ? 16'b10110110000110://21
		 (countsec == 8'h16) ? 16'b10110111011011://22
		 (countsec == 8'h17) ? 16'b10110111001111://23
		 (countsec == 8'h18) ? 16'b10110111100110://24
		 (countsec == 8'h19) ? 16'b10110111101101://25
		 (countsec == 8'h1a) ? 16'b10110111111101://26
		 (countsec == 8'h1b) ? 16'b10110110000111://27
		 (countsec == 8'h1c) ? 16'b10110111111111://28
		 (countsec == 8'h1d) ? 16'b10110111101111://29
		 (countsec == 8'h1e) ? 16'b10011110111111://30
		 (countsec == 8'h1f) ? 16'b10011110000110://31
		 (countsec == 8'h20) ? 16'b10011111011011://32
		 (countsec == 8'h21) ? 16'b10011111001111://33
		 (countsec == 8'h22) ? 16'b10011111100110://34
		 (countsec == 8'h23) ? 16'b10011111101101://35
		 (countsec == 8'h24) ? 16'b10011111111101://36
		 (countsec == 8'h25) ? 16'b10011110000111://37
		 (countsec == 8'h26) ? 16'b10011111111111://38
		 (countsec == 8'h27) ? 16'b10011111101111://39
		 (countsec == 8'h28) ? 16'b11001100111111://40
		 (countsec == 8'h29) ? 16'b11001100000110://41
		 (countsec == 8'h2a) ? 16'b11001101011011://42
		 (countsec == 8'h2b) ? 16'b11001101001111://43
		 (countsec == 8'h2c) ? 16'b11001101100110://44
		 (countsec == 8'h2d) ? 16'b11001101101101://45
		 (countsec == 8'h2e) ? 16'b11001101111101://46
		 (countsec == 8'h2f) ? 16'b11001100000111://47
		 (countsec == 8'h30) ? 16'b11001101111111://48
		 (countsec == 8'h31) ? 16'b11001101101111://49
		 (countsec == 8'h32) ? 16'b11011010111111://50
		 (countsec == 8'h33) ? 16'b11011010000110://51
		 (countsec == 8'h34) ? 16'b11011011011011://52
		 (countsec == 8'h35) ? 16'b11011011001111://53
		 (countsec == 8'h36) ? 16'b11011011100110://54
		 (countsec == 8'h37) ? 16'b11011011101101://55
		 (countsec == 8'h38) ? 16'b11011011111101://56
		 (countsec == 8'h39) ? 16'b11011010000111://57
		 (countsec == 8'h3a) ? 16'b11011011111111://58
		 (countsec == 8'h3b) ? 16'b11011011101111://59
		 16'b01111110111111;
endmodule