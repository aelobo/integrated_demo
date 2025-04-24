`default_nettype none

module rotor_settings (
    input               i_clock,
    input               reset,

    input               rotor_ring_2_en, 
    input               rotor_ring_1_en, 

    input               rotor_start_3_en, 
    input               rotor_start_2_en, 
    input               rotor_start_1_en, 

    input               rotor_num_3_en, 
    input               rotor_num_2_en, 
    input               rotor_num_1_en, 

    input               rotary_a,
    input               rotary_b,

    input          rotor_2_ring_increment,
	input          rotor_1_ring_increment,

    // input          rotor_3_increment,
	// input          rotor_2_increment,
	// input          rotor_1_increment,

    input          rotor_3_num_increment,
	input          rotor_2_num_increment,
	input          rotor_1_num_increment,

    output reg          update_settings,

    output reg [4:0]    rotor_ring_3, 
    output reg [4:0]    rotor_ring_2, 
    output reg [4:0]    rotor_ring_1, 

	output reg [4:0]    rotor_start_3, 
    output reg [4:0]    rotor_start_2, 
    output reg [4:0]    rotor_start_1,

    output reg [2:0]    rotor_num_3, 
    output reg [2:0]    rotor_num_2, 
    output reg [2:0]    rotor_num_1,

    // output reg          rotor_2_ring_increment,
	// output reg          rotor_1_ring_increment,

    output reg          rotor_3_increment,
	output reg          rotor_2_increment,
	output reg          rotor_1_increment,

    // output reg          rotor_3_num_increment,
	// output reg          rotor_2_num_increment,
	// output reg          rotor_1_num_increment,

    output reg          turned_3,
    output reg          turned_2,
    output reg          turned_1
); 

    wire rotor_2_ring_increment_out;
    wire rotor_1_ring_increment_out;

    wire rotor_3_increment_out;
    wire rotor_2_increment_out;
    wire rotor_1_increment_out;

    wire rotor_3_num_increment_out;
    wire rotor_2_num_increment_out;
    wire rotor_1_num_increment_out;

    wire [2:0] rotor_num_3_temp;
	wire [2:0] rotor_num_2_temp;
    wire [2:0] rotor_num_1_temp;

    wire [4:0] rotor_ring_2_temp;
    wire [4:0] rotor_ring_1_temp;

    wire [4:0] rotor_start_3_temp;
    wire [4:0] rotor_start_2_temp;
    wire [4:0] rotor_start_1_temp;

    wire turned_3_temp;
    wire turned_2_temp;
    wire turned_1_temp;


    // always @(posedge i_clock) begin
    //     rotor_2_ring_increment <= rotor_2_ring_increment_out;
    //     rotor_1_ring_increment <= rotor_1_ring_increment_out;
    // end

    // always @(posedge i_clock) begin
    //     rotor_3_num_increment <= rotor_3_num_increment_out;
    //     rotor_2_num_increment <= rotor_2_num_increment_out;
    //     rotor_1_num_increment <= rotor_1_num_increment_out;
    // end

    always @(posedge i_clock) begin
        rotor_3_increment <= rotor_3_increment_out;
        rotor_2_increment <= rotor_2_increment_out;
        rotor_1_increment <= rotor_1_increment_out;
    end

    // button_press_fsm rotor2_ring    (.i_clock(i_clock), .reset(reset), .press_in(rotor_ring_2_en), .press_out(rotor_2_ring_increment_out));
    // button_press_fsm rotor1_ring    (.i_clock(i_clock), .reset(reset), .press_in(rotor_ring_1_en), .press_out(rotor_1_ring_increment_out));

    // button_press_fsm rotor3_start   (.i_clock(i_clock), .reset(reset), .press_in(rotor_start_3_en), .press_out(rotor_3_increment_out));
    // button_press_fsm rotor2_start   (.i_clock(i_clock), .reset(reset), .press_in(rotor_start_2_en), .press_out(rotor_2_increment_out));
    // button_press_fsm rotor1_start   (.i_clock(i_clock), .reset(reset), .press_in(rotor_start_1_en), .press_out(rotor_1_increment_out));

    // // simple_fsm rotor3_start   (.clock(i_clock), .reset(reset), .button_sync(rotor_start_3_en), .rotor_enable(rotor_3_increment_out));
    // // simple_fsm rotor2_start   (.clock(i_clock), .reset(reset), .button_sync(rotor_start_2_en), .rotor_enable(rotor_2_increment_out));
    // // simple_fsm rotor1_start   (.clock(i_clock), .reset(reset), .button_sync(rotor_start_1_en), .rotor_enable(rotor_1_increment_out));

    // button_press_fsm rotor3_num     (.i_clock(i_clock), .reset(reset), .press_in(rotor_num_3_en), .press_out(rotor_3_num_increment_out));
    // button_press_fsm rotor2_num     (.i_clock(i_clock), .reset(reset), .press_in(rotor_num_2_en), .press_out(rotor_2_num_increment_out));
    // button_press_fsm rotor1_num     (.i_clock(i_clock), .reset(reset), .press_in(rotor_num_1_en), .press_out(rotor_1_num_increment_out));


    // // RING POSIITON
    // always @(posedge i_clock) begin
	// 	if (reset) begin
    //         rotor_ring_3 <= 5'b00000;
	// 		rotor_ring_2 <= 5'b00000;
	// 		rotor_ring_1 <= 5'b00000;
	// 	end
	// 	else begin
	// 		if (rotor_2_ring_increment) begin
    //             if (rotor_ring_2 == 5'd25) rotor_ring_2 <= 5'b0;
    //             else                        rotor_ring_2 <= rotor_ring_2 + 5'b1;
    //         end 
	// 	    else if (rotor_1_ring_increment) begin
	// 			if (rotor_ring_1 == 5'd25) rotor_ring_1 <= 5'b0;
    //             else                        rotor_ring_1 <= rotor_ring_1 + 5'b1;
    //         end
	// 		else begin
    //             rotor_ring_2 <= rotor_ring_2;
    //             rotor_ring_1 <= rotor_ring_1;
    //         end

    //         rotor_ring_3 <= 5'b00000;
	// 	end
	// end


    // // ROTOR STARTING POSITION
	// always @(posedge i_clock) begin
	// 	if (reset) begin
	// 		rotor_start_3 <= 5'b00000;
	// 		rotor_start_2 <= 5'b00000;
	// 		rotor_start_1 <= 5'b00000;
	// 	end
	// 	else begin
	// 		if (rotor_3_increment) begin
    //             if (rotor_start_3 == 5'd25) rotor_start_3 <= 5'b0;
    //             else                        rotor_start_3 <= rotor_start_3 + 5'b1;
    //         end 
	// 	    else if (rotor_2_increment) begin
	// 			if (rotor_start_2 == 5'd25) rotor_start_2 <= 5'b0;
    //             else                        rotor_start_2 <= rotor_start_2 + 5'b1;
    //         end
	// 		else if (rotor_1_increment) begin
	// 			if (rotor_start_1 == 5'd25) rotor_start_1 <= 5'b0;
    //             else                        rotor_start_1 <= rotor_start_1 + 5'b1;
    //         end
	// 		else begin
	// 			rotor_start_3 <= rotor_start_3;
    //             rotor_start_2 <= rotor_start_2;
    //             rotor_start_1 <= rotor_start_1;
    //         end
	// 	end

    //     update_settings <= rotor_3_increment || rotor_2_increment || rotor_1_increment;
	// end

    // // ROTOR NUM
	// always @(posedge i_clock) begin
	// 	if (reset) begin
	// 		rotor_num_3 <= 3'b010;
	// 		rotor_num_2 <= 3'b001;
	// 		rotor_num_1 <= 3'b000;
	// 	end
	// 	else begin
	// 		if (rotor_3_num_increment) begin
    //             if (rotor_num_3 == 3'd7)    rotor_num_3 <= 3'b0;
    //             else                        rotor_num_3 <= rotor_num_3 + 3'b1;
    //         end 
	// 	    else if (rotor_2_num_increment) begin
	// 			if (rotor_num_2 == 3'd7)    rotor_num_2 <= 3'b0;
    //             else                        rotor_num_2 <= rotor_num_2 + 3'b1;
    //         end
	// 		else if (rotor_1_num_increment) begin
	// 			if (rotor_num_1 == 3'd7)    rotor_num_1 <= 3'b0;
    //             else                        rotor_num_1 <= rotor_num_1 + 3'b1;
    //         end
	// 		else begin
	// 			rotor_num_3 <= rotor_num_3;
    //             rotor_num_2 <= rotor_num_2;
    //             rotor_num_1 <= rotor_num_1;
    //         end
	// 	end
	// end

    always @(posedge i_clock) begin
        rotor_num_3 <= rotor_num_3_temp;
        rotor_num_2 <= rotor_num_2_temp;
        rotor_num_1 <= rotor_num_1_temp;
    end

    always @(posedge i_clock) begin
        rotor_ring_3 <= 5'b00000;
        rotor_ring_2 <= rotor_ring_2_temp;
        rotor_ring_1 <= rotor_ring_1_temp;
    end

    // always @(posedge i_clock) begin
    //     rotor_start_3 <= 5'b00000; //rotor_start_3_temp;
    //     rotor_start_2 <= 5'b00000; //rotor_start_2_temp;
    //     rotor_start_1 <= 5'b00000; //rotor_start_1_temp;
    // end

    always @(posedge i_clock) begin
        rotor_start_3 <= rotor_start_3_temp; //;
        rotor_start_2 <= rotor_start_2_temp; //;
        rotor_start_1 <= rotor_start_1_temp; //;
    end

    always @(posedge i_clock) begin
        turned_3 <= turned_3_temp;
        turned_2 <= turned_2_temp;
        turned_1 <= turned_1_temp;
    end

    rotary_num rotor_num3(.clock(i_clock), .reset(reset), .enable(rotor_num_3_en), .reset_val(3'b010), .rotary_a(rotary_a), .rotary_b(rotary_b), .num(rotor_num_3_temp));
    rotary_num rotor_num2(.clock(i_clock), .reset(reset), .enable(rotor_num_2_en), .reset_val(3'b001), .rotary_a(rotary_a), .rotary_b(rotary_b), .num(rotor_num_2_temp));
    rotary_num rotor_num1(.clock(i_clock), .reset(reset), .enable(rotor_num_1_en), .reset_val(3'b000), .rotary_a(rotary_a), .rotary_b(rotary_b), .num(rotor_num_1_temp));

    rotary_letter  ring_2(.clock(i_clock), .reset(reset), .enable(rotor_ring_2_en), .reset_val(5'b00000), .rotary_a(rotary_a), .rotary_b(rotary_b), .letter(rotor_ring_2_temp));
    rotary_letter  ring_1(.clock(i_clock), .reset(reset), .enable(rotor_ring_1_en), .reset_val(5'b00000), .rotary_a(rotary_a), .rotary_b(rotary_b), .letter(rotor_ring_1_temp));

    rotary_letter rotor_start3(.clock(i_clock), .reset(reset), .enable(rotor_start_3_en), .reset_val(5'b00000), .rotary_a(rotary_a), .rotary_b(rotary_b), .letter(rotor_start_3_temp), .increment(rotor_3_increment_out));
    rotary_letter rotor_start2(.clock(i_clock), .reset(reset), .enable(rotor_start_2_en), .reset_val(5'b00000), .rotary_a(rotary_a), .rotary_b(rotary_b), .letter(rotor_start_2_temp), .increment(rotor_2_increment_out));
    rotary_letter rotor_start1(.clock(i_clock), .reset(reset), .enable(rotor_start_1_en), .reset_val(5'b00000), .rotary_a(rotary_a), .rotary_b(rotary_b), .letter(rotor_start_1_temp), .increment(rotor_1_increment_out));

endmodule


