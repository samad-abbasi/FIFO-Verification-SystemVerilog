module fifo #(parameter DEPTH = 8, WIDTH = 32) (
input logic clk,
input logic rst_n,
input logic [WIDTH-1:0] data,
input logic wr_en,
input logic rd_en,
output logic full,
output logic empty,
output logic [WIDTH-1:0] data_out
);
  logic [WIDTH-1:0] mem [0:DEPTH-1];
int wr_ptr, rd_ptr, count;
assign full = (count == DEPTH);
assign empty = (count == 0);
always_ff @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
wr_ptr <= 0; rd_ptr <= 0; count <= 0;
end else begin
if (wr_en && !full) begin
mem[wr_ptr] <= data;
wr_ptr <= (wr_ptr + 1) % DEPTH;
count <= count + 1;
end
if (rd_en && !empty) begin
data_out <= mem[rd_ptr];
rd_ptr <= (rd_ptr + 1) % DEPTH;
count <= count - 1;
end
end
end
endmodule
