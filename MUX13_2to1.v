module MUX13_2to1 (in1, in2, sel, out);

  input [12:0] in1, in2;
  input sel;
  output [12:0] out;
  
  assign out = (sel == 0) ? in1 : in2;
  
endmodule