`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2020 13:45:53
// Design Name: 
// Module Name: subtract_2
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


module subtract_2( sub2, inp1, inp2);
parameter W=6;
        output reg [W-1:0]sub2;
        input [W-1:0]inp1;
        input [W-1:0]inp2;
        
        wire [W:0] x,y,sub_inter;
        assign x = {inp1[W-1],inp1};
        assign y = {inp2[W-1],inp2};
        //assign sub_inter = x-y;
        assign sub_inter = x+~y+1'b1;
       
       /* always@(sub_inter)
        begin
            sub2[W-1]=sub_inter[W];
          case({sub_inter[W:W-1]})
            2'b00,2'b11: sub2[W-2:0] = sub_inter[W-2:0]; 
            2'b01: sub2[W-2:0] = {{(W-1){1'b1}}};
            2'b10: sub2[W-2:0] = {{(W-1){1'b0}}};
          endcase
        end */
        
        always@(sub_inter)
        begin
          case({sub_inter[W:W-1]})
            2'b00,2'b11: sub2 = sub_inter[W-1:0]; 
            2'b01: sub2 = {1'b0,{(W-1){1'b1}}};
            2'b10: sub2 = {1'b1,{(W-1){1'b0}}};
          endcase
          end
        
        
endmodule
