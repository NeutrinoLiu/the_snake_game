module randomseed_generator(
            OSC_50,
            OSC,
            rst,
            KEY,
            randomseed
            );

  input OSC_50, OSC, rst;
  input [3:0] KEY;
  output [11:0] randomseed;

  reg [11:0] randomseed, sampling;
  reg [11:0] shaker;
	// random seed generator
  always @(negedge KEY[0] or negedge KEY[1] or negedge KEY[2]) 
  		begin
  			sampling <= shaker;
  		end

  always @(posedge OSC or negedge rst)
    begin
      if (!rst)
        randomseed <= 3535;
      else begin
        randomseed <= sampling;
      end
    end
  		
	always @(posedge OSC_50 or negedge rst)
  		begin
  			if(!rst) 
  				begin 
  					shaker <= 0;
  				end
    		else 
    			begin
         			if(shaker==3989)						//any prime number
           				begin 
           					shaker <= 0;
           				end
           			else shaker <= shaker + 1;
         		end
  		end
endmodule