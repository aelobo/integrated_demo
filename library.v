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
                        press_out <= 1'b1;
                    end
                    else begin
                        state <= STATE_IDLE;
                        press_out <= 1'b0;
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



module button_fsm(
    input               clock,
    input               reset,
    input       [7:0]   button_sync,
    output reg  [7:0]   rotor_sel
);

    reg [3:0] state;

parameter STATE_0    = 3'd0;
parameter STATE_1    = 3'd1;
parameter STATE_2    = 3'd2;
parameter STATE_3    = 3'd3;
parameter STATE_4    = 3'd4;
parameter STATE_5    = 3'd5;
parameter STATE_6    = 3'd6;
parameter STATE_7    = 3'd7;
parameter STATE_IDLE = 3'd8;

    always @(posedge clock) begin
        if (reset) begin
            state <= STATE_IDLE;
            rotor_sel <= 8'b0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    rotor_sel <= 8'b0; // Clear selection
                    case (button_sync)
                        8'b0000_0001: begin rotor_sel[0] <= 1'b1; state <= STATE_0; end
                        8'b0000_0010: begin rotor_sel[1] <= 1'b1; state <= STATE_1; end
                        8'b0000_0100: begin rotor_sel[2] <= 1'b1; state <= STATE_2; end
                        8'b0000_1000: begin rotor_sel[3] <= 1'b1; state <= STATE_3; end
                        8'b0001_0000: begin rotor_sel[4] <= 1'b1; state <= STATE_4; end
                        8'b0010_0000: begin rotor_sel[5] <= 1'b1; state <= STATE_5; end
                        8'b0100_0000: begin rotor_sel[6] <= 1'b1; state <= STATE_6; end
                        8'b1000_0000: begin rotor_sel[7] <= 1'b1; state <= STATE_7; end
                        default: begin rotor_sel <= 8'b0; state <= STATE_IDLE; end
                    endcase
                end

                STATE_0, STATE_1, STATE_2, STATE_3, STATE_4, STATE_5, STATE_6, STATE_7: begin
                    if (button_sync == (8'b1 << state)) begin
                        // Pressed the *same* button again -> clear and go idle
                        rotor_sel <= 8'b0;
                        state <= STATE_IDLE;
                    end else if (button_sync != 8'b0) begin
                        // Pressed a *different* button -> switch
                        rotor_sel <= 8'b0;
                        case (button_sync)
                            8'b0000_0001: begin rotor_sel[0] <= 1'b1; state <= STATE_0; end
                            8'b0000_0010: begin rotor_sel[1] <= 1'b1; state <= STATE_1; end
                            8'b0000_0100: begin rotor_sel[2] <= 1'b1; state <= STATE_2; end
                            8'b0000_1000: begin rotor_sel[3] <= 1'b1; state <= STATE_3; end
                            8'b0001_0000: begin rotor_sel[4] <= 1'b1; state <= STATE_4; end
                            8'b0010_0000: begin rotor_sel[5] <= 1'b1; state <= STATE_5; end
                            8'b0100_0000: begin rotor_sel[6] <= 1'b1; state <= STATE_6; end
                            8'b1000_0000: begin rotor_sel[7] <= 1'b1; state <= STATE_7; end
                            default: begin rotor_sel <= 8'b0; state <= STATE_IDLE; end
                        endcase
                    end
                end

            endcase
        end
    end

endmodule



module max_c7_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [7:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h30;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h30;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h30;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h30;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h30;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h30;
            8'b0_1_0_0_0_0_0_0: max_out = 8'h30;
			8'b1_0_0_0_0_0_0_0: max_out = max_in;

			default: 			max_out = max_in;
		endcase
	end
endmodule


module max_c6_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [3:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h9;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h9;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h9;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h9;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h9;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h9;
			8'b0_1_0_0_0_0_0_0: max_out = max_in;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h9;

			default: 			max_out = max_in;
		endcase
	end
endmodule

module max_c5_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [7:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h30;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h30;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h30;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h30;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h30;
			8'b0_0_1_0_0_0_0_0: max_out = max_in;
			8'b0_1_0_0_0_0_0_0: max_out = 8'h30;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h30;

			default: 			max_out = max_in;
		endcase
	end
endmodule

module max_c4_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [7:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h30;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h30;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h30;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h30;

			8'b0_0_0_1_0_0_0_0: max_out = max_in;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h30;
			8'b0_1_0_0_0_0_0_0: max_out = 8'h30;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h30;

			default: 			max_out = max_in;
		endcase
	end
endmodule

module max_c3_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [3:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h9;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h9;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h9;
			8'b0_0_0_0_1_0_0_0: max_out = max_in;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h9;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h9;
			8'b0_1_0_0_0_0_0_0: max_out = 8'h9;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h9;

			default: 			max_out = max_in;
		endcase
	end
endmodule

module max_c2_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [7:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h30;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h30;
			8'b0_0_0_0_0_1_0_0: max_out = max_in;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h30;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h30;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h30;
			8'b0_1_0_0_0_0_0_0: max_out = 8'h30;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h30;

			default: 			max_out = max_in;
		endcase
	end
endmodule

module max_c1_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [7:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = 8'h30;
			8'b0_0_0_0_0_0_1_0: max_out = max_in;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h30;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h30;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h30;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h30;
			8'b0_1_0_0_0_0_0_0: max_out = 8'h30;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h30;

			default: 			max_out = max_in;
		endcase
	end
endmodule

module max_c0_inputs (
    input       [7:0]   button_sync,
    input       [7:0]   max_in,
    output reg  [3:0]   max_out   
);
    always @* begin
		case (button_sync[7:0])
			8'b0_0_0_0_0_0_0_1: max_out = max_in;
			8'b0_0_0_0_0_0_1_0: max_out = 8'h9;
			8'b0_0_0_0_0_1_0_0: max_out = 8'h9;
			8'b0_0_0_0_1_0_0_0: max_out = 8'h9;

			8'b0_0_0_1_0_0_0_0: max_out = 8'h9;
			8'b0_0_1_0_0_0_0_0: max_out = 8'h9;
			8'b0_1_0_0_0_0_0_0: max_out = 8'h9;
            8'b1_0_0_0_0_0_0_0: max_out = 8'h9;

			default: 			max_out = max_in;
		endcase
	end
endmodule