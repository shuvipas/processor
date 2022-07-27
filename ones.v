module ones(input wire [8:0] Rx,
				 output reg [8:0] num_of_1);
				 integer i;
				 always @(Rx)
					 begin
					 	 num_of_1 = 8'b0;
					
							 for(i=0; i<9; i=i+1)
								if(Rx[i]==1'b1)
									num_of_1 = num_of_1 + 8'b1;
							
					end
endmodule
				 