`include "uvm_macros.svh"
import uvm_pkg::*;




class fifo_agent extends uvm_agent;

`uvm_component_utils(fifo_agent)

function new(string name ="fifo_agent", uvm_component parent=null);
super.new(name,parent);
endfunction


fifo_driver m_drv; 
fifo_monitor m_mon;
fifo_sequencer m_sqr;

//uvm_sequence #(fifo_item) sqr;

virtual function void build_phase(uvm_phase phase);

  super.build_phase(phase);   

m_drv = fifo_driver :: type_id :: create ("m_drv", this);

m_sqr = fifo_sequencer :: type_id :: create ("m_sqr", this);

m_mon = fifo_monitor :: type_id :: create ("m_mon", this);

endfunction


virtual function void connect_phase (uvm_phase phase);
m_drv.seq_item_port.connect(m_sqr.seq_item_export);

endfunction

endclass
