`default_nettype none

module rotary_letter(
    // Inputs
	clock,
    reset,

    enable,
    reset_val,
	
    rotary_a,
    rotary_b,

	// Outputs
	letter,
    increment,
);


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				clock;
input		        reset;

input               enable;
input       [4:0]   reset_val;

input               rotary_a;
input               rotary_b;

// Outputs
output reg	[4:0]	letter;
output reg          increment;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

wire                turned;
wire                direction;
// reg                 increment;

reg         [7:0]   count;

wire                A_sync;
wire                B_sync;

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

// Letter (A-Z) increment
always @(posedge clock) begin
    if (reset) begin
        count <= {reset_val, 2'b00};
        increment <= 1'b0;
    end
    else begin
        if (direction && turned && enable) begin // && enable
            if (count == 8'd0)
                count <= 8'd104;
            else 
                count <= count - 1'b1;
            increment <= 1'b0;
        end
        else if (turned && enable) begin // && enable
            if (count == 8'd104) begin
                count <= 8'd0;
                increment <= 1'b0;
            end 
            else begin
                count <= count + 1'b1;
                increment <= 1'b1;
            end
        end
        else begin
            count <= count;
            increment <= 1'b0;
        end
    end    
end

always @(posedge clock) begin
    if (reset)
        letter <= reset_val;
    else 
        letter <= (count >> 8'd2);    
end

// always @(posedge clock) begin
//     if (reset)
//         quad_turned <= 1'b0;
//     else if (turned && (count[1:0] == 2'b00)) 
//         quad_turned <= 1'b1;
//     else
//         quad_turned <= 1'b0;
// end

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Synchronizer #(1) SyncA (
        .clock              (clock),
        .async              (rotary_a),
        .sync               (A_sync)
);

Synchronizer #(1) SyncB (
        .clock              (clock),
        .async              (rotary_b),
        .sync               (B_sync)
);

Quad rotary_fsm(.clk(clock),
                .reset(reset),
                .A(A_sync),
                .B(B_sync),
                .turned(turned),
                .direction(direction)
);    

endmodule
