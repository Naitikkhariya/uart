module baud#(
    parameter baudRate = 9600,
    parameter systemFreq = 100_000_000
)(
    input wire clk,
    input wire reset,
    output reg baudTick
);
    localparam baudCount = systemFreq/baudRate;

    reg[$clog2(baudCount):0] counter;

    always@(posedge clk or posedge reset)begin
        if(reset)begin
            counter <= 0;
        end else begin
            if(counter >= baudCount-1)begin
                counter<=0;
            end else counter <= counter + 1;
        end
    end

    always@(*)begin
        if(counter == baudCount - 1) baudTick = 1'b1;
        else baudTick = 1'b0;
    end
endmodule