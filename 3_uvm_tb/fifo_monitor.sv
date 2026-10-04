
class fifo_monitor extends uvm_monitor;

`uvm_component_utils(fifo_monitor)



function new(string name ="fifo_monitor", uvm_component parent=null);
super.new(name,parent);
endfunction


virtual fifo_if vif;
uvm_analysis_port#(fifo_item)mon_analysis_port;


//////////////////////////////////////////////////////
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon_analysis_port = new("mon_analysis_port", this);
if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif))
$fatal(45,"uvm_config_db get is failed in monitor");
endfunction
////////////////////////////////////////////////////////

virtual task run_phase(uvm_phase phase);
fifo_item req;
forever begin
@(posedge vif.clk);
  #1;
req = fifo_item::type_id::create("req");  // req is obj for that we dont use this its used for parent

//$display("Fifo_transaction is coming:")

req.data = vif.data;
req.wr_en = vif.wr_en;
req.rd_en = vif.rd_en;
req.data = vif.data;
req.empty=vif.empty;
req.full=vif.full;
req.data_out=vif.data_out;
  
  
  ////////////////
  $display("[MONITOR] time=%0t wr=%0d rd=%0d data=%0d data_out=%0d empty=%0d full=%0d",
                 $time,
                 req.wr_en,
                 req.rd_en,
                 req.data,
                 req.data_out,
                 req.empty,
                 req.full);
  
  
  
  //////////////////
mon_analysis_port.write(req);

end
endtask

endclass


