module uart_top#(
    parameter baudRate = 9600,
    parameter systemFreq = 100_000_000
)(
    input wire clk,
    input wire reset,
    input wire [7:0]data,
    input wire txStart,
    output wire txDone,
    output wire txBusy,
    output wire baudTick,
    output wire txData
);

    baud inst(.clk(clk),.reset(reset),.baudTick(baudTick));
    tx inst1(.clk(clk),.reset(reset),.data(data),
    .baudTick(baudTick),.txStart(txStart),.txDone(txDone),.txData(txData),.txBusy(txBusy));

endmodule