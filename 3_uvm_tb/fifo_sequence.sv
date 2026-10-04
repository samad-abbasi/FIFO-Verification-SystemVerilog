


class fifo_sequence extends uvm_sequence #(fifo_item);
`uvm_object_utils(fifo_sequence)

function new(string name = "fifo_sequence");
super.new(name);
endfunction

fifo_item tr;

virtual task body();
repeat(20) begin
tr = fifo_item::type_id::create("tr");
start_item(tr);
assert(tr.randomize());
finish_item(tr);
//`uvm_info("[fifo_sequence]",$sformatf("data=%0d, wr_en= %0d,rd_en= %0d ",tr.data,tr.wr_en,tr.rd_en) , UVM_LOW)
end
endtask
endclass 

