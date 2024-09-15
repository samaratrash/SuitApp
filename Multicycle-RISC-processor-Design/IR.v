module IR (
    input [15:0] InstrIn,     
    output reg [3:0] Opcode, 
    output reg [2:0] RW,     
    output reg [2:0] RA,     
    output reg [2:0] RB,     
    output reg Mode,          
    output reg [4:0] Imm5,    
    output reg [7:0] Imm8,    
    output reg [11:0] Jump_Offset,
    output reg [2:0] Unused   
);

    // Always block to update outputs whenever the instruction input changes
    always @(*) begin
        Opcode = InstrIn[15:12]; 
        
        // Default assignments to avoid latches
        RW = 3'b0;
        RA = 3'b0;
        RB = 3'b0;
        Mode = 1'b0;
        Imm5 = 5'b0;
        Imm8 = 8'b0;
        Jump_Offset = 12'b0;
        Unused = 3'b0;

        // Decode instruction based on Opcode using if-else statements
        if (Opcode == 4'b0000 || Opcode == 4'b0001 || Opcode == 4'b0010) begin
            // R-Type instruction
            RW     <= InstrIn[11:9];
            RA    <= InstrIn[8:6];
            RB    <= InstrIn[5:3];
            Unused <= InstrIn[2:0];
        end else if (Opcode == 4'b1100 || Opcode == 4'b1101 || Opcode == 4'b1110) begin
            // J-Type instruction
            Jump_Offset <= InstrIn[11:0];
        end else if (Opcode == 4'b1111) begin
            // S-Type instruction
            RA       <= InstrIn[11:9];
            Imm8      <= InstrIn[8:1];
        end else if (Opcode == 4'b0111) begin 
            // SW
            Mode      <= InstrIn[11];
            RB        <= InstrIn[10:8];
            RA       <= InstrIn[7:5];
            Imm5      <= InstrIn[4:0];
        end else if (Opcode == 4'b0011 || Opcode == 4'b0100 || Opcode == 4'b0101 || Opcode == 4'b0110 ) begin 
            // ADDI ANDI LW LBu LBs
            // I-Type instruction
            Mode      <= InstrIn[11];
            RW        <= InstrIn[10:8];
            RA       <= InstrIn[7:5];
            Imm5      <= InstrIn[4:0];
        end else begin
          	// BGT BGTZ BLT BLTZ BEQ BEQZ BNE BNEZ
          	Mode      <= InstrIn[11];
            RA        <= InstrIn[10:8];
            RB       <= InstrIn[7:5];
            Imm5      <= InstrIn[4:0];
        end
    end
endmodule

// module tb_IR;
//     reg [15:0] InstrIn;
//     wire [3:0] Opcode;
//     wire [2:0] RW, RA, RB;
//     wire Mode;
//     wire [4:0] Imm5;
//     wire [7:0] Imm8;
//     wire [11:0] Jump_Offset;
//     wire [2:0] Unused;

//     IR uut (
//         .InstrIn(InstrIn),
//         .Opcode(Opcode),
//         .RW(RW),
//         .RA(RA),
//         .RB(RB),
//         .Mode(Mode),
//         .Imm5(Imm5),
//         .Imm8(Imm8),
//         .Jump_Offset(Jump_Offset),
//         .Unused(Unused)
//     );

//     initial begin
//         $monitor("Time=%0t InstrIn=%h Opcode=%b RW=%b RA=%b RB=%b Mode=%b Imm5=%b Imm8=%b Jump_Offset=%b Unused=%b",
//                  $time, InstrIn, Opcode, RW, RA, RB, Mode, Imm5, Imm8, Jump_Offset, Unused);

//         // Test R-Type Instruction (Opcode 0000)
//         InstrIn = 16'b0000_011_010_001_000; // Opcode=0000, RW=011, RA=010, RB=001, Unused=000
//         #10;

//         // Test J-Type Instruction (Opcode 1100)
//         InstrIn = 16'b1100_000011110000; // Opcode=1100, Jump_Offset=000011110000
//         #10;

//         // Test S-Type Instruction (Opcode 1111)
//         InstrIn = 16'b1111_011_10101010; // Opcode=1111, RA=011, Imm8=10101010
//         #10;

//         // Test I-Type Instruction with Mode=1 (Opcode other than 0000, 1100, 1111)
//         InstrIn = 16'b0011_1_101_100_11000; // Opcode=0011, Mode=1, RW=101, RA=100, Imm5=11000
//         #10;

//         // Test another R-Type Instruction (Opcode 0001)
//         InstrIn = 16'b0001_100_011_001_101; // Opcode=0001, RW=100, RA=011, RB=001, Unused=101
//         #10;

//         // Test another J-Type Instruction (Opcode 1101)
//         InstrIn = 16'b1101_000000111111; // Opcode=1101, Jump_Offset=000000111111
//         #10;

//         // Test another I-Type Instruction with Mode=0 (Opcode other than 0000, 1100, 1111)
//         InstrIn = 16'b0100_0_010_001_10101; // Opcode=0100, Mode=0, RW=010, RA=001, Imm5=10101
//         #10;

//         // Test SW Instruction (Opcode 0111)
//         InstrIn = 16'b0111_1_011_010_10101; // Opcode=0111, Mode=1, RB=011, RA=010, Imm5=10101
//         #10;

//         $finish;
//     end
// endmodule
