`timescale 1ns/1ps

module updown_counter #(
    parameter N = 8
)(
    input  wire             clk,
    input  wire             rst,      // synchronous reset
    input  wire             enable,
    input  wire             up_down,  // 1 = up, 0 = down
    output reg  [N-1:0]     count,
    output reg              overflow
);

    localparam [N-1:0] MAX_VAL = {N{1'b1}};

    always @(posedge clk) begin
        if (rst) begin
            count    <= {N{1'b0}};
            overflow <= 1'b0;
        end
        else if (enable) begin
            overflow <= 1'b0;  // default

            if (up_down) begin
                // UP counting
                if (count == MAX_VAL) begin
                    count    <= {N{1'b0}};
                    overflow <= 1'b1;
                end
                else begin
                    count <= count + 1'b1;
                end
            end
            else begin
                // DOWN counting
                if (count == {N{1'b0}}) begin
                    count    <= MAX_VAL;
                    overflow <= 1'b1;
                end
                else begin
                    count <= count - 1'b1;
                end
            end
        end
        else begin
            overflow <= 1'b0; // no spurious flag when disabled
        end
    end

endmodule
