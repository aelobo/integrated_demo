`default_nettype none

module integrated_demo (
	// Inputs
	CLOCK_50,
	KEY,
    SW,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
    GPIO,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

    LEDR
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;
input       [9:0]   SW;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;
inout       [35:0]  GPIO;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;

output      [9:0]   LEDR;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire                ps2_clk_posedge;

wire		[7:0]	received_data;
wire				received_data_en;

wire        [7:0]   o_outputData;
wire                o_valid;  

wire                rotor_start_3_sel, rotor_start_2_sel, rotor_start_1_sel;
wire                rotor_num_3_sel, rotor_num_2_sel, rotor_num_1_sel;
wire                rotor_ring_2_sel, rotor_ring_1_sel;

wire        [4:0]   rotor_start_3, rotor_start_2, rotor_start_1; // rotor starting position

wire        [9:0]   SW_sync;
wire        [3:0]   KEY_sync; 
wire		[7:0]	button_sync;    

wire                A_sync, B_sync;

wire 				rotor_3_num_increment, rotor_2_num_increment, rotor_1_num_increment;

wire                update_settings_out;

wire        [4:0]   rotor3_out, rotor2_out, rotor1_out;
wire        [4:0]   rotor3_num, rotor2_num, rotor1_num;
wire        [4:0]   rotor3_ring, rotor2_ring, rotor1_ring;

wire        [7:0]  	c0, c1, c2, c3, c4, c5, c6, c7;

wire 		[7:0] 	c7_in, c5_in, c4_in, c2_in, c1_in;
wire 		[3:0] 	c6_in, c3_in, c0_in;

wire 		[7:0] 	c7_out, c5_out, c4_out, c2_out, c1_out;
wire 		[3:0] 	c6_out, c3_out, c0_out;



// Internal Registers
reg         [2:0]   state;
reg                 rotate;             // rotate signal, input to State_Machine

reg         [7:0]   history;            // registered scan code             (plaintext)
wire        [7:0]   ascii_plaintext;    // scan code -> ascii conversion    (plaintext)
reg         [7:0]   encoded_data;       // encoded ascii value              (ciphertext)

reg  		[31:0] 	parallel_in;		// lampboard stuff
wire 		[31:0]	lampboard;			// more lamp


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

parameter STATE_INIT    = 3'd0;
parameter STATE_IDLE    = 3'd1;
parameter STATE_MAKE    = 3'd2;
parameter STATE_BREAK   = 3'd3;
parameter STATE_WAIT    = 3'd4;

reg [12:0] counter;

always @(posedge CLOCK_50) begin
    // On reset, go to IDLE state
    if (~KEY_sync[0]) begin
        state <= STATE_INIT;
        rotate <= 1'b1;
        history <= 8'b0;
        counter <= 13'b0;
        encoded_data <= 8'h00;
    end
    else begin
        case (state)
            STATE_INIT: begin
                state <= STATE_IDLE;
                rotate <= 1'b1;
                history <= 8'b0;
                counter <= 13'b0;
                encoded_data <= 8'h00;
            end
            STATE_IDLE: begin
                if (received_data_en) begin
                    state   <= STATE_MAKE;
                    history <= received_data;
                end
                else begin
                    state   <= STATE_IDLE;
                    history <= history;
                end
                rotate <= 1'b0;
                encoded_data <= 8'h00;
            end
            STATE_MAKE: begin
                if ((received_data == 8'hF0)) begin
                    state   <= STATE_BREAK;
                end
                else begin
                    state   <= STATE_MAKE;
                end
                history <= history;
                rotate <= 1'b0;
                encoded_data <= o_outputData;
            end
            STATE_BREAK: begin
                if ((received_data == history)) begin
                    state   <= STATE_WAIT;
                    // rotate <= 1'b1;
                    rotate <= o_valid;
                    counter <= 13'b0;
                end
                else begin
                    state   <= STATE_BREAK;
                    rotate <= 1'b0;
                end
                history <= history;
                encoded_data <= 8'h00;
            end 
            STATE_WAIT: begin
                if (counter == 13'd5000)
                    state <= STATE_IDLE;
                else
                    state <= STATE_WAIT;
                history <= history;
                // rotate <= 1'b1;
                rotate <= rotate;
                counter <= counter + 13'b1;
                encoded_data <= 8'h00;
            end   
            default: begin
                state <= STATE_IDLE;
                history <= 8'b0;
                rotate <= 1'b0;
                counter <= 13'b0;
                encoded_data <= 8'h00;
            end
        endcase
    end
end


// CLOCK DIVIDER FOR MAX SEVEN SEGMENT
// 3-bit counter to count from 0 to 4
reg [2:0] clk_counter;
reg       clk_out;

always @(posedge CLOCK_50) begin
if (~KEY[0]) begin
    clk_counter <= 3'd0;
    clk_out <= 1'b0;
end else begin
    // increment counter; reset to 0 when count reaches 4
    if (clk_counter == 3'd4)
    clk_counter <= 3'd0;
    else
    clk_counter <= clk_counter + 3'd1;
    
    // generate clk_out: high for 2 cycles, low for 3 cycles
    if (clk_counter < 3'd2)
    clk_out <= 1'b1;
    else
    clk_out <= 1'b0;
end
end


// LAMPBOARD
always @(posedge clk_out) begin
	if (~KEY[0])
		parallel_in <= 32'd0;
	else
		parallel_in <= lampboard[31:0];
end


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX1 = 7'h7F;
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;

assign LEDR[0] = ~button_sync[7];
assign LEDR[1] = ~button_sync[6];
assign LEDR[2] = ~button_sync[5];
assign LEDR[3] = ~button_sync[4];
assign LEDR[4] = ~button_sync[3];
assign LEDR[5] = ~button_sync[2];
assign LEDR[6] = ~button_sync[1];
assign LEDR[7] = ~button_sync[0]; 

assign c7_in = {3'b0, rotor3_out[4:0]} + 8'h40;
assign c6_in = {rotor3_num[3:0] + 4'b1};
assign c5_in = {3'b0, rotor2_ring[4:0]} + 8'h41;
assign c4_in = {3'b0, rotor2_out[4:0]} + 8'h41;
assign c3_in = {rotor2_num[3:0] + 4'b1};
assign c2_in = {3'b0, rotor1_ring[4:0]} + 8'h41;
assign c1_in = {3'b0, rotor1_out[4:0]} + 8'h41;
assign c0_in = {rotor1_num[3:0] + 4'b1};

assign rotor_start_3_sel    =  ~button_sync[7];
assign rotor_num_3_sel      =  ~button_sync[6];
assign rotor_ring_2_sel     =  ~button_sync[5];
assign rotor_start_2_sel    =  ~button_sync[4];
assign rotor_num_2_sel      =  ~button_sync[3];
assign rotor_ring_1_sel     =  ~button_sync[2];
assign rotor_start_1_sel    =  ~button_sync[1];
assign rotor_num_1_sel      =  ~button_sync[0];

assign GPIO[32] = clk_out; // shift register


/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

    PS2_Controller PS2 (
        // Inputs
        .CLOCK_50			(CLOCK_50),
        .reset				(~KEY_sync[0]),

        // Bidirectionals
        .PS2_CLK			(PS2_CLK),
        .PS2_DAT			(PS2_DAT),

        // Outputs
        .received_data		(received_data),
        .received_data_en	(received_data_en)
    );

    // Convert scan code to ASCII for encryption
    Scan_Code_to_ASCII ASCII (
        .scan_code          (history),
        .ascii_plaintext    (ascii_plaintext) // input as ASCII
    );

    // State machine to control encryption
    State_Machine Enigma (
        .i_clock			(CLOCK_50),
        .reset				(~KEY_sync[0]),
        .i_inputData        (ascii_plaintext),
        .rotate             (rotate),

        .rotor_ring_2_en    (rotor_ring_2_sel),
        .rotor_ring_1_en    (rotor_ring_1_sel),

        .rotor_start_3_en   (rotor_start_3_sel),
        .rotor_start_2_en   (rotor_start_2_sel),
        .rotor_start_1_en   (rotor_start_1_sel),

        .rotor_num_3_en     (rotor_num_3_sel),
        .rotor_num_2_en     (rotor_num_2_sel),
        .rotor_num_1_en     (rotor_num_1_sel),

		// .rotor_2_ring_increment (rotor_2_ring_increment),
		// .rotor_1_ring_increment (rotor_1_ring_increment),

		.rotor_3_num_increment (rotor_3_num_increment),
		.rotor_2_num_increment (rotor_2_num_increment),
		.rotor_1_num_increment (rotor_1_num_increment),

        .o_outputData	    (o_outputData), // final output (in decimal)
        .o_valid            (o_valid),
        .update_settings_out(update_settings_out),

		.rotor_start_3		(rotor_start_3),

        .rotor2_ring        (rotor2_ring),
        .rotor1_ring        (rotor1_ring),
        
        .rotor3_out         (rotor3_out),
        .rotor2_out         (rotor2_out),
        .rotor1_out         (rotor1_out),

        .rotor3_num         (rotor3_num),
        .rotor2_num         (rotor2_num),
        .rotor1_num         (rotor1_num),

        .rotary_a           (A_sync),
        .rotary_b           (B_sync)
    );

	// Rotary Encoder Synchronizer
	Synchronizer #(1) SyncA (.clock(CLOCK_50), .async(GPIO[0]), .sync(A_sync));
	Synchronizer #(1) SyncB (.clock(CLOCK_50), .async(GPIO[2]), .sync(B_sync));

    // Plaintext on HEX0, Ciphertext on HEX2
    Scan_Code_to_Seven_Segment 	Segment0 (.scan_code(history[7:0]), .seven_seg_display(HEX0));
    ASCII_to_Seven_Segment 		Segment1 (.ascii(encoded_data[7:0]),.seven_seg_display(HEX2));

	// Blank MAX Displays on Button Press
	max_c7_inputs	c7_input(.button_sync(~button_sync[7:0]), .max_in(c7_in), .max_out(c7_out));
	max_c6_inputs 	c6_input(.button_sync(~button_sync[7:0]), .max_in(c6_in), .max_out(c6_out));
	max_c5_inputs 	c5_input(.button_sync(~button_sync[7:0]), .max_in(c5_in), .max_out(c5_out));
	max_c4_inputs 	c4_input(.button_sync(~button_sync[7:0]), .max_in(c4_in), .max_out(c4_out));
	max_c3_inputs 	c3_input(.button_sync(~button_sync[7:0]), .max_in(c3_in), .max_out(c3_out));
	max_c2_inputs 	c2_input(.button_sync(~button_sync[7:0]), .max_in(c2_in), .max_out(c2_out));
	max_c1_inputs 	c1_input(.button_sync(~button_sync[7:0]), .max_in(c1_in), .max_out(c1_out));
	max_c0_inputs 	c0_input(.button_sync(~button_sync[7:0]), .max_in(c0_in), .max_out(c0_out));
    
	// Display on MAX
    ASCII_to_MAX 	C7	(.ascii(c7_out), 	.seven_seg_display(c7));	// ROTOR 3 STARTING POSITION
    Decimal_to_MAX 	C6	(.decimal(c6_out),	.seven_seg_display(c6));	// ROTOR 3 ROTOR NUMBER
    ASCII_to_MAX 	C5	(.ascii(c5_out),	.seven_seg_display(c5));	// ROTOR 2 RING POSITION
    ASCII_to_MAX 	C4 	(.ascii(c4_out),	.seven_seg_display(c4));	// ROTOR 2 STARTING POSITION
    Decimal_to_MAX 	C3 	(.decimal(c3_out),	.seven_seg_display(c3));	// ROTOR 2 ROTOR NUMBER
    ASCII_to_MAX	C2 	(.ascii(c2_out),	.seven_seg_display(c2));	// ROTOR 1 RING POSITION
    ASCII_to_MAX 	C1 (.ascii(c1_out),		.seven_seg_display(c1));	// ROTOR 1 STARTING POSITION
    Decimal_to_MAX 	C0 (.decimal(c0_out),	.seven_seg_display	(c0));	// ROTOR 1 ROTOR NUMBER

	// MAX 7-Segment Display Top
    top max_top(
        .CLK                (clk_out),
        .c0                 (c0),
        .c1                 (c1),
        .c2                 (c2),
        .c3                 (c3),
        .c4                 (c4),
        .c5                 (c5),
        .c6                 (c6),
        .c7                 (c7), 
        .PIN_13             (GPIO[28]), // CLK
        .PIN_12             (GPIO[24]), // DIN
        .PIN_11             (GPIO[26]), // CS
        .USBPU              ()
    );

	// DE10 Key, Switch Synchronizer
    Synchronizer #(4) KeySync 		(.clock(CLOCK_50), .async(KEY[3:0]), .sync(KEY_sync[3:0]));
	Synchronizer #(10) SwitchSync 	(.clock(CLOCK_50), .async(SW[9:0]), .sync(SW_sync[9:0]));

	// PCB Button Synchronizer 
	Synchronizer #(8) ButtonSync (
        .clock              (CLOCK_50),
        .async              ({GPIO[8], GPIO[10], GPIO[12], GPIO[14], GPIO[16], GPIO[18], GPIO[20], GPIO[22]}),
        .sync               (button_sync[7:0])
    );

    // Lampboard
	ASCII_to_Lampboard lamp (.scan_code(encoded_data[7:0]), .lampboard(lampboard[31:0]));

	shifter shifty (
		.clk				(clk_out),
		.rst				(~KEY[0]),
		.en					(1'b1),
		.parallel_in		(parallel_in[31:0]),
		.serial				(GPIO[34]),
		.output_en_l		(),
		.rclk				(GPIO[30])
	);


endmodule