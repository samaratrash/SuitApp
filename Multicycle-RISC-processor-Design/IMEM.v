module IMEM (
  input [15:0] pc,    
  input enInst,
  output reg [15:0] instruction  
);

  // Define a memory array to hold instructions (byte-addressable, size 64 bytes, Little endian)
  reg [7:0] mem[63:0];	

  parameter AND  = 4'b0000;
  parameter ADD  = 4'b0001;
  parameter SUB  = 4'b0010;

  // I type
  parameter ADDI = 4'b0011;
  parameter ANDI = 4'b0100;
  parameter LW   = 4'b0101;
  parameter LBu  = 4'b0110;
  parameter LBs  = 4'b0110;
  parameter SW   = 4'b0111;

  // Branch
  parameter BGT  = 4'b1000;
  parameter BGTZ = 4'b1000;
  parameter BLT  = 4'b1001;
  parameter BLTZ = 4'b1001;
  parameter BEQ  = 4'b1010;
  parameter BEQZ = 4'b1010;
  parameter BNE  = 4'b1011;
  parameter BNEZ = 4'b1011;

  // J type
  parameter JMP  = 4'b1100;
  parameter CALL = 4'b1101;
  parameter RET  = 4'b1110;

  // S type
  parameter Sv   = 4'b1111;

//   // CODE 1 :
// initial begin
//     // Initialize the memory with the instruction set in little-endian format
//     mem[0]  = 8'h05; mem[1]  = 8'h31;  // ADDI R1, R0, 5; R1 = 0 + 5 = 5 
//     mem[2]  = 8'h00; mem[3]  = 8'h52;  // LW R2, R0, 0; R2 = MEM[0 + 2] = 7 
//     mem[4]  = 8'h88; mem[5]  = 8'h24;  // SUB R2,R2,R1; R2=R2-R1
//     mem[6]  = 8'h02; mem[7]  = 8'h6B;  // LBs R3, R0, 2; R3 = MEM[R0 + 2]  
//     mem[8]  = 8'hD0; mem[9]  = 8'h16;  // ADD R3, R3, R2
//     mem[10] = 8'h03; mem[11] = 8'h73;  // SW R3, R0, 3;mem[R0 + 3] = R3
//   end
     // CODE 2 :
  initial begin
    mem[0]  = 8'h05; mem[1]  = 8'h31;  // ADDI R1, R0, 5; R1 = 0 + 5 = 5 
    mem[2]  = 8'h06; mem[3]  = 8'h32;  // ADDI R2, R0, 6; R2 = 0 + 6 = 6 
    mem[4]  = 8'h88; mem[5]  = 8'h24;  // SUB R2,R2,R1; R2=R2-R1
    mem[6]  = 8'h1E; mem[7]  = 8'h8A;  // BGTZ R2, R0, -2; if (R2 > R1) pc <= pc + -2 
    mem[8]  = 8'h0C; mem[9]  = 8'hD0;  // CALL 12; pc <= pc[15:12] || 12
    mem[10] = 8'h68; mem[11] = 8'hF4;  // SV R2,100; mem[R2] = 52;
    mem[12] = 8'h49; mem[13] = 8'h32;  // ADDI R2, R2, 1
    mem[14] = 8'h5E; mem[15] = 8'hB1;  // BNE R1, R2,-2; if (R1 != R2) pc <= pc + -2
    mem[16] = 8'h00; mem[17] = 8'hE0;  //RET 0; return
    
  end
  
  
  

  // Read the instruction from memory (2 consecutive 8-bit cells form a 16-bit instruction)
always @(*) begin
    if (enInst) begin
      instruction <= {mem[pc + 1], mem[pc]};
    end
end
endmodule


// module tb_IMEM;
//     reg [15:0] pc;          
//     reg enInst;            
//     wire [15:0] instruction; 
//     IMEM uut (
//         .pc(pc),
//         .enInst(enInst),
//         .instruction(instruction)
//     );

//     initial begin
//         // Monitor the signals
//         $monitor("PC = %d, Instruction = %h", pc, instruction);

//         enInst = 1;

//         // Run through a few test cases
//         pc = 0;
//         #10;
        
//         pc = 2;
//         #10;
        
//         pc = 4;
//         #10;
        
//         pc = 6;
//         #10;
        
//         pc = 8;
//         #10;
        
//         pc = 10;
//         #10;
        
//         pc = 12;
//         #10;
        
//         pc = 14;
//         #10;
        
//         pc = 16;
//         #10;
        
        
//         $finish;
//     end
// endmodule
