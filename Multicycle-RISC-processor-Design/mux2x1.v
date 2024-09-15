// 2x1 Multiplexer module with parameterized width
module mux2x1 #(parameter WIDTH = 1) (
  input [WIDTH-1:0] A, B,
  input sel,
  output [WIDTH-1:0] Y
);
  // Assign output Y based on selector sel

  assign Y = sel ? B : A;

endmodule
 
// module tb_mux2x1();

//     parameter WIDTH = 1;

//     reg [WIDTH-1:0] A, B;
//     reg sel;

//     wire [WIDTH-1:0] Y;

//     mux2x1 #(WIDTH) uut (
//         .A(A),
//         .B(B),
//         .sel(sel),
//         .Y(Y)
//     );

    
//     // Test vectors
//     initial begin
//         $monitor("Time = %0t A = %b, B = %b, sel = %b, Y = %b", $time, A, B, sel, Y);

//         // Test case 1: sel = 0, A = 0, B = 1
//         A = 0; B = 1; sel = 0;
//         #10;

//         // Test case 2: sel = 1, A = 0, B = 1
//         A = 0; B = 1; sel = 1;
//         #10;

//         // Test case 3: sel = 0, A = 1, B = 0
//         A = 1; B = 0; sel = 0;
//         #10;

//         // Test case 4: sel = 1, A = 1, B = 0
//         A = 1; B = 0; sel = 1;
//         #10;

//         // Test case 5: sel = 0, A = 3, B = 2 (extended width test)
//         A = 3; B = 2; sel = 0;
//         #10;

//         // Test case 6: sel = 1, A = 3, B = 2 (extended width test)
//         A = 3; B = 2; sel = 1;
//         #10;

//         $finish;
//     end

// endmodule
