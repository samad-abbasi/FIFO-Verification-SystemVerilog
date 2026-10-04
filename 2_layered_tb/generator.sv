//`include"fifo_transaction.sv"

class generator;

rand fifo_transaction fifo_trans;

mailbox #(fifo_transaction)gen2drive;


int repeat_count =50;

event ended;

function new(mailbox #(fifo_transaction)gen2drive);
this.gen2drive = gen2drive;

endfunction






task run();
int generated_count;
repeat(repeat_count) begin
fifo_trans = new();
if(!fifo_trans.randomize()) $fatal ("Gen:: trans randomization failed");
gen2drive.put(fifo_trans);
generated_count++;
$display("Data_in %0d Data_out %0d Wr_en %0d Rd_En %0d",fifo_trans.data_in,fifo_trans.data_out,fifo_trans.wr_en,fifo_trans.rd_en);

end 
$display("Total Gen transactions are:%d ", generated_count);
-> ended;

endtask

endclass

/*
module check;
generator g1;
mailbox #(fifo_transaction)gen2drive;
initial begin;
gen2drive = new();
g1 = new(gen2drive);
g1.run();
end
endmodule
*/
