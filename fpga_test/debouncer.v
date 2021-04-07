module debouncer (
  input clk, in, 
  input [3:0] t,
  output reg [0:0] out
);

reg [3:0] counter;

always @(posedge clk) begin
  if (in == 1 && counter < t) counter <= counter + 1;
  if (in == 0 && counter > 0) counter <= counter - 1;
  if (counter == 0) out[0] = 0;
  if (counter == t) out[0] = 1;
end


endmodule