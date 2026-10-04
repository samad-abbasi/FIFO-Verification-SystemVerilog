/*
My own FIFO design (extra MSB on the pointers for full/empty detection)
module sync_fifo #(parameter depth = 4, parameter data_width = 8 )
(
input  logic clk, rst_n, wr_en, rd_en,
input  logic [data_width-1:0] data_in,
output logic full, empty, overflow, underflow,
output logic [data_width-1:0] data_out,
output logic [$clog2(depth):0] count
);

logic [$clog2(depth):0] rd_ptr, wr_ptr;     
logic [data_width-1:0]  fifo [0:depth-1];

logic wr_fire, rd_fire;
assign wr_fire = wr_en && !full;
assign rd_fire = rd_en && !empty;

always @(posedge clk or negedge rst_n) begin
  //reset
  if (!rst_n) begin
    for (int i = 0; i < depth; i++) begin
      fifo[i] <= 0;
    end
    data_out <= 0;
    count    <= 0;
    rd_ptr   <= 0;
    wr_ptr   <= 0;
  end
  else begin
    // write
    if (wr_fire) begin
      fifo[wr_ptr[$clog2(depth)-1:0]] <= data_in;   
      wr_ptr <= wr_ptr + 1;
    end

    // read
    if (rd_fire) begin
      data_out <= fifo[rd_ptr[$clog2(depth)-1:0]]; 
      rd_ptr   <= rd_ptr + 1;
    end

  
    case ({wr_fire, rd_fire})
      2'b10:   count <= count + 1;   
      2'b01:   count <= count - 1;   
      default: count <= count;      
    endcase
  end
end

assign full  = (wr_ptr[$clog2(depth)]     != rd_ptr[$clog2(depth)]) &&
               (wr_ptr[$clog2(depth)-1:0] == rd_ptr[$clog2(depth)-1:0]);
assign empty = (wr_ptr == rd_ptr);
assign overflow  = (wr_en && full);
assign underflow = (rd_en && empty);

endmodule



*/





// Provided FIFO with the full-flag bug fixed (see README)
module sync_fifo #(
  parameter int data_width = 8,
  parameter int depth      = 8
 // parameter int ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  wr_en,
  input  logic                  rd_en,
  input  logic [data_width-1:0] data_in,
  output logic [data_width-1:0] data_out,
  output logic                  full,
  output logic                  empty,
  output logic                  overflow,
  output logic                  underflow,
  output logic [$clog2(depth):0]   count
);

  logic [data_width-1:0] mem [depth];
  logic [$clog2(depth)-1:0] wr_ptr, rd_ptr;

 // assign full  = (count >= (depth[$clog2(depth):0] - 1'b1));
//the fifo should be full be at equal to 8 for depth of 8 instead of count>=7 thats wrong

assign full = (count == depth);

  assign empty = (count == '0);

  wire wr_acc = wr_en & ~full;
  wire rd_acc = rd_en & ~empty;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr    <= '0;
      rd_ptr    <= '0;
      count     <= '0;
      data_out  <= '0;
      overflow  <= 1'b0;
      underflow <= 1'b0;
    end
    else begin
      overflow  <= wr_en & full;
      underflow <= rd_en & empty;

      if (wr_acc) begin
        mem[wr_ptr] <= data_in;
        wr_ptr      <= wr_ptr + 1'b1;
      end
      if (rd_acc) begin
        data_out <= mem[rd_ptr];
        rd_ptr   <= rd_ptr + 1'b1;
      end

      unique case ({wr_acc, rd_acc})
        2'b10:   count <= count + 1'b1;
        2'b01:   count <= count - 1'b1;
        default: count <= count;
      endcase
    end
  end

endmodule


