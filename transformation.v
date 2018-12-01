module transformation(
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
	input [5:0] random_x, random_y;
	input [1:0] control;
	input [1:0] cstate;
	input [1:0] cdirection;
	input [29:0] capple_x, capple_y;
	input [599:0] csnake_x, csnake_y;
	input [8:0] cscore;
	input [99:0] clength;
	input cgrow_flag;
	input [8:0] cgrow_countdown;

	output [1:0] nstate;
	output [1:0] ndirection;//
	output [29:0] napple_x, napple_y;//
	output [599:0] nsnake_x, nsnake_y;//
	output [99:0]  nlength;//
	output [8:0] nscore;
	output ngrow_flag;
	output [8:0] ngrow_countdown; 

	reg [1:0] nstate;
	reg [1:0] ndirection;
	reg [29:0] napple_x, napple_y;
	reg [599:0] nsnake_x, nsnake_y;//
	reg [99:0] nlength;
	reg [8:0] nscore;
	reg ngrow_flag;
	reg [8:0] ngrow_countdown;
	reg deadjudge;
	reg winjudge;
	
	reg [5:0] head_x, head_y;
	reg [599:0] nsnake_x_temp, nsnake_y_temp;
always @(nsnake_x_temp or nsnake_y_temp or nlength)
	begin
		integer i;
		for (i=0;i<=99;i=i+1)
			begin
				nsnake_x[(99-i)*6] = nsnake_x_temp[(99-i)*6] && nlength[i];
				nsnake_x[(99-i)*6+1] = nsnake_x_temp[(99-i)*6+1] && nlength[i];
				nsnake_x[(99-i)*6+2] = nsnake_x_temp[(99-i)*6+2] && nlength[i];
				nsnake_x[(99-i)*6+3] = nsnake_x_temp[(99-i)*6+3] && nlength[i];
				nsnake_x[(99-i)*6+4] = nsnake_x_temp[(99-i)*6+4] && nlength[i];
				nsnake_x[(99-i)*6+5] = nsnake_x_temp[(99-i)*6+5] && nlength[i];
				nsnake_y[(99-i)*6] = nsnake_y_temp[(99-i)*6] && nlength[i];
				nsnake_y[(99-i)*6+1] = nsnake_y_temp[(99-i)*6+1] && nlength[i];
				nsnake_y[(99-i)*6+2] = nsnake_y_temp[(99-i)*6+2] && nlength[i];
				nsnake_y[(99-i)*6+3] = nsnake_y_temp[(99-i)*6+3] && nlength[i];
				nsnake_y[(99-i)*6+4] = nsnake_y_temp[(99-i)*6+4] && nlength[i];
				nsnake_y[(99-i)*6+5] = nsnake_y_temp[(99-i)*6+5] && nlength[i];
			end
	end
/*
always @(cstate or cgrow_flag or cgrow_countdown)
	begin	
		if (cstate==2'd1)
			begin
				
				if (nscore != cscore)
					begin
						ngrow_flag = 1;
						ngrow_countdown = cscore;
						nlength = clength;
					end
				else
				
				if (cgrow_flag)
					begin	
						if (cgrow_countdown != 0)
							begin
								ngrow_flag = 1;
								ngrow_countdown = cgrow_countdown -1;
								nlength = clength;
							end
						else
							begin
								ngrow_flag = 0;
								ngrow_countdown = 100;
								nlength = clength*2+1;
							end
					end
				else
					begin
						ngrow_flag = 0;
						ngrow_countdown = 100;
						nlength = clength;
					end
			
			end
			
			else
				if (nstate == 2'd1)
					begin
						ngrow_flag = 0;
						ngrow_countdown = 100;
						nlength =  {{95{1'b0}},5'b11111};
					end
				else
					begin
						nlength = {100{1'b1}};
						ngrow_flag = 0;
						ngrow_countdown =100;
					end
	end
*/

	reg [5:0] head_x0, head_y0;
always @(csnake_x or csnake_y or cstate or clength or cdirection or nstate) //snake position fresh; combinational
	begin
		
		if (cstate==2'd1)
		begin
			case (cdirection)
				2'b00: 
					begin
						head_x0 = csnake_x[599:594] ;
						head_y0 = csnake_y[599:594] - 6'b000001;
					end
				2'b01:
					begin
						head_x0 = csnake_x[599:594] + 6'b000001;
						head_y0 = csnake_y[599:594];
					end
				2'b10:
					begin
						head_x0 = csnake_x[599:594];
						head_y0 = csnake_y[599:594] + 6'b000001;
					end
				2'b11:
					begin
						head_x0 = csnake_x[599:594] - 6'b000001;
						head_y0 = csnake_y[599:594];
					end
			endcase
			nsnake_x_temp = {head_x0, csnake_x[100*6 - 1:6]}; //   				$$$$$$$$$$$$$$$$$$	WAIT TO BE SOLVED   $$$$$$$$$$$$$$$$$$$$
			nsnake_y_temp = {head_y0, csnake_y[100*6 - 1:6]}; //
		end
		else 

		begin
			nsnake_x_temp = {{5{6'd32}}, {95{6'b000000}}};
			nsnake_y_temp = {6'd25, 6'd26, 6'd27, 6'd28, 6'd29, {95{6'b000000}}};
		end

	end

