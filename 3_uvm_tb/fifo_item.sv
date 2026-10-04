

class fifo_item  extends uvm_sequence_item;
`uvm_object_utils(fifo_item)


function new(string name = "fifo_item");
super.new(name);
endfunction

rand bit wr_en,rd_en;
rand bit[31:0]data;
//rand bit [7:0]data_in;
//bit [7:0]data_out;
bit full,empty;
//bit [2:0] count;
bit [31:0]data_out;
constraint c1{wr_en != rd_en;}
endclass 

