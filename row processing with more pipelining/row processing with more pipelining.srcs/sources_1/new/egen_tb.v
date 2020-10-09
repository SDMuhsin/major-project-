`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2020 18:11:08
// Design Name: 
// Module Name: egen_tb
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


module egen_tb();

    reg clk,rst;
    
    parameter w=6;
    parameter wc=18;
    wire [2*(w-1)+5+wc-1:0]ecomp;
    reg [w*wc-1:0] x;
    //integer i;
    
    wire [(w-1):0]x_display[wc-1:0];
    wire [(wc-1):0]sign_display; 
    wire parity_display;
    wire [wc*(w-1)-1:0]abs1;
    wire [(w-2):0]abs_disp[wc-1:0];
    wire [(w-2):0]min1_disp,min2_disp,pos_disp;
    emsggen u1(ecomp,x,clk,rst);
    
    initial begin
    x=0;
    clk=0;
    rst=0;
    //ecomp=0;
    end
    
    always@(negedge clk) #1
    x=x+$random;
    
    assign min1_disp=u1.min1;
    assign min2_disp=u1.min2;
    assign pos_disp=u1.pos;
    assign abs1=u1.abs;
    assign sign_display=u1.signbit_5;
    assign parity_display=u1.signparity;
    
    genvar i;
    generate for(i=0;i<wc;i=i+1)begin:lab
        assign x_display[i] = x[(i+1)*w-1:i*w];
        //assign sign_display[i]=x[(i+1)*w-1];
        assign abs_disp[i]=abs1[(i+1)*(w-1)-1:i*(w-1)];
    end
    endgenerate
    
    always #5 clk=~clk;
    
endmodule
