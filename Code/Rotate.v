module Rotate2(clk, xIn, yIn, sin, cos, xOut, yOut);
    parameter coordinateBits = 32;
    parameter sinCosBits     = 16;

    localparam multiplicationBits = coordinateBits + sinCosBits;
    
    input  wire clk;
    input  wire signed [coordinateBits - 1 : 0] xIn;
    input  wire signed [coordinateBits - 1 : 0] yIn;
    input  wire signed [sinCosBits     - 1 : 0] sin;
    input  wire signed [sinCosBits     - 1 : 0] cos;
    output reg  signed [coordinateBits - 1 : 0] xOut = 0;
    output reg  signed [coordinateBits - 1 : 0] yOut = 0;

    wire signed [multiplicationBits - 1 : 0] xTemp;
    wire signed [multiplicationBits - 1 : 0] yTemp;

    assign xTemp = ((xIn * cos) - (yIn * sin)) >>> (sinCosBits - 1);
    assign yTemp = ((xIn * sin) + (yIn * cos)) >>> (sinCosBits - 1);
    
    always @(posedge clk)
    begin
        xOut = xTemp;
        yOut = yTemp;
    end
endmodule

// Porque es ">>> (sinCosBits - 1)" ?