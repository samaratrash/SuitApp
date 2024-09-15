module Ext8 (
  input [7:0] imm_in,    // 8-bit immediate input
  input extop,          
  output reg [15:0] imm_out  
);

  // Always block to assign the 16-bit output based on the value of the extop signal
  // If extop is 1, perform sign extension: replicate the sign bit (imm_in[7]) 8 times
  // If extop is 0, perform zero extension: replicate '0' 8 times
  always @(*) begin
    if (extop)
      imm_out = {{8{imm_in[7]}}, imm_in}; // Sign extension
    else
      imm_out = {8'b0, imm_in};           // Zero extension
  end

endmodule



// module tb_ext8;

//     reg [7:0] imm_in;       
//     reg extop;             
//     wire [15:0] imm_out;   

//     Ext8 uut (
//         .imm_in(imm_in),
//         .extop(extop),
//         .imm_out(imm_out)
//     );

//     initial begin
//         // Test 1: Zero extension
//         imm_in = 8'b10101010; // Input value
//         extop = 0;            // Zero extension mode
//         #10;                  // Wait for a few time units
//         $display("Test 1: Zero Extension");
//         $display("imm_in  = %b", imm_in);
//         $display("extop   = %b", extop);
//         $display("imm_out = %b", imm_out);
        
//         // Test 2: Sign extension
//         imm_in = 8'b10101010; // Input value
//         extop = 1;            // Sign extension mode
//         #10;                  // Wait for a few time units
//         $display("\nTest 2: Sign Extension");
//         $display("imm_in  = %b", imm_in);
//         $display("extop   = %b", extop);
//         $display("imm_out = %b", imm_out);
   
//         #10;
//         $finish;
//     end

// endmodule
