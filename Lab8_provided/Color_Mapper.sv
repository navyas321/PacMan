

module  color_mapper ( input Reset, Clk,
							  input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
							  input go, ss, ws,
							  input logic BR, BL, TR, TL,
							  input logic [2:0] dir,
							  //input Clk, 
							  input [9:0] ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y, ghost4_x, ghost4_y,
                       output logic [7:0]  Red, Green, Blue,
							  output logic wall);
							  //output logic Up, Down, Left, Right);
    
    logic ball_on;
	 
	 logic [15:0] mouth;
	 
	 logic [10:0] checkpoint1_x  = 10'h210; // BR
	 logic [10:0] checkpoint2_x  = 10'h060; // BL
	 logic [10:0] checkpoint3_x  = 10'h210; // TR
	 logic [10:0] checkpoint4_x  = 10'h060; // TL
	 logic [10:0] checkpoint1_y  = 10'h1C2; // BR
	 logic [10:0] checkpoint2_y  = 10'h1C0; // BL
	 logic [10:0] checkpoint3_y  = 10'h010; // TR
	 logic [10:0] checkpoint4_y  = 10'h010; // TL
	 logic checkpoint1_on;
	 logic checkpoint2_on;
	 logic checkpoint3_on;
	 logic checkpoint4_on;
	 logic [10:0] cpSize = 16;

	 
	 logic ghost1_on;
	 logic ghost3_on;
	 logic ghost4_on;
	 //logic [10:0] ghost_x = 16;
	 //logic [10:0] ghost_y = 16;
	 logic [10:0] ghost1_size_x = 16;
	 logic [10:0] ghost1_size_y = 16;
	 logic [10:0] ghost3_size_x = 16;
	 logic [10:0] ghost3_size_y = 16;
	 logic [10:0] ghost4_size_x = 16;
	 logic [10:0] ghost4_size_y = 16;
	 
	 logic wall_on;
	 logic [10:0] wall_x = 0;
	 logic [10:0] wall_y = 0;
	 logic [10:0] wall_size_x = 640;
	 logic [10:0] wall_size_y = 480;
	 
	 logic [10:0] sprite_addr;
	 logic [7:0] sprite_data;
	 logic [6:0] sprite_addr1;
	 logic [15:0] sprite_data1;
	 logic [8:0] wall_addr;
	 logic [639:0] wall_data;
	 
	 logic start_on;
	 logic [4:0] start_addr;
	 logic [63:0] start_data;
	 logic [10:0] start_x = 0;
	 logic [10:0] start_y = 0;
	 logic [10:0] start_size_x = 640;
	 logic [10:0] start_size_y = 480;
	 
	 logic end_on;
	 logic [4:0] end_addr;
	 logic [63:0] end_data;
	 logic [10:0] end_x = 0;
	 logic [10:0] end_y = 0;
	 logic [10:0] end_size_x = 640;
	 logic [10:0] end_size_y = 480;
	 
	 logic win_on;
	 logic [4:0] win_addr;
	 logic [63:0] win_data;
	 logic [10:0] win_x = 0;
	 logic [10:0] win_y = 0;
	 logic [10:0] win_size_x = 640;
	 logic [10:0] win_size_y = 480;

	 font_rom fr(.addr(sprite_addr), .data(sprite_data));
	 Sprites spr(.addr(sprite_addr1), .data(sprite_data1));
	 Walls walls(.addr(wall_addr), .data(wall_data));
	 Start start(.addr(start_addr), .data(start_data));
	 End endd(.addr(end_addr), .data(end_data));
	 Win win(.addr(win_addr), .data(win_data));
	 
	 logic ghost2_on;
	 //logic [10:0] ghost2_x = 16;
	 //logic [10:0] ghost2_y = 448;
	 logic [10:0] ghost2_size_x = 16;
	 logic [10:0] ghost2_size_y = 16;
	 logic [7:0]chameleon;

	 //mouth = ((DrawX  + DrawY )%2) + 1;
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 always_comb
	 begin
		  if(DrawX/10 >= start_x && DrawX/10 < start_x + start_size_x &&
			DrawY/15 >= start_y && DrawY/15 < start_y + start_size_y)
			begin
			start_on = 1'b1;
			start_addr = (DrawY/15);
			end
			else
			begin
			start_on = 1'b0;
			start_addr = 5'b0;
			end
			
			if(DrawX/10 >= end_x && DrawX/10 < end_x + end_size_x &&
			DrawY/15 >= end_y && DrawY/15 < end_y + end_size_y)
			begin
			end_on = 1'b1;
			end_addr = (DrawY/15);
			end
			else
			begin
			end_on = 1'b0;
			end_addr = 5'b0;
			end

			if(DrawX/10 >= win_x && DrawX/10 < win_x + win_size_x &&
			DrawY/15 >= win_y && DrawY/15 < win_y + win_size_y)
			begin
			win_on = 1'b1;
			win_addr = (DrawY/15);
			end
			else
			begin
			win_on = 1'b0;
			win_addr = 5'b0;
			end
			

			if(dir == 0)
				mouth = 16*'h3;
			else if(dir == 1)
				mouth = 16*'h0;
			else if(dir == 2)
				mouth = 16*'h4;
			else if(dir == 3)
				mouth = 16*'h5;
			else
				mouth = 16*'h1;
	 end
	 
	 
	 always_ff @ (posedge Clk)
	 begin
		if (Reset) chameleon <= 0;
		else 
			chameleon <= chameleon +1;
	 end
	 
    always_comb
    begin:Ball_on_proc
			
        if (DrawX >= BallX && DrawX < BallX + Size &&
			DrawY >= BallY && DrawY < BallY + Size)
			begin
            ball_on = 1'b1;
				ghost1_on = 1'b0;
            ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				sprite_addr = 10'b0;
				//start_addr = 6'b0;
				sprite_addr1 = (DrawY - BallY + mouth);
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			else if(DrawX >= ghost2_x && DrawX < ghost2_x + ghost2_size_x &&
			DrawY >= ghost2_y && DrawY < ghost2_y + ghost2_size_y)
			begin
				ghost1_on = 1'b0;
				ball_on = 1'b0;
				ghost2_on = 1'b1;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr = 10'b0;
				sprite_addr1 = (DrawY - ghost2_y + 16*'h02);
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
		else if(DrawX >= ghost1_x && DrawX < ghost1_x + ghost1_size_x &&
			DrawY >= ghost1_y && DrawY < ghost1_y + ghost1_size_y)
			begin
				ghost1_on = 1'b1;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				ball_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr1 = (DrawY - ghost1_y + 16*'h02);
				sprite_addr = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			
		else if(DrawX >= ghost3_x && DrawX < ghost3_x + ghost3_size_x &&
			DrawY >= ghost3_y && DrawY < ghost3_y + ghost3_size_y)
			begin
				ghost3_on = 1'b1;
				ghost2_on = 1'b0;
				ghost1_on = 1'b0;
				ghost4_on = 1'b0;
				ball_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr1 = (DrawY - ghost3_y + 16*'h02);
				sprite_addr = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			
		else if(DrawX >= ghost4_x && DrawX < ghost4_x + ghost4_size_x &&
			DrawY >= ghost4_y && DrawY < ghost4_y + ghost4_size_y)
			begin
				ghost4_on = 1'b1;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost1_on = 1'b0;
				ball_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr1 = (DrawY - ghost4_y + 16*'h02);
				sprite_addr = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			
			else if(DrawX >= checkpoint1_x && DrawX < checkpoint1_x + cpSize &&
			DrawY >= checkpoint1_y && DrawY < checkpoint1_y + cpSize)
			begin
				ghost1_on = 1'b0;
				ball_on = 1'b0;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				checkpoint1_on = 1'b1;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr = 10'b0;
				sprite_addr1 = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			
		else if(DrawX >= checkpoint2_x && DrawX < checkpoint2_x + cpSize &&
			DrawY >= checkpoint2_y && DrawY < checkpoint2_y + cpSize)
			begin
				ghost1_on = 1'b0;
				ball_on = 1'b0;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b1;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr = 10'b0;
				sprite_addr1 = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			
		else if(DrawX >= checkpoint3_x && DrawX < checkpoint3_x + cpSize &&
			DrawY >= checkpoint3_y && DrawY < checkpoint3_y + cpSize)
			begin
				ghost1_on = 1'b0;
				ball_on = 1'b0;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b1;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr = 10'b0;
				sprite_addr1 = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
			
		else if(DrawX >= checkpoint4_x && DrawX < checkpoint4_x + cpSize &&
			DrawY >= checkpoint4_y && DrawY < checkpoint4_y + cpSize)
			begin
				ghost1_on = 1'b0;
				ball_on = 1'b0;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b1;
				//start_addr = 6'b0;
				sprite_addr = 10'b0;
				sprite_addr1 = 10'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			  end
			
			else if(DrawX >= wall_x && DrawX < wall_x + wall_size_x &&
			DrawY >= wall_y && DrawY < wall_y + wall_size_y)
			begin
				ghost1_on = 1'b0;
				ghost2_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				ball_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr1 = 6'b0;
				sprite_addr = 10'b0;
				wall_addr = (DrawY);
				wall_on = 1'b1;
			end
			
		else
			begin
				ghost1_on = 1'b0;
				ghost3_on = 1'b0;
				ghost4_on = 1'b0;
				ball_on = 1'b0;
				ghost2_on = 1'b0;
				checkpoint1_on = 1'b0;
				checkpoint2_on = 1'b0;
				checkpoint3_on = 1'b0;
				checkpoint4_on = 1'b0;
				//start_addr = 6'b0;
				sprite_addr = 10'b0;
				sprite_addr1 = 6'b0;
				wall_addr = 9'b0;
				wall_on = 1'b0;
			end
     end 
       
    always_comb
    begin:RGB_Display
		  if(ss == 1'b1)
		  begin
				if((start_on == 1'b1) && (start_data[64 - (DrawX/10 - start_x)] == 1'b1))
				begin
				Red = 8'hff;
            Green = 8'hee;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
				end
		  end
		  else if(go == 1'b1)
		  begin
				if((end_on == 1'b1) && (end_data[64 - (DrawX/10 - end_x)] == 1'b1))
				begin
				Red = 8'hff;
            Green = 8'hee;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
				end
		  end
		  else if(ws == 1'b1)
		  begin
		      if((win_on == 1'b1) && (win_data[64 - (DrawX/10 - win_x)] == 1'b1))
				begin
				Red = 8'hff;
            Green = 8'hee;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
				end
		  end
        else if ((ball_on == 1'b1) && sprite_data1[DrawX - BallX] == 1'b1) 
        begin 
            Red = 8'hff;
            Green = 8'hee;
            Blue = 8'h00;
        end
		  
		  else if ((ghost1_on == 1'b1) && sprite_data1[DrawX - ghost1_x] == 1'b1) 
        begin 
            Red = 8'hff;
            Green = 8'h69;
            Blue = 8'hb4;
        end
		  
		  else if ((ghost2_on == 1'b1) && sprite_data1[DrawX - ghost2_x] == 1'b1) 
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end
		  
		  else if ((ghost3_on == 1'b1) && sprite_data1[DrawX - ghost3_x] == 1'b1) 
        begin 
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  
		  else if ((ghost4_on == 1'b1) && sprite_data1[DrawX - ghost4_x] == 1'b1) 
        begin 
            Red = 8'hcc;
            Green = 8'hcc;
            Blue = 8'h00;
        end
		
		  else if (checkpoint1_on == 1'b1) 
        begin 
				if(BR == 1'b1)
				begin
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
				end
				
        end
		  
		  else if (checkpoint2_on == 1'b1) 
        begin 
            if(BL == 1'b1)
				begin
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
				end
        end
		  
		  else if (checkpoint3_on == 1'b1) 
        begin
				if(TR == 1'b1)
				begin
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
				end
        end
		  
		  else if (checkpoint4_on == 1'b1) 
        begin 
            if(TL == 1'b1)
				begin
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
				end
				else
				begin
				Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
				end
        end
		  
		   else if ((wall_on == 1'b1) && wall_data[DrawX - wall_x] == 1'b1) 
        begin 
				if(chameleon >= 0 && chameleon < 64)
				begin
				Red = 8'hff; 
				Green = 8'h69;
				Blue = 8'hbf;
			end
            else if(chameleon >= 64 && chameleon < 128)
			begin
				Red = 8'h00; 
				Green = 8'hff;
				Blue = 8'hff;
			end
			else if(chameleon >= 128 && chameleon < 192)
			begin
				Red = 8'h00; 
				Green = 8'hff;
				Blue = 8'h00;
			end
			else 
		  begin
				Red = 8'h00; 
				Green = 8'h00;
				Blue = 8'hff;
			end
			
        end
		  
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
        end      
    end 
	 

    
endmodule
