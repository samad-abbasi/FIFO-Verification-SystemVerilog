interface fifo_if#(parameter depth = 8, parameter data_width = 8 )(input clk,input rst_n);
logic wr_en,rd_en;
logic [data_width-1:0]data_in;
logic full,empty,overflow,underflow;
logic [data_width-1:0]data_out;
logic [$clog2(depth):0] count;



//driver
clocking driver_cb@(negedge clk);
default input #1step output #1ns;
output data_in,wr_en,rd_en;
input full,empty,overflow,underflow,data_out,count;


endclocking

//monitor
clocking monitor_cb@(negedge clk);
default input #1step output #1ns;
input full,empty,overflow,underflow,data_out,count,data_in,wr_en,rd_en;

endclocking


endinterface: fifo_if

