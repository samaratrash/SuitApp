module ConcatenationUnit(
  input [3:0] highBits,       
  input [11:0] lowBits,       
  output [15:0] concatenated  
);

  // Concatenate the 4 high-order bits with the 12 low-order bits to form a 16-bit output
  assign concatenated = {highBits, lowBits};

endmodule

// module tb_ConcatenationUnit;

//   // Testbench signals
//   reg [3:0] highBits;
//   reg [11:0] lowBits;
//   wire [15:0] concatenated;

//   // Instantiate the ConcatenationUnit
//   ConcatenationUnit uut (
//     .highBits(highBits),
//     .lowBits(lowBits),
//     .concatenated(concatenated)
//   );

//   initial begin
//     $display("highBits\tlowBits\t\tconcatenated");
    
//     // Monitor the signals
//     $monitor("%b\t%b\t%b", highBits, lowBits, concatenated);

//     // Test case 1
//     highBits = 4'b1010;
//     lowBits = 12'b110011001100;
//     #1; // Wait for 1 time unit for the simulation to update

//     // Test case 2
//     highBits = 4'b0110;
//     lowBits = 12'b001100110011;
//     #1; // Wait for 1 time unit for the simulation to update

//     // End of test
//     $finish;
//   end

// endmodule

