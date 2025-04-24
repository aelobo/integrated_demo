`default_nettype none

module ASCII_to_Lampboard(
    input       [7:0]   scan_code,  
    output reg  [31:0]   lampboard
);

always @* begin
    case (scan_code)
      8'h41: lampboard = 32'b1          << 2;  // A*
      8'h42: lampboard = 32'b1          << 18; // B*
      8'h43: lampboard = 32'b1          << 12; // C*
      8'h44: lampboard = 32'b1          << 0;  // D*
      8'h45: lampboard = 32'b1          << 7;  // E*
      8'h46: lampboard = 32'b1          << 11; // F*
      8'h47: lampboard = 32'b1          << 14; // G*
      8'h48: lampboard = 32'b1          << 17; // H*
      8'h49: lampboard = 32'b1          << 27; // I*
      8'h4A: lampboard = 32'b1          << 20; // J*
      8'h4B: lampboard = 32'b1          << 23; // K*
      8'h4C: lampboard = 32'b1          << 26; // L*
      8'h4D: lampboard = 32'b1          << 16; // M*
      8'h4E: lampboard = 32'b1          << 21; // N*
      8'h4F: lampboard = 32'b1          << 25; // O*
      8'h50: lampboard = 32'b1          << 3;  // P*
      8'h51: lampboard = 32'b1          << 1;  // Q*
      8'h52: lampboard = 32'b1          << 10; // R*
      8'h53: lampboard = 32'b1          << 5;  // S*
      8'h54: lampboard = 32'b1          << 13; // T*
      8'h55: lampboard = 32'b1          << 19; // U*
      8'h56: lampboard = 32'b1          << 15; // V*
      8'h57: lampboard = 32'b1          << 4;  // W*
      8'h58: lampboard = 32'b1          << 9;  // X*
      8'h59: lampboard = 32'b1          << 6;  // Y*
      8'h5A: lampboard = 32'b1          << 8;  // Z*
    default: lampboard = 32'b0;
endcase
end

// L and I LEDs wrong

endmodule