module Adder (
    input [15:0] a,      
    input [15:0] b,      
    output reg[15:0] sum    
);

    // Assign statement for sum calculation
  always @(b)begin
    sum = a + b;
  end

endmodule

// module tb_Adder;

//     reg [15:0] a;
//     reg [15:0] b;
    
//     wire [15:0] sum;
    
//     Adder uut (
//         .a(a),
//         .b(b),
//         .sum(sum)
//     );
    
//     // Clock generation
//     reg clk = 0;
//     always #5 clk = ~clk;
    
//     initial begin
//         // Initialize inputs
//         a = 16'h0000;
//         b = 16'h0000;
        
//         // Test case 1: a = 5, b = 3
//         a = 16'h0005;
//         b = 16'h0003;
//         #10;
        
//         // Test case 2: a = 10, b = 0
//         a = 16'h000A;
//         b = 16'h0000;
//         #10;
        
//         // Test case 3: a = 32767 (max positive value), b = 1
//         a = 16'h7FFF;
//         b = 16'h0001;
//         #10; 
       
//        $finish;
//     end
    
//     // Display output during simulation
//     initial begin
//         $monitor("Time = %0t, a = %h, b = %h, sum = %h", $time, a, b, sum);
//     end
    
// endmodule