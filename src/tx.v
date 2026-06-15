module tx (
    input wire clk,
    input wire reset,
    input wire [7:0]data,
    input wire baudTick,
    input wire txStart,
    output reg txData,
    output reg txDone,
    output reg txBusy
);
    localparam IDLE = 2'b00,
                START = 2'b01,
                DATA = 2'b10,
                STOP = 2'b11;
    reg[1:0] currentState,nextState;
    reg[2:0] bitCounter;
    reg[7:0] shiftReg;
    reg shiftBit;
    //currentState Logic
    always @(posedge clk or posedge reset) begin
        if(reset)begin
            currentState <= IDLE;
        end else begin
            currentState <= nextState;
        end
    end

    //nextState Logic
    always @(*)begin
        nextState = currentState;
        case(currentState)
            IDLE:begin
                if(txStart) nextState = START;
            end
            START:begin
                if(baudTick)nextState = DATA;
            end
            DATA:begin
                if(baudTick && bitCounter == 7) nextState = STOP;
            end
            STOP:begin
                if(baudTick)begin
                    if(txStart) nextState = START;
                    else nextState = IDLE;
                end
            end
            default: nextState = IDLE;
        endcase
    end
    
    //shift and counter logic 
    always @(posedge clk or posedge reset)begin
        if(reset)begin
            shiftReg <= 0;
            shiftBit <= 0;
            bitCounter <= 0;
        end else begin
            if(currentState == START)begin
                shiftReg<=data;
                bitCounter<=0;
            end else if(currentState == DATA)begin
                if(baudTick)begin
                    shiftBit<=shiftReg[0];//LSB first
                    shiftReg <= shiftReg >> 1;
                    bitCounter <= bitCounter + 1;
                end
            end else begin
                shiftReg<=0;
                shiftBit<=0;
                bitCounter<=0;
            end
        end
    end

    //output logic 
    always @(*)begin
        txData = 1'b1;
        case(currentState)
            IDLE: txData = 1'b1;
            START: txData = 1'b0;
            DATA: txData = shiftBit;
            STOP: txData = 1'b1;
            default: txData = 1'b1;
        endcase
    end
    
    //txbusy logic
    always@(*) txBusy = !(currentState == IDLE);

    //txDone logic
    always @(posedge clk or posedge reset)begin
        if(reset)txDone<=1'b0;
        else begin
            if(currentState == STOP && nextState == IDLE)begin
                txDone<=1'b1;
            end else txDone<=1'b0;
        end
    end
endmodule