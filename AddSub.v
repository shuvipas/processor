module AddSub(
              input wire [8:0] regA,
				  input wire [8:0] Bus,
				  input wire add_sub, //0 for add, 1 for sub
				  output reg [8:0] regG
				  );
					
					always @(regA)
						begin
					   if (~add_sub)
							regG <= regA + Bus;
						else
							regG <= regA - Bus;
						end
endmodule

				  