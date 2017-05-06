module MUX16_2to1 (in1, in2, sel, out);

  input sel;
  input [15:0] in1, in2;
  output [15:0] out;
  
  assign out = (sel == 0) ? in1 : in2;
  
endmodule