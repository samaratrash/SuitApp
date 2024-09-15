module DMEM (
    input [15:0] address,    
    input MemWr,             
    input MemRd,            
    input LB,               
    input [15:0] data_in,    
    output reg [15:0] data_out 
);

    // Define a memory array to hold data (byte-addressable, 32 bytes in total)
    reg [7:0] memory [31:0];
    // Initialize memory with predefined values
    initial begin
      	memory[0] = 8'h07;
        memory[1] = 8'h00;
      	memory[2] = 8'h81;
        memory[3] = 8'h11;
        memory[4] = 8'h22;
        memory[5] = 8'h22;
        memory[6] = 8'h33;
        memory[7] = 8'h33;
        memory[8] = 8'h44;
        memory[9] = 8'h44;
        memory[10] = 8'h55;
        memory[11] = 8'h55;
        memory[12] = 8'h66;
        memory[13] = 8'h66;
        memory[14] = 8'h77;
        memory[15] = 8'h77;
        memory[16] = 8'h88;
        memory[17] = 8'h88;
        memory[18] = 8'h99;
        memory[19] = 8'h99;
        memory[20] = 8'hAA;
        memory[21] = 8'hAA;
        memory[22] = 8'hBB;
        memory[23] = 8'hBB;
        memory[24] = 8'hCC;
        memory[25] = 8'hCC;
        memory[26] = 8'hDD;
        memory[27] = 8'hDD;
        memory[28] = 8'hEE;
        memory[29] = 8'hEE;
        memory[30] = 8'hFF;
        memory[31] = 8'hFF;
    end
    
  always @(MemWr or MemRd) begin
        // Condition for Write
      if (MemWr) begin
            // Write lower byte to memory at address
            memory[address] = data_in[7:0];
            // Write upper byte to memory at address + 1
            memory[address + 1] = data_in[15:8];
        end
        // Condition for Read
      if (MemRd) begin
            // Read lower byte from memory at address
            data_out[7:0] = memory[address];
        if(LB)
            // Read upper byte from memory at address + 1
            data_out[15:8] =8'b0; 
        else
                // Set upper byte to 0
               data_out[15:8] = memory[address + 1];
             
        end
    end

endmodule

// module tb_DMEM;

//     reg [3:0] address;  // Address is now 4 bits
//     reg [15:0] datain;
//     reg memread, memwrite, LB;
//     wire [15:0] dataout;

//     DMEM uut (
//         .address(address),
//         .MemWr(memwrite),
//         .MemRd(memread),
//         .LB(LB),
//         .data_in(datain),
//         .data_out(dataout)
//     );

//     initial begin
//         $monitor("Time = %0t ns: address=%h, datain=%h, memread=%b, memwrite=%b, LB=%b, dataout=%h, mem[%h]=%h, mem[%4h]=%h", 
//                  $time, address, datain, memread, memwrite, LB, dataout, address, uut.memory[address], address + 1, uut.memory[address + 1]);

//         // Test scenario 1: Write operation
//         address = 4'h0; datain = 16'hAAAA; memwrite = 1; memread = 0; LB = 0;
//         #10; 
//         memwrite = 0; memread = 1;
//         #10; // Wait for a few clock cycles to complete the write operation

//         // Test scenario 2: Read operation (word)
//         address = 4'h0; memwrite = 0; memread = 1; LB = 0;
//         #10; 

//         // Test scenario 3: Read operation (byte)
//         address = 4'h0; memwrite = 0; memread = 1; LB = 1;
//         #10; 

//         // Test scenario 4: Write another value
//         address = 4'h2; datain = 16'h5555; memwrite = 1; memread = 0; LB = 0;
//         #10; 
//         memwrite = 0; memread = 1;
//         #10; 

//         $finish;
//     end
//endmodule





