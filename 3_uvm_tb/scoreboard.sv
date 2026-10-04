class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction

  uvm_analysis_imp #(fifo_item, scoreboard) scb_analysis_port;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_analysis_port = new("scb_analysis_port", this);
  endfunction

  bit [31:0] reference_queue [$];
  bit [31:0] expected;
  bit        pending_read;   // tracks a read requested last cycle, awaiting data_out

  virtual function void write(fifo_item tr);

    // STEP A: if a read was requested LAST cycle, its data_out is valid THIS cycle
    if (pending_read) begin
      expected = reference_queue.pop_front();
      $display("[SCOREBOARD] time=%0t expected=%0d actual=%0d", $time, expected, tr.data_out);
      if (expected != tr.data_out)
        `uvm_info("----Expected and Actual Data Error-----",
                   $sformatf("Expected : data_out=%0d , Actual : data_out=%0d", expected, tr.data_out), UVM_LOW)
      else
        `uvm_info("----Expected and Actual Data Matched-----",
                   $sformatf("Expected : data_out=%0d , Actual : data_out=%0d", expected, tr.data_out), UVM_LOW)
      pending_read = 0;
    end

    // STEP B: handle THIS cycle's write (push happens on its own real cycle)
    if (tr.wr_en && !tr.full) begin
      `uvm_info("SB", $sformatf("Received from monitor: wr_en=%0d, rd_en=%0d, data=%0d",
                 tr.wr_en, tr.rd_en, tr.data), UVM_LOW)
      reference_queue.push_back(tr.data);
    end

    // STEP C: THIS cycle's read request — don't compare yet, data_out isn't valid until next cycle
    if (tr.rd_en && !tr.empty) begin
      pending_read = 1;
    end
  endfunction
endclass