module load_Reg16 (clk, ld, in, out);
	input clk, ld;
	input [15:0] in;
	output reg [15:0] out;

	always @(posedge clk) begin
		if (ld) out <= in;
	end
endmodule