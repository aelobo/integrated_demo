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
        end
        else begin
            case(state)
                STATE_IDLE: begin
                    for (integer i = 0; i < 8; i = i + 1) begin
                        if (button_sync == (8'b1 << i)) begin
                            rotor_sel[i] <= 1'b1;
                            state <= i[2:0]; // state now directly equals i
                        end
                        else begin   
                            rotor_sel[i] <= 1'b0;
                            state <= STATE_IDLE;
                        end
                    end
                end
                STATE_0: begin
                    if (button_sync == (8'b1 << 0)) begin
                        rotor_sel[0] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 0)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin   
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_0;
                            end
                        end
                    end
                end
                STATE_1: begin
                    if (button_sync == (8'b1 << 1)) begin
                        rotor_sel[1] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 1)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin   
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_1;
                            end
                        end
                    end
                end
                STATE_2: begin
                    if (button_sync == (8'b1 << 2)) begin
                        rotor_sel[2] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 2)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin  
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_2;
                            end
                        end
                    end
                end
                STATE_3: begin
                    if (button_sync == (8'b1 << 3)) begin
                        rotor_sel[3] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 3)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_3;
                            end
                        end
                    end
                end
                STATE_4: begin
                    if (button_sync == (8'b1 << 4)) begin
                        rotor_sel[4] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 4)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_4;
                            end
                        end
                    end
                end
                STATE_5: begin
                    if (button_sync == (8'b1 << 5)) begin
                        rotor_sel[5] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 5)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_5;
                            end
                        end
                    end
                end
                STATE_6: begin
                    if (button_sync == (8'b1 << 6)) begin
                        rotor_sel[6] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 6)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin   
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_6;
                            end
                        end
                    end
                end
                STATE_7: begin
                    if (button_sync == (8'b1 << 7)) begin
                        rotor_sel[7] <= 1'b0;
                        state <= STATE_IDLE;
                    end
                    else begin
                        for (integer i = 0; i < 8; i = i + 1) begin
                            if (button_sync == (8'b1 << i) && (i != 7)) begin
                                rotor_sel[i] <= 1'b1;
                                state <= i[2:0]; // state now directly equals i
                            end
                            else begin   
                                rotor_sel[i] <= 1'b0;
                                state <= STATE_7;
                            end
                        end
                    end
                end
            endcase
    end
    end


endmodule