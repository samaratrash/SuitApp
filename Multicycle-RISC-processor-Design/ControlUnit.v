module ControlUnit(
    input clk,
    input [3:0] Op,
    input zero,
    input neg,
    input overflow,
    input mbit,
    output reg [1:0] PCSrc,
    output reg RegWr,
    output reg ExtOp,
    output reg ALUSrc,
    output reg MemRd,
    output reg [1:0] ALUOp,
    output reg MemWr,
    output reg WBdata,
    output reg SV_signal,
    output reg R7_RET,
    output reg R7_CALL,
    output reg LB,Pcen,enReg,enInst,ALUen
  
);

reg [4:0] operation;
//R type
parameter AND = 5'b00000;
parameter ADD = 5'b00010;
parameter SUB = 5'b00100;

//I type
parameter ADDI = 5'b00110;
parameter ANDI = 5'b01000;
parameter LW = 5'b01010;
parameter LBu = 5'b01100;
parameter LBs = 5'b01101;
parameter SW = 5'b01110;

//branch
parameter BGT = 5'b10000;
parameter BGTZ = 5'b10001;
parameter BLT = 5'b10010;
parameter BLTZ = 5'b10011;
parameter BEQ = 5'b10100;
parameter BEQZ = 5'b10101;
parameter BNE = 5'b10110;
parameter BNEZ = 5'b10111;

//J type
parameter JMP = 5'b11000;
parameter CALL = 5'b11010;
parameter RET = 5'b11100;

//S type
parameter SV = 5'b11110;
  
//stages	
parameter start = 0;
parameter RS = 1;
parameter IF = 2;
parameter ID = 3;
parameter EX = 4;
parameter MEM = 5;
parameter WB = 6; 	
  
