`include "defines.v"

module Controller(clk, rst, zero, opcode, PCwrite, PCwrite_cond, PCsrc, IorD, MemRead, MemWrite, IRwrite, ldACC, ACCsrc, ldA, ldB, Asrc, Bsrc, ALUop);
  input clk, zero, rst;
  input [2:0] opcode;
  output reg PCwrite, PCwrite_cond, PCsrc, IorD, MemRead, MemWrite, IRwrite, ldACC, ACCsrc, ldA, ldB, Asrc, Bsrc;
  output reg [1:0] ALUop;
  
  reg [4:0] ps, ns;
  
  always@(*)begin
    {PCwrite, PCwrite_cond, PCsrc, IorD, MemRead, MemWrite, IRwrite, ldACC, ACCsrc, ldA, ldB, Asrc, Bsrc, ALUop} = 15'b000000000000000;
    case(ps)
      `s1:  begin 
        IorD = 0; MemRead = 1; IRwrite = 1; //Reading or fetching the instruction...
        Asrc = 1; Bsrc = 1; ALUop = `ADD_OP; PCsrc = 0; PCwrite = 1; //PC++; 
      end
      `s2:  begin /*Giving the controller time to decode the fetched instruction*/ end
      `s3:  begin PCsrc = 1; PCwrite = 1; end //Unconditional jump (JMP)
      `s4:  begin PCsrc = 1; PCwrite_cond = 1; end //Conditional jump (JZ)
      `s5:  begin IorD = 1; MemRead = 1; end //Reading from the memory
      `s6:  begin ldA = 1; ldB = 1; end //Loading stuff into A and B
      `s7:  begin Asrc = 0; Bsrc = 0; ALUop = opcode[1:0]; end //Executing the appropriate operation in ALU
      `s8:  begin ALUop = opcode[1:0]; /*Loading stuff into ALU_reg*/ end
      `s9:  begin ALUop = opcode[1:0]; ACCsrc = 0; ldACC = 1; end //Loadint the result of ADD, SUB, or AND into the ACC register
      `s10: begin ACCsrc = 1; ldACC = 1; end //Loadint some data from the memory into the ACC register
      `s11: begin MemWrite = 1; IorD = 1; end //Writing data from ACC to the memory
      `s12: begin ldB = 1; end //Loading studd into B
      `s13: begin Bsrc = 0; ALUop = `NOT; end //Executing the bitwise NOT operation in the ALU
      `s14: begin /*Loading stuff into ALU_reg*/ ALUop = `NOT; end
      `s15: begin ldACC = 1; ACCsrc = 0; ALUop = `NOT; end //Loadint the result of NOT into the ACC register
    endcase
  end
  
  always@(*)begin
    case(ps)
      `s1:  ns <= `s2;
      `s2:  
      begin
          if(opcode == `JMP) ns <= `s3; 
          else if(opcode == `JZ)  ns <= `s4;
          else if(opcode == `ADD || opcode == `SUB || opcode == `AND || opcode == `LDA) ns <= `s5;
          else if(opcode == `NOT) ns <= `s12;
          else ns <= `s11; // In other words if upcode == STA (the only remaining option)
      end 
      `s3:  ns <= `s1;
      `s4:  ns <= `s1;
      `s5:  
      begin
          if(opcode == `ADD || opcode == `SUB || opcode == `AND) ns <= `s6;
          else ns <= `s10; //else could only mean LDA because the state machine doesn't reach here if the upcode is AND, ADD, SUB, or LDA!!
      end
      `s6:  ns <= `s7;
      `s7:  ns <= `s8;
      `s8:  ns <= `s9;
      `s9:  ns <= `s1;
      `s10: ns <= `s1;
      `s11: ns <= `s1;
      `s12: ns <= `s13;
      `s13: ns <= `s14;
      `s14: ns <= `s15;
      `s15: ns <= `s1;
    endcase
  end
  
  always@(posedge clk, posedge rst) begin
    if (rst) ps <= 5'd1;
    else ps <= ns;  
  end
  
endmodule