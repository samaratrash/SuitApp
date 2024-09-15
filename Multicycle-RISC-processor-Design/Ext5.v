module Ext5 (
    input [4:0] imm_in,   // 5-bit immediate input
    input extop,
    output reg [15:0] imm_out 
);

    // Always block to extend the 5-bit immediate input to 16 bits based on the extension operation
    always @(*) begin
        if (extop)
            imm_out = {{11{imm_in[4]}}, imm_in}; // Sign extension
        else
            imm_out = {11'b0, imm_in};           // Zero extension
    end
  
endmodule


// module tb_ext5;

//     reg [4:0] imm_in;    // Input: 5-bit 
//     reg extop;          
//     wire [15:0] imm_out; // Output: 16-bit 

//     Ext5 uut (
//         .imm_in(imm_in),
//         .extop(extop),
//         .imm_out(imm_out)
//     );

//     initial begin
//         $monitor("imm_in = %b, extop = %b, imm_out = %b", imm_in, extop, imm_out);
        
//         // Test 1: Zero extension
//         imm_in = 5'b10101; 
//         extop = 0;      
//         #10;            
        
//         // Test 2: Sign extension
//         imm_in = 5'b10101; 
//         extop = 1;       
//         #10;              

     
//         #10;
//         $finish;
//     end

// endmodule
