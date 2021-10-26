// Sine and cosine computation through lookuptable and linear interpolation

module SinCos(clk, phase, sin, cos);
    parameter inputBits    = 16;
    parameter lutBits      = 6;
    parameter outputBits   = 16;

    localparam interpolationBits = inputBits - (1 + lutBits);
    localparam lutSize = (1 << lutBits);
    localparam pi = 3.1415926535897931;
    
    input wire clk;
    input wire [inputBits - 1 : 0 ] phase;
    output reg signed [outputBits - 1 : 0] sin = 0;
    output reg signed [outputBits - 1 : 0] cos = 0;

    real scale;
    integer i;

    reg signed [outputBits - 1 : 0] lut [0 : lutSize - 1];

    wire [lutBits : 0] sinPhase0;
    wire [lutBits : 0] sinPhase1;
    wire [lutBits : 0] cosPhase0;
    wire [lutBits : 0] cosPhase1;

    wire signed [outputBits - 1 : 0] sinAmplitude0;
    wire signed [outputBits - 1 : 0] sinAmplitude1;
    wire signed [outputBits - 1 : 0] cosAmplitude0;
    wire signed [outputBits - 1 : 0] cosAmplitude1;

    wire signed [outputBits - 1 : 0] sinValue0;
    wire signed [outputBits - 1 : 0] sinValue1;
    wire signed [outputBits - 1 : 0] cosValue0;
    wire signed [outputBits - 1 : 0] cosValue1;

    wire signed [interpolationBits + 1 : 0] weight0;
    wire signed [interpolationBits + 1 : 0] weight1;
    
    wire signed [outputBits + interpolationBits : 0] sinTemp;
    wire signed [outputBits + interpolationBits : 0] cosTemp;

    initial
    begin
        for (i = 0; i < lutSize; i = i + 1)
        begin
            // NOTE: scale is < 1.0
            scale = ((2.0 ** (outputBits - 1.0)) - 1.0);
            lut[i] = $rtoi($sin(i * pi / lutSize) * scale);
        end
    end

    assign sinPhase0 = phase[inputBits - 1 : interpolationBits];
    assign sinPhase1 = sinPhase0 + 1;
    assign cosPhase0 = sinPhase0 + (1 << (lutBits - 1));
    assign cosPhase1 = cosPhase0 + 1;

    assign sinAmplitude0 = lut[sinPhase0[lutBits - 1 : 0]];
    assign sinAmplitude1 = lut[sinPhase1[lutBits - 1 : 0]];
    assign cosAmplitude0 = lut[cosPhase0[lutBits - 1 : 0]];
    assign cosAmplitude1 = lut[cosPhase1[lutBits - 1 : 0]];

    assign sinValue0 = sinPhase0[lutBits] ? -sinAmplitude0 : sinAmplitude0;
    assign sinValue1 = sinPhase1[lutBits] ? -sinAmplitude1 : sinAmplitude1;
    assign cosValue0 = cosPhase0[lutBits] ? -cosAmplitude0 : cosAmplitude0;
    assign cosValue1 = cosPhase1[lutBits] ? -cosAmplitude1 : cosAmplitude1;
    
    assign weight0 = (1 << interpolationBits) - weight1;
    assign weight1 = phase[interpolationBits - 1 : 0];
    
    assign sinTemp = (sinValue0 * weight0 + sinValue1 * weight1) >>> interpolationBits;
    assign cosTemp = (cosValue0 * weight0 + cosValue1 * weight1) >>> interpolationBits;
    
    always @(posedge clk)
    begin
        sin = sinTemp;
        cos = cosTemp;
    end
endmodule
