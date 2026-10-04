//`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

//`include "fifo_if.sv"

module top;
logic clk;


fifo_if vif(.clk(clk));

 fifo #(.DEPTH(8), .WIDTH(32)) dut (
    .clk    (vif.clk),
    .rst_n  (vif.rst_n),
    .data   (vif.data),
    .wr_en  (vif.wr_en),
    .rd_en  (vif.rd_en),
    .full   (vif.full),
    .empty  (vif.empty),
    .data_out   (vif.data_out)
  );
  

  
  
always #5 clk= ~clk;

 initial begin
	clk=0;
    vif.rst_n = 0;
    #20 vif.rst_n = 1;   
  end

initial begin
uvm_config_db#(virtual fifo_if)::set(null,"*","vif",vif);
run_test("fifo_test");
end

endmodule

