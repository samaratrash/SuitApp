module tb_datapath;
    reg clk,Pcen;
    wire [15:0] NextPc;
    wire [15:0] Alu_result;
    wire [15:0] Data_out;
    wire [15:0] address_MUX;
    wire [15:0] data_IN;
    wire [15:0] WReg,BusA,BusB;
    wire [1:0] PCSrc;
    // Instantiate the datapath
    datapath uut (
      .clk(clk),
      .NextPc(NextPc),
      .Alu_result(Alu_result),
      .Data_out(Data_out),
      .address_MUX(address_MUX),
      .data_IN(data_IN),
      .WReg(WReg),
      .BusA(BusA),
      .BusB(BusB),
      .PCSrc(PCSrc),
      .Pcen(Pcen)
    );

    // Clock generation
    initial begin
        $dumpfile("dump.vcd");
       $dumpvars;
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test scenarios
    initial begin
        $monitor("Time = %0t ns: clk=%b, NextPc=%h, Alu_result=%h, Data_out=%h, address_MUX=%h, data_IN=%h, WReg=%h,PCS=%h,PCEN=%h,BusA=%h,BusB=%h", 
                 $time, clk, NextPc, Alu_result, Data_out, address_MUX, data_IN, WReg,PCSrc,Pcen,BusA,BusB);


        #1100; // Run the simulation for a sufficient duration
        $finish;
    end
endmodule


