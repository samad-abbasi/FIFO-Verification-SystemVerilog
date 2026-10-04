module tb_sync_fifo ();
parameter depth = 4;
parameter data_width = 8;
logic clk,rst_n,wr_en,rd_en;
logic [data_width-1:0]data_in;
logic full,empty,overflow,underflow;
logic [data_width-1:0]data_out;
logic [$clog2(depth)-1:0] count;


sync_fifo dut(.clk(clk), .rst_n(rst_n), .data_in(data_in), .data_out(data_out), .count(count), .full(full), .empty(empty), .overflow(overflow),
.underflow(underflow), .wr_en(wr_en), .rd_en(rd_en));


initial begin 
clk=1;
forever #5 clk = ~clk;
end 

initial begin

//reset case
 rst_n = 1'b0; rd_en=1'b0 ; wr_en= 1'b0; data_in=8'd1;

//writing
#10;  rst_n = 1'b1; rd_en=1'b0 ; wr_en= 1'b1; data_in=8'd19;


//writing
#10;  rst_n = 1'b1; rd_en=1'b0 ; wr_en= 1'b1; data_in=8'd16;



//writing
#10;  rst_n = 1'b1; rd_en=1'b0 ; wr_en= 1'b1; data_in=8'd18;

#10;  rst_n = 1'b1; rd_en=1'b0 ; wr_en= 1'b1; data_in=8'd25;

//writing
#10;  rst_n = 1'b1; rd_en=1'b0 ; wr_en= 1'b1; data_in=8'd14;

//reading
//#10;  rst_n = 1'b1; rd_en=1'b1 ; wr_en= 1'b0; 

//reading
//#10;  rst_n = 1'b1; rd_en=1'b1 ; wr_en= 1'b0;

 
//reading
//#10;  rst_n = 1'b1; rd_en=1'b1 ; wr_en= 1'b0; 



#200;

$finish;

end 

endmodule