reg [2:0] stage = start; // Register to track the pipeline stage
  
  always @(posedge clk) begin
        case (stage)
            start: begin
                // Resetall control signals
                Pcen=1'b0;
                ALUen<=1'b0;
                ALUOp = 2'b00;
                PCSrc = 2'b00;
                RegWr = 1'b0;
                ExtOp = 1'b0;
                ALUSrc = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                WBdata = 1'b0;
                SV_signal = 1'b0;
                R7_RET = 1'b0;
                R7_CALL = 1'b0;
                LB =1'b0;
                enInst<=1'b0;
                stage <= IF; // Initial stage transition to IF
              
            end
            
            RS: begin
            // Reset all control signals
                ALUen<=1'b0;
                ALUOp = 2'b00;
                RegWr = 1'b0;
                ExtOp = 1'b1;
                ALUSrc = 1'b0;
                MemRd = 1'b0;
                MemWr = 1'b0;
                WBdata = 1'b0;
                SV_signal = 1'b0;
                R7_RET = 1'b0;
                R7_CALL = 1'b0;
                LB =1'b0;
              case (Op)
                    4'b1000: begin // BGT & BGTZ
                      if (zero == 0 && neg == overflow ) begin
                            PCSrc <= 2'b10; // Branch taken
                        end else begin
                            PCSrc <= 2'b00; // Branch not taken
                        end
                    end
                    4'b1001: begin // BLT & BLTZ
                      if (zero == 0 && neg != overflow) begin
                            PCSrc <= 2'b10; // Branch taken
                        end else begin
                            PCSrc <= 2'b00; // Branch not taken
                        end
                    end
                    4'b1010: begin // BEQ & BEQZ
                      if (zero == 1) begin
                            PCSrc <= 2'b10; // Branch taken
                        end else begin
                            PCSrc <= 2'b00; // Branch not taken
                        end
                    end
                    4'b1011: begin // BNE & BNEZ
                      	if (zero == 0) begin
                            PCSrc <= 2'b10; // Branch taken
                        end else begin
                            PCSrc <= 2'b00; // Branch not taken
                        end
                    end
            endcase
              // Move to IF stage
              	#1 Pcen<=1'b1;
                enInst<=1'b0;
                stage <= IF;

            end       
            
            IF: begin
                enInst<=1'b1;
                Pcen<=1'b0;
                stage <= ID; // Move to ID stage
                enReg<=1'b1;
                ExtOp=1'b0;
              

            end
                
            ID: begin
                ALUen<=1'b0;
                enInst<=1'b0;
                enReg<=1'b0;
                Pcen<=1'b0;
                operation = {Op, 1'b0};
              	case(operation)
                	ADDI,LW,LBs,SW,BGT,BGTZ,BLT,BLTZ,BEQ,BEQZ,BNE,BNEZ,SV:
                  	ExtOp=1'b1;
              	endcase
                if (Op[3:0] == 4'b0110 || (Op[3:0] > 4'b0111 && Op[3:0] < 4'b1100)) begin
                    operation[0] = mbit;
                end
              if (operation == JMP)
                PCSrc <= 2'b01;
              else if(operation == RET)
                PCSrc <= 2'b11;
                
                
              case(operation)
                    AND, ADD, SUB, ADDI, ANDI, LW, LBu, LBs, SW, BGT, BGTZ, BLT, BLTZ, BEQ, BEQZ, BNE,
                BNEZ: 
                        stage <= EX; // Move to EX stage
                    JMP, RET: 
                        stage <= RS; // Move to RS stage
                SV:
                        stage <= MEM; // Move to MEM stage
                  CALL:begin
                    	WBdata = (Op == 4'b0101 || Op == 4'b0110);
                        stage <= WB; // Move to WB stage
                  end
  
                endcase	
                 
                  case (Op)
        4'b0000: ALUOp = 2'b00; // AND
        4'b0001: ALUOp = 2'b01; // ADD
        4'b0010: ALUOp = 2'b10; // SUB
        4'b0011: ALUOp = 2'b01; // ADDI (uses ADD)
        4'b0100: ALUOp = 2'b00; // ANDI (uses AND)
        4'b0101: ALUOp = 2'b01; // LW (uses ADD)
        4'b0110: ALUOp = 2'b01; // LBu & LBs (use ADD)
        4'b0111: ALUOp = 2'b01; // SW (uses ADD)
        4'b1000: ALUOp = 2'b10; // BGT & BGTZ (use SUB)
        4'b1001: ALUOp = 2'b10; // BLT & BLTZ (use SUB)
        4'b1010: ALUOp = 2'b10; // BEQ (uses SUB)
        4'b1011: ALUOp = 2'b10; // BNE & BNEZ (use SUB)
                  endcase
                
                // Control signal assignments

                ALUSrc = (Op == 4'b0100 || Op == 4'b0011 || Op == 4'b0101 || Op == 4'b0110 || Op == 4'b0111 );
                SV_signal = (Op == 4'b1111);
                R7_RET = (Op == 4'b1110);
                R7_CALL = (Op == 4'b1101);
                MemWr = (Op == 4'b1111);
                LB =(Op == 4'b0110);
            end
            
          EX: begin 
            

			case (operation)
				AND,ADD,SUB,ADDI,ANDI:begin
                  WBdata = (Op == 4'b0101 || Op == 4'b0110);
                  stage <= WB; // Move to WB stage after ALU operation
                end
				LW,LBu,LBs,SW:begin
                  stage <= MEM; // Move to MEM stage for memory access
                end
				BGT,BGTZ,BLT,BLTZ,BEQ,BEQZ,BNE,BNEZ:
                  stage <= RS; // Move to RS stage for branch resolution

			endcase
            ALUen<=1'b1;
            ExtOp=1'b1;


		end
      
           MEM: begin
             ALUen<=1'b0;
             ExtOp=1'b0;
             if (operation ==LBs )
            	ExtOp=1'b1;
                // Determine next stage based on operation
                case (operation)
                    LW, LBu, LBs:begin
                      	MemRd = (Op == 4'b0101 || Op == 4'b0110);
                      	WBdata = (Op == 4'b0101 || Op == 4'b0110);
                        stage <= WB; // Move to WB stage after load operation
                    end
                    SW, SV:begin
                      	MemWr = (Op == 4'b0111 || Op == 4'b1111);
                        PCSrc <= 2'b01;
                        stage <= RS; // Move to RS stage after store or system call
                    end
                endcase

            end
		
		WB: begin 	
          		ALUen <=1'b0;
          		ExtOp=1'b0;
          if (Op == 4'b1101)
            PCSrc <= 2'b01;
          else PCSrc <= 2'b00;
          		RegWr = (Op == 4'b0000 || Op == 4'b0001 || Op == 4'b0010 || Op == 4'b0011 || Op == 4'b0100 || Op == 4'b0101 || Op == 4'b0110 || Op == 4'b1101);
          		MemRd <=1'b0; 
                stage <= RS; // Move back to RS stage after write-back
  end
        endcase
    end
endmodule

// module ControlUnit_tb();

//     // Inputs
//     reg clk;
//     reg [3:0] Op;
//     reg zero;
//     reg neg;
//     reg overflow;
//     reg mbit;

//     // Outputs
//     wire [1:0] PCSrc;
//     wire RegWr;
//     wire ALUSrc;
//     wire MemRd;
//     wire [1:0] ALUOp;
//     wire MemWr;
//     wire WBdata;
//     wire SV_signal;
//     wire R7_RET;
//     wire R7_CALL;
//     wire LB;

//     // Instantiate the Unit Under Test (UUT)
//     ControlUnit uut (
//         .clk(clk), 
//         .Op(Op), 
//         .zero(zero), 
//         .neg(neg), 
//         .overflow(overflow), 
//         .mbit(mbit), 
//         .PCSrc(PCSrc), 
//         .RegWr(RegWr), 
//         .ExtOp(), // Adjust as per your module
//         .ALUSrc(ALUSrc), 
//         .MemRd(MemRd), 
//         .ALUOp(ALUOp), 
//         .MemWr(MemWr), 
//         .WBdata(WBdata), 
//         .SV_signal(SV_signal), 
//         .R7_RET(R7_RET), 
//         .R7_CALL(R7_CALL),
//         .LB(LB)
//     );

//     // Clock generation
//     always #1 clk = ~clk; 

//     initial begin
//         // Initialize Inputs
//         clk = 0;
//         Op = 4'b0000;
//         zero = 0;
//         neg = 0;
//         overflow = 0;
//         mbit = 0;

//         #100;

//         // Test case 1: AND
//         #100;
//         Op = 4'b0000;
//         $display("Op: %b", Op);
//         $display("PCSrc: %b, RegWr: %b, ALUSrc: %b, MemRd: %b, ALUOp: %b, MemWr: %b, WBdata: %b, SV_signal: %b, R7_RET: %b, R7_CALL: %b, LB: %b", 
//                  PCSrc, RegWr, ALUSrc, MemRd, ALUOp, MemWr, WBdata, SV_signal, R7_RET, R7_CALL, LB);

//         // Test case 2: ADDI
//         #100;
//         Op = 4'b0011;
//         $display("Op: %b", Op);
//         $display("PCSrc: %b, RegWr: %b, ALUSrc: %b, MemRd: %b, ALUOp: %b, MemWr: %b, WBdata: %b, SV_signal: %b, R7_RET: %b, R7_CALL: %b, LB: %b", 
//                  PCSrc, RegWr, ALUSrc, MemRd, ALUOp, MemWr, WBdata, SV_signal, R7_RET, R7_CALL, LB);

//         // Test case 3: LW
//         #200;
//         Op = 4'b0101;
//         $display("Op: %b", Op);
//         $display("PCSrc: %b, RegWr: %b, ALUSrc: %b, MemRd: %b, ALUOp: %b, MemWr: %b, WBdata: %b, SV_signal: %b, R7_RET: %b, R7_CALL: %b, LB: %b", 
//                  PCSrc, RegWr, ALUSrc, MemRd, ALUOp, MemWr, WBdata, SV_signal, R7_RET, R7_CALL, LB);

//         // Test case 4: BGT
//         #200;
//         Op = 4'b1000;
//         zero = 0;
//         neg = 0;
//         overflow = 0;
//         $display("Op: %b, zero: %b, neg: %b, overflow: %b", Op, zero, neg, overflow);
//         $display("PCSrc: %b, RegWr: %b, ALUSrc: %b, MemRd: %b, ALUOp: %b, MemWr: %b, WBdata: %b, SV_signal: %b, R7_RET: %b, R7_CALL: %b, LB: %b", 
//                  PCSrc, RegWr, ALUSrc, MemRd, ALUOp, MemWr, WBdata, SV_signal, R7_RET, R7_CALL, LB);

//         // Test case 5: CALL
//         #100;
//         Op = 4'b1101;
//         $display("Op: %b", Op);
//         $display("PCSrc: %b, RegWr: %b, ALUSrc: %b, MemRd: %b, ALUOp: %b, MemWr: %b, WBdata: %b, SV_signal: %b, R7_RET: %b, R7_CALL: %b, LB: %b", 
//                  PCSrc, RegWr, ALUSrc, MemRd, ALUOp, MemWr, WBdata, SV_signal, R7_RET, R7_CALL, LB);

//         // Test case 6: RET
//         #50;
//         Op = 4'b1110;
//         $display("Op: %b", Op);
//         $display("PCSrc: %b, RegWr: %b, ALUSrc: %b, MemRd: %b, ALUOp: %b, MemWr: %b, WBdata: %b, SV_signal: %b, R7_RET: %b, R7_CALL: %b, LB: %b", 
//                  PCSrc, RegWr, ALUSrc, MemRd, ALUOp, MemWr, WBdata, SV_signal, R7_RET, R7_CALL, LB);

//         // Finish simulation
//         $finish;
//     end

// endmodule





