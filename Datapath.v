module Datapath(clk, PC_init, PCwrite, PCwrite_cond, PCsrc, IorD, MemRead, MemWrite, 
                IRwrite, ldACC, ACCsrc, ldA, ldB, Asrc, Bsrc, ALUop, zero, opcode);
  input clk, PC_init;
  input PCwrite, PCwrite_cond, PCsrc, IorD, MemRead, MemWrite, IRwrite, ldACC, ACCsrc, ldA, ldB, Asrc, Bsrc;
  input [1:0] ALUop;
  
  output zero;
  output [2:0] opcode;
  
  wire zero;
  wire [12:0] PCin, PCout, addr;
  wire [15:0] mem_out, MDR_out, SE_out, ACC_in, ACC_out, A_out, B_out, ALU_A, ALU_B, ALU_res, ALU_out, IR_out;
  
  assign opcode = IR_out[15:13];
  
  PC PC_unit (
    .clk(clk), 
    .write(PCwrite),
    .write_cond(PCwrite_cond),
    .zero(zero),
    .PC_init(PC_init),
    .pc_in(PCin),
    .pc_out(PCout)
  );
  
  MUX13_2to1 IorD_MUX (
    .in1(PCout),
    .in2(IR_out[12:0]),
    .sel(IorD),
    .out(addr)
  );
  
  MUX13_2to1 PCsrc_MUX (
    .in1(ALU_res[12:0]),
    .in2(IR_out[12:0]),
    .sel(PCsrc),
    .out(PCin)
  );
  
  memory MemUnit (
    .clk(clk),
    .address(addr),
    .write_en(MemWrite),
    .read_en(MemRead),
    .data_in(ACC_out),
    .data_out(mem_out)
  );
  
  ALU ALU_unit (
    .A(ALU_A),
    .B(ALU_B),
    .operation(ALUop),
    .out(ALU_res)
  );
  
  sign_extend SE (
    .in(PCout),
    .out(SE_out)
  );
  
  ACC_Reg ACC (
    .clk(clk),
    .ldACC(ldACC),
    .in(ACC_in),
    .out(ACC_out),
    .zero(zero)
  );
  
  Reg16 ALU_Reg(
    .clk(clk),
    .in(ALU_res),
    .out(ALU_out)
  );
  
  Reg16 MDR (
    .clk(clk),
    .in(mem_out),
    .out(MDR_out)
  );
  
  load_Reg16 IR (
    .clk(clk),
    .in(mem_out),
    .out(IR_out),
    .ld(IRwrite)
  );
  
  Reg16 A_Reg (
    .clk(clk),
    .in(MDR_out),
    .out(A_out)
  );
  
  Reg16 B_Reg (
    .clk(clk),
    .in(ACC_out),
    .out(B_out)
  );
  
  MUX16_2to1 ACC_Mux(
    .in1(ALU_out),
    .in2(MDR_out),
    .sel(ACCsrc),
    .out(ACC_in)
  );
  
  MUX16_2to1 A_Mux(
    .in1(A_out),
    .in2(SE_out),
    .sel(Asrc),
    .out(ALU_A)
  );
  
  MUX16_2to1_one_input_const_1 B_Mux(
    .in1(B_out),
    .sel(Bsrc),
    .out(ALU_B)
  );
  
endmodule










