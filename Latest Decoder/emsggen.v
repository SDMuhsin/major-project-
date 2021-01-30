`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2020 22:25:02
// Design Name: 
// Module Name: emsggen
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

module emsggen(ecomp,x,clk,rst);

input clk,rst;
    
    parameter w=6;
    parameter wabs=w-1;
    parameter wc=32;
    output [2*(w-1)+wabs+wc-1:0]ecomp;
    //output [2*(w-1)+wabs+wc-1:0]ecomp;
    input [w*wc-1:0] x;
    //0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17;
    wire [wc-1:0]signbit;
    //integer i;
    wire [w-2:0]min1,min2;
    wire [(w-1)*wc-1:0] abs;
    reg [(w-1)*wc-1:0] abs_1;
    wire [(w-1)*wc-1:0] absnormL;
    wire [w-2:0]pos;
    wire [2*(w-1)+5+wc-1:0] etemp;
    wire signparity;
    wire [wc-1:0] updatedsign;
    reg [wc-1:0]updated_sign_reg;
    
    defparam m1.wc=wc,m1.w=w;
    Absoluter_32 m1(signbit,abs,x,clk,rst);
    
    defparam m3.Wc=wc,m3.W=w;
    NormaliserWc m3(absnormL, abs_1, clk,rst);
    
    defparam m2.Wc=wc,m2.W=w;
    m32VG_pipelined m2(min1,min2,pos,absnormL,clk,rst);
    
    reg [wc-1:0]signbit_1,signbit_2,signbit_3,signbit_4,signbit_5;
    wire [2*(w-1)+wabs+wc-1:0]ecomp_wire;
    
    //x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10],x[11],x[12],x[13],x[14],x[15],x[16],x[17]
    //m18VG_pipelined_cover m2(min1,min2,pos,abs[4:0],abs[9:5],abs[14:10],abs[19:15],abs[24:20],abs[29:25],abs[34:30],abs[39:35],abs[44:40],abs[49:45],abs[54:50],abs[59:55],abs[64:60],abs[69:65],abs[74:70],abs[79:75],abs[84:80],abs[89:85],clk,rst);
    //abs[0],abs[1],abs[2],abs[3],abs[4],abs[5],abs[6],abs[7],abs[8],abs[9],abs[10],abs[11],abs[12],abs[13],abs[14],abs[15],abs[16],abs[17]
    assign signparity=^signbit_5[wc-1:0];
    genvar i;
    generate
    for(i=0;i<wc;i=i+1)
    begin
    assign updatedsign[i]=signbit_5[i]^signparity;
    end
    endgenerate
    
    always@(posedge clk)
    begin
    if(!rst)begin
        updated_sign_reg<=0;
        
        abs_1<=0;
        signbit_1 <= 0;
        signbit_2 <= 0;
        signbit_3 <= 0;
        signbit_4 <= 0;
        signbit_5 <= 0;
        //ecomp<=0;
    end
    else begin
        updated_sign_reg<=updatedsign;
        
        abs_1<=abs;
        signbit_1 <= signbit;
        signbit_2 <= signbit_1;
        signbit_3 <= signbit_2;
        signbit_4 <= signbit_3;
        signbit_5 <= signbit_4;
        //ecomp<=ecomp_wire;
    end
    end
    //assign ecomp_wire={min1,min2,pos,updated_sign_reg};
    assign ecomp={min1,min2,pos,updated_sign_reg};
endmodule
