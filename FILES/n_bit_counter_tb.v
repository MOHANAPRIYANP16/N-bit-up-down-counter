`timescale 1ns/1ps

module tb_updown_counter;

    parameter N = 4;

    reg clk;
    reg rst;
    reg enable;
    reg up_down;
    wire [N-1:0] count;
    wire overflow;

    // DUT instantiation
    updown_counter #(
        .N(N)
    ) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .up_down(up_down),
        .count(count),
        .overflow(overflow)
    );

    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk     = 0;
        rst     = 1;
        enable  = 0;
        up_down = 1;

        // Reset
        #20;
        rst = 0;

        // Enable UP counting
        enable  = 1;
        up_down = 1;

        // Run long enough to overflow
        #200;

        // Switch to DOWN counting
        up_down = 0;

        // Run long enough to underflow
        #200;

        // Disable counter
        enable = 0;
        #50;

        // Re-enable UP counting
        enable  = 1;
        up_down = 1;
        #100;

        $finish;
    end

endmodule
