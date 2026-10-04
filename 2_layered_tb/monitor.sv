

class monitor;

virtual fifo_if fifo_vif;
mailbox #(fifo_transaction)mon2scb;


function new(virtual fifo_if fifo_vif, mailbox #(fifo_transaction)mon2scb);
this.fifo_vif=fifo_vif;
this.mon2scb=mon2scb;
endfunction


task run();
fifo_transaction tr;
forever begin 
@(fifo_vif.monitor_cb);
tr=new();
tr.data_in = fifo_vif.monitor_cb.data_in;
tr.data_out = fifo_vif.monitor_cb.data_out;
tr.wr_en = fifo_vif.monitor_cb.wr_en;
tr.rd_en = fifo_vif.monitor_cb.rd_en;
tr.full = fifo_vif.monitor_cb.full;
tr.empty = fifo_vif.monitor_cb.empty;
tr.underflow = fifo_vif.monitor_cb.underflow;
tr.overflow = fifo_vif.monitor_cb.overflow;
tr.count=fifo_vif.monitor_cb.count;

mon2scb.put(tr);


end 

endtask


endclass







