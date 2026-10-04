class fifo_transaction;
rand bit wr_en,rd_en;
rand bit [7:0]data_in;
bit [7:0]data_out;
bit full,empty,overflow,underflow,count;

static bit transaction_id = 0;

function new();
transaction_id++;
endfunction


function void display();
$display("wr_en= %d,rd_en= %d, data_in= %d, data_out= %d, full= %d, empty= %d,overflow=          %d,underflow=%d,transaction_id=%d", wr_en, rd_en, data_in, data_out, full, empty, overflow, underflow,transaction_id);
endfunction



//copy function
function copy_transaction();

fifo_transaction t = new();

t.transaction_id=transaction_id;
t.wr_en = wr_en;
t.rd_en = rd_en;
t.data_in=data_in;
t.data_out=data_out;
t.full=full;
t.empty=empty;
t.overflow=overflow;
t.underflow=underflow;
t.count=count;

endfunction


//constraint c_1{data_in inside {[0:100]} && {data_in % 8'd2 ==8'd0}; }
constraint c_1 {
  data_in inside {[0:100]};
  data_in % 8'd2 == 8'd0;
  wr_en != rd_en;
}

endclass

/*module check;
fifo_transaction t1;
initial begin;
repeat (30) begin
t1 = new();
t1.randomize();
t1.display();
end
end
endmodule
*/

