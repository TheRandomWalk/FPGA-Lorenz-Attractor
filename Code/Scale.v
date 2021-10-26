module Scale2(clk, xIn, yIn, xScale, yScale, xOut, yOut);
    parameter integerBits   = 6;
    parameter fractionBits  = 25;

    localparam totalBits = 1 + integerBits + fractionBits;
    localparam multiplicationBits = totalBits + fractionBits;
    
    input  wire clk;
    input  wire signed [totalBits - 1 : 0] xIn;
    input  wire signed [totalBits - 1 : 0] yIn;
    input  wire signed [totalBits - 1 : 0] xScale;
    input  wire signed [totalBits - 1 : 0] yScale;
    output reg  signed [totalBits - 1 : 0] xOut = 0;
    output reg  signed [totalBits - 1 : 0] yOut = 0;

    wire signed [multiplicationBits - 1 : 0] x = (xIn * xScale) >>> fractionBits;
    wire signed [multiplicationBits - 1 : 0] y = (yIn * yScale) >>> fractionBits;

    always @(posedge clk)
    begin
        xOut = x;
        yOut = y;
    end
endmodule


module Scale3(clk, xIn, yIn, zIn, xScale, yScale, zScale, xOut, yOut, zOut);
    parameter integerBits   = 6;
    parameter fractionBits  = 25;

    localparam totalBits = 1 + integerBits + fractionBits;
    localparam multiplicationBits = totalBits + fractionBits;
    
    input  wire clk;
    input  wire signed [totalBits - 1 : 0] xIn;
    input  wire signed [totalBits - 1 : 0] yIn;
    input  wire signed [totalBits - 1 : 0] zIn;
    input  wire signed [totalBits - 1 : 0] xScale;
    input  wire signed [totalBits - 1 : 0] yScale;
    input  wire signed [totalBits - 1 : 0] zScale;
    output reg  signed [totalBits - 1 : 0] xOut = 0;
    output reg  signed [totalBits - 1 : 0] yOut = 0;
    output reg  signed [totalBits - 1 : 0] zOut = 0;

    wire signed [multiplicationBits - 1 : 0] x = (xIn * xScale) >>> fractionBits;
    wire signed [multiplicationBits - 1 : 0] y = (yIn * yScale) >>> fractionBits;
    wire signed [multiplicationBits - 1 : 0] z = (zIn * zScale) >>> fractionBits;

    always @(posedge clk)
    begin
        xOut = x;
        yOut = y;
        zOut = z;
    end
endmodule
