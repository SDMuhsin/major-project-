`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2021 13:06:14
// Design Name: 
// Module Name: ne_memcircuitSRQ_wiringtest
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
//Test stimulus: wr_data_regin
  //wr_data_regin = { LLR_32_25, LLR_32_24, ..., LLR_32_1, LLR_32_0}
  //numlist = {31,30,29,...,2,1,0}
  // LLR_32_0 = numlist
  // LLR_32_1 = numlist + 1
  // ...
  // LLR_32_25 = numlist+25
  
//Expected Result: --Obtained (verified from waveforms and self check)
    // Captured result in array: lmem_data_in_arr[Nb-1:0][r-1:0]
    // lmem_data_in_arr[0] = 52 symbol list={ LLR_32_25[1],LLR_32_24[1],...,LLR_32_0[1],LLR_32_25[0],...,LLR_32_0[0]}
    //= {{1,1,1,..,1},  {25,24,...,0}}
    //lmem_data_in_arr[1] = 52 symbol list={ LLR_32_25[3],LLR_32_24[3],...,LLR_32_0[3],LLR_32_25[2],...,LLR_32_0[2]}
    //= { {3,...,3} , {2,...,2} }
//////////////////////////////////////////////////////////////////////////////////


module ne_memcircuitSRQ_wiringtest();
//module Lmem_SRQtype_combined_ns_reginout_pipeV1(unload_HDout_vec_regout,rd_data_regout, unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstiter, clk,rst);
parameter W=6;//6;//configurable by user
parameter maxVal = 6'b011111;

//non-configurable parameters
parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
parameter Nb=16;//16;//circulant blocks per layer
parameter Kb=14;//first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;//taking 32 bits at a time
parameter Wt=2; //circulant weight
parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.

//Non-configurable. (use script analyse and configure accordingly)
parameter r=P*Wt;//r is predefined to be 52. non configurable.
parameter w=W;

//registered input and output
wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;
wire [(P*Nb*Wt*W)-1:0] rd_data_regout;
reg unload_en_regin;
reg [ADDRESSWIDTH-1:0] unloadAddress_regin;
reg rd_en_regin;
reg [ADDRESSWIDTH-1:0] rd_address_regin;
reg rd_layer_regin;
reg [(32*Nb*W)-1:0] load_data_regin;
reg loaden_regin;
reg [(P*Nb*Wt*W)-1:0] wr_data_regin;
reg wr_en_regin;
reg wr_layer_regin;
reg firstiter_regin; //from controller send after fsm start, iff (itr==0), first iter=1.
reg clk,rst;

integer inb2,jr2, passcount,totalcount;
wire [w-1:0]lmem_data_in_arr[Nb-1:0][r-1:0];
wire [32*W-1:0] numlist;
reg ld_en;

defparam dut.W=W, dut.maxVal=maxVal;
Lmem_SRQtype_combined_ns_regout_pipeV1 dut(unload_HDout_vec_regout,rd_data_regout,unload_en_regin,unloadAddress_regin,rd_en_regin,rd_address_regin,rd_layer_regin, load_data_regin,loaden_regin, wr_data_regin,wr_en_regin,wr_layer_regin, firstiter_regin, clk,rst);

//Capture result of wiring:
genvar j_r, i_nb;
generate
  for(i_nb=0;i_nb<=Nb-1;i_nb=i_nb+1) begin: i_nb_loop
    assign numlist[(((2*i_nb)+1)+1)*W-1:((2*i_nb)+1)*W]=(2*i_nb)+1;
    assign numlist[((2*i_nb)+1)*W-1:((2*i_nb))*W]=(2*i_nb);
    for(j_r=0;j_r<=(r)-1;j_r=j_r+1) begin:j_r_52_loop
    //Expected Result: --Obtained (verified from waveforms and self check)
    // lmem_data_in_arr[0] = 52 symbol list={ LLR_32_25[1],LLR_32_24[1],...,LLR_32_0[1],LLR_32_25[0],...,LLR_32_0[0]}
    //= {{1,1,1,..,1},  {25,24,...,0}}
    //lmem_data_in_arr[1] = 52 symbol list={ LLR_32_25[3],LLR_32_24[3],...,LLR_32_0[3],LLR_32_25[2],...,LLR_32_0[2]}
    //= { {3,...,3} , {2,...,2} }
      assign lmem_data_in_arr[i_nb][j_r]=dut.lmem_data_in[i_nb][((j_r+1)*W)-1:((j_r)*W)];
    end//j_r_52_loop
  end//i_nb_loop
endgenerate


always
#1 clk=~clk;

//Stimulus
genvar j_p;
generate 
  for(j_p=0;j_p<=P-1;j_p=j_p+1) begin: p26_loop
  //wr_data_regin = { LLR_32_25, LLR_32_24, ..., LLR_32_1, LLR_32_0}
  //numlist = {31,30,29,...,2,1,0}
  // LLR_32_0 = numlist
  // LLR_32_1 = numlist + 1
  // ...
  // LLR_32_25 = numlist+25
    always@(ld_en)
    begin
      if(ld_en) begin
          wr_data_regin[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))]=numlist+j_p;
      end
    end
  end//p26_loop 
endgenerate

initial
begin
  clk=0;rst=0; ld_en=0; totalcount=0; passcount=0;
  unload_en_regin=0;unloadAddress_regin=0;
  rd_en_regin=0;rd_address_regin=0;rd_layer_regin=0;
  load_data_regin=0;loaden_regin=0;
  wr_data_regin=0;wr_en_regin=0;wr_layer_regin=0;
  firstiter_regin=0;
  
  @(posedge clk);
  @(posedge clk) rst=1; @(negedge clk)ld_en=1;wr_en_regin=1;
  @(posedge clk); @(negedge clk)ld_en=0;wr_en_regin=0;
  @(posedge clk);
  for(inb2=0;inb2<=Nb-1;inb2=inb2+1) begin
    for(jr2=0;jr2<=(r/2)-1;jr2=jr2+1) begin //0 to 25 loop
    totalcount=totalcount+1;
      if(inb2==0)
        if(lmem_data_in_arr[inb2][jr2] == jr2) begin
          $display("\n Match at inb2=%d,jr2=%d,lmem_data_in_arr[inb2][jr2]=%d==jr2=%d",inb2,jr2,lmem_data_in_arr[inb2][jr2], jr2);
          passcount=passcount+1;
        end
        else
          $display("\n MisMatch at inb2=%d,jr2=%d,lmem_data_in_arr[inb2][jr2]=%d != jr2=%d",inb2,jr2,lmem_data_in_arr[inb2][jr2], jr2);
      else
        if(lmem_data_in_arr[inb2][jr2] == (2*inb2)) begin
          $display("\n Match at inb2=%d,jr2=%d,lmem_data_in_arr[inb2][jr2]=%d== (2*inb2)=%d",inb2,jr2,lmem_data_in_arr[inb2][jr2], (2*inb2));
          passcount=passcount+1;
        end
        else
          $display("\n MisMatch at inb2=%d,jr2=%d,lmem_data_in_arr[inb2][jr2]=%d != (2*inb2)=%d",inb2,jr2,lmem_data_in_arr[inb2][jr2], (2*inb2));
    
    end
    for(jr2=r/2;jr2<=(r)-1;jr2=jr2+1) begin //26 to 51 loop
      totalcount=totalcount+1;
        if(lmem_data_in_arr[inb2][jr2] == (2*inb2)+1) begin
          $display("\n Match at inb2=%d,jr2=%d,lmem_data_in_arr[inb2][jr2]=%d== (2*inb2)+1=%d",inb2,jr2,lmem_data_in_arr[inb2][jr2], (2*inb2)+1);
          passcount=passcount+1;
        end
        else
          $display("\n MisMatch at inb2=%d,jr2=%d,lmem_data_in_arr[inb2][jr2]=%d != (2*inb2)+1=%d",inb2,jr2,lmem_data_in_arr[inb2][jr2], (2*inb2)+1);
      
    end
  end
  $display("\n totalcount = %d, passcount=%d", totalcount, passcount);
    @(posedge clk);
      @(posedge clk);
        @(posedge clk);
  $finish;
  
end

endmodule
