`timescale 1ns/1ps
module testbench;
    reg clk,reset;
    wire baudTick;

    initial clk = 0;
    always #5 clk = ~clk;

    uart_top inst(.clk(clk),.reset(reset),.baudTick(baudTick));

    initial begin
        reset = 1'b1;
        #100;
        reset = 1'b0;
        #300000;
        $stop;
    end
endmodule