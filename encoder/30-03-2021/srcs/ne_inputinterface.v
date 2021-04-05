`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2021 21:54:01
// Design Name: 
// Module Name: ne_msg_fifo
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
// input fifo + load fsm
//////////////////////////////////////////////////////////////////////////////////


module ne_inputinterface(msg_k, msg_vec, wren, msg_data_regin,datavalid_regin,inclk,clk,rst);

parameter Z=511;
parameter K=7136;
parameter Kunshort = 7154;
parameter Kunshortwithzeros = Kunshort + (Kunshort/Z); //7154 + 14
parameter DW=16;
parameter COUNTDEPTH = K/DW;//K/DW = 7136/16 = 446
parameter COUNTWIDTH = 9;//ceil(log2(K/DW)) = ceil(log2(7136/16)) = 9

output[K-1:0] msg_k; //to putput buffer.
output[(Kunshortwithzeros)-1:0] msg_vec;
output reg wren; //to msg mem and output buffer
input[DW-1:0] msg_data_regin;
input datavalid_regin;
input inclk;
input clk;
input rst;

//received at posedge of inclk
reg[DW-1:0] msg_data;
reg datavalid;

//fsm
reg[COUNTWIDTH-1:0] nextcount,count;
reg nextfifofull;
reg fifofull;
reg ps,ns;
parameter INIT=1'b0, COUNTING=1'b1;

reg[DW-1:0] D_SR[COUNTDEPTH-1:0]; //fifo

//registered inputs
always@(posedge inclk)
begin
  if(rst)
  begin
    msg_data<=0;
    datavalid<=0;
  end
  else
  begin
    msg_data<=msg_data_regin;
    datavalid<=datavalid_regin;
  end
end


always@(posedge inclk)
begin
  if(rst)
  begin
    ps<=0;
    count<=0;
    fifofull<=0;
  end
  else
  begin
    ps<=ns;
    count<=nextcount;
    fifofull<=nextfifofull;
  end
end

always@(*)
begin
  case(ps)
    INIT: begin
            ns=datavalid ? COUNTING : ps;
            nextcount=0;
            nextfifofull=0;            
          end
    COUNTING: begin
                ns= (count==COUNTDEPTH-1) ? INIT: ps; 
                nextcount= (count==COUNTDEPTH-1) ? 0 : count+1; //CHANGED  ...0:count+1... 
                nextfifofull = (count==COUNTDEPTH-1) ? 1 : 0;
              end
    default: begin
               ns=0;
               nextcount=0;
               nextfifofull=0;                
             end                    
  endcase
end

//FIFO writing:
    always@(posedge inclk)
    begin
      if(rst)
      begin
        D_SR[0]<=0;
      end
      else
      begin
        if(datavalid)
          D_SR[0]<=msg_data;
        else
          D_SR[0]<=D_SR[0];
      end
    end 
    
genvar k;
generate
  for(k=0;k<=COUNTDEPTH-2;k=k+1) begin: shift_loop    
        //FIFO writing:
    always@(posedge inclk)
    begin
      if(rst)
      begin
        D_SR[k+1]<=0;
      end
      else
      begin
        if(datavalid)
          D_SR[k+1]<=D_SR[k];
        else
          D_SR[k+1]<=D_SR[k+1];
      end
    end   
  end//shift_loop
endgenerate    

//Unshortening and zerofilling and bitreversing:
// msg_k <-7136
// msg_k_unshort <-{7136,18zeros}
// msg_k_unshortwithzeros <- { bitrev({1'b0,D511_13}), bitrev({1'b0,D511_12}), ..., bitrev({1'b0,D511_0}) )
//wire[K-1:0] msg_k; //output for transmission
wire[(Kunshort)-1:0] msg_k_unshort;
wire[(Kunshortwithzeros)-1:0] msg_k_unshortwithzeros, msg_k_unshortwithzeros_bitrev;

    
genvar i;
generate
  for(i=0;i<=COUNTDEPTH-1;i=i+1) begin: k_loop 
    assign msg_k[((i+1)*DW)-1:(i*DW)] = D_SR[i];
  end//k_loop
endgenerate

//prepending 18 zeros
assign msg_k_unshort = {msg_k , {18{1'b0}}};

// append zeros at every Z-bit boundaries:
genvar j;
generate
  for(j=0;j<=14-1;j=j+1) begin: KB_loop
    assign msg_k_unshortwithzeros[((j+1)*(Z+1))-1:(j*(Z+1))] = {1'b0, msg_k_unshort[((j+1)*Z)-1:(j*Z)]};
    
    //bitreverse to feed the Z-bit sections from MSB to LSB ot the network:
    //({1'b0,D511_0})
    defparam rev.N=Z+1;
    bitreverse rev(msg_k_unshortwithzeros_bitrev[((j+1)*(Z+1))-1:(j*(Z+1))],msg_k_unshortwithzeros[((j+1)*(Z+1))-1:(j*(Z+1))]);

  end//KB_loop
endgenerate

//Clock sync inclk -> clk
reg[(Kunshortwithzeros)-1:0] DOUT[1:0]; 
reg[1:0] loaden;
always@(posedge clk)
begin
  if(rst)
  begin
    loaden[1:0]<=0;
    DOUT[1]<=0;
    DOUT[0]<=0;
  end
  else
  begin
    loaden[0]<=fifofull;
    loaden[1]<=loaden[0];
    DOUT[0]<=msg_k_unshortwithzeros_bitrev;
    DOUT[1]<=DOUT[0];
  end
end

//Load FSM and output
reg psload, nsload;
parameter LOADSTART=1'b0, WAITFORLOADENRESET=1'b1;

always@(posedge clk)
begin
  if(rst)
    psload<=0;
  else
    psload<=nsload;
end

always@(*)
begin
  case(psload)
    LOADSTART: begin
                 nsload = loaden[1] ? WAITFORLOADENRESET : psload;
                 wren = loaden[1];
               end
    WAITFORLOADENRESET: begin
                 nsload = loaden[1] ? psload : LOADSTART;
                 wren = 0;
               end
    default: begin
                 nsload =0;
                 wren = 0;
               end                              
  endcase
end
//output
assign msg_vec = DOUT[1];

endmodule

/*
                ns= (count==COUNTDEPTH-1) ? (datavalid ? ps : INIT) : ps; 
                nextcount= (count==COUNTDEPTH-1) ? (datavalid ? count : 0 ) : count+1; //CHANGED  ...0:count+1... 
                nextfifofull = (count==COUNTDEPTH-1) ? (datavalid ? 0 : 1) : 0;
*/