/* Example of NOT instantiating a latch. */

module latch3
(
    input wire clk_16mhz,
    input wire button0,
    output reg [7:0] led
);

assign led[7:1] = 7'b0;

always @ (posedge clk_16mhz)
begin
    if (button0) begin
        led[0] <= ~led[0];
    end
end

endmodule

