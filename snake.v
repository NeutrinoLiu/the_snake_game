module snake(	
						OSC_50, 
						KEY,
						VGA_CLK,    
						VGA_HS,     
						VGA_VS,     
						VGA_BLANK,    
						VGA_SYNC,         
						VGA_R,      
						VGA_B,      
						VGA_G,
						LEDG,
						LEDR
						);
	input OSC_50;   
	input [3:0] KEY;  
	output VGA_CLK,VGA_HS,VGA_VS,VGA_BLANK,VGA_SYNC;
	output [7:0] VGA_R,VGA_B,VGA_G;
	output [7:0] LEDG, LEDR;
	wire [7:0] LEDR, LEDG;

	//keycontrol    f = 5 Hz
	wire [1:0] control; // 00 - key0 01 - key1 10 key2 11 - nothing;
	key_reader instance_key(		//???
						OSC_50,
						OSC_main,
						KEY[3],
						KEY,
						control,
						LEDG[4],
						LEDG[5],
						LEDG[6]
						);

	wire [11:0] randomseed;
	randomseed_generator instance_rand(
						OSC_50,
						OSC_main,
						KEY[3],
						KEY,
						randomseed
						);	
	wire [5:0] random_x, random_y;
	find_a_new_apple newapple(			//50 hz
						OSC_50,
						OSC_main,
						KEY[3],
						cstate,
						csnake_x,
						csnake_y,
						capple_x,
						capple_y,
						randomseed,
						random_x,
						random_y
						);

	wire [1:0] nstate;
	wire [1:0] ndirection;
	wire [29:0] napple_x, napple_y;
	wire [599:0] nsnake_x, nsnake_y;//
	wire [99:0] nlength;
	wire [8:0] nscore;
	wire ngrow_flag;
	wire [8:0] ngrow_countdown;
	
	reg cgrow_flag;
	reg [8:0] cgrow_countdown;
	reg [1:0] cstate;
	reg [1:0] cdirection;
	reg [29:0] capple_x, capple_y;
	reg [599:0] csnake_x, csnake_y;//
	reg [99:0] clength;
	reg [8:0] cscore; 
	transformation instance_trans(   //combinational
						control,
						random_x,
						random_y,

						cstate,
						cdirection,
						capple_x,
						capple_y,
						csnake_x,
						csnake_y,
						cscore,
						clength,
						cgrow_flag,
						cgrow_countdown,

						nstate, 
						ndirection,
						napple_x,
						napple_y,
						nsnake_x,
						nsnake_y,
						nscore,
						nlength,
						ngrow_flag,
						ngrow_countdown
						);

	////////////////////////////////////////// FSM //////////////////////////////////

	reg [22:0] cnt;
	reg OSC_main;
	always @(posedge OSC_50 or negedge KEY[3])
  		begin
  			if(!KEY[3]) 
  				begin 
  					OSC_main <=0; 
  					cnt <= 0;
  				end
    		else 
    			begin
         			if(cnt==4999999)						//freq desider
           				begin 
           					OSC_main <= ~ OSC_main;
           					cnt <= 0;
           				end
           			else cnt <= cnt + 1;
         		end
  		end

  	always @(posedge OSC_main or negedge KEY[3])								// rst
  		begin
			if (!KEY[3])
				begin
					cstate <= 2'b00;// 00-start 01-game 10-end 11-win
					cdirection <= 2'b00; // 00up 01right 10left 11down
					capple_x <= {6'd16, 6'd16, 6'd32, 6'd48, 6'd48};
					capple_y <= {6'd12, 6'd36, 6'd12, 6'd12, 6'd36};
					csnake_x <= {{5{6'd32}}, {95{6'b000000}}};
					csnake_y <= {6'd25, 6'd26, 6'd27, 6'd28, 6'd29, {95{6'b000000}}};
					cscore <= 8'd0;
					clength <= {{95{1'b0}},5'b11111}; 
					cgrow_flag <= 0;
					cgrow_countdown <= 100;
				end
			else
				begin
					cstate <= nstate;
					cdirection <= ndirection;
					capple_x <= napple_x;
					capple_y <= napple_y;
					csnake_x <= nsnake_x;
					csnake_y <= nsnake_y;
					cscore <= nscore;
					clength <= nlength;
					cgrow_countdown <= ngrow_countdown;
					cgrow_flag <= ngrow_flag;
				end
		end

	///////////////////////////////////////////// FSM ////////////////////////////

	//driver of display   

	//display f = 25M Hz  quickly reaction
	//assign map = {	{64{1'b1}},{46{64'h8000000000000001}},{64{1'b1}}};
	wire [23:0] RGB;
	reg[7:0] VGA_R, VGA_G, VGA_B;
	always @(RGB)
	begin
		VGA_R = RGB[23:16];
		VGA_G = RGB[15:8];
		VGA_B = RGB[7:0];
	end	
	vga instance_vga(
						OSC_50,     
						csnake_x,
						csnake_y,
						capple_x,
						capple_y,
						RGB,
						VGA_HS,     
						VGA_VS,     
						VGA_BLANK,    
						VGA_SYNC,   
						VGA_CLK
						);
	////////////////////////////////////////////////////test use
	assign LEDR[0] = nstate[0];
	assign LEDR[1] = nstate[1];
	assign LEDR[2] = cstate[0];
	assign LEDR[3] = cstate[1];
	assign LEDR[4] = control[0];
	assign LEDR[5] = control[1];
	//assign LEDR[6] = 0;
	assign LEDR[7] = OSC_main;

	assign LEDG[0] = KEY[0];
	assign LEDG[1] = KEY[1];
	assign LEDG[2] = KEY[2];
	assign LEDG[3] = KEY[3];
	//assign LEDG[4] = 0;
	//assign LEDG[5] = 0;
	//assign LEDG[6] = 0;
	assign LEDG[7] = 0;

	////////////////////////////////////////////////////test use
	
endmodule