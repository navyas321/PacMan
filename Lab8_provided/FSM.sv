module FSM(input Reset,Clk,
			input logic [15:0]keyboard,
			//input logic pause
			input logic  pacDeath,
			input logic winsignal,
			output logic startscreen,
			output logic gamescreen,
			//output logic pausescreen,
			output logic gameoverscreen,
			output logic winscreen
			);

enum logic [2:0]{Start,Game,Death,Win}state,next_state;

always_ff @(posedge Clk or posedge Reset)
begin 
if(Reset)
	state<=Start;
	else
	state<=next_state;
end

always_comb
begin
next_state=state;

unique case(state)
Start:begin
	if(keyboard==8'h28)//enter
	next_state<=Game;
	else 
	next_state<=Start;
	end

Game:begin
	//if(keyboard==####)///esc
	//next_state<=Pause;
	if(pacDeath)
	next_state<=Death;
	else if(winsignal)
	next_state<=Win;
	else
	next_state<=Game;
	end

/*Pause:begin
	if(keyboard==####)//esc
	next_state<=gamescreen;
	else 
	next_state<=Pause;
	end*/

Death:begin
	if(keyboard==8'h2c)//esc
	next_state<=Start;
	else 
	next_state<=Death;
	end

Win:begin
if(keyboard==8'h2c)//esc
	next_state<=Start;
	else 
	next_state<=Win;
	end
endcase
end

always_comb
	begin
	
	//case(state)
	if(state == Start)
		begin
		startscreen=1'b1;
		gamescreen=1'b0;
		gameoverscreen=1'b0;
		winscreen=1'b0;
		end
	else if(state == Game)
		begin
		gamescreen=1'b1;
		startscreen=1'b0;
		gameoverscreen=1'b0;
		winscreen=1'b0;
		end
	else if(state==Win)
	begin
	winscreen=1'b1;
	gamescreen=1'b0;
	startscreen=1'b0;
	gameoverscreen=1'b0;
	end
	else if(state == Death) 
	begin
	gameoverscreen=1'b1;
	startscreen=1'b0;
	gamescreen=1'b0;
	winscreen=1'b0;
	end
	else
	begin
	startscreen=1'b0;
	gamescreen=1'b0;
	gameoverscreen=1'b0;
	winscreen=1'b0;
	end
end

endmodule