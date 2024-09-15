module PC(              
    input Pcen,                
    input [15:0] newPC,      
    output reg [15:0] PC     
);

    initial begin
	PC <= 16'b0; 
     end		
  
  always @(posedge Pcen) begin  
        PC <= newPC;     // Update PC to newPC on clock edge
    end 
endmodule


// module tb_PC();

//     reg Pcen;               // PC enable signal
//     reg [15:0] newPC;      
    
//     wire [15:0] PC;       

//     PC uut (
//         .Pcen(Pcen),
//         .newPC(newPC),
//         .PC(PC)
//     );

//     initial begin
//         $monitor("At time %t, PC = %h, Pcen = %b, newPC = %h", $time, PC, Pcen, newPC);

//         // Reset signals
//         Pcen = 0;
//         newPC = 16'h0000;

     
//         #10;

//         // Test case 1: Change PC to 16'h1234 with Pcen enabled
//         Pcen = 1;
//         newPC = 16'h1234;
//         #10;

//         // Test case 2: Change PC to 16'h5678 with Pcen enabled
//         newPC = 16'h5678;
//         #10;

//         // Test case 3: Change PC to 16'hABCD with Pcen disabled (PC should not change)
//         Pcen = 0;
//         newPC = 16'hABCD;
//         #10;

//         // Test case 4: Change PC to 16'hABCD with Pcen enabled
//         Pcen = 1;
//         newPC = 16'hABCD;
//         #10;

//         $finish;
//     end
// endmodule

