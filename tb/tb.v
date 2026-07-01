`timescale 1ns/1ps

module testbench;

    reg clk, reset, txStart;
    reg [7:0] data;

    wire baudTick;
    wire txDone;
    wire txBusy;
    wire txData;
    initial clk = 0;
    always #5 clk = ~clk;

    uart_top inst(
        .clk(clk),
        .reset(reset),
        .data(data),
        .txStart(txStart),
        .txDone(txDone),
        .txBusy(txBusy),
        .baudTick(baudTick),
        .txData(txData)
    );

    // Corrected Task
    task txtest;
        input rst;
        input start;
        input [7:0] din;
        begin
            reset   = rst;
            txStart = start;
            data    = din;
        end
    endtask

    initial begin

        txtest(1'b1, 1'b0, 8'd11);
        #10;

        txtest(1'b0, 1'b1, 8'd11);
        #10;

        txtest(1'b0, 1'b0, 8'd11);
        // Wait until transmission completes
        wait(txDone);
        #100;
        txtest(1'b0, 1'b1, 8'b10101010);
        #1_100_000;
        #100;
        $stop;
    end

endmodule