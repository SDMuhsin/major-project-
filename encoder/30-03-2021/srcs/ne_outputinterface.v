`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 14:31:09
// Design Name: 
// Module Name: ne_outputinterface
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
// output interface with clk sync logic and tx fsm
//////////////////////////////////////////////////////////////////////////////////


module ne_outputinterface(codevalid,codeTx, parityout_regin,parity_parloaden_regin, msg_k_regin,wren_regin,txstart_regin,outclk,clk,rst);
parameter K=7136;
parameter M = 1022;
parameter Zeroappend =2;
parameter M_z = M + Zeroappend;
parameter DW=16;
parameter SYSCOUNT = K/DW;//K/DW = 7136/16 = 446
parameter SYSCOUNTWIDTH = 9;//ceil(log2(SYSCOUNT)) = 9
parameter PARITYCOUNT = M_z/DW; // M_z/DW= 1024 /16 = 64
parameter PARITYCOUNTWIDTH = 6;//ceil(log2(PARITYCOUNT)) = 6
parameter CLK_OUTCLK_SYNCCYCLES=10;

output reg codevalid;
output reg[DW-1:0] codeTx;
input[M-1:0] parityout_regin; //from parity shift network
input parity_parloaden_regin;
input[K-1:0] msg_k_regin;
input wren_regin; //parallel write no write address required.
input txstart_regin;
input outclk;
input clk;
input rst;

//regd inputs at outclk with clk sync
reg[K-1:0] msg_k_meta, msg_k; //7136
reg[M_z-1:0] parityout_meta, parityout; //1024
reg wren_meta, wren;
reg parity_parloaden_meta, parity_parloaden;
reg[CLK_OUTCLK_SYNCCYCLES-1:0] parity_parloaden_expander;
reg txstart_meta, txstart;

//Encoder sends Parallel Load Signal at posedge clk
//expand this signal to be captured by slower outclk:
always@(posedge clk)
begin
  if(rst)
  begin
    parity_parloaden_expander<=0;
  end
  else
  begin
    parity_parloaden_expander<={parity_parloaden_expander[CLK_OUTCLK_SYNCCYCLES-2:0],parity_parloaden_regin};
  end
end

always@(posedge outclk)
begin
  if(rst)
  begin
    msg_k_meta<=0;
    msg_k<=0;
    parityout_meta<=0;
    parityout<=0;
    wren_meta<=0;
    wren<=0;
    parity_parloaden_meta<=0;
    parity_parloaden<=0;
    txstart_meta<=0;
    txstart<=0;
  end
  else
  begin
    msg_k_meta<=msg_k_regin;
    msg_k<=msg_k_meta;
    parityout_meta<=parityout_regin;
    parityout<=parityout_meta;
    wren_meta<=wren_regin;
    wren<=wren_meta;
    parity_parloaden_meta<=|(parity_parloaden_expander);//parity_parloaden_regin;
    parity_parloaden<=parity_parloaden_meta; 
    txstart_meta<=txstart_regin;
    txstart<=txstart_meta;
  end
end

reg tx_mux_switch;
reg[SYSCOUNTWIDTH-1:0] syscount, nextsyscount; 
reg[PARITYCOUNTWIDTH-1:0] parcount, nextparcount;
reg[1:0] ps, ns;
parameter INIT = 0, SYSBIT_TX = 1, PARITY_TX=2;
always@(posedge outclk)
begin
  if(rst)
  begin
    ps<=0;
    syscount<=0;
    parcount<=0;
  end
  else
  begin
    ps<=ns;
    syscount<=nextsyscount;
    parcount<=nextparcount;
  end
end

always@(*)
begin
  case(ps)
    INIT: begin
            ns= txstart ? SYSBIT_TX : ps;
            nextsyscount=0;
            nextparcount=0;
            tx_mux_switch = 0;
            codevalid=0;
          end
    SYSBIT_TX: begin
                 ns= (syscount == SYSCOUNT-1) ? PARITY_TX : ps;
                 nextsyscount=(syscount == SYSCOUNT-1) ? 0 : syscount+1;
                 nextparcount=0;
                 tx_mux_switch = 0;
                 codevalid=1;                 
               end
    PARITY_TX: begin
                 ns= (parcount == PARITYCOUNT-1) ? (txstart ? SYSBIT_TX : INIT) : ps;
                 nextsyscount=0;
                 nextparcount=(parcount == PARITYCOUNT-1) ? 0 : parcount+1;
                 tx_mux_switch = 1;
                 codevalid=1;    
               end
    default: begin
               ns= 0;
               nextsyscount=0;
               nextparcount=0;
               tx_mux_switch = 0;
               codevalid=0;    
             end
  endcase
end 

//Mem FIFOs
reg[K-1:0] msgvecmem; //7136
reg[M_z-1:0] parvecmem; //1024
//Write operation 
always@(posedge outclk)
begin
  if(rst)
  begin
    msgvecmem <=0;
  end
  else
  begin
    if(wren)
      msgvecmem<=msg_k;
    else
      msgvecmem<=msgvecmem;
  end
end

always@(posedge outclk)
begin
  if(rst)
  begin
    parvecmem <=0;
  end
  else
  begin
    if(parity_parloaden)
      parvecmem<={2'd0,parityout}; //1024
    else
      parvecmem<=parvecmem;
  end
end

//Split Lm sections
wire[DW-1:0] msgmem[SYSCOUNT-1:0];
wire[DW-1:0] parmem[PARITYCOUNT-1:0];
genvar i;
generate 
  for(i=0;i<=SYSCOUNT-1;i=i+1) begin: DW_sysloop
    assign msgmem[i] = msgvecmem[(i+1)*DW-1:(i*DW)];
  end
endgenerate

genvar j;
generate 
  for(j=0;j<=PARITYCOUNT-1;j=j+1) begin: DW_parloop
    assign parmem[j] = parvecmem[(j+1)*DW-1:(j*DW)];
  end
endgenerate

//READ/TX operation
always@(*)
begin
  if(tx_mux_switch==0)
    if(syscount<=SYSCOUNT-1)
      codeTx =  msgmem[syscount];
    else
      codeTx = 0;
  else
    if(parcount<=PARITYCOUNT-1)
      codeTx =  parmem[parcount];
    else
      codeTx = 0;
end



endmodule
