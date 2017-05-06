module PC (clk, write, write_cond, zero, PC_init, pc_in, pc_out);
	
	input clk, PC_init, write, write_cond, zero;
	input [12:0] pc_in;
	
	output reg [12:0] pc_out;

  always@(posedge clk) begin
    if (PC_init) pc_out <= 13'd0;
    else if (write || (write_cond && zero)) pc_out <= pc_in;
  end

endmodule