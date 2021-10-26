module Top(clk, btn, rgb, led, pinX, pinY);
    localparam integerBits  = 6;
    localparam fractionBits = 25;
    localparam totalBits    = 1 + integerBits + fractionBits;
    localparam dtBits       = 20;
    localparam dtShift      = 32;
    localparam iteratorBits = 18;
    localparam sigma        =        10.0 * (2.0 ** $itor(fractionBits));
    localparam beta         = (8.0 / 3.0) * (2.0 ** $itor(fractionBits));
    localparam rho          =        28.0 * (2.0 ** $itor(fractionBits));
    
    localparam phaseBits  = 30;
    localparam lutBits    = 6;
    localparam sinCosBits = 16;
    
    localparam deltaSigmaBits = 16;
    
    input  wire clk;
    input  wire [1 : 0] btn;
    output reg  [2 : 0] rgb = 3'b111;
    output reg  [3 : 0] led = 4'b0000;
    output wire pinX;
    output wire pinY;

    wire clkSlow;
    wire clkFast;

    reg  signed [dtBits       - 1 : 0] dt   = 0.00005 * (2.0 ** dtShift);
    reg         [iteratorBits - 1 : 0] skip = 1024;
    
    wire signed [totalBits - 1 : 0] x0, x1, x2, x3, x4, x5;
    wire signed [totalBits - 1 : 0] y0, y1, y2, y3, y4, y5;
    wire signed [totalBits - 1 : 0] z0, z1, z2, z3, z4;
   
    reg [phaseBits - 1 : 0] xyPhase = 0;
    reg [phaseBits - 1 : 0] yzPhase = 0;

    wire [sinCosBits - 1 : 0] xySin;
    wire [sinCosBits - 1 : 0] xyCos;
    wire [sinCosBits - 1 : 0] yzSin;
    wire [sinCosBits - 1 : 0] yzCos;
   
    ClockWizard clockWizard(.clk(clk), .reset(), .clkSlow(clkSlow), .clkFast(clkFast), .locked());
   
    Lorenz #
    ( 
        .integerBits(integerBits),
        .fractionBits(fractionBits),
        .dtBits(dtBits),
        .dtShift(dtShift),
        .iteratorBits(iteratorBits),
        .sigma(sigma),
        .beta(beta),
        .rho(rho)
    ) lorenz(clkSlow, dt, skip, x0, y0, z0);

    SinCos #(phaseBits, lutBits, sinCosBits) xySinCos(clkSlow, xyPhase, xySin, xyCos);
    SinCos #(phaseBits, lutBits, sinCosBits) yzSinCos(clkSlow, yzPhase, yzSin, yzCos);

    Translate3 #(totalBits)               translateA(clkSlow, x0, y0, z0, 0, 0, $rtoi(-23.5 * (2.0 ** fractionBits)), x1, y1, z1);
    Scale3 #(integerBits, fractionBits)   scaleA(clkSlow, x1, y1, z1, $rtoi(0.015 * (2.0 ** fractionBits)), $rtoi(0.015 * (2.0 ** fractionBits)), $rtoi(0.015 * (2.0 ** fractionBits)), x2, y2, z2);
    Rotate2 #(totalBits, sinCosBits)      xyRotate(clkSlow, x2, y2, xySin, xyCos, x3, y3); assign z3 = z2;
    Rotate2 #(totalBits, sinCosBits)      yzRotate(clkSlow, y3, z3, yzSin, yzCos, y4, z4); assign x4 = x3;
    Translate2 #(totalBits)               translateC(clkSlow, x4, y4, $rtoi(0.5 * (2.0 ** fractionBits)), $rtoi(0.5 * (2.0 ** fractionBits)), x5, y5);
    
    DeltaSigma #(deltaSigmaBits) deltaSigmaX(clk, x5[totalBits - 1 : fractionBits - deltaSigmaBits], pinX);
    DeltaSigma #(deltaSigmaBits) deltaSigmaY(clk, y5[totalBits - 1 : fractionBits - deltaSigmaBits], pinY);

    always @(posedge clkSlow)
    begin
        xyPhase <= xyPhase + 3;
        yzPhase <= yzPhase + 4;
    end
endmodule
