`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2020 19:47:24
// Design Name: 
// Module Name: addWCover
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


module addWCover(
        output reg [9:0]output_reg,
        input  [9:0]input1_ff_drive,
        input  [9:0]input2_ff_drive,
        input cin_drive,
        input clk,
        input rst
    );



wire cout;
wire [9:0]output_actual;
reg [9:0]input1_actual;
reg [9:0]input2_actual;
reg cin_actual;

always@(posedge clk)
    begin
      if(!rst)
      begin
        //outputs
        output_reg <= 9'b0;

        //inputs
        input1_actual <= 0;
        input2_actual <= 0;
        cin_actual <= 0;
      end
      else
      begin
        //outputs
        output_reg <= output_actual;
        //inputs
        input1_actual <= input1_ff_drive;
        input2_actual <= input2_ff_drive;
        cin_actual <= cin_drive;
      end
 end   
 

 
 adderW a( output_actual, input1_actual, input2_actual, cin_actual);
endmodule
