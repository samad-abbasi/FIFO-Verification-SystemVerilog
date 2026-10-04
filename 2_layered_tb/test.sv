//`include "environment.sv"
//`include "fifo_if.sv"
class test;
environment env;
function new(virtual fifo_if fifo_vif);
env = new(fifo_vif);
endfunction
task run();
env.run();
endtask
endclass
