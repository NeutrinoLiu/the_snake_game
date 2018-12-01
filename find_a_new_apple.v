module find_a_new_apple(
						OSC_50,
						OSC,
						rst,  //useless
						cstate,
						//map,
			snake_x,
			snake_y,
			apple_x,
			apple_y,

						randomseed,
						random_x,
						random_y
						);
	input OSC_50, rst, OSC;
	input [1:0] cstate;
	//input [64*48-1:0] map;



input [599:0] snake_x, snake_y;
input [29:0] apple_x, apple_y;

	input [11:0] randomseed;
	output [5:0] random_x, random_y;
	
	reg [5:0] x, y, px = 0, py = 0, random_x, random_y;
			
  	reg [11:0] addr;
  	always @(x or y)
  		begin
  			addr = {y[5],y[4],y[3],y[2],y[1],y[0],x[5],x[4],x[3],x[2],x[1],x[0]} -12'h001;
  			px[0] = addr[0];
  			px[1] = addr[1];
  			px[2] = addr[2];
  			px[3] = addr[3];
  			px[4] = addr[4];
   		px[5] = addr[5];
  			py[0] = addr[6];
  			py[1] = addr[7];
  			py[2] = addr[8];
   		py[3] = addr[9];
  			py[4] = addr[10];
  			py[5] = addr[11];
  		end
		
  	reg [11:0] seedcnt;
  	always @(posedge OSC or negedge rst)
  		begin
			if (!rst)
				begin	
					random_x <= 1;
					random_y <= 1;
				end
			else
				begin
					random_x <= px;
					random_y <= py;
				end;
  		end
		
	/*reg flag;
	always @(seed)
		begin	
			flag = (seed != 0);
		end*/
 
	always @(posedge OSC_50 or posedge OSC)
  		begin
		
			if (OSC)										//					@@@@@@@@@@@       MAYBE UNSECURE       @@@@@@@@@@@@
				
				begin
					x <= 0;
					y <= 0;
				end
				
			else 
			begin
			
				if (seedcnt < randomseed) 
					begin
					
						if (x!=63)
							begin
								x <= x + 1;
								y <= y;
							end
						else 
							begin
								x <= 0;
								if (y!=47) 
									y <= y + 1;
								else y <= 0;
							end
							
					end
					
				else 
					begin
						x <= x;
						y <= y;
					end
			end
			
  		end

	wire answer;
	inquiry q2(
			snake_x,
			snake_y,
			apple_x,
			apple_y,
			x,
			y,
			answer
			);



	always @(posedge OSC_50 or posedge OSC)
  		begin
		
			if (OSC)										//					@@@@@@@@@@@       MAYBE UNSECURE       @@@@@@@@@@@@
				seedcnt <= 0;
			else 
				seedcnt <= seedcnt + ((seedcnt < randomseed && ~ answer)?1'b1:1'b0);		
			
  		end
		
 endmodule 
 