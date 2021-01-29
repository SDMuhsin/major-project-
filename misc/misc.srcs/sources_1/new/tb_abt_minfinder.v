`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 09:10:05
// Design Name: 
// Module Name: tb_abt_minfinder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_abt_minfinder(

    );
    
    parameter w = 5;
    parameter Wc = 32;
    
    defparam mf.w = w;
    defparam mf.Wc = Wc;
    
    wire [w-1:0]min1;
    wire [w-1:0]min2;
    wire [ $clog2(Wc) - 1:0]index;
    reg [w*Wc - 1:0]inp;
    abt_minfinder mf(min1,min2,index,inp);
    
    wire [w-1:0]inp_sep[Wc-1:0];
    wire [Wc-1:0]min1_onehot;
    wire [Wc-1:0]min2_onehot;
    assign min1_onehot = mf.min1_onehot;
    assign min2_onehot = mf.min2_onehot;
    genvar i;
    generate
        for(i = 0; i < Wc; i=i+1)begin : loop_name
            assign inp_sep[i] = inp[ (i+1)*w-1 : i*w];
        end
    endgenerate
    initial begin
        inp = 32'b1;
        inp = inp + $random;    
    end
    always #10 inp = inp + $random;
endmodule
