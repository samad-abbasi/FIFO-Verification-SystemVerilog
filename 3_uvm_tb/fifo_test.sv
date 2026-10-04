
class fifo_test extends uvm_test;

`uvm_component_utils(fifo_test)

environment env;

function new(string name = "fifo_test", uvm_component parent=null);
super.new(name, parent);
endfunction


virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = environment :: type_id :: create ("env", this);
endfunction


virtual task run_phase(uvm_phase phase);

fifo_sequence seq;
seq = fifo_sequence :: type_id :: create ("seq", this);

phase.raise_objection(this, "Start fifo_sequence");
seq.start(env.e_agent.m_sqr);
phase.drop_objection(this, "End fifo_sequence");
endtask

endclass



