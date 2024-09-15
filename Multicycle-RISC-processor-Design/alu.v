module alu (
    input [3:0] ALUop,
    input ALUen,              
    input signed [15:0] a, b,        
    output reg zero,                 
    output reg carry,                
    output reg overflow,            
    output reg negative,             
    output reg signed [15:0] result 
);

  always @(ALUen)
      begin
      if(ALUen)// Check if ALU is enabled
    begin
        case(ALUop)
            4'b0000: 
                begin
                    result = a & b;         // Bitwise AND operation
                    carry = 1'b0;           // Clear carry for AND operation
                    overflow = 1'b0;        // Clear overflow for AND operation
                end
            4'b0001: 
                begin
                    result = a + b;         // Addition operation
                    carry = (result > 32767 || result < -32768); // Set carry if there's an overflow
                    overflow = ((a[15] == b[15]) && (result[15] != a[15])) ? 1'b1 : 1'b0; // Detect overflow
                end
            4'b0010: 
                begin
                    result = a - b;         // Subtraction operation
                    carry = (result < 0);   // Set carry if there's a borrow (result is negative)
                    overflow = ((a[15] != b[15]) && (result[15] != a[15])) ? 1'b1 : 1'b0; // Detect overflow
                end
            default:
                begin
                    result = 16'b0;         // Default case to avoid latches (should not occur)
                    carry = 1'b0;           // Clear carry
                    overflow = 1'b0;        // Clear overflow
          end
        endcase
   
        // Update zero and negative flags based on the result
        zero = (result == 16'b0);       // Set zero flag if result is zero
        negative = result[15];          // Set negative flag based on the most significant bit (sign bit) of result
       end
    end

endmodule

// module tb_alu;

//     reg [3:0] ALUop;                    // ALU operation code
//     reg ALUen;                          // ALU enable signal
//     reg signed [15:0] a, b;             // Input operands
//     wire zero;                          // Zero flag output
//     wire carry;                         // Carry flag output
//     wire overflow;                      // Overflow flag output
//     wire negative;                      // Negative flag output
//     wire signed [15:0] result;          // ALU result output

//     alu uut (
//         .ALUop(ALUop),
//         .ALUen(ALUen),
//         .a(a),
//         .b(b),
//         .zero(zero),
//         .carry(carry),
//         .overflow(overflow),
//         .negative(negative),
//         .result(result)
//     );

//     // Initial stimulus
//     initial begin
//         $monitor("Time = %0t ns: ALUop = %b, a = %h, b = %h, result = %h, zero = %b, carry = %b, overflow = %b, negative = %b", 
//                  $time, ALUop, a, b, result, zero, carry, overflow, negative);

//         // Test case 1: AND operation
//         ALUop = 4'b0000;     // AND operation
//         a = 16'hAAAA;        // Operand a
//         b = 16'h5555;        // Operand b
//         ALUen = 1;           // Enable ALU to start operation
//         #10;                 // Wait for 10 time units
//         ALUen = 0;           // Disable ALU to ensure next operation waits for enable
//         #10;                 // Wait for 10 time units

//         // Test case 2: ADD operation
//         ALUop = 4'b0001;     // ADD operation
//         a = 16'h0001;        // Operand a
//         b = 16'hFFFF;        // Operand b
//         ALUen = 1;           // Enable ALU to start operation
//         #10;                 // Wait for 10 time units
//         ALUen = 0;           // Disable ALU to ensure next operation waits for enable
//         #10;                 // Wait for 10 time units

//         // Test case 3: Subtraction operation
//         ALUop = 4'b0010;     // Subtraction operation
//         a = 16'h8000;        // Operand a (signed -32768)
//         b = 16'h0001;        // Operand b (1)
//         ALUen = 1;           // Enable ALU to start operation
//         #10;                 // Wait for 10 time units
//         ALUen = 0;           // Disable ALU to ensure next operation waits for enable
//         #10;                 // Wait for 10 time units

//         // Test case 4: No operation (ALU disabled)
//         ALUop = 4'b0000;     // Setting ALUop to a valid operation to avoid latches
//         a = 16'hFFFF;        // Operand a
//         b = 16'hFFFF;        // Operand b
//       ALUen = 0;           	 // Keep ALU disabled ( to ensure module won't work)
//         #10;                 // Wait for 10 time units

//         // Finish simulation
//         $finish;
//     end

// endmodule

