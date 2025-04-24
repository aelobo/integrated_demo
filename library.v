`default_nettype none

module Synchronizer #(parameter WIDTH=1) (
    input clock,
    input [WIDTH-1:0] async,

    output reg [WIDTH-1:0] sync
);

    reg [WIDTH-1:0] temp;

    always @(posedge clock) begin
        temp <= async;
        sync <= temp;
    end

endmodule

module button_press_fsm (
    input               i_clock,
    input               reset,
    input               press_in,
    output reg          press_out
);

    reg state;

    parameter STATE_IDLE    = 1'b0;
    parameter STATE_PRESSED = 1'b1;

    always @(posedge i_clock) begin
        if (reset) begin
            state <= STATE_IDLE;
            press_out <= 1'b0;
        end
        else 
            case (state)
                STATE_IDLE: begin
                    if (press_in) begin
                        state <= STATE_PRESSED;
                        press_out <= 1'b0;
                    end
                    else begin
                        state <= STATE_IDLE;
                        press_out <= 1'b0;
                    end
                end
                STATE_PRESSED: begin
                    if (press_in) begin
                        state <= STATE_PRESSED;
                        press_out <= 1'b0;
                    end
                    else begin
                        state <= STATE_IDLE;
                        press_out <= 1'b1;
                    end
                end
                default: begin
                    state <= STATE_IDLE;
                    press_out <= 1'b0;
                end
            endcase
    end

endmodule

module depressed_fsm (
    input               i_clock,
    input               reset,
    input       [7:0]   press_in,
    output reg  [7:0]   press_out
);

    reg state;

    parameter STATE_IDLE    = 1'b0;
    parameter STATE_PRESSED = 1'b1;

    always @(posedge i_clock) begin
        if (reset) begin
            state <= STATE_IDLE;
            press_out <= 8'b0;
        end
        else 
            case (state)
                STATE_IDLE: begin
                    if (press_in[7:0] != 8'b0) begin
                        state <= STATE_PRESSED;
                        press_out <= press_in[7:0];
                    end
                    else begin
                        state <= STATE_IDLE;
                        press_out <= press_out[7:0];
                    end
                end
                STATE_PRESSED: begin
                    if (press_in[7:0] != 8'b0) begin
                        state <= STATE_PRESSED;
                        press_out <= press_out[7:0];
                    end
                    else begin
                        state <= STATE_IDLE;
                        press_out <= press_out[7:0];
                    end
                end
                default: begin
                    state <= STATE_IDLE;
                    press_out <= 8'b0;
                end
            endcase
    end

endmodule


module increment_fsm (
    input               clock,
    input               reset,
    input               turned,
    output reg          increment
);

    reg [2:0] state;

    parameter STATE_IDLE    = 3'd0;
    parameter STATE_1 = 3'd1;
    parameter STATE_2 = 3'd2;
    parameter STATE_3 = 3'd3;
    parameter STATE_4 = 3'd4;

    always @(posedge clock) begin
        if (reset) begin
            state <= STATE_IDLE;
            increment <= 1'b0;
        end
        else begin
            case(state)
                STATE_IDLE: begin
                    state <= (turned) ? STATE_1 : STATE_IDLE;
                    increment <= 1'b0;
                end
                STATE_1: begin
                    state <= STATE_2;
                    increment <= 1'b0;
                end
                STATE_2: begin
                    state <= STATE_3;
                    increment <= 1'b0;
                end
                STATE_3: begin
                    state <= STATE_4;
                    increment <= 1'b0;
                end
                STATE_4: begin
                    state <= STATE_IDLE;
                    increment <= 1'b1;
                end

            endcase
        end
    end

endmodule


module simple_fsm(
    input               clock,
    input               reset,
    input               button_sync,
    output reg          rotor_enable
);

    reg [1:0] state;

    parameter STATE_IDLE    = 3'd0;
    parameter STATE_HELD = 3'd1;
    parameter STATE_RELEASED = 3'd2;


    always @(posedge clock) begin
        if (reset) begin
            state <= STATE_IDLE;
            rotor_enable <= 1'b0;
        end
        else 
            case (state)
                STATE_IDLE: begin
                    if (button_sync) begin
                        state <= STATE_HELD;
                        rotor_enable <= 1'b0;
                    end
                    else begin
                        state <= STATE_IDLE;
                        rotor_enable <= 1'b0;
                    end
                end
                STATE_HELD: begin
                    if (!button_sync) begin
                        state <= STATE_RELEASED;
                        rotor_enable <= 1'b0;
                    end
                    else begin
                        state <= STATE_HELD;
                        rotor_enable <= 1'b1;
                    end
                end
                STATE_RELEASED: begin
                    state <= STATE_IDLE;
                    rotor_enable <= 1'b0;
                end
                default: begin
                    state <= STATE_IDLE;
                    rotor_enable <= 1'b0;
                end
            endcase
    end


endmodule