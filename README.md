# Synchronous FIFO Verification: Directed → Layered → UVM

Verification of a synchronous FIFO in SystemVerilog, built up in three stages during my Digital IC Design & Verification training at GIKI (USTP):

1. **Directed testbench:** hand-written stimulus, checked on the waveform
2. **Layered testbench:** class-based, constrained-random stimulus with a self-checking scoreboard
3. **UVM testbench:** the same idea rebuilt with UVM components, sequences, phases and analysis ports

While verifying the provided FIFO I found a real bug: its `full` flag asserted one entry too early.

Simulated with Cadence Xcelium 24.09.

## Repository layout
```
rtl/
  sync_fifo_bug.sv      provided FIFO containing the bug (original, for reference)
  sync_fifo.sv          fixed FIFO (+ my own FIFO design, commented at the top)
1_directed_tb/
  tb_sync_fifo.sv       reset + back-to-back writes
2_layered_tb/
  fifo_if.sv            interface with driver / monitor clocking blocks
  fifo_transaction.sv   randomised transaction + constraints
  generator.sv          N random transactions → mailbox
  driver.sv             drives transactions onto the interface
  monitor.sv            samples DUT pins every cycle → mailbox
  scoreboard.sv         queue-based reference model, compares read data
  environment.sv        builds and connects the components
  test.sv, top.sv       test class, clock/reset/DUT instantiation
  files.f, xrun.log     compile list and log of the passing run
3_uvm_tb/
  fifo.sv               32-bit, depth-8 FIFO used for the UVM lab
  fifo_if.sv            interface
  fifo_item.sv          uvm_sequence_item
  fifo_sequence.sv      uvm_sequence: 20 randomised items
  fifo_sequencer.sv     uvm_sequencer
  fifo_driver.sv        uvm_driver: gets items from the sequencer
  fifo_monitor.sv       uvm_monitor: samples pins → analysis port
  fifo_agent.sv         uvm_agent: driver + sequencer + monitor
  scoreboard.sv         uvm_scoreboard: reference queue via analysis imp
  environment.sv        uvm_env: agent + scoreboard, port connections
  fifo_test.sv          uvm_test: starts the sequence, raises/drops objections
  fifo_pkg.sv           package including all classes
  fifo_top.sv           top module: DUT, interface, config_db, run_test()
  files.f               compile list
```

## 1. Directed testbench
`1_directed_tb/tb_sync_fifo.sv` applies reset and then a fixed sequence of writes (19, 16, 18, 25, 14) to push the FIFO up to full, and the waveform is checked by eye. It is quick to write, but every scenario has to be coded by hand and nothing is checked automatically. Those two limits are why I moved to a layered testbench.

## 2. Layered testbench
```
 generator ──mailbox──► driver ──► fifo_if ──► DUT
                                      │
 scoreboard ◄──mailbox── monitor ◄────┘
```
- **Transaction:** `wr_en`, `rd_en` and `data_in` are `rand`. Constraints keep `data_in` even and in the range 0–100, and make each cycle either a write or a read (`wr_en != rd_en`).
- **Generator:** 50 randomised transactions per run.
- **Driver / monitor:** use separate clocking blocks in `fifo_if` to avoid race conditions.
- **Scoreboard:** keeps a SystemVerilog queue as the reference model. Accepted writes are pushed, and every accepted read is compared with the popped value. To decide whether an operation was accepted, it uses the *previous* cycle's `full`/`empty`.

### Bug found
In the provided design (`rtl/sync_fifo_bug.sv`):
```systemverilog
assign full = (count >= (DEPTH - 1));   // full raised with DEPTH-1 entries
```
For a depth-8 FIFO, `full` went high at 7 entries, so the last slot could never be written. The fix:
```systemverilog
assign full = (count == depth);          // full only when every entry is used
```

### Result
With the fix, `2_layered_tb/xrun.log` shows **19 read comparisons passed, 0 failed**:
```
[SCB_PASS] Expected: 38, Actual: 38
[SCB_PASS] Expected: 2, Actual: 2
...
Simulation complete via $finish(1) at time 570 NS
```

## 3. UVM testbench
```
 fifo_test
 └── environment (uvm_env)
     ├── fifo_agent (uvm_agent)
     │   ├── fifo_sequencer ◄── fifo_sequence (20 random fifo_items)
     │   ├── fifo_driver ──► fifo_if ──► DUT
     │   └── fifo_monitor ◄── fifo_if
     │          │ mon_analysis_port
     └── scoreboard ◄┘ (uvm_analysis_imp)
```
- **Factory and config DB:** components are created with `type_id::create()`. The virtual interface is passed from `top` through `uvm_config_db`.
- **Phases:** `build_phase` creates the components and `connect_phase` wires driver↔sequencer and monitor→scoreboard. `run_phase` in the test raises an objection, starts the sequence on the agent's sequencer, then drops the objection.
- **Scoreboard timing:** `data_out` is registered, so read data is only valid one cycle after `rd_en`. The scoreboard records a *pending read* and compares against the reference queue on the next sample. My earlier version compared in the same cycle, before `data_out` had updated.

## Run
```bash
# Layered testbench
cd 2_layered_tb && xrun -sv -f files.f

# UVM testbench
cd 3_uvm_tb && xrun -uvm -sv -f files.f +UVM_TESTNAME=fifo_test
```

## Author
Abdul Samad Abbasi
