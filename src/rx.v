module rx(
    input wire clk,
    input wire reset,
    input wire txData,
    input wire baudTick,
    output reg [7:0]rxData,
    output reg rxDone,
    output reg rxBusy
);
    localparam IDLE = 2'b00,
                START = 2'b01,
                DATA = 2'b10,
                STOP = 2'b11;
    
    reg[1:0] currentState,nextState;
    reg[2:0] bitCounter;
    reg[7:0] shiftReg;
    //currentState Logic
    always @(posedge clk or posedge reset)begin
        if(reset)begin
            currentState<=IDLE;
        end else begin
            currentState<=nextState;
        end
    end
    //nextState Logic
    always@(*)begin
        nextState=currentState;
        case(currentState)
            IDLE:begin
                if((!txData)) nextState = START;
            end
            START:begin
                if(baudTick)nextState = DATA;
            end
            DATA:begin
                if(baudTick && bitCounter == 3'd7) nextState = STOP;
            end
            STOP:begin
                if(baudTick)begin
                    nextState = IDLE;
                end
            end
        endcase
    end

    //shift and counter logic
    always @(posedge clk or posedge reset)begin
        if(reset)begin
            shiftReg<=0;
            bitCounter<=0;
        end else begin
            if(currentState == IDLE && nextState == START)begin
                shiftReg<=0;
                bitCounter<=0;
            end else if(currentState == DATA) begin
                if(baudTick)begin
                    shiftReg <= {txData,shiftReg[7:1]};
                    bitCounter <= bitCounter + 1;
                end
            end
        end
    end

    //output logic
    always @(posedge clk or posedge reset)begin
        if(reset)begin
            rxData<=8'd0;
        end else begin
            if(currentState == STOP)begin
                rxData<=shiftReg;
            end
        end
    end

    //rxDone logic
    always @(posedge clk or posedge reset)begin
        if(reset)begin
            rxDone<=1'b0;
        end else begin
            if(currentState == STOP && baudTick)begin
                rxDone<=1'b1;
            end else rxDone <= 1'b0;
        end
    end

    //rxBusy logic
    always@(*) rxBusy = !(currentState == IDLE);
endmodule