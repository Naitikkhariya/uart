module uart_top#(
    parameter baudRate = 9600,
    parameter systemFreq = 100_000_000
)(
    input wire clk,
    input wire reset,
    output wire baudTick
);

    baud inst(.clk(clk),.reset(reset),.baudTick(baudTick));

endmodule