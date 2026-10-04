// fifo_if.sv
interface fifo_if(input bit clk);
logic rst_n;
logic [31:0] data;
logic wr_en;
logic rd_en;
logic full;
logic empty;
logic [31:0]data_out;
endinterface
