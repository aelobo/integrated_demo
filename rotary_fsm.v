`default_nettype none

module Quad(
    input clk,
    input reset,
    input A,
    input B,
    output reg turned,
    output reg direction,
    output reg quad_increment
    );    

    (*ASYNC_REG="TRUE"*)reg[1:0] sync, AB; // synchronization registers
    reg[1:0] state;
    localparam S00=2'b00, S01=2'b01, S10=2'b10, S11=2'b11; // states

    always @ (posedge clk) // two-stage input synchronizer
        begin
            sync <= {A,B};
            AB <= sync;
        end

    always @(posedge clk) // always block to compute output
        begin 
            if(reset) begin
                state <= S00;
                turned <= 0;
                direction <= 0;
                quad_increment <= 0;
            end else
                case(state)              
                    S00: begin 
                        if(AB == 2'b01) begin
                            turned <= 1;
                            direction <= 0;
                            state <= S01;
                        end else if(AB == 2'b10) begin
                            turned <= 1;
                            direction <= 1;
                            state <= S10;
                        end             
                        else begin
                            turned <= 0;
                            direction <= 0;
                            state <= S00;
                        end
                        quad_increment <= 0;    
                    end      

                    S01: begin
                        if(AB == 2'b00) begin
                            turned <= 1;
                            direction <= 1;
                            state <= S00;
                            quad_increment <= 1;
                        end else if(AB == 2'b11) begin
                            turned <= 1;
                            direction <= 0;
                            state <= S11;
                            quad_increment <= 1;
                        end  
                        else begin
                            turned <= 0;
                            direction <= 0;
                            state <= S01;
                            quad_increment <= 0;
                        end
                        // quad_increment <= 0; 
                    end 

                    S10: begin
                        if(AB == 2'b00) begin
                            turned <= 1;
                            direction <= 0;
                            state <= S00;
                        end else if(AB == 2'b11) begin
                            turned <= 1;
                            direction <= 1;
                            state <= S11;
                        end           
                        else begin
                            turned <= 0;
                            direction <= 0;
                            state <= S10;
                        end
                        quad_increment <= 0; 
                    end   

                    S11: begin
                        if(AB == 2'b01) begin
                            turned <= 1;
                            direction <= 1;
                            state <= S01;
                        end else if(AB == 2'b10) begin
                            turned <= 1;
                            direction <= 0;
                            state <= S10;
                        end
                        else begin
                            turned <= 0;
                            direction <= 0;
                            state <= S11;
                        end
                        quad_increment <= 0;
                    end
                endcase
        end 
endmodule