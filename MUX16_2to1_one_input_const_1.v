module MUX16_2to1_one_input_const_1 (in1, sel, out);

  input sel;
  input [15:0] in1;
  output [15:0] out;
  
  assign out = (sel == 0) ? in1 : 16'd1;
  
endmodule