//`include"generator.sv"
//`include"driver.sv"
//`include"monitor.sv"
//`include"scoreboard.sv"
//`include"fifo_transaction.sv"
class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;

virtual fifo_if fifo_vif;
mailbox #(fifo_transaction) gen2drive;
mailbox #(fifo_transaction) mon2scb;
//mailbox #(fifo_transaction) drv2scb;


function new (virtual fifo_if fifo_vif);
gen2drive = new();
mon2scb = new();
//drv2scb=new();
gen=new(gen2drive);
drv=new(gen2drive,fifo_vif);
mon=new(fifo_vif,mon2scb);
scb=new(mon2scb);
endfunction


task run();
fork 
gen.run();
drv.run();
mon.run();
scb.run();
join_none

wait(gen.ended.triggered);
#550;

$finish;

endtask 

endclass

