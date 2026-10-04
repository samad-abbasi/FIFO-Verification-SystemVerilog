class fifo_driver extends uvm_driver #(fifo_item);
`uvm_component_utils(fifo_driver)

virtual fifo_if vif;

function new(string name ="fifo_driver", uvm_component parent=null);
super.new(name,parent);
endfunction



//////////////////////////////////////////////////////
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif))
$fatal(54,"uvm_config_db get is failed in driver");
endfunction
////////////////////////////////////////////////////////



virtual task run_phase(uvm_phase phase);
fifo_item req;
forever begin
seq_item_port.get_next_item(req);
//$display("Fifo_transaction is coming:")
@(posedge vif.clk)
vif.data<=req.data;
vif.wr_en<=req.wr_en;
vif.rd_en<=req.rd_en;

`uvm_info("=============Driver", $sformatf("Data_in = %d", req.data), UVM_LOW);


seq_item_port.item_done();
end
endtask


 
endclass
 




















