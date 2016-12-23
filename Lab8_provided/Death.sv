module Death(input logic [9:0] pX, pY, G1X, G1Y, G2X, G2Y, G3X, G3Y, G4X, G4Y,
				 output logic pacDeath);

				 logic x1,y1,x2,y2,x3,y3,x4,y4;
		always_comb
		begin 
		
		if((G1X > pX && G1X < pX+16) || (pX > G1X && pX < G1X+16))
		begin
			x1 = 1'b1;
			x2 = 1'b0;
			x3 = 1'b0;
			x4 = 1'b0;
		end
		else if((G2X > pX && G2X < pX+16) || (pX > G2X && pX < G2X+16))
		begin
			x2 = 1'b1;
			x1 = 1'b0;
			x3 = 1'b0;
			x4 = 1'b0;
		end
		else if((G3X > pX && G3X < pX+16) || (pX > G3X && pX < G3X+16))
		begin
			x3 = 1'b1;
			x2 = 1'b0;
			x1 = 1'b0;
			x4 = 1'b0;
		end
		else if((G4X > pX && G4X < pX+16) || (pX > G4X && pX < G4X+16))
		begin
			x4 = 1'b1;
			x2 = 1'b0;
			x3 = 1'b0;
			x1 = 1'b0;
		end
		else  
			begin
			x1 = 1'b0;
			x2 = 1'b0;
			x3 = 1'b0;
			x4 = 1'b0;
			end
			
		if((G1Y > pY && G1Y < pY+16) || (pY > G1Y && pY < G1Y+16))
		begin
			y1 = 1'b1;
			y2 = 1'b0;
			y3 = 1'b0;
			y4 = 1'b0;
		end
		else if((G2Y > pY && G2Y < pY+16) || (pY > G2Y && pY < G2Y+16))
		begin
			y2 = 1'b1;
			y1 = 1'b0;
			y3 = 1'b0;
			y4 = 1'b0;
		end
		else if((G3Y > pY && G3Y < pY+16) || (pY > G3Y && pY < G3Y+16))
		begin
			y3 = 1'b1;
			y2 = 1'b0;
			y1 = 1'b0;
			y4 = 1'b0;
		end
		else if((G4Y > pY && G4Y < pY+16) || (pY > G4Y && pY < G4Y+16))
		begin
			y4 = 1'b1;
			y2 = 1'b0;
			y3 = 1'b0;
			y1 = 1'b0;
		end
		else 
			begin
			y1 = 1'b0;
			y2 = 1'b0;
			y3 = 1'b0;
			y4 = 1'b0;
			end
		
		pacDeath = (x1 & y1) | (x2 & y2) | (x3 & y3) | (x4 & y4);
		
		end		 
endmodule