`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2020 10:53:57
// Design Name: 
// Module Name: negandpos
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


module negandpos(min1pos,min1neg,min2pos,min2neg,hotpos,UpdatedSign, Ecomp);
  
    parameter Wc=32;
    parameter Wcbits = 5;
    parameter W=10;
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
  
    input[ECOMPSIZE-1:0] Ecomp;
    output [Wc-1:0] UpdatedSign;
    output [Wc-1:0]hotpos;
    output[W-1:0]min1pos,min1neg,min2pos,min2neg;
    
    
    wire[Wabs-1:0] Min1mag, Min2mag;
    //wire[W-1:0] posMin1, negMin1, posMin2, negMin2;
    wire [Wcbits-1:0] Pos;
    
    

  
    
    assign {Min1mag, Min2mag, Pos, UpdatedSign} = Ecomp;
    genvar i;
    generate for(i=0;i<=Wc-1;i=i+1) begin: loop1
    assign hotpos[i] = (Pos == i);
    end
    endgenerate
    
    assign min1pos={1'b0,Min1mag};
    assign min2pos={1'b0,Min2mag}; 
    assign min1neg={1'b1,~Min1mag}+1'b1;
    assign min2neg={1'b1,~Min2mag}+1'b1;
    
endmodule
