`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2020 23:53:40
// Design Name: 
// Module Name: simpledualportram
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


module simpledualportram_ne(DOUT, RA, rd_in, DIN, WA, wr_in, memclk, rst);
parameter Z=511;
parameter W=6;
parameter COLADDR_BITS=9;//9bits to address Z=511 locations
parameter COLDEPTH = Z;
output reg[(W)-1:0] DOUT;
input[(COLADDR_BITS)-1:0] RA;
input rd_in;
input[(W)-1:0] DIN;
input[(COLADDR_BITS)-1:0] WA;
input wr_in;
input memclk, rst;

reg[W-1:0] Lmemreg[COLDEPTH-1:0];
//reg[W-1:0] dout_array[1:0];
//wire[W-1:0] din_array[1:0];
//wire[COLADDR_BITS-1:0] wa_array[1:0];
//wire[COLADDR_BITS-1:0] ra_array[1:0];

//assign {ra_array[1],ra_array[0]} = RA;
//assign {wa_array[1],wa_array[0]} = WA;
//assign {din_array[1],din_array[0]} = DIN;
//assign DOUT = {dout_array[1],dout_array[0]};


//genvar i;
//generate for(i=0;i<=1;i=i+1) begin: wtc_2_loop
    //Reading at negedge, register old value
    always@(negedge memclk)
    begin
        if(!rst)
        begin
          DOUT<=0;
          //dout_array[i]<=0;
          //dout_array[0]<=0;
          //dout_array[1]<=0;
        end
        else
        begin
          DOUT<= rd_in ? Lmemreg[RA] : 0;
          //dout_array[i]<= rd_in[i] ? Lmemreg[ra_array[i]] : dout_array[i];
          //dout_array[0]<= rd_in[0] ? Lmemreg[ra_array[0]] : dout_array[0];
          //dout_array[1]<= rd_in[1] ? Lmemreg[ra_array[1]] : dout_array[1];          
        end
    end 
    //Writing at posedge
    always@(posedge memclk)
    begin
      if(!rst)
      begin
        Lmemreg[WA]<=Lmemreg[WA];
        //Lmemreg[wa_array[i]]<=Lmemreg[wa_array[i]];
        //Lmemreg[wa_array[0]]<=Lmemreg[wa_array[0]];
        //Lmemreg[wa_array[1]]<=Lmemreg[wa_array[1]];
      end
      else
      begin
        Lmemreg[WA]<=(wr_in ? (DIN) : Lmemreg[WA] );
        //Lmemreg[wa_array[i]]<=(wr_in[i] ? (din_array[i]) : Lmemreg[wa_array[i]] );
        //Lmemreg[wa_array[0]]<=(wr_in[0] ? (din_array[0]) : Lmemreg[wa_array[0]] );
        //Lmemreg[wa_array[1]]<=(wr_in[1] ? (din_array[1]) : Lmemreg[wa_array[1]] );
      end
    end  
    
//end//for
//endgenerate

endmodule