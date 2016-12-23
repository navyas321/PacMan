module checkpoint(input logic [9:0] pX,
				  input logic [9:0] pY,
				  input Clk, Reset,
				  output logic winner, TL1, TR1, BL1, BR1);
	 logic TL;
	 logic TR;
	 logic BR;
	 logic BL;
	 logic win;
	 logic x1,y1,x2,y2,x3,y3,x4,y4;
	 logic [10:0] G1X  = 10'h210; // BR
	 logic [10:0] G2X  = 10'h060; // BL
	 logic [10:0] G3X = 10'h210; // TR
	 logic [10:0] G4X  = 10'h060; // TL
	 logic [10:0] G1Y  = 10'h1C2; // BR
	 logic [10:0] G2Y  = 10'h1C0; // BL
	 logic [10:0] G3Y  = 10'h010; // TR
	 logic [10:0] G4Y  = 10'h010; // TL
	always_ff @ (posedge Reset or posedge Clk)
	if(Reset)
	begin
		TL <= 1'b0;
		TR <= 1'b0;
		BR <= 1'b0;
		BL <= 1'b0;
		win <= 1'b0;
	end
	else
	begin
	
	if((G1X > pX && G1X < pX+16) || (pX > G1X && pX < G1X+16))
		begin
			x1 <= 1'b1;
			x2 <= 1'b0;
			x3 <= 1'b1;
			x4 <= 1'b0;
		end
		else if((G2X > pX && G2X < pX+16) || (pX > G2X && pX < G2X+16))
		begin
			x2 <= 1'b1;
			x1 <= 1'b0;
			x3 <= 1'b0;
			x4 <= 1'b1;
		end
		/*else if((G3X > pX && G3X < pX+16) || (pX > G3X && pX < G3X+16))
		begin
			x3 <= 1'b1;
			x2 <= 1'b0;
			x1 <= 1'b0;
			x4 <= 1'b0;
		end*/
		/*else if((G4X > pX && G4X < pX+16) || (pX > G4X && pX < G4X+16))
		begin
			x4 <= 1'b1;
			x2 <= 1'b0;
			x3 <= 1'b0;
			x1 <= 1'b0;
		end*/
		else  
			begin
			x1 <= 1'b0;
			x2 <= 1'b0;
			x3 <= 1'b0;
			x4 <= 1'b0;
			end
			
		if((G1Y > pY && G1Y < pY+16) || (pY > G1Y && pY < G1Y+16))
		begin
			y1 <= 1'b1;
			y2 <= 1'b1;
			y3 <= 1'b0;
			y4 <= 1'b0;
		end
		/*else if((G2Y > pY && G2Y < pY+16) || (pY > G2Y && pY < G2Y+16))
		begin
			y2 <= 1'b1;
			y1 <= 1'b0;
			y3 <= 1'b0;
			y4 <= 1'b0;
		end*/
		else if((G3Y > pY && G3Y < pY+16) || (pY > G3Y && pY < G3Y+16))
		begin
			y3 <= 1'b1;
			y2 <= 1'b0;
			y1 <= 1'b0;
			y4 <= 1'b1;
		end
		/*else if((G4Y > pY && G4Y < pY+16) || (pY > G4Y && pY < G4Y+16))
		begin
			y4 <= 1'b1;
			y2 <= 1'b0;
			y3 <= 1'b0;
			y1 <= 1'b0;
		end*/
		else 
			begin
			y1 <= 1'b0;
			y2 <= 1'b0;
			y3 <= 1'b0;
			y4 <= 1'b0;
			end
			
		if(x1 && y1)
			BR <= 1'b1;
		else
			BR <= BR;
			
		if(x2 && y2)
			BL <= 1'b1;
		else
			BL <= BL;
			
		if(x3 && y3)
			TR <= 1'b1;
		else
			TR <= TR;
			
		if(x4 && y4)
			TL <= 1'b1;
		else
			TL <= TL;
		
		if(TL && TR && BR && BL)
			win <= 1'b1;
		else
			win <= win;
	end
	
	assign TL1 = TL;
	assign TR1 = TR;
	assign BR1 = BR;
	assign BL1 = BL;
	assign winner = win;
	endmodule
	