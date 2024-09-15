module PCAdder (
    input  [15:0] PCResult,       
    output reg [15:0] PCAddResult
);

   
  always @(*) begin
        // Add 2 to the current Program Counter value to increment by 1 word (assuming each word is 2 bytes)
        PCAddResult <= PCResult + 14'h2;
    end

endmodule


// module tb_PCAdder;

//     reg [15:0] PCResult;           
//     wire [15:0] PCAddResult;      

//     // Instantiate PCAdder module
//     PCAdder uut (
//         .PCResult(PCResult),
//         .PCAddResult(PCAddResult)
//     );

//     initial begin
//         // Test case 1: PCResult = 16'h0000
//         PCResult = 16'h0000;
//         #10;
//         $display("Test 1: PCResult = %h, PCAddResult = %h", PCResult, PCAddResult);

//         // Test case 2: PCResult = 16'hFFFF
//         PCResult = 16'hFFFF;
//         #10;
//         $display("\nTest 2: PCResult = %h, PCAddResult = %h", PCResult, PCAddResult);

//         // Test case 3: PCResult = 16'h1234
//         PCResult = 16'h1234;
//         #10;
//         $display("\nTest 3: PCResult = %h, PCAddResult = %h", PCResult, PCAddResult);

//         // Test case 4: PCResult = 16'h8000
//         PCResult = 16'h8000;
//         #10;
//         $display("\nTest 4: PCResult = %h, PCAddResult = %h", PCResult, PCAddResult);

//         // End simulation
//         #10;
//         $finish;
//     end

// endmodule