always @(cstate or control or cdirection) 
	begin
		if (cstate==2'd1)
		begin
			/*if (cdirection == 2'b10) 
				begin
					case (control)
						2'b01: ndirection = 2'b01;
						2'b10: ndirection = 2'b11;
						default: ndirection = 2'b10;
					endcase
				end 
			else*/
			if (control == 2'b01) ndirection = cdirection + 2'b01;
			else if (control == 2'b10 ) 
				begin
					if (cdirection == 2'b00) ndirection = 2'b11;
					else ndirection = cdirection - 1'b1;
				end
			else ndirection = cdirection;
		end
		else ndirection = 2'b00;
	end


		reg [5:0] 	a0_x,
					a1_x,
					a2_x,
					a3_x,
					a4_x;
		reg [5:0] 	a0_y,
					a1_y,
					a2_y,
					a3_y,
					a4_y;

always @(nsnake_x or nsnake_y)
	begin			
		head_x = nsnake_x[599:594];
		head_y = nsnake_y[599:594];
	end	
always @(nsnake_x or nsnake_y or capple_x or capple_y or cscore or random_x or random_y or cstate or nstate or cscore) 
	begin
		

		a0_x = capple_x[5:0];
		a1_x = capple_x[11:6];
		a2_x = capple_x[17:12];
		a3_x = capple_x[23:18];
		a4_x = capple_x[29:24];
		a0_y = capple_y[5:0];
		a1_y = capple_y[11:6];
		a2_y = capple_y[17:12];
		a3_y = capple_y[23:18];
		a4_y = capple_y[29:24];		
		
	if (cstate == 1'd1) 
	begin
		if (head_x == a0_x && head_y == a0_y)
			begin
				napple_x = {random_x, capple_x[29:6]};
				napple_y = {random_y, capple_y[29:6]};
				nscore = cscore +1'b1;
				ngrow_flag = 1;
				ngrow_countdown = cscore + 5;
				nlength = clength;
			end			
		else 	
		if (head_x == a1_x && head_y== a1_y)
			begin
				napple_x = {capple_x[5:0], random_x, capple_x[29:12]};
				napple_y = {capple_y[5:0], random_y, capple_y[29:12]};
				nscore = cscore +1'b1;
				ngrow_flag = 1;
				ngrow_countdown = cscore + 5;
				nlength = clength;
			end			
		else 
		if (head_x == a2_x && head_y == a2_y)
			begin
				napple_x = {capple_x[11:0], random_x, capple_x[29:18]};
				napple_y = {capple_y[11:0], random_y, capple_y[29:18]};
				nscore = cscore +1'b1;
				ngrow_flag = 1;
				ngrow_countdown = cscore + 5;				
				nlength = clength;
			end			
		else
		if  (head_x == a3_x && head_y == a3_y)
			begin
				napple_x = {capple_x[17:0], random_x, capple_x[29:24]};
				napple_y = {capple_y[17:0], random_y, capple_y[29:24]};
				nscore = cscore +1'b1;
				ngrow_flag = 1;
				ngrow_countdown = cscore + 5;
				nlength = clength;
			end			
		else 
		if  (head_x == a4_x && head_y == a4_y)
			begin
				napple_x = {capple_x[23:0], random_x};
				napple_y = {capple_y[23:0], random_y};
				nscore = cscore +1'b1;
				ngrow_flag = 1;
				ngrow_countdown = cscore + 5;
				nlength = clength;

			end			
		else 
			begin
				napple_x = capple_x;
				napple_y = capple_y;
				nscore = cscore;
				
				if (cgrow_flag)
					begin	
						if (cgrow_countdown != 0)
							begin
								ngrow_flag = 1;
								ngrow_countdown = cgrow_countdown -1;
								nlength = clength;
							end
						else
							begin
								ngrow_flag = 0;
								ngrow_countdown = 100;
								nlength = clength*2+1;
							end
					end
				else
					begin
						ngrow_flag = 0;
						ngrow_countdown = 100;
						nlength = clength;
					end
					
			end
	end
	else 

			begin
					napple_x = {6'd16, 6'd16, 6'd32, 6'd48, 6'd48};
					napple_y = {6'd12, 6'd36, 6'd12, 6'd12, 6'd36};
					nscore = 8'd0;
					ngrow_countdown = 100;
					ngrow_flag = 0;
					nlength =  {{95{1'b0}},5'b11111};
			end

	end

	wire answer;
inquiry_snake q3(
					nsnake_x,
					nsnake_y,
					head_x,
					head_y,
					answer
					);
					
always @(cstate or control or deadjudge or winjudge)
	case (cstate)
		2'd0:
			begin
				if (control==2'b00) nstate = 2'd1;
				else nstate = 2'd0;
			end
		2'd1:
			begin
				if (deadjudge) nstate = 2'd2;
				else if (winjudge) nstate = 2'd3;
				else nstate = 2'd1;
			end
		2'd2:
			begin
				if (control==2'b00) nstate = 2'd1;
				else nstate = 2'd2;
			end
		2'd3:
			begin
				if (control==2'b00) nstate = 2'd1;
				else nstate = 2'd3;
			end
	endcase

always @(nsnake_x or nsnake_y or answer) 
	begin

		head_x = nsnake_x[599:594];
		head_y = nsnake_y[599:594];
		if ((head_x>=1 && head_x<=61 && head_y>=1 && head_y<=46) && (! answer))
				deadjudge = 1'b0;
		else 	deadjudge = 1'b1;
	end


always @(cscore) 
	begin
		if (cscore == 8'd100)
				winjudge = 1'b1;
		else 	winjudge = 1'b0;
	end

endmodule