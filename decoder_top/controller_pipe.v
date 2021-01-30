`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2021 13:40:29
// Design Name: 
// Module Name: ne_AddrGenFSM
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
// if loading is going on: cancel all operations, clear all signals and counters and stay in initial state.
// else continue operation assuming fresh start, by waiting for start signal form LoadunloadFSM of input interface.
//////////////////////////////////////////////////////////////////////////////////


module ne_AddrGenFSM_pipe(SISOready,firstprocessing_indicate,LYRindex,rowaddress,rd_E,rd_L,rcu_en,loaden,start,clk,rst);
parameter Z=511;
parameter P=26;
parameter PIPESTAGES = 13;//rcu pipetages+1 for mem write
parameter MAXITRS = 10;
parameter ROWDEPTH=20;//Z/P; //Z/P = 73
//last_p rowdepth and pipestages.
parameter P_LAST = Z-(P*(ROWDEPTH-1));//511-(26*19)=511-494=17
parameter ROWWIDTH = 5;//7;//2**7 = 128 > 72, 2**5 = 32 > 20.
parameter PIPECOUNTWIDTH = 4;//2**3 = 8 > 7
parameter ITRWIDTH = 4;//2**4 = 16 > 9
parameter MEMRDCYCLES0=4;
parameter MEMRDCYCLES1=4;

output SISOready;
output firstprocessing_indicate;//to select proper Lmem (load to lyr0) unit.
output LYRindex;
output [ROWWIDTH-1:0] rowaddress;
output[P-1:0]rd_E;//---------------clr_en_E Alternative: first iter rd E =0 
output rd_L;
output[P-1:0] rcu_en;//26 rcu enable lines
input loaden;
input start, clk, rst;

//......................
reg[ROWWIDTH-1:0] count, nextcount;
reg[PIPECOUNTWIDTH-1:0] pipecount, nextpipecount;
reg lyr, nextlyr;
reg[ITRWIDTH-1:0] itr, nextitr;
reg rd, nextrd;
reg ready, nextready;

//outputs
assign SISOready = ready;
assign LYRindex = lyr;
assign rowaddress = count;
assign rd_L = rd;
assign rd_E = (itr==0) ? 0 : ( (count==ROWDEPTH-1) ? { {(P-P_LAST){1'b0}} , {P_LAST{rd}} } : {P{rd}} );
assign firstprocessing_indicate = ((itr==0)&&(lyr==0)); //to indicate the first processing after loading new code symbols.
assign rcu_en = (count==ROWDEPTH-1) ? { {(P-P_LAST){1'b0}} , {P_LAST{rd}} } : {P{rd}}; //last address 17 out of 26 rows are valid, so enabling first 17 RCUs only.

/*initial begin

end*/
//add one cycle delay for load_en (input pipelining for lmem top)
//FSM
parameter INIT=0, LYR0=1, LYR0WAIT=2, LYR1=3, LYR1WAIT=4;
reg[2:0] ps, ns;

always@(posedge clk)
begin
  if(!rst|loaden) //loaden logic for present state/control/other signals is same as reset operation.
  begin
    ps<=0;
    ready<=0;
    rd<=0;
    itr<=0;
    lyr<=0;
    pipecount<=0;
    count<=0;
  end
  else
  begin
    ps<=ns;
    ready<=nextready;
    rd<=nextrd;
    itr<=nextitr;
    lyr<=nextlyr;
    pipecount<=nextpipecount;
    count<=nextcount;
  end  
end

always@(ps, ready, rd, itr, lyr, pipecount, count, start,loaden)//remove loaden depending on start
begin
  if(loaden) //loaden logic for next state/control/other signals
  begin
    ns=0;
    nextready=ready;
    nextrd=0;
    nextitr=0;
    nextlyr=0;
    nextpipecount=0;
    nextcount=0;  
  end
  else begin
    case(ps)
      INIT : begin
               ns=start ? LYR0 : ps;
               nextready=start ? 0 : ready;
               nextrd=start ? 1 : 0;
               nextitr=start ? 0 : itr;
               nextlyr=start ? 0 : lyr;
               nextpipecount=start ? 0 : pipecount;
               nextcount=start ? 0 : count;
             end
      LYR0 : begin
               ns=(count<ROWDEPTH-1) ? ps : LYR0WAIT;
               nextready=0;
               nextrd=(count<ROWDEPTH-1) ? 1 : 0;
               nextitr=itr;
               nextlyr=0;
               nextpipecount=0;
               nextcount=(count<ROWDEPTH-1) ? count+1 : count;
             end
    LYR0WAIT:begin              
               ns=(pipecount<PIPESTAGES-1) ? ps : LYR1;
               nextready=0;
               nextrd=(pipecount<PIPESTAGES-1) ? 0 : 1;
               nextitr=itr;
               nextlyr=(pipecount<PIPESTAGES-1) ? 0 : 1;
               nextpipecount=(pipecount<PIPESTAGES-1) ? pipecount+1 : pipecount;
               nextcount=(pipecount<PIPESTAGES+-1) ? count : 0;
             end
      LYR1 : begin
               ns=(count<ROWDEPTH-1) ? ps : LYR1WAIT;
               nextready=0;
               nextrd=(count<ROWDEPTH-1) ? 1 : 0;
               nextitr=itr;
               nextlyr=1;
               nextpipecount=0;
               nextcount=(count<ROWDEPTH-1) ? count+1 : count;
             end
    LYR1WAIT:begin
               ns=(pipecount<PIPESTAGES-1) ? ps : ((itr<MAXITRS-1) ? LYR0 : INIT);
               nextready=(pipecount<PIPESTAGES-1) ? 0 : ((itr<MAXITRS-1) ? 0 : 1);
               nextrd=(pipecount<PIPESTAGES-1) ? 0 : ((itr<MAXITRS-1) ? 1 : 0);
               nextitr=(pipecount<PIPESTAGES-1) ? itr : ((itr<MAXITRS-1)? itr+1 : itr);
               nextlyr=(pipecount<PIPESTAGES-1) ? 1 : 0;//0 is reset value.
               nextpipecount=(pipecount<PIPESTAGES-1) ? pipecount+1 : pipecount;
               nextcount=(pipecount<PIPESTAGES-1)? count : 0;
             end     
    
    default: begin
               ns=0;
               nextready=0;
               nextrd=0;
               nextitr=0;
               nextlyr=0;
               nextpipecount=0;
               nextcount=0;
             end
    endcase
  end//else
end

endmodule