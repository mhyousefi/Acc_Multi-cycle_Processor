module MIPS_MC (clk, reset);
  input clk, reset;
  
  wire PCwrite, PCwrite_cond, PCsrc, IorD, MemRead, MemWrite, IRwrite, ldACC, ACCsrc, ldA, ldB, Asrc, Bsrc, zero;
  wire [1:0] ALUop;
  wire [2:0] opcode;
  
  Datapath MIPS_DP (
    .clk(clk),
    .PC_init(reset),
    .PCwrite(PCwrite),
    .PCwrite_cond(PCwrite_cond),
    .PCsrc(PCsrc),
    .IorD(IorD),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .IRwrite(IRwrite),
    .ldACC(ldACC),
    .ACCsrc(ACCsrc),
    .ldA(ldA),
    .ldB(ldB),
    .Asrc(Asrc),
    .Bsrc(Bsrc),
    .ALUop(ALUop),
    .zero(zero),
    .opcode(opcode)
  );
  
  Controller MIPS_CU (
    .clk(clk),
    .rst(reset),
    .zero(zero),
    .opcode(opcode),
    .PCwrite(PCwrite),
    .PCwrite_cond(PCwrite_cond),
    .PCsrc(PCsrc),
    .IorD(IorD),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .IRwrite(IRwrite),
    .ldACC(ldACC),
    .ACCsrc(ACCsrc),
    .ldA(ldA),
    .ldB(ldB),
    .Asrc(Asrc),
    .Bsrc(Bsrc),
    .ALUop(ALUop)
  );
  
endmodule