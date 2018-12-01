module key_reader(
						OSC_50,
						OSC,
						rst,
						KEY,
						control,
						t0,
						t1,
						t2
						);
	input OSC_50;
	input OSC;
	input rst;
	input [3:0] KEY;
	output [1:0] control;
	
	/////////TEST
	output  t0, t1, t2;
	reg t0, t1, t2;
	always @(flag0 or flag1 or flag2)
		begin
			t0 = flag0;
			t1 = flag1;
			t2 = flag2;
		end
	///////TEST
	
	reg [1:0] control;
	reg  flag2, flag1, flag0;
	
	reg OSC_double;
	always @(posedge OSC or negedge rst)
		begin	
			if (!rst)
				begin
					OSC_double <= 0;
				end
			else
					OSC_double <= ~ OSC_double;
		end
		
  	always @(posedge OSC or negedge rst)
  		begin
			if (!rst)
				begin
					control <= 3;
				end
			else
  			  	begin
					
					if (flag0) control <= 2'b00;
					else if (flag1) control <= 2'b01;
					else if (flag2) control <= 2'b10;
					else control <= 2'b11;
					
				end
		end
		
  	always @(posedge OSC_50 or posedge OSC_double)
  		begin
		
			if (OSC_double) flag0 <= 0;
			else
  			  	begin
					if (!KEY[0]) flag0 <= 1;
					else flag0 <= flag0;
				end
				
  		end

	always @(posedge OSC_50 or posedge OSC_double)
  		begin
		
			if (OSC_double) flag1 <= 0;
			else
  			  	begin
					if (!KEY[1]) flag1 <= 1;
					else flag1 <= flag1;
				end
				
  		end
  	always @(posedge OSC_50 or posedge OSC_double)
  		begin
		
			if (OSC_double) flag2 <= 0;
			else
  			  	begin
					if (!KEY[2]) flag2 <= 1;
					else flag2 <= flag2;
				end
				
  		end
		
endmodule
