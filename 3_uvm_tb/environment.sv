
class environment extends uvm_env;

`uvm_component_utils(environment)

fifo_agent e_agent;
scoreboard e_scb;

function new(string name = "environment", uvm_component parent=null);
super.new(name, parent);
endfunction


virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e_agent = fifo_agent :: type_id :: create ("e_agent", this);
e_scb = scoreboard :: type_id :: create ("e_scb", this);
endfunction




virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
e_agent.m_mon.mon_analysis_port.connect(e_scb.scb_analysis_port);
endfunction








endclass



