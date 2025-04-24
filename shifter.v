`default_nettype none

module shifter (
    input           clk,
    input           rst,
    input           en,
    input   [31:0]  parallel_in,

    output reg      serial,
    output reg      output_en_l,
    output reg      rclk
);
    // 4 states: START, SHIFT, WAIT, WAIT2
    localparam [1:0]
        START  = 2'd0,
        SHIFT  = 2'd1,
        WAIT   = 2'd2,
        WAIT2  = 2'd3;

    reg [1:0] state;
    reg [4:0] cnt;  // will count 31 down to 0

    always @(posedge clk) begin
        if (rst) begin
            state        <= START;
            cnt          <= 5'd31;
            serial       <= 1'b0;
            output_en_l  <= 1'b0;
            rclk         <= 1'b0;
        end
        else begin
            case (state)
                START: begin
                    if (en) begin
                        state <= SHIFT;
                        cnt   <= 5'd31;
                    end
                    output_en_l <= 1'b0;
                    rclk        <= 1'b0;
                end

                SHIFT: begin
                    // shift out current bit
                    serial      <= parallel_in[cnt];
                    output_en_l <= 1'b0;
                    rclk        <= 1'b0;

                    if (cnt == 5'd0)
                        state <= WAIT;        // done all 32 bits
                    else
                        cnt   <= cnt - 1;     // next bit
                end

                WAIT: begin
                    serial      <= 1'b0;
                    output_en_l <= 1'b0;
                    rclk        <= 1'b0;
                    state       <= WAIT2;
                end

                WAIT2: begin
                    serial      <= 1'b0;
                    output_en_l <= 1'b0;
                    rclk        <= 1'b1;   // latch pulse
                    state       <= START;
                end
            endcase
        end
    end

endmodule
