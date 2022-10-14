//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
					input grid [19:0][9:0],
					input [9:0] DrawX, DrawY,
					input [4:0] DrawGridY,
			      input [3:0] DrawGridX,
					input [3:0] data, data1, data2, data3, data4,
               output [9:0]  BallX, BallY, BallS,
					output stuck,
					output [4:0] BallGridY,
			      output [3:0] BallGridX);
					
		    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
			 
			 logic spawn, drop;
			 
			 logic [5:0] counter;
			 
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=112;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=240;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=400;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=80;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=384;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
					
	 enum logic {Pressed, NotPressed} State, Next_State;
		
	always_ff @ (posedge frame_clk)
		begin
			BallGridY <= (Ball_Y_Pos - 32 - 79)/16;
			BallGridX <= (Ball_X_Pos - 32 - 239)/16;
		end
	 
	 always_ff @ (posedge Reset or posedge frame_clk)
		begin
			if (Reset)
				counter <= 6'b111111;
			else if (counter == 0)
				begin
					counter <= 6'b111111;
					drop <= 1;
				end
			else
				begin
					drop <= 0;
					counter <= counter - 1;
				end
		end
	 
	 always_ff @ (posedge Reset or posedge frame_clk)
		begin	
			if (Reset)  // Asynchronous Reset
			  begin 
					State <= NotPressed;
					Ball_Y_Pos <= Ball_Y_Center;
					Ball_X_Pos <= Ball_X_Center;
			  end
			else if(spawn)
				begin
					Ball_Y_Pos <= Ball_Y_Center;
					Ball_X_Pos <= Ball_X_Center;
				end
			else begin
				State <= Next_State;
				case (State)
					NotPressed :
						begin
							if(keycode != 0 || drop)
								begin
									Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
									Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);	
								end
							else
								begin
									Ball_X_Pos <= Ball_X_Pos;
									Ball_Y_Pos <= Ball_Y_Pos;
								end
						end
				endcase
				
			end
		end
		
	 always_comb
		begin
			Next_State = State;
			case (State)
				NotPressed : 
					begin
						if(keycode != 0)
							begin
								Next_State = Pressed;
							end
					end
				Pressed:
					begin
						if(keycode == 0)
							begin
								Next_State = NotPressed;
							end
					end
				default : ;
			endcase
		end
    


    assign Ball_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 always_comb
		begin
			stuck = 1'b0;
			spawn = 1'b0;
			case(keycode)
				8'h04 : begin
								if(((Ball_X_Min + Ball_Size + 16) <= Ball_X_Pos) && ((Ball_Y_Pos + Ball_Size + 16) <= Ball_Y_Max) && (~(grid[BallGridY][BallGridX-1])))
									begin
										Ball_X_Motion = -16;//A
										Ball_Y_Motion = 0;
									end
								else
									begin
										Ball_X_Motion = 0;
										Ball_Y_Motion = 0;
										stuck = 1'b0;
										spawn = 1'b0;
									end
							  end
				8'h07 : begin
								if(((Ball_X_Pos + Ball_Size + 16) <= Ball_X_Max) && ((Ball_Y_Pos + Ball_Size + 16) <= Ball_Y_Max) && (~(grid[BallGridY][BallGridX+1])))
									begin
										Ball_X_Motion = 16;//D
										Ball_Y_Motion = 0;
									end
								else
									begin
										Ball_X_Motion = 0;
										Ball_Y_Motion = 0;
										stuck = 1'b0;
										spawn = 1'b0;
									end
							  end

							  
				8'h16 : begin
								if(((Ball_Y_Pos + Ball_Size + 16) <= Ball_Y_Max))// && (~(grid[BallGridY+1][BallGridX])))
									begin
										Ball_Y_Motion = 16;//S
										Ball_X_Motion = 0;
									end
								else
									begin
										Ball_X_Motion = 0;
										Ball_Y_Motion = 0;
										stuck = 1'b1;
										spawn = 1'b1;
									end
							 end
				default : begin
								Ball_X_Motion = 0;
								Ball_Y_Motion = 0;
								stuck = 1'b0;
								spawn = 1'b0;
							end
			endcase
			if(drop)
				begin
					if(((Ball_Y_Pos + Ball_Size + 16) <= Ball_Y_Max))//((Ball_Y_Pos + Ball_Size) <= Ball_Y_Max) && ())// && (~(grid[BallGridY+1][BallGridX])))
						begin
							Ball_Y_Motion = 16;//S
							Ball_X_Motion = 0;
						end
					else
						begin
							Ball_X_Motion = 0;
							Ball_Y_Motion = 0;
							stuck = 1'b1;
							spawn = 1'b1;
						end
				end
				
		end
   
//    always_ff @ (posedge Reset or posedge frame_clk )
//    begin: Move_Ball
//        if (Reset)  // Asynchronous Reset
//        begin 
//            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
//				Ball_X_Motion <= 10'd0; //Ball_X_Step;
//				Ball_Y_Pos <= Ball_Y_Center;
//				Ball_X_Pos <= Ball_X_Center;
//        end
//           
//        else 
        //begin 
//				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
//					  
//				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
//					  Ball_Y_Motion <= Ball_Y_Step;
//					  
//				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
//					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
//					  
//				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
//					  Ball_X_Motion <= Ball_X_Step;
//					  
//				 else 
//					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				
//				if((Ball_Y_Pos + Ball_Size) < Ball_Y_Max)
//					begin
//						Ball_Y_Motion <= 1;
//						Ball_X_Motion <= 0;
//					end
//				else
//					begin
//						Ball_Y_Motion <= 0;
//						Ball_X_Motion <= 0;
//					end
				
				 
//				 case (keycode)
//					8'h04 : begin
//								if((Ball_X_Pos - Ball_Size) > Ball_X_Min)
//									begin
//										Ball_X_Motion <= -16;//A
//										Ball_Y_Motion <= 0;
//									end
//							  end
//					        
//					8'h07 : begin
//								if((Ball_X_Pos + Ball_Size) < Ball_X_Max)
//								begin
//									Ball_X_Motion <= 1;//D
//									Ball_Y_Motion <= 0;
//								end
//							  end
//
//							  
//					8'h16 : begin
//								if((Ball_Y_Pos + Ball_Size) < Ball_Y_Max)
//								begin
//									Ball_Y_Motion <= 2;//S
//									Ball_X_Motion <= 0;
//								end
//							 end
//							  
//					8'h1A : begin
//								if((Ball_Y_Pos - Ball_Size) > Ball_Y_Min)
//								begin
//									Ball_Y_Motion <= -1;//W
//									Ball_X_Motion <= 0;
//								end
//							 end	  
//					default: ;
//			   endcase
//				 
//				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
//				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		//end  
    //end
	 
	 
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
