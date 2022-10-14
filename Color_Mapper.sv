//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
								input blank, Clk, stuck, Reset,
								input [4:0] BallGridY,
								input [3:0] BallGridX,
								output grid [19:0][9:0],
								output [4:0] DrawGridY,
								output [3:0] DrawGridX,
								output [3:0] data, data1, data2, data3, data4,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, occupied, block_on;
	 
	 logic [23:0] square_pixel_color;
	 
	 logic [10:0] shape_x = 288;
	 logic [10:0] shape_y = 80;
	 logic [10:0] shape_size_x = 64;
	 logic [10:0] shape_size_y = 64;
	 
	 logic [7:0] R, G, B;
	 
//	 logic [4:0] BallGridY;
//	 logic [3:0] BallGridX;
	 
	 integer block[33:0] = '{1, 4, 18, 15, 5, 13, 14, 2, 4, 9, 11, 14, 8, 6, 12, 17, 7, 9, 13, 16, 15, 8, 10, 17, 18, 2, 4, 6, 2, 5, 1, 3, 19, 8};
	 
	 bit [31:0] randShape;
	 logic [6:0] fontAddr, fontAddr1, fontAddr2, fontAddr3, fontAddr4;
	 
	 int i = 0;
	 
	 font_rom blocks(.addr(fontAddr), .data(data));
	 font_rom blocks1(.addr(fontAddr1), .data(data1));
	 font_rom blocks2(.addr(fontAddr2), .data(data2));
	 font_rom blocks3(.addr(fontAddr3), .data(data3));
	 font_rom blocks4(.addr(fontAddr4), .data(data4));
	 
	 always_ff @ (posedge Clk)
			begin
				if(Reset)
					begin
						for(int x = 0; x < 20; x++)
							begin
								for(int y = 0; y < 10; y++)
									begin
										grid[x][y] <= 1'b0;
										grid[19][y] <= 1'b1;
									end
							end
					end
				else
					begin
						if(stuck)
							begin
								i <= i + 1;
								grid[BallGridY][BallGridX] <= data1[3];
								grid[BallGridY][BallGridX+1] <= data1[2];
								grid[BallGridY][BallGridX+2] <= data1[1];
								grid[BallGridY][BallGridX+3] <= data1[0];
								grid[BallGridY+1][BallGridX] <= data2[3];
								grid[BallGridY+1][BallGridX+1] <= data2[2];
								grid[BallGridY+1][BallGridX+2] <= data2[1];
								grid[BallGridY+1][BallGridX+3] <= data2[0];
								grid[BallGridY+2][BallGridX] <= data3[3];
								grid[BallGridY+2][BallGridX+1] <= data3[2];
								grid[BallGridY+2][BallGridX+2] <= data3[1];
								grid[BallGridY+2][BallGridX+3] <= data3[0];
								grid[BallGridY+3][BallGridX] <= data4[3];
								grid[BallGridY+3][BallGridX+1] <= data4[2];
								grid[BallGridY+3][BallGridX+2] <= data4[1];
								grid[BallGridY+3][BallGridX+3] <= data4[0];
							end
					end
				if(block[i] == 1)
					begin
						R <= 8'hFF;
						G <= 8'hFF;
						B <= 8'h00;
					end
				else if((block[i] == 2) || (block[i] == 9))
					begin
						R <= 8'hFF;
						G <= 8'h00;
						B <= 8'h00;
					end
				else if((block[i] == 3) || (block[i] == 8))
					begin
						R <= 8'h00;
						G <= 8'hFF;
						B <= 8'hFF;
					end
				else if((block[i] == 4) || (block[i] == 10))
					begin
						R <= 8'h90;
						G <= 8'hEE;
						B <= 8'h90;
					end
				else if((block[i] == 5) || (block[i] == 11) || (block[i] == 12) || (block[i] == 13))
					begin
						R <= 8'h00;
						G <= 8'h00;
						B <= 8'h8B;
					end
				else if((block[i] == 6) || (block[i] == 14) || (block[i] == 15) || (block[i] == 16))
					begin
						R <= 8'hFF;
						G <= 8'hA5;
						B <= 8'h00;
					end
				else if((block[i] == 7) || (block[i] == 17) || (block[i] == 18) || (block[i] == 19))
					begin
						R <= 8'hA0;
						G <= 8'h20;
						B <= 8'hF0;
					end
			end
			
	 always_comb
		begin
			DrawGridY = (DrawY - 80)/16;
			DrawGridX = (DrawX - 240)/16;
//			BallGridY = BallY/25;
//			BallGridX = (BallX - 182)/26;
		end
		
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 always_comb
		begin
			fontAddr1 = (4*block[i]);
			fontAddr2 = (4*block[i] + 1);
			fontAddr3 = (4*block[i] + 2);
			fontAddr4 = (4*block[i] + 3);
		end
	 
    always_comb
    begin:Ball_on_proc
        if(
		  	 (DrawX + Ball_size >= BallX) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY + Ball_size >= BallY) &&
       (DrawY <= BallY + Ball_size))
//DrawX >= shape_x && DrawX < shape_x + shape_size_x && DrawY >= shape_y && DrawY < shape_y + shape_size_y)
				begin
					ball_on = 1'b1;
					fontAddr = (((DrawY - (BallY - Ball_size))/16) + 4*block[i]);
				end
        else
				begin
					ball_on = 1'b0;
					fontAddr = 7'b0;
				end 
     end
       
    always_comb
    begin:RGB_Display
			if(~blank)
				begin
					Red = 8'h0; 
					Green = 8'h0;
					Blue = 8'h0;
				end
			else
				begin
					if((ball_on == 1'b1) && (DrawX % 16 != 0) && (DrawY % 16 != 0) && (data[2'b11 - (((DrawX - (BallX - Ball_size))/16))] == 1'b1))// && (data[2'b11 - (((DrawX - shape_x)/16)%4)] == 1'b1))
						begin
							Red = R;
							Green = G;
							Blue = B;
//							else
//								begin
//									Red = 8'h69; 
//									Green = 8'h69;
//									Blue = 8'h69;
//								end
						end
					else if((grid[(DrawY-80)/16][((DrawX-240)/16)] == 1'b1) && (DrawX % 16 != 0) && (DrawY % 16 != 0))
						begin
							Red = 8'hff;
							Green = 8'h55;
							Blue = 8'h00;
						end
					else
						begin
							if(DrawX % 16 == 0)
								begin
									Red = 8'hFF; 
									Green = 8'hFF;
									Blue = 8'hFF;
								end
							else if(DrawY % 16 == 0)
								begin
									Red = 8'hFF; 
									Green = 8'hFF;
									Blue = 8'hFF;
								end
							else
								begin
									Red = 8'h69; 
									Green = 8'h69;
									Blue = 8'h69;
								end
						end
				end
    end
    
endmodule
