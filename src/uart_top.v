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
    output wire txData,
    output wire [7:0]rxData,
    output wire rxDone,
    output wire rxBusy
);

    baud baud_inst(.clk(clk),.reset(reset),.baudTick(baudTick));
    tx tx_inst(.clk(clk),.reset(reset),.data(data),
    .baudTick(baudTick),.txStart(txStart),.txDone(txDone),.txData(txData),.txBusy(txBusy));
    rx rx_inst(.clk(clk),.reset(reset),.txData(txData),
    .baudTick(baudTick),.rxData(rxData),.rxDone(rxDone),.rxBusy(rxBusy));
endmodule