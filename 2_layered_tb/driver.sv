
class driver;
virtual fifo_if fifo_vif;
mailbox#(fifo_transaction)gen2driver;
 
function new(mailbox#(fifo_transaction)gen2driver, virtual fifo_if fifo_vif);
this.fifo_vif=fifo_vif;
this.gen2driver=gen2driver;
endfunction
 
task reset(rst_n);
@(fifo_vif.driver_cb);
if(!fifo_vif.rst_n) begin
$display("---[Driver] Reset Started------");
 
fifo_vif.driver_cb.wr_en <=0;
fifo_vif.driver_cb.rd_en <=0;
fifo_vif.driver_cb.data_in <=0;
end
$display("---[Driver] Reset Ended------");
 
endtask
 
 
int count;
 
fifo_transaction tr;
task run();
 
forever begin
gen2driver.get(tr);
@(fifo_vif.driver_cb);
 
	 fifo_vif.driver_cb.wr_en <= tr.wr_en;
	 fifo_vif.driver_cb.rd_en <= tr.rd_en;
	 fifo_vif.driver_cb.data_in <= tr.data_in;
	 count++;
end
endtask
endclass
 


