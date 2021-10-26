module DeltaSigma(clk, in, out);
    parameter bits = 16;

    input wire clk;
    input wire [bits - 1 : 0] in;
    output reg out = 0;
    
    reg [bits : 0] sum = 0;
    
    always @(posedge clk)
    begin
        sum = sum + in;
        out = sum[bits];
        sum[bits] = 0;
    end
endmodule
