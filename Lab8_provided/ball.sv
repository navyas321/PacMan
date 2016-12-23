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
					input [15:0]key,
               output [9:0]  BallX, BallY, BallS, 
					input logic [3:0] wall,
					output logic Up, Down, Left, Right,
					output logic [2:0] direction);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 //logic [0:479][0:639] ROM;
	 logic [8:0] wall_addr1,  wall_addr2, wall_addr3,  wall_addr4;
	 logic [639:0] wall_data1, wall_data2, wall_data3, wall_data4;
    parameter [9:0] Ball_X_Center=160;  // Center position on the X axis // 480
    parameter [9:0] Ball_Y_Center=230;  // Center position on the Y axis // 230
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
           
        else 
			begin
			
			/*if(ROM[x][y-1]) //up
					Up = 1'b0;
			else Up = 1'b1;	
			
			if(ROM[x+1][y]) //right
					Right = 1'b0;
			else Right = 1'b1;
			
		   if(ROM[x-1][y]) //left
					Left = 1'b0;
			else Left = 1'b1;
			
			if(ROM[x][y+1]) //down
					Down = 1'b0;
			else Down = 1'b1;*/
			
			/*else 
				begin
					Down = 1'b1;
					Up = 1'b1;
					Left = 1'b1;
					Right = 1'b1;
				end*/
			/*if(!key)
				begin
				 Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				 Ball_X_Motion <= Ball_X_Motion;
				 end 
			else 
				begin*/
			
			wall_addr1 = Ball_Y_Pos-1; //Up
			wall_addr2 = Ball_Y_Pos; //Right
			wall_addr3 = Ball_Y_Pos; //Left
			wall_addr4 = Ball_Y_Pos+16; //Down
			
			Up = wall_data1[Ball_X_Pos];
			Right = wall_data2[Ball_X_Pos+16];
			Left = wall_data3[Ball_X_Pos-1];
			Down = wall_data4[Ball_X_Pos];
			
			case (key)
			8'h07:
				begin
				//	if (((Ball_X_Pos + Ball_Size) > 329 ) && (Ball_Y_Pos + Ball_Size) < 231 )
				if(Right)
						begin
						Ball_Y_Motion<=10'd0;
						Ball_X_Motion<=10'd0;
						direction<=3'd3;
						end
					else 
						begin
						Ball_X_Motion<=10'd2;
						Ball_Y_Motion<=10'd0;
						direction<=3'd3;
						end
				end
				
			8'h1a:
				begin
				if(Up)
					begin
					Ball_Y_Motion<=10'd0;
					Ball_X_Motion<=10'd0;
					direction<=3'd0;
					end
					else 
						begin
						Ball_Y_Motion<=~10'd2 + 1'b1;
						Ball_X_Motion<=10'd0;
						direction<=3'd0;
						end
				end
				
			8'h04:
				begin
					if(Left)
						begin
						Ball_Y_Motion<=10'd0;
						Ball_X_Motion<=10'd0;
						direction<=3'd1;
						end
					else 
						begin
						Ball_Y_Motion<=10'd0;
						Ball_X_Motion<=~10'd2 +1'b1;
						direction<=3'd1;
						end
				end
				
			8'h16:
				begin
					if(Down)
						begin
						Ball_Y_Motion<=10'd0;
						Ball_X_Motion<=10'd0;
						direction<=3'd2;
						end
					else 
						begin
						Ball_X_Motion<=10'd0;
						Ball_Y_Motion<=10'd2;
						direction<=3'd2;
						end
				end
				
			default
						begin
						Ball_Y_Motion<=10'd0;
						Ball_X_Motion<=10'd0;
						direction<=3'd4;
						end
			endcase
			
				//end
				
				
				 
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				 
				 
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
	 
	 assign x = Ball_X_Pos;
	 assign y = Ball_Y_Pos;
	 
	 
	 /*assign Up = ROM[y-9][x];
    assign Right = ROM[y][x+8];
	 assign Left = ROM[y][x-9];
	 assign Down = ROM[y+8][x];*/
	 
	 /*always_comb
		begin
			wall_addr1 = Ball_Y_Pos-1; //Up
			wall_addr2 = Ball_Y_Pos; //Right
			wall_addr3 = Ball_Y_Pos; //Left
			wall_addr4 = Ball_Y_Pos+16; //Down
			
			Up = wall_data1[Ball_X_Pos];
			Right = wall_data2[Ball_X_Pos+16];
			Left = wall_data3[Ball_X_Pos-1];
			Down = wall_data4[Ball_X_Pos];
		end*/
	 
	 Walls wall1(.addr(wall_addr1), .data(wall_data1));
	 Walls wall2(.addr(wall_addr2), .data(wall_data2));
	 Walls wall3(.addr(wall_addr3), .data(wall_data3));
	 Walls wall4(.addr(wall_addr4), .data(wall_data4));

endmodule
