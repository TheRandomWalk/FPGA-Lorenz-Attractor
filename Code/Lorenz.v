// Variable range (alpha = 10, beta = 8/3, rho = 28):
// X: [-19.2, 19.6]
// Y: [-26.5, 27.2]
// Z: [0.9, 47.9]

module Lorenz (clk, dt, skip, x, y, z);
    parameter integerBits   = 6;
    parameter fractionBits  = 25;
    parameter dtBits        = 16;
    parameter dtShift       = 30;
    parameter iteratorBits  = 16;
    parameter signed [integerBits + fractionBits : 0] sigma  =        10.0 * (2.0 ** $itor(fractionBits));
    parameter signed [integerBits + fractionBits : 0] beta   = (8.0 / 3.0) * (2.0 ** $itor(fractionBits));
    parameter signed [integerBits + fractionBits : 0] rho    =        28.0 * (2.0 ** $itor(fractionBits));
    parameter signed [integerBits + fractionBits : 0] startX =         8.0 * (2.0 ** fractionBits);
    parameter signed [integerBits + fractionBits : 0] startY =         8.0 * (2.0 ** fractionBits);
    parameter signed [integerBits + fractionBits : 0] startZ =        27.0 * (2.0 ** fractionBits);    

    localparam totalBits = 1 + integerBits + fractionBits;
   
    input  wire clk;
    input  wire signed [dtBits       - 1 : 0] dt;
    input  wire        [iteratorBits - 1 : 0] skip;
    output reg  signed [totalBits    - 1 : 0] x = startX;
    output reg  signed [totalBits    - 1 : 0] y = startY;
    output reg  signed [totalBits    - 1 : 0] z = startZ;

    reg        [iteratorBits  - 1 : 0] iterator = 0;
    reg signed [totalBits     - 1 : 0] a        = startX;
    reg signed [totalBits     - 1 : 0] b        = startY;
    reg signed [totalBits     - 1 : 0] c        = startZ;
    reg signed [totalBits * 2 - 1 : 0] dxdt     = 0;
    reg signed [totalBits * 2 - 1 : 0] dydt     = 0;
    reg signed [totalBits * 2 - 1 : 0] dzdt     = 0;

    always @(posedge clk)
    begin
        iterator <= iterator + 1;    
       
        if (!iterator)
        begin
            x = a;
            y = b;
            z = c;
        end
        else
        begin
            if (iterator == skip)
            begin
                a = x;
                b = y;
                c = z;
            end

            dxdt = (sigma * (y - x)) >>> fractionBits;
            dydt = ((x * (rho - z)) >>> fractionBits) - y;
            dzdt = (x * y - beta * z) >>> fractionBits;

            x = x + ((dxdt * dt) >>> dtShift);
            y = y + ((dydt * dt) >>> dtShift);
            z = z + ((dzdt * dt) >>> dtShift);
        end
    end
endmodule
