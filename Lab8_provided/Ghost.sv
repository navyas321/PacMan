module ghost ( input Reset, frame_clk,
					input logic [9:0] Ghost_X_Center, Ghost_Y_Center, pX, pY,
					//input [15:0]key,
               output [9:0]  GhostX, GhostY); 
					//input logic [3:0] wall,
					//output logic Up, Down, Left, Right);
	 logic [9:0] Ghost_X_Pos, Ghost_X_Motion, Ghost_Y_Pos, Ghost_Y_Motion, Ghost_Size;
	 //logic [0:479][0:639] ROM;
	 logic [8:0] wall_addr1,  wall_addr2, wall_addr3,  wall_addr4;
	 logic [639:0] wall_data1, wall_data2, wall_data3, wall_data4;
	 logic Up, Down, Left, Right;
	 logic [3:0] valid, Direction;
    //parameter [9:0] Ghost_X_Center=480;  // Center position on the X axis // 480
    //parameter [9:0] Ghost_Y_Center=230;  // Center position on the Y axis // 230
    parameter [9:0] Ghost_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ghost_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ghost_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ghost_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ghost_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ghost_Y_Step=1;      // Step size on the Y axis
	 
	 assign Ghost_Size = 16;
	 
	     always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ghost
        if (Reset)  // Asynchronous Reset
        begin 
            Ghost_Y_Motion <= 10'd0; //Ghost_Y_Step;
				Ghost_X_Motion <= 10'd0; //Ghost_X_Step;
				Ghost_Y_Pos <= Ghost_Y_Center;
				Ghost_X_Pos <= Ghost_X_Center;
        end
           
        else 
			begin
			
			wall_addr1 = Ghost_Y_Pos-1; //Up
			wall_addr2 = Ghost_Y_Pos; //Right
			wall_addr3 = Ghost_Y_Pos; //Left
			wall_addr4 = Ghost_Y_Pos+16; //Down
			
			Up = wall_data1[Ghost_X_Pos];
			Right = wall_data2[Ghost_X_Pos+16];
			Left = wall_data3[Ghost_X_Pos-1];
			Down = wall_data4[Ghost_X_Pos];
			
			valid = {~Down,~Up,~Right,~Left};
			/*if(!Right && Ghost_X_Pos < pX)	
				Ghost_X_Motion<=10'd1;
			else 
				Ghost_Y_Motion<=10'd0;
				
			if(!Left && Ghost_X_Pos > pX)
				Ghost_X_Motion<=~10'd1 +1'b1;
				else Ghost_Y_Motion<=10'd0;
				
			if(!Down && Ghost_Y_Pos < pY)
				Ghost_Y_Motion<=10'd1;
				else Ghost_X_Motion<=10'd0;		
				
			if(!Up && Ghost_Y_Pos > pY)
				Ghost_Y_Motion<=~10'd1 + 1'b1;
				else Ghost_X_Motion<=10'd0;*/
				
				
			/*else
				begin 
				Ghost_X_Motion<=Ghost_X_Motion;
				Ghost_Y_Motion<=Ghost_Y_Motion;
				end*/
				
			//case(Direction)
				if(Direction == 4'b0001) //left
					begin
						Ghost_Y_Motion<=10'd0;
						Ghost_X_Motion<=~10'd1 +1'b1;
					end
				else if(Direction == 4'b0010) //right
					begin
						Ghost_Y_Motion<=10'd0;
						Ghost_X_Motion<=10'd1;
					end
				else if(Direction == 4'b0100) //up
					begin
						Ghost_Y_Motion<=~10'd1 + 1'b1;
						Ghost_X_Motion<=10'd0;
					end
				else if(Direction == 4'b1000)	//down
					begin
						Ghost_Y_Motion<=10'd1;
						Ghost_X_Motion<=10'd0;
					end
					
				/*default
						begin
						G_Y_Motion<=10'd0;
						Ball_X_Motion<=10'd0;
						end
				endcase*/
				
				 Ghost_Y_Pos <= (Ghost_Y_Pos + Ghost_Y_Motion);  // Update Ghost position
				 Ghost_X_Pos <= (Ghost_X_Pos + Ghost_X_Motion);
				 
		 end  
    end
     
    assign GhostX = Ghost_X_Pos;
   
    assign GhostY = Ghost_Y_Pos;
   
    //assign GhostS = Ghost_Size;
	 
	 assign x = Ghost_X_Pos;
	 assign y = Ghost_Y_Pos;
	 
	 always@ *
	 begin
		case(valid)
			4'b0000: Direction <= 4'b0000;	
			4'b0001: Direction <= 4'b0001;
			4'b0010: Direction <= 4'b0010;
			4'b0011: begin 
							
							if(((Ghost_X_Pos == pX)) && ((Ghost_Y_Pos > pY)))
								Direction <= 4'b0001;
				
							else if(((Ghost_X_Pos == pX)) && ((pY > Ghost_Y_Pos)))
								Direction <= 4'b0010;
			
							else if(pX > Ghost_X_Pos)
								Direction <= 4'b0010;
	
							else if(Ghost_X_Pos > pX)
								Direction <= 4'b0001;
							
							else
								Direction <= Direction;
															
						end
			4'b0100: Direction <= 4'b0100;
			4'b0101: begin 
			
							if((Ghost_X_Pos == pX)  && (Ghost_Y_Pos > pY))
								Direction <= 4'b0100;
							
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
								
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0100;
								
							else if((Ghost_X_Pos == pX)  && (pY > Ghost_Y_Pos))
								Direction <= 4'b0001;
							
							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_Y_Pos - pY) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b0100;

							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (Ghost_Y_Pos - pY)))
							
									Direction <= 4'b0001;
							
							else if((pY > Ghost_Y_Pos) &&
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (pY - Ghost_Y_Pos)))
								
									Direction <= 4'b0100;
									
							else if((Ghost_Y_Pos > pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0100;
		
							else if((pY > Ghost_Y_Pos) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;

							else if((pY > Ghost_Y_Pos) &&
								(pX > Ghost_X_Pos) && 
								((pY - Ghost_Y_Pos) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b0001;
							
							else
								Direction <= Direction;
				
						end
			4'b0110: begin // can go Up or Right
							
							// if PacMan directly above go Up
							if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
								Direction <= 4'b0100;
								
							// if PacMan directly to the Right go Right
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan directly to the Left go Up
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0100;
								
							// if PacMan directly below go Right
							else if((Ghost_X_Pos == pX)  && (pY > Ghost_Y_Pos))
								Direction <= 4'b0010;
							
							// if PacMan to the Right and Up and Up is closer go Up
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((Ghost_Y_Pos - pY) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b0100;
							
							// if PacMan to the Right and Up and Right is closer go Right
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (Ghost_Y_Pos - pY)))
								
									Direction <= 4'b0010;
							
							// if PacMan to the Left and Down and Left is closer go Up
							else if((pY > Ghost_Y_Pos) &&
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (pY - Ghost_Y_Pos)))
								
									Direction <= 4'b0100;
									
							// if PacMan Up and to the Left go Up
							else if((Ghost_Y_Pos > pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0100;
							
							//if PacMan Down and to the Right go Right
							else if((pY > Ghost_Y_Pos) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Right
							else if((pY > Ghost_Y_Pos) &&
								(Ghost_X_Pos > pX) && 
								((pY - Ghost_Y_Pos) < (Ghost_X_Pos - pX)))
									
									Direction <= 4'b0010;
									
							else
								Direction <= Direction;
						
						
						end
			4'b0111: begin // can go Left, Right, or Up
			
							// if PacMan directly above go Up
							if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
								Direction <= 4'b0100;
							
							// if PacMan directly to the Right go Right
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan directly to the Left go Left
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
								
							// if PacMan directly below go Right
							else if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
								Direction <= 4'b0010;
							
							// if PacMan below and to the Right go Right
							else if((pY > Ghost_Y_Pos) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan below and to the Left go Left
							else if((pY > Ghost_Y_Pos) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
														
							// if PacMan above and to the Right and Right is closer go Right
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (Ghost_Y_Pos - pY)))
								
									Direction <= 4'b0010;
							
							// if PacMan above and to the Right and Up is closer go Up
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((Ghost_Y_Pos - pY) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b0100;
							
							// if PacMan above and to the Left and Left is closer go Left
							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (Ghost_Y_Pos - pY)))
									
									Direction <= 4'b0001;
							
							// if PacMan above and to the Left and Up is closer go Up
							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_Y_Pos - pY) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b0100;
								
							else
								Direction <= Direction;
															
						end
			4'b1000: Direction <= 4'b1000;
			4'b1001: begin // can go Down or Left
							
							// if PacMan directly below go Down
							if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
								Direction <= 4'b1000;

							// if PacMan directly to the Left go Left
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
							
							// if PacMan directly to the Right go Down
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b1000;
							
							// if PacMan directly above go Left
							else if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
								Direction <= 4'b0001;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((pY - Ghost_Y_Pos) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (pY - Ghost_Y_Pos)))
								
									Direction <= 4'b0001;
							
							// if PacMan to the Right and Up and Right is closer go Down
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (Ghost_Y_Pos - pY)))
									
									Direction <= 4'b1000;
									
							// if PacMan Down and to the Right go Down
							else if((pY > Ghost_Y_Pos) && (pX > Ghost_X_Pos))
								Direction <= 4'b1000;
							
							// if PacMan Up and to the Left go Left
							else if((Ghost_Y_Pos > pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
							
							// if PacMan to the Right and Up and Up is closer go Left
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((Ghost_Y_Pos - pY) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b0001;
							
							else
								Direction <= Direction;
							
						end
			4'b1010: begin // can go Down or Right
			
							// if PacMan directly below go Down
							if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
								Direction <= 4'b1000;
								
							// if PacMan directly to the Right go Right
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
								
							// if PacMan directly above go Right
							else if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
								Direction <= 4'b0010;
							
							// if PacMan directly to the Left go Down
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b1000;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pY - Ghost_Y_Pos) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (pY - Ghost_Y_Pos)))
								
									Direction <= 4'b0010;
							
							// if PacMan to the Left and Up and Left is closer go Down
							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (Ghost_Y_Pos - pY)))
									
									Direction <= 4'b1000;
							
							// if PacMan Down and to the Left go Down
							else if((pY > Ghost_Y_Pos) && (Ghost_X_Pos > pX))
								Direction <= 4'b1000;
							
							// if Pacman up and to the Right go Right
							else if((Ghost_Y_Pos > pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan to the Left and Up and Up is closer go Right
							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_Y_Pos - pY) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b0010;
							
							else
								Direction <= Direction;
						
						end
			4'b1011: begin // can go Left, Right, or Down

						// if PacMan directly below go Down
							if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
								Direction <= 4'b1000;
							
							// if PacMan directly to the Right go Right
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan directly to the Left go Left
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
								
							// if PacMan directly above go Right
							else if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
								Direction <= 4'b0010;
															
							// if PacMan above and to the Right go Right
							else if((Ghost_Y_Pos > pY)  && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
							
							// if PacMan above and to the Left go Left
							else if((Ghost_Y_Pos > pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pY - Ghost_Y_Pos) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (pY - Ghost_Y_Pos)))
									
									Direction <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((pY - Ghost_Y_Pos) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos - pX) && 
								((Ghost_X_Pos - pX) < (pY - Ghost_Y_Pos)))
									
									Direction <= 4'b0001;
					
							else
								Direction <= Direction;
								
						end
			4'b1100: begin // can go Down or Up
			
							// if PacMan directly to the Right go Up
							if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0100;
							
							// if PacMan directly to the Left go Down
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b1000;
							
							// if PacMan below go Down
							else if(pY > Ghost_Y_Pos)
								Direction <= 4'b1000;
								
							// if PacMan above go Up
							else if(Ghost_Y_Pos > pY)
								Direction <= 4'b0100;
							
							else
								Direction <= Direction;
								
						end
			4'b1101: begin // can go Left, Down, or Up

						// if PacMan directly below go Down
						if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
							Direction <= 4'b1000;
						
						// if PacMan directly above go Up
						else if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
							Direction <= 4'b0100;
							
						// if PacMan directly to the Left go Left
						else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
						
						// if PacMan directly to the Right go Down
						else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b1000;
													
						// if PacMan above and to the Right go Up
						else if((Ghost_Y_Pos > pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0100;
						
						// if PacMan below and to the Right go Down
						else if((pY > Ghost_Y_Pos) && (pX > Ghost_X_Pos))
								Direction <= 4'b1000;
						
						// if PacMan to the Left and Down and Down is closer go Down
						else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((pY - Ghost_Y_Pos) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b1000;
							
						// if PacMan to the Left and Down and Left is closer go Left
						else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (pY - Ghost_Y_Pos)))
									
									Direction <= 4'b0001;
						
						// if PacMan to the Left and Up and Up is closer go Up
						else if((Ghost_Y_Pos > pY) && 
							(Ghost_X_Pos > pX) && 
							((Ghost_Y_Pos - pY) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b0100;
							
						// if PacMan to the Left and Up and Left is closer go Left
						else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (Ghost_Y_Pos - pY)))
										
									Direction <= 4'b0001;
									
						else
								Direction <= Direction;
												
						end
			4'b1110: begin // can go Right, Down, or Up

						// if PacMan directly below go Down
						if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
							Direction <= 4'b1000;
						
						// if PacMan directly above go Up
						else if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
							Direction <= 4'b0100;
							
						// if PacMan directly to the Right go Right
						else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
						
						// if PacMan directly to the Left go Down
						else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b1000;
													
						// if PacMan above and to the Left go Up
						else if((Ghost_Y_Pos > pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0100;
						
						// if PacMan below and to the Left go Down
						else if((pY - Ghost_Y_Pos) && (Ghost_X_Pos > pX))
								Direction <= 4'b1000;
						
						// if PacMan to the Right and Down and Down is closer go Down
						else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pY - Ghost_Y_Pos) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b1000;
							
						// if PacMan to the Right and Down and Right is closer go Right
						else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (pY - Ghost_Y_Pos)))
									
									Direction <= 4'b0010;
						
						// if PacMan to the Right and Up and Up is closer go Up
						else if((Ghost_Y_Pos > pY) && 
							(pX > Ghost_X_Pos) && 
							((Ghost_Y_Pos - pY) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b0100;
							
						// if PacMan to the Right and Up and Right is closer go Right
						else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (Ghost_Y_Pos - pY)))
										
									Direction <= 4'b0010;
									
						else
								Direction <= Direction;
							
						end
			4'b1111: begin // can go Right, Left, Down, or Up
							
							// if PacMan directly below go Down
							if((Ghost_X_Pos == pX) && (pY > Ghost_Y_Pos))
								Direction <= 4'b1000;
							
							// if PacMan directly above go Up
							else if((Ghost_X_Pos == pX) && (Ghost_Y_Pos > pY))
								Direction <= 4'b0100;
						
							// if PacMan directly to the Right go Right
							else if((Ghost_Y_Pos == pY) && (pX > Ghost_X_Pos))
								Direction <= 4'b0010;
								
							// if PacMan directly to the Left go Left
							else if((Ghost_Y_Pos == pY) && (Ghost_X_Pos > pX))
								Direction <= 4'b0001;
								
							// if PacMan to the Left and Up and Up is closer go Up
							else if((Ghost_Y_Pos > pY) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_Y_Pos - pY) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b0100;
							
							// if PacMan to the Left and Up and Left is closer go Left
							else if((Ghost_Y_Pos > pY) && 
									(Ghost_X_Pos > pX) && 
									((Ghost_X_Pos - pX) < (Ghost_Y_Pos - pY)))
										
									Direction <= 4'b0001;
							
							// if PacMan to the Right and Up and Up is closer go Up
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((Ghost_Y_Pos - pY) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b0100;
							
							// if PacMan to the Right and Up and Right is closer go Right
							else if((Ghost_Y_Pos > pY) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (Ghost_Y_Pos - pY)))
								
									Direction <= 4'b0010;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pY - Ghost_Y_Pos) < (pX - Ghost_X_Pos)))
								
									Direction <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((pY > Ghost_Y_Pos) && 
								(pX > Ghost_X_Pos) && 
								((pX - Ghost_X_Pos) < (pY - Ghost_Y_Pos)))
									
									Direction <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((pY - Ghost_Y_Pos) < (Ghost_X_Pos - pX)))
								
									Direction <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((pY > Ghost_Y_Pos) && 
								(Ghost_X_Pos > pX) && 
								((Ghost_X_Pos - pX) < (pY - Ghost_Y_Pos)))
									
									Direction <= 4'b0001;
			
							else
								Direction <= Direction;
							
						end
		endcase
	 end
	 /*always_comb
		begin
			wall_addr1 = Ghost_Y_Pos-1; //Up
			wall_addr2 = Ghost_Y_Pos; //Right
			wall_addr3 = Ghost_Y_Pos; //Left
			wall_addr4 = Ghost_Y_Pos+16; //Down
			
			Up = wall_data1[Ghost_X_Pos];
			Right = wall_data2[Ghost_X_Pos+16];
			Left = wall_data3[Ghost_X_Pos-1];
			Down = wall_data4[Ghost_X_Pos];
		end*/
	 
	 Walls wall1(.addr(wall_addr1), .data(wall_data1));
	 Walls wall2(.addr(wall_addr2), .data(wall_data2));
	 Walls wall3(.addr(wall_addr3), .data(wall_data3));
	 Walls wall4(.addr(wall_addr4), .data(wall_data4));

endmodule