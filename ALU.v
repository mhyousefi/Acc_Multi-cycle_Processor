`include "defines.v"

module ALU (A, B, operation, out);

    input  [15:0] A, B;
    input  [1:0] operation;
    output reg [15:0] out;
    
    always@(A, B, operation) begin
      case (operation)
        `ADD_OP:     out = A + B;
        `SUB_OP:     out = A - B;
        `AND_OP:     out = A & B;
        `NOT_OP:     out  = ~B;	
      endcase   
    end
 endmodule