module RegFile(
    input [2:0] RA,     
    input [2:0] RB,      
    input [2:0] RW,      
    input [15:0] BusW,   
    input RegWrite,     
    input Clk,enReg,          
    output reg [15:0] BusA, 
    output reg [15:0] BusB  
);

    // an array of 8 registers, each 16 bits wide
    reg [15:0] Registers [7:0];

    // Initialize the registers to 0 at the start
    initial begin
        Registers[0] <= 16'h0000;
        Registers[1] <= 16'h0000;
        Registers[2] <= 16'h0000;
        Registers[3] <= 16'h0000;
        Registers[4] <= 16'h0000;
        Registers[5] <= 16'h0000;
        Registers[6] <= 16'h0000;
        Registers[7] <= 16'h0000;
    end
    
    always @(posedge Clk) begin
      if (RegWrite == 1 && RW != 0) begin
            Registers[RW] <= BusW;  // Write data to the register specified by RW if RegWrite is enabled and RW is not 0
        end
    end

    always @(posedge Clk) begin
          if (enReg) begin

        BusA <= Registers[RA];  // Read data from the register specified by RA
        BusB <= Registers[RB];  // Read data from the register specified by RB
            end
    end

endmodule


// module tb_RegFile;
//     reg clk;
//     reg [2:0] RA, RB, RW;
//     reg [15:0] BusW;
//     reg RegWrite, enReg;
//     wire [15:0] BusA, BusB;

//     RegFile uut (
//         .Clk(clk),
//         .RA(RA),
//         .RB(RB),
//         .RW(RW),
//         .BusW(BusW),
//         .RegWrite(RegWrite),
//         .enReg(enReg),
//         .BusA(BusA),
//         .BusB(BusB)
//     );

//     // Clock generation
//     initial begin
//         clk = 0;
//         forever #5 clk = ~clk;
//     end

//     // Test cases
//     initial begin
//         $monitor("clk=%b, RegWrite=%b, enReg=%b, RA=%b, RB=%b, RW=%b, BusW=%h, BusA=%h, BusB=%h", 
//                  clk, RegWrite, enReg, RA, RB, RW, BusW, BusA, BusB);

//         // Initialize inputs
//         RegWrite = 0;
//         enReg = 0;
//         RA = 3'b000;
//         RB = 3'b000;
//         RW = 3'b000;
//         BusW = 16'h0000;

//         #10;
        
//         // Test case 1: Write to register 1 and read it back
//         RegWrite = 1;
//         RW = 3'b001;
//         BusW = 16'hAAAA;
//         #10;  

//         // Enable read and read from register 1
//         RegWrite = 0;
//         enReg = 1;
//         RA = 3'b001;
//         RB = 3'b000;
//         #10; 

//         // Test case 2: Write to register 2 and read it back
//         RegWrite = 1;
//         enReg = 0;
//         RW = 3'b010;
//         BusW = 16'h5555;
//         #10; 

//         // Enable read and read from register 2
//         RegWrite = 0;
//         enReg = 1;
//         RA = 3'b010;
//         RB = 3'b001;
//         #10; 

//         $finish;
//     end
// endmodule
