module inquiry(
					snake_x,
					snake_y,
					apple_x,
					apple_y,
					x,
					y,
					answer		
					);
	
	input [599:0] snake_x, snake_y;
	input [29:0] apple_x, apple_y;
	input [5:0] x, y;
	output answer;

	reg answer;
	reg [104:0] candidate;
	always @(x or y or ax or ay)
		begin
			integer i;
			if  ((x == 0)||(x >= 63)||(y == 0)||(y >= 47)) 
				candidate = 1;
			else 
				begin
					for (i=0; i<=104; i=i+1)
						candidate[i] = ((ay[i] == y)&&(ax[i] == x))?1'b1:1'b0;
				end
		end

	always @(candidate)
		begin
			if (!candidate) answer = 0;
			else answer = 1;
		end


	reg [5:0] ax[0:104];
	
	reg [5:0] ay[0:104];

	always @(apple_x or apple_y or snake_x or snake_y)
		begin
			integer i;
			integer j;
			for (i=0; i<=4; i=i+1)
				begin
					ay[i] = {apple_y[i*6 + 5], apple_y[i*6 + 4], apple_y[i*6 + 3], apple_y[i*6 + 2], apple_y[i*6 + 1], apple_y[i*6]};
					ax[i] = {apple_x[i*6 + 5], apple_x[i*6 + 4], apple_x[i*6 + 3], apple_x[i*6 + 2], apple_x[i*6 + 1], apple_x[i*6]};
				end
			for (j=0; j<=99; j=j+1)
				begin
					ay[j+5] = {snake_y[(99-j)*6 + 5], snake_y[(99-j)*6 + 4], snake_y[(99-j)*6 + 3], snake_y[(99-j)*6 + 2], snake_y[(99-j)*6 + 1], snake_y[(99-j)*6]};
					ax[j+5] = {snake_x[(99-j)*6 + 5], snake_x[(99-j)*6 + 4], snake_x[(99-j)*6 + 3], snake_x[(99-j)*6 + 2], snake_x[(99-j)*6 + 1], snake_x[(99-j)*6]}; 
					//address[j+5] = {snake_y[j*6 ], snake_y[j*6 +1 ], snake_y[j*6 +2 ], snake_y[j*6 + 3 ], snake_y[j*6 +4 ], snake_y[j*6 +5 ]} * 64 + {snake_x[j ], snake_x[j*6 + 1], snake_x[j*6 + 2], snake_x[j*6 + 3], snake_x[j*6 + 4 ], snake_x[j*6 +5]} ; 

				end
		end
endmodule