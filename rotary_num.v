`default_nettype none

module rotary_num(
    // Inputs
	clock,
    reset,

    enable,
    reset_val,

    rotary_a,
    rotary_b,
	
	// Outputs
	num
);


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				clock;
input		        reset;

input               enable;
input       [2:0]   reset_val;

input               rotary_a;
input               rotary_b;

// Outputs
output reg	[2:0]	num;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

wire                turned;
wire                direction;
reg                 increment;

reg         [5:0]   num_count;

wire                A_sync;
wire                B_sync;

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

// Number (0-7) increment
always @(posedge clock) begin
    if (reset) begin
        num_count <= {reset_val, 2'b00};
    end
    else begin
        if (direction && turned && enable) begin
            if (num_count == 6'd0)
                num_count <= 6'd32;
            else 
                num_count <= num_count - 1'b1;
        end
        else if (turned && enable) begin
            if (num_count == 6'd32)
                num_count <= 6'd0;
            else
                num_count <= num_count + 1'b1;
        end
        else
            num_count <= num_count;
    end    
end

always @(posedge clock) begin
    if (reset)
        num <= reset_val;
    else 
        num <= (num_count >> 6'd2);    
end

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
