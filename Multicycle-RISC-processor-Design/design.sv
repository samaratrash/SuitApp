`include "alu.v"
`include "Ext5.v"
`include "Ext8.v"
`include "Adder.v"
`include "mux4x1.v"
`include "mux2x1.v"
`include "IMEM.v"
`include "RegFile.v"
`include "PCAdder.v"
`include "PC.v"
`include "DMEM.v"
`include "IR.v"
`include "ControlUnit.v"
`include "ConcatenationUnit.v"

module datapath(
  input clk,
  output wire [15:0] NextPc,
  output wire[15:0] Alu_result,
  output wire[15:0] Data_out,
  output wire[15:0] address_MUX,
  output wire[15:0] data_IN,
  output wire[15:0] WReg,
  output wire[15:0] BusA,BusB,
  output wire [1:0] PCSrc,
  output reg Pcen


);
// Define wires for datapath connections
    wire [15:0] IMem_to_IR;
    wire [15:0] Mux_to_PC,ADDPc;
    wire [3:0] Opcode;
    wire [2:0] Rd,RA,RB;
    wire [2:0] Rs1;
    wire [15:0] BusW;
    wire [15:0] R7_RET;
    wire [15:0] R7_CALL;
    wire Mode;
    wire enReg,enInst;
    wire [4:0] Imm5;
    wire [7:0] Imm8;
  wire [15:0] Imm16_5,Imm16_8, Imm16_8_LB;
    wire [15:0] Alu_op2;
    wire [11:0] Jump_Offset;
    wire [2:0] Unused;
    wire RegWr, ExtOp, ALUSrc, MemRd, MemWr, WBdata,LB,ALUen;
    wire [3:0] ALUOp; 
    wire zero, SV,carry,overflow,negative;
    wire neg;
    wire [15:0] jump_target; 
    wire [15:0] branch_target;  
  wire [15:0] RW, LB_res;
   
// Instantiate PC module

    PC PC(
      .Pcen(Pcen),
        .newPC(Mux_to_PC),
        .PC(NextPc)
    );
