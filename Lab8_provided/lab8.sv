//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  lab8 		( input         CLOCK_50,
                       input[3:0]    KEY, 
							  input [17:0] SW,
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK				// SDRAM Clock
											);
    
    logic Reset_h, vssig, Clk;
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig, x, y, G1X, G1Y, G2X, G2Y, G3X, G3Y, G4X, G4Y, SS, GS;
	 logic [15:0] keycode;
	 logic [2:0] dir;
	 logic wall, win;
    logic up, down, left, right, pacDeath, TL, TR, BL, BR, ws;
	 logic [10:0] ghost1_x = 192;
	 logic [10:0] ghost1_y = 19;
	 logic [10:0] ghost2_x = 496;
	 logic [10:0] ghost2_y = 19;
	 logic [10:0] ghost3_x = 192;
	 logic [10:0] ghost3_y = 463;
	 logic [10:0] ghost4_x = 496;
	 logic [10:0] ghost4_y = 463;
	 
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	 assign x = ballxsig;
	 assign y = ballysig;
	 assign rst = Reset_h | SS;
	 
	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_clk_clk(DRAM_CLK),
										 .keycode_export(keycode),  
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w));
	
	//Fill in the connections for the rest of the modules 
    vga_controller vgasync_instance(.Clk(Clk), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_CLK), .blank(VGA_BLANK_N), 
	 .sync(VGA_SYNC_N), .DrawX(drawxsig), .DrawY(drawysig));
   
    ball ball_instance(.Reset(SS), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .key(keycode), .wall(SW[3:0]),
									.Up(up), .Down(down), .Left(left), .Right(right), .direction(dir));
   
    color_mapper color_instance(.BallX(ballxsig), .BallY(ballysig), .DrawX(drawxsig), .DrawY(drawysig), .Ball_size(ballsizesig), .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B), .wall(wall), 
										  .ghost1_x(G1X), .ghost1_y(G1Y), .ghost2_x(G2X), .ghost2_y(G2Y), .ghost3_x(G3X), .ghost3_y(G3Y), .ghost4_x(G4X), .ghost4_y(G4Y), .go(GS), .ss(SS), .ws(WS), .dir(dir),
										  .BR(BR), .BL(BL), .TR(TR), .TL(TL), .Reset(rst), .Clk(VGA_VS)); 
											//.Up(up), .Down(down), .Left(left), .Right(right), .Clk(VGA_VS));
	 ghost Ghost1(.Reset(rst), .frame_clk(VGA_VS), .Ghost_X_Center(ghost1_x), .Ghost_Y_Center(ghost1_y), .GhostX(G1X), .GhostY(G1Y), .pX(ballxsig), .pY(ballysig));
	 ghost Ghost2(.Reset(rst), .frame_clk(VGA_VS), .Ghost_X_Center(ghost2_x), .Ghost_Y_Center(ghost2_y), .GhostX(G2X), .GhostY(G2Y), .pX(ballxsig), .pY(ballysig));
	 ghost Ghost3(.Reset(rst), .frame_clk(VGA_VS), .Ghost_X_Center(ghost3_x), .Ghost_Y_Center(ghost3_y), .GhostX(G3X), .GhostY(G3Y), .pX(ballxsig), .pY(ballysig));
	 ghost Ghost4(.Reset(rst), .frame_clk(VGA_VS), .Ghost_X_Center(ghost4_x), .Ghost_Y_Center(ghost4_y), .GhostX(G4X), .GhostY(G4Y), .pX(ballxsig), .pY(ballysig));
	 Death death(.pX(ballxsig), .pY(ballysig), .G1X(G1X), .G1Y(G1Y), .G2X(G2X), .G2Y(G2Y), .G3X(G3X), .G3Y(G3Y), .G4X(G4X), .G4Y(G4Y), .pacDeath(go));
	 FSM fsm(.Reset(Reset_h), .Clk(VGA_VS), .keyboard(keycode), .pacDeath(go), .startscreen(SS), .gameoverscreen(GS), .winscreen(WS), .winsignal(win));
	 checkpoint cp(.pX(ballxsig), .pY(ballysig), .Clk(VGA_VS), .Reset(rst), .winner(win), .TL1(TL), .TR1(TR), .BL1(BL), .BR1(BR));
	 
	 HexDriver hex_inst_0 (x[3:0], HEX0);
	 HexDriver hex_inst_1 (x[7:4], HEX1);
	 HexDriver hex_inst_2 (x[9:8], HEX2);
	 HexDriver hex_inst_3 (BL, HEX3);
	 HexDriver hex_inst_4 (BR, HEX4);
	 HexDriver hex_inst_5 (TR, HEX5);
	 HexDriver hex_inst_6 (TL, HEX6);
	 HexDriver hex_inst_7 (win, HEX7);
  
endmodule
