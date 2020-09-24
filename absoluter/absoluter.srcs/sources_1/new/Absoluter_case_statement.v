`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2020 16:02:42
// Design Name: 
// Module Name: Absoluter_case_statement
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


module Absoluter_case_statement(
        output sign,
        output reg [4:0]mag,
        input [5:0]in
);

    assign sign = in[5];
    always @(*)begin
    case(in[5])
        1'b0 : mag = in[4:0];
        1'b1 : begin
        case(in[4:0])
            0:mag = 31;
            1:mag = 31;
            2:mag = 30;
            3:mag = 29;
            4:mag = 28;
            5:mag = 27;
            6:mag = 26;
            7:mag = 25;
            8:mag = 24;
            9:mag = 23;
            10:mag = 22;
            11:mag = 21;
            12:mag = 20;
            13:mag = 19;
            14:mag = 18;
            15:mag = 17;
            16:mag = 16;
            17:mag = 15;
            18:mag = 14;
            19:mag = 13;
            20:mag = 12;
            21:mag = 11;
            22:mag = 10;
            23:mag = 9;
            24:mag = 8;
            25:mag = 7;
            26:mag = 6;
            27:mag = 5;
            28:mag = 4;
            29:mag = 3;
            30:mag = 2;
            31:mag = 1;
        endcase
        end 
        endcase
    end
endmodule
