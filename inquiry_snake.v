module inquiry_snake(
					snake_x,
					snake_y,
					x,
					y,
					answer		
					);
	
	input [599:0] snake_x, snake_y;
	input [5:0] x, y;
	output answer;

	reg answer;
	reg [99:1] candidate;
	always @(x or y or ax or ay)
		begin
			integer i;
			if  ((x == 0)||(x >= 63)||(y == 0)||(y >= 47)) 
				candidate = 1;
			else 
				begin
					for (i=1; i<=99; i=i+1)
						candidate[i] = ((ay[i] == y)&&(ax[i] == x))?1'b1:1'b0;
				end
		end

	always @(candidate)
		begin
			if (!candidate) answer = 0;
			else answer = 1;
		end


	reg [5:0] ax[0:199];
	
	reg [5:0] ay[0:199];

	always @(snake_x or snake_y)
		begin
			integer j;

			for (j=1; j<=99; j=j+1)
				begin
					ay[j] = {snake_y[(99-j)*6 + 5], snake_y[(99-j)*6 + 4], snake_y[(99-j)*6 + 3], snake_y[(99-j)*6 + 2], snake_y[(99-j)*6 + 1], snake_y[(99-j)*6]};
					ax[j] = {snake_x[(99-j)*6 + 5], snake_x[(99-j)*6 + 4], snake_x[(99-j)*6 + 3], snake_x[(99-j)*6 + 2], snake_x[(99-j)*6 + 1], snake_x[(99-j)*6]}; 
					//address[j+5] = {snake_y[j*6 ], snake_y[j*6 +1 ], snake_y[j*6 +2 ], snake_y[j*6 + 3 ], snake_y[j*6 +4 ], snake_y[j*6 +5 ]} * 64 + {snake_x[j ], snake_x[j*6 + 1], snake_x[j*6 + 2], snake_x[j*6 + 3], snake_x[j*6 + 4 ], snake_x[j*6 +5]} ; 

				end
		end
endmodule