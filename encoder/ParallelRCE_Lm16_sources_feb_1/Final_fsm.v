`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2020 13:14:43
// Design Name: 
// Module Name: Final_fsm
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
// addedFSM_tx.v and counterload_frmFSM.v for other modules.
//added datavalid frm top --> start pin to control count1 in counter_load.
//////////////////////////////////////////////////////////////////////////////////


//module Final_fsm(en,parity_parload_en,p_en,t_en,f_sel,m_en,sm,start,rst,clk_in,clk);
module Final_fsm(en,parity_parload_en,t_en,f_sel,m_en,sm,start,rst,clk_in,clk);
parameter K=32;//1024
parameter K_N=256;

parameter Lm=32;
parameter La=8;
parameter MSEL_BITSIZE = 2;//log2(K/(Lm*La))

output en,parity_parload_en;
//output p_en;
output t_en,sm;//  t_en for transmission mux ,sm for data mux;
output [1:0] f_sel;
output[MSEL_BITSIZE-1:0] m_en; // for selecting message and corressponding circulant matrix 
input start,rst,clk_in,clk;
wire en;

defparam fsmtx.K=K,fsmtx.N_K=K_N;
FSM_tx fsmtx(t_en,en,rst,clk);

defparam counterload.K=K, counterload.Lm=Lm, counterload.La=La, counterload.MSEL_BITSIZE = MSEL_BITSIZE;
counter_load counterload(en,parity_parload_en,f_sel,m_en,sm,start,rst,clk_in);
//parity_load parityload(p_en,en,rst,clk_in);

endmodule