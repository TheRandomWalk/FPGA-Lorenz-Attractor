module Translate2(clk, xIn, yIn, xTranslation, yTranslation, xOut, yOut);
    parameter bits = 32;
    
    input  wire clk;
    input  wire signed [bits - 1 : 0] xIn;
    input  wire signed [bits - 1 : 0] yIn;
    input  wire signed [bits - 1 : 0] xTranslation;
    input  wire signed [bits - 1 : 0] yTranslation;
    output reg  signed [bits - 1 : 0] xOut = 0;
    output reg  signed [bits - 1 : 0] yOut = 0;

    always @(posedge clk)
    begin
        xOut = xIn + xTranslation;
        yOut = yIn + yTranslation;
    end
endmodule


module Translate3(clk, xIn, yIn, zIn, xTranslation, yTranslation, zTranslation, xOut, yOut, zOut);
    parameter bits = 32;
    
    input  wire clk;
    input  wire signed [bits - 1 : 0] xIn;
    input  wire signed [bits - 1 : 0] yIn;
    input  wire signed [bits - 1 : 0] zIn;
    input  wire signed [bits - 1 : 0] xTranslation;
    input  wire signed [bits - 1 : 0] yTranslation;
    input  wire signed [bits - 1 : 0] zTranslation;
    output reg  signed [bits - 1 : 0] xOut = 0;
    output reg  signed [bits - 1 : 0] yOut = 0;
    output reg  signed [bits - 1 : 0] zOut = 0;

    always @(posedge clk)
    begin
        xOut = xIn + xTranslation;
        yOut = yIn + yTranslation;
        zOut = zIn + zTranslation;
    end
endmodule

