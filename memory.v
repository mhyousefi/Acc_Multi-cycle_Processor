module memory (clk, address, write_en, read_en, data_in, data_out);
  input clk, write_en, read_en;
  output reg [15:0] data_out;
  input  [15:0] data_in;
  input  [12:0] address;
  
  reg[15:0] data [0:127];

  initial begin
    $readmemh ("instructions.hex", data);
    $readmemh ("data1.hex", data, 100);
    $readmemh ("data2.hex", data, 50);
  end

  
  always@(posedge clk) begin 
    if (write_en) data[address] <= data_in;
  end

  always @(read_en or address)
   if(read_en)
      data_out <=  data[address];

endmodule