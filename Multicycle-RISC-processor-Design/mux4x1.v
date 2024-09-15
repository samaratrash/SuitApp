module mux4x1(
  input wire [15:0] A,       
  input wire [15:0] B,       
  input wire [15:0] C,       
  input wire [15:0] D,       
  input wire [1:0] sel,      
  output reg [15:0] Y      
);

  // Always block that is sensitive to changes in the sel signal
  always @(sel or A) begin
    case (sel)
      2'b00: Y = A;
      2'b01: Y = B;
      2'b10: Y = C;
      2'b11: Y = D;
      default: Y = 16'b0;  // Default case to avoid latches
    endcase
  end
endmodule


// module tb_mux4x1();

//     reg [15:0] A, B, C, D;   
//     reg [1:0] sel;           
    
//     wire [15:0] Y;           

//     // Instantiate the mux4x1 module
//     mux4x1 uut (
//         .A(A),
//         .B(B),
//         .C(C),
//         .D(D),
//         .sel(sel),
//         .Y(Y)
//     );

//     initial begin
//         // Test case 1: sel = 00 (A)
//         A = 16'h1234;
//         B = 16'h5678;
//         C = 16'hABCD;
//         D = 16'hFFFF;
//         sel = 2'b00;
//         #10;
//         $display("Test case 1: sel = %b, Y = %h", sel, Y);

//         // Test case 2: sel = 01 (B)
//         sel = 2'b01;
//         #10;
//         $display("Test case 2: sel = %b, Y = %h", sel, Y);

//         // Test case 3: sel = 10 (C)
//         sel = 2'b10;
//         #10;
//         $display("Test case 3: sel = %b, Y = %h", sel, Y);

       
//         $finish;
//     end

// endmodule

