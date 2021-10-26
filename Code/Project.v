// Notes:
// The module requires zIn > 0
// Verilog/Vivado division appears to work only with unsigned numbers

module Project3(clk, xIn, yIn, zIn, xOut, yOut);
    parameter integerBits  = 6;
    parameter fractionBits = 25;
    parameter reduction = 12;

    localparam totalBits = 1 + integerBits + fractionBits - reduction;
    localparam divisionBits = totalBits  + fractionBits;
    
    input  wire clk;
    input  wire signed [totalBits - 1 : 0] xIn;
    input  wire signed [totalBits - 1 : 0] yIn;
    input  wire signed [totalBits - 1 : 0] zIn;
    output reg  signed [totalBits - 1 : 0] xOut = 0;
    output reg  signed [totalBits - 1 : 0] yOut = 0;

    wire signed [divisionBits - 1 : 0] xPos =  (( xIn <<< fractionBits) / zIn);
    wire signed [divisionBits - 1 : 0] xNeg = -((-xIn <<< fractionBits) / zIn);
    wire signed [divisionBits - 1 : 0] yPos =  (( yIn <<< fractionBits) / zIn);
    wire signed [divisionBits - 1 : 0] yNeg = -((-yIn <<< fractionBits) / zIn);

    always @(posedge clk)
    begin
        xOut = zIn != 0 ? (xIn >= 0 ? xPos : xNeg) : 0;
        yOut = zIn != 0 ? (yIn >= 0 ? yPos : yNeg) : 0;
    end    
endmodule