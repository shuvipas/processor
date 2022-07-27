module mux_eleven2one(
                   input wire [8:0] DIn,
						 input wire [8:0]R0,
						 input wire [8:0]R1,
						 input wire [8:0]R2,
						 input wire [8:0]R3,
						 input wire [8:0]R4,
						 input wire [8:0]R5,
						 input wire [8:0]R6,
						 input wire [8:0]R7,
						 input wire [8:0]G,
						 input wire [8:0]ones,
						 
						 input wire [7:0]Rout,
						 input wire Gout,
						 input wire DIn_out,
						 input wire ones_out,
						 
						 output reg [8:0] Bus
						 );

	
						always  @(Rout, Gout, DIn_out)
						begin
							if(Gout)
								Bus = G;
							
							else if (DIn_out)
						      Bus = DIn;	
							
							else if (ones_out)
									Bus = ones;
							else 
								begin
								case(Rout)
									8'b00000001: Bus = R0;
									8'b00000010: Bus = R1;
									8'b00000100: Bus = R2;
									8'b00001000: Bus = R3;
									8'b00010000: Bus = R4;
									8'b00100000: Bus = R5;
									8'b01000000: Bus = R6;
									8'b10000000: Bus = R7;
									endcase
								end
						end
				
endmodule		
								
						 
						 
						 