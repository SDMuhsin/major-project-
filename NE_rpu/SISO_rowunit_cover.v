`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2021 12:17:54
// Design Name: 
// Module Name: SISO_rowunit_cover
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


module SISO_rowunit_cover(
updLLR_regout_s,
Dout_regout_s, 
wrlayer_s,wraddress_s,wren_s, 
Dmem_rden_layer_address_s, 
rdlayer_regin_s,rdaddress_regin_s,rden_LLR_regin_s,rden_E_regin_s, 
Lmemout_regin_s,
D_reaccess_in_regin_s,
clk,rst
    );
    
    parameter Nb=16;
    parameter Wc=32;
    parameter Wcbits = 5;//2**5 =32
    parameter W=6;
    parameter LAYERS=2;
    parameter ADDRWIDTH = 5;//2^5 = 32 > 20
    parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
    parameter PIPESTAGES=11;
    
    output reg [(Wc*(W))-1:0] updLLR_regout_s;
    output reg [(Wc*(W))-1:0] Dout_regout_s;
    output reg [(ADDRWIDTH+1+1)-1:0] Dmem_rden_layer_address_s;
    output reg wrlayer_s;
    output reg [ADDRWIDTH-1:0]wraddress_s;
    output reg wren_s;
    input rdlayer_regin_s;
    input [ADDRWIDTH-1:0]rdaddress_regin_s;
    input rden_LLR_regin_s;
    input rden_E_regin_s;
    input [(Wc*(W))-1:0] Lmemout_regin_s;
    input [(Wc*(W))-1:0] D_reaccess_in_regin_s;
    input clk,rst;
    
    wire [(Wc*(W))-1:0] updLLR_regout;
    wire [(Wc*(W))-1:0] Dout_regout;
    wire wrlayer,wren; 
    wire [ADDRWIDTH-1:0] wraddress;
    wire [ADDRWIDTH+1:0]Dmem_rden_layer_address; 
    reg [ADDRWIDTH-1:0] rdaddress_regin;
    reg rdlayer_regin,rden_LLR_regin,rden_E_regin; 
    reg [(Wc*(W))-1:0]Lmemout_regin;
    reg [(Wc*(W))-1:0]D_reaccess_in_regin;
    
    always@(posedge clk) begin
        if(rst) begin
        updLLR_regout_s<=0;
        Dout_regout_s<=0;
        wrlayer_s<=0;
        wraddress_s<=0;
        wren_s<=0;
        Dmem_rden_layer_address_s<=0;
        rdlayer_regin<=0;
        rdaddress_regin<=0;
        rden_LLR_regin<=0;
        rden_E_regin <=0;
        Lmemout_regin<=0;
        D_reaccess_in_regin<=0;
        end
        else begin
                updLLR_regout_s<=updLLR_regout;
                Dout_regout_s<=Dout_regout;
                wrlayer_s<=wrlayer;
                wraddress_s<=wraddress;
                wren_s<=wren;
                Dmem_rden_layer_address_s<=Dmem_rden_layer_address;
                rdlayer_regin<=rdlayer_regin_s;
                rdaddress_regin<=rdaddress_regin_s;
                rden_LLR_regin<=rden_LLR_regin_s;
                rden_E_regin <=rden_E_regin_s;
                Lmemout_regin<=Lmemout_regin_s;
                D_reaccess_in_regin<=D_reaccess_in_regin_s;
            end
    end
    
    SISO_rowunit m1(
    updLLR_regout,
    Dout_regout, 
    wrlayer,wraddress,wren, 
    Dmem_rden_layer_address, 
    rdlayer_regin,rdaddress_regin,rden_LLR_regin,rden_E_regin, 
    Lmemout_regin,
    D_reaccess_in_regin,
    clk,rst);
endmodule
