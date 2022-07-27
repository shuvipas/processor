module proc (DIN, Resetn, Clock, Run, Done, BusWires); 
					input wire [8:0] DIN;
					input wire Resetn, Clock, Run;
					output reg Done;
					output wire [8:0] BusWires;
				

					parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
					
					reg [1:0] Tstep_Q;//cs
					reg [1:0] Tstep_D;//ns
					wire [2:0] I;//instruction
					wire [7:0] Xreg;// en the reg that we write to
					wire [7:0] Yreg;
					
					//the register enablers
					reg [7:0] Rin; 
				   reg IRin, Ain, Gin, add_sub, O_in; 	
					
					//the mux selectors
					reg DIn_out, Gout, ones_out;
					reg [8:0] Rout;
					
					//the input to the mux
					wire [8:0] R0;
					wire [8:0] R1;
					wire [8:0] R2;
					wire [8:0] R3;
					wire [8:0] R4;
					wire [8:0] R5;
					wire [8:0] R6;
					wire [8:0] R7;
					wire [8:0] ones;
					wire [8:0] G;
					wire [8:0] num_of_1;//output of ones
					
					
					//internal wires for reg usage
					wire [8:0] A;//input to the addsub
					wire [8:0] IR;// the instruction that is being executed (the IR reg)
					wire [8:0] Alu_G;//wire between addsub and G
								
									
					assign I = IR[8:6];
					dec3to8 decX (IR[5:3], 1'b1, Xreg); 
					dec3to8 decY (IR[2:0], 1'b1, Yreg);

					
					// Control FSM flip-flops 
					always @(posedge Clock, negedge Resetn)
						begin
						if (!Resetn) 
							begin
								Tstep_Q <= T0;
							end
						else
							begin
								Tstep_Q <= Tstep_D;
							end
						end
					

					// Control FSM state table
					always @(Tstep_Q, Run, Done)
						begin
						case (Tstep_Q)
							T0: // data is loaded into IR in this time step
								if (~Run)
									Tstep_D = T0;
								else
									begin
									Tstep_D = T1;
									end
							T1:
							begin
						      
								if(Done)
									Tstep_D = T0;
								else
									Tstep_D = T2;
							end
							T2:
								if(Done)
									Tstep_D = T0;
								else
									Tstep_D = T3;
							T3:
							   Tstep_D = T0;
						endcase
						end
					


					// Control FSM outputs 
						always @(Tstep_Q or I or Xreg or Yreg)
						begin
								Rin <= 8'b0;
								Ain <= 1'b0;
								Gin <= 1'b0;
								Rout <= 9'b0;
								DIn_out <= 1'b0;
								Gout <= 1'b0;
								add_sub <= 1'b0;
								Done <= 1'b0;
								O_in <= 1'b0;
								ones_out <= 1'b0;
								
						
						case (Tstep_Q) 
								T0: begin  // store DIN in IR in time step 0 begin
										IRin <= 1'b1;//en for register IR
									 end
								
								T1: //define signals in time step 1 
									begin
									IRin <= 1'b0;//closes the instruction reg
									
									case (I)
											3'b000:
													begin
													Rin <= Xreg;
													Rout <= Yreg;
													Done <= 1'b1;
													end
											3'b001:
													 begin
													 Rin <= Xreg;
													 DIn_out <= 1'b1;
													 Done <= 1'b1;
													 end
											3'b010:
													 begin
													 Rout <= Xreg;
													 Ain <= 1'b1;
													 end
											3'b011:
													 begin
													 Rout <= Xreg;
													 Ain <= 1'b1;
													 end
											3'b100:
													 begin
													 Rout <= Xreg;
													 O_in <= 1'b1; 
													 end
									endcase
								
								end
								
								T2: //define signals in time step 2 
									case (I)
											3'b010:
													begin
													Rout <= Yreg;
													Gin <= 1'b1;
													end
											3'b011:
													begin
													Rout <= Yreg;
													Gin <= 1'b1;
													add_sub <= 1'b1;
													end
											3'b100:
													begin
													Rin <= Yreg;
													ones_out <= 1'b1;
													Done <= 1'b1;
													end
									endcase
								
								T3: //define signals in time step 3
									case (I)
											3'b010:
													begin
													Gout <= 1'b1;
													Rin <= Xreg;
													Done <= 1'b1;
													end
											3'b011:
													begin
													Gout <= 1'b1;
													Rin <= Xreg;
													Done <= 1'b1;
													end
									endcase
						
						endcase
					end


					
					regn reg_0 (BusWires, Rin[0], Clock, R0);
					regn reg_1 (BusWires, Rin[1], Clock, R1);
					regn reg_2 (BusWires, Rin[2], Clock, R2);
					regn reg_3 (BusWires, Rin[3], Clock, R3);
					regn reg_4 (BusWires, Rin[4], Clock, R4);
					regn reg_5 (BusWires, Rin[5], Clock, R5);
					regn reg_6 (BusWires, Rin[6], Clock, R6);
					regn reg_7 (BusWires, Rin[7], Clock, R7);
	
					regn reg_A (BusWires, Ain, Clock, A);
					regn reg_G (Alu_G, Gin, Clock, G);
					regn reg_IR (DIN, IRin, Clock, IR);
					regn reg_ones (num_of_1, O_in, Clock, ones);
					
					AddSub alu(.regA(A), .Bus(BusWires), .add_sub(add_sub), .regG(Alu_G));
					mux_eleven2one mux(DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, ones, Rout,
												Gout, DIn_out, ones_out, BusWires);
					ones ones1(.Rx(BusWires), .num_of_1(num_of_1));
					 

endmodule
