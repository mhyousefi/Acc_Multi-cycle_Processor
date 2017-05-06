module ACC_Reg (clk, ldACC, in, out, zero);
  
	input clk, ldACC;
	input [15:0] in;
	output reg [15:0] out;
	output zero;

	always @(posedge clk) begin
		if (ldACC) out <= in;
	end

	assign zero = (out == 16'd0) ? 1'b1 : 1'b0;

endmodule