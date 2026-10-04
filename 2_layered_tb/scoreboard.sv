



class scoreboard;
  mailbox #(fifo_transaction) mon2scb;
  bit [7:0] reference_queue [$];

  bit prev_full  = 0;
  bit prev_empty = 1;  
 
  function new(mailbox #(fifo_transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction
 
  task run();
    fifo_transaction mon_item;
    bit [7:0] exp_data;
    forever begin
      mon2scb.get(mon_item);
 
      // gate using PRE-operation state (prev_full/prev_empty), not
      // mon_item's own full/empty which already reflects the outcome
      if (mon_item.wr_en && !prev_full) begin
        reference_queue.push_back(mon_item.data_in);
        $display("[SCB_WRITE] pushed: %0d", mon_item.data_in);
      end
 
      if (mon_item.rd_en && !prev_empty) begin
        if (reference_queue.size() == 0) begin
          $display("[SCB_ERROR] Reference queue desync - underflow!");
        end else begin
          exp_data = reference_queue.pop_front();
          if (exp_data == mon_item.data_out)
            $display("[SCB_PASS] Expected: %0d, Actual: %0d", exp_data, mon_item.data_out);
          else
            $display("[SCB_FAIL] Expected: %0d, Actual: %0d", exp_data, mon_item.data_out);
        end
      end
 
      // this cycle's full/empty becomes "previous" for the next mon_item
      prev_full  = mon_item.full;
      prev_empty = mon_item.empty;
    end
  endtask
endclass


