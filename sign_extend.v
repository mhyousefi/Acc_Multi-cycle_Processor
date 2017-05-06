module sign_extend(in, out);
	input  [12:0] in;
	output [15:0] out;

  assign out = (in[12] == 1'b1) ? {3'b111, in} : {3'b000, in};

endmodule
