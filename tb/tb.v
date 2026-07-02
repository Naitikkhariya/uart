`timescale 1ns/1ps

module testbench;

    // Simulation ko fast karne ke liye parameters
    parameter SYS_FREQ = 100_000_000;
    parameter SIM_BAUD = 10_000_000; 

    reg clk, reset, txStart;
    reg [7:0] data;

    wire baudTick;
    wire txDone;
    wire txBusy;
    wire txData;
    wire rxBusy, rxDone;
    wire [7:0] rxData;

    initial clk = 0;
    always #5 clk = ~clk; // 100MHz System Clock

    // Instantiate with overridden parameters
    uart_top #(
        .baudRate(SIM_BAUD),
        .systemFreq(SYS_FREQ)
    ) inst (
        .clk(clk),
        .reset(reset),
        .data(data),
        .txStart(txStart),
        .txDone(txDone),
        .txBusy(txBusy),
        .baudTick(baudTick),
        .txData(txData),
        .rxBusy(rxBusy),
        .rxData(rxData),
        .rxDone(rxDone)
    );

    // Aapka apna Task - Optimized for Synchronous Logic
    task txtest;
        input rst;
        input start;
        input [7:0] din;
        begin
            @(posedge clk); // Input changes aligned to clock edge
            reset   = rst;
            txStart = start;
            data    = din;
        end
    endtask

    // Naya Task: Data ko automatically verify karne ke liye
    task check_rx;
        input [7:0] expected_data;
        begin
            wait(rxDone); // RX complete hone ka wait karega
            
            if (rxData === expected_data)
                $display("[%0t] PASS: Sent = %d, Received = %d", $time, expected_data, rxData);
            else
                $display("[%0t] FAIL: Sent = %d, Received = %d", $time, expected_data, rxData);
        end
    endtask

    initial begin
        // --- 1. System Reset ---
        $display("Applying Reset...");
        txtest(1'b1, 1'b0, 8'd0);
        #20; 

        // --- 2. Test Case 1: Transmitting 8'd11 ---
        $display("\nSending Data 11...");
        txtest(1'b0, 1'b1, 8'd11); // txStart HIGH
        txtest(1'b0, 1'b0, 8'd11); // txStart LOW (Creates exactly 1 clock cycle pulse)
        
        check_rx(8'd11); // Auto-check output

        #100; // Chota sa gap between transmissions

        // --- 3. Test Case 2: Transmitting 8'b10101010 ---
        $display("\nSending Data 170 (10101010)...");
        txtest(1'b0, 1'b1, 8'b10101010);
        txtest(1'b0, 1'b0, 8'b10101010);
        
        check_rx(8'b10101010);

        #100;
        $display("\nSimulation Complete.");
        $stop;
    end

endmodule