// Instantiate PCAdder module for calculating branch and jump targets

    PCAdder PCAdder_inst (
        .PCResult(NextPc),
      .PCAddResult(ADDPc)
    );
      // Instantiate ControlUnit module for controlling the datapath operations

    ControlUnit CU(
        .clk(clk),
        .Pcen(Pcen),
        .Op(Opcode),
        .zero(zero),
        .neg(negative),
        .overflow(overflow),
        .mbit(Mode),
        .ALUOp(ALUOp),
        .PCSrc(PCSrc),
        .RegWr(RegWr),
       .enInst(enInst),
       .ALUen(ALUen),
        .ExtOp(ExtOp),
        .ALUSrc(ALUSrc),
        .MemRd(MemRd),
        .MemWr(MemWr),
        .WBdata(WBdata),
        .SV_signal(SV),
        .R7_RET(R7_RET),
        .R7_CALL(R7_CALL),
        .LB(LB),
        .enReg(enReg)
    );
      // Instantiate ConcatenationUnit module for concatenating jump offset with high bits of PC

      ConcatenationUnit concatUnit(
        .highBits(ADDPc[15:12]), 
        .lowBits(Jump_Offset), 
        .concatenated(jump_target)
    );
    // Instantiate Mux4x1 module for selecting next PC value (Mux_to_PC)

    mux4x1 PCMux (
      .A(ADDPc),  
      .B(jump_target),     
        .C(branch_target),    
      .D(BusA),
        .sel(PCSrc),
        .Y(Mux_to_PC)
    );
    // Instantiate Instruction Memory module (IMEM)

    IMEM InstructionMem(
        .pc(NextPc),
      .enInst(enInst),
        .instruction(IMem_to_IR)
    );
    // Instantiate Instruction Register module (IR)

    IR IRModule(
        .InstrIn(IMem_to_IR),
        .Opcode(Opcode),
        .RW(Rd),
      .RA(Rs1),
      .RB(RB),
        .Mode(Mode),
        .Imm5(Imm5),
        .Imm8(Imm8),
        .Jump_Offset(Jump_Offset),
        .Unused(Unused)
    );
    // Instantiate Register File module (RegFile)

    RegFile RegFile_inst (
        .RA(RA),
        .RB(RB),
        .RW(RW), 
        .enReg(enReg),
        .BusW(BusW), 
        .RegWrite(RegWr),
        .Clk(clk),
        .BusA(BusA),
        .BusB(BusB)
    );
    // Instantiate Mux2x1 module for selecting between Rs1 and R7 


  mux2x1 #(3) R7MUX(
        .A(Rs1),  
        .B(3'b111),           
        .sel(R7_RET),
        .Y(RA)
    );
    // Instantiate Mux2x1 module for selecting between BusB and Imm16_5 for ALU operand_2


  mux2x1 #(16) RegWrite(
        .A(BusB), 
      .B(Imm16_5),            
        .sel(ALUSrc),
        .Y(Alu_op2)
    );
  
      // Instantiate Mux2x1 module for selecting between WReg and Mux_to_PC for R7_CALL register write
  mux2x1 #(16) R7_call(
    	.A(LB_res), 
        .B(ADDPc),            
        .sel(R7_CALL),
        .Y(BusW)
    );
      // Instantiate Ext5 module for sign or zero extension of 5-bit immediate value

    Ext5 Extension5(
        .imm_in(Imm5),     
        .extop(ExtOp),     
      .imm_out(Imm16_5)    
    );
      // Instantiate Ext8 module for sign or zero extension of 8-bit immediate value

    Ext8 Extensiont8(
      .imm_in(Imm8),    
        .extop(ExtOp),     
      .imm_out(Imm16_8)   
    );
   // Instantiate Ext8 module for sign or zero extension of 8-bit immediate value

    Ext8 Extensiont8_LB(
      .imm_in(WReg),    
        .extop(ExtOp),     
      .imm_out(Imm16_8_LB)   
    );
  // Instantiate Mux2x1 module for selecting between ALU result and BusA 

  mux2x1 #(16) LBmux(
    	.A(WReg), 
    	.B(Imm16_8_LB),            
    	.sel(LB),
    	.Y(LB_res)
    );
      // Instantiate ALU module

    alu ALU_inst(
        .ALUop(ALUOp),
        .a(BusA),  
        .ALUen(ALUen),
        .b(Alu_op2),     
        .zero(zero),
        .carry(carry),
        .overflow(overflow),
        .negative(negative),
        .result(Alu_result)
    );
      // Instantiate Mux2x1 module for selecting between ALU result and BusA 

  mux2x1 #(16) Address(
        .A(Alu_result), 
        .B(BusA),            
        .sel(SV),
        .Y(address_MUX)
    );
    // Instantiate Mux2x1 module for selecting between BusB and Imm16_8 for data memory write

  mux2x1 #(16) In_Data(
        .A(BusB), 
      .B(Imm16_8),            
        .sel(SV),
      .Y(data_IN)
    );
      // Instantiate Mux2x1 module for selecting between Rd and R7 for R7 write during CALL

  mux2x1 #(3) R7_write(
        .A(Rd), 
        .B(3'b111),            
        .sel(R7_CALL),
        .Y(RW)
    );
    // Instantiate Data Memory module (DMEM)

    DMEM DataMemory (
        .address(address_MUX),   
        .MemWr(MemWr),          
        .MemRd(MemRd),         
        .LB(LB),
        .data_in(data_IN),    
        .data_out(Data_out)     
    );
    // Instantiate Mux2x1 module for selecting between ALU result and Data Memory output for write-back

  mux2x1 #(16) Out_data(
        .A(Alu_result), 
        .B(Data_out),            
        .sel(WBdata),
        .Y(WReg)
    );
      // Instantiate Adder module for calculating branch target address

    Adder branchAdder (
      .a(NextPc),       
      .b(Imm16_5),        
      .sum(branch_target)      
    );

endmodule


