module MIPS_MC_TB();
  
  reg clk, rst;
  MIPS_MC MUT1(clk, rst);
      
  initial begin
        clk = 0;
        repeat(400)#10
        clk = ~clk;
      end
      
      initial begin
      rst = 0;
      #5;
      rst = 1;
      #10;
      rst = 0;
      $stop;
      end 
      
endmodule