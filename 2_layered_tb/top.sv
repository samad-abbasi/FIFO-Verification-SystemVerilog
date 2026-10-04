//`include "test.sv"

module top;


parameter depth = 4;
parameter data_width = 8;

bit clk = 0;
bit rst_n;

always #5 clk = ~clk;


fifo_if fifo_vif (clk, rst_n);

sync_fifo #(
  .data_width (data_width),
  .depth      (depth)
) DUT (
  .clk       (fifo_vif.clk),
  .rst_n     (fifo_vif.rst_n),
  .wr_en     (fifo_vif.wr_en),
  .rd_en     (fifo_vif.rd_en),
  .data_in   (fifo_vif.data_in),
  .data_out  (fifo_vif.data_out),
  .count     (fifo_vif.count),
  .full      (fifo_vif.full),
  .empty     (fifo_vif.empty),
  .overflow  (fifo_vif.overflow),
  .underflow (fifo_vif.underflow)
);

test t;

initial begin
rst_n = 0;
#20;
rst_n = 1; 

t = new(fifo_vif);
t.run();

$finish;
end



endmodule
