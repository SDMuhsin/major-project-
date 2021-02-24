`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2021 09:27:04
// Design Name: 
// Module Name: rowcomputer_tb
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


module rowcomputer_kal_tb(

    );
    
    //RCU
    //Configurable
    parameter W=6;
    //non-configurable parameters
    parameter Nb=16;
    parameter Wc=32;
    parameter Wcbits = 5;                           //2**5 =32
    parameter LAYERS=2;
    parameter ADDRESSWIDTH = 5;                     //2^5 = 32 > 20
    parameter ADDRDEPTH = 20;                       //ceil(Z/P) = ceil(511/26)
    parameter EMEMDEPTH=ADDRDEPTH*LAYERS;           //for LUT RAM //512;//for BRAM ineffcient//
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
    parameter RCU_PIPESTAGES=12;
    
    //Agen controller
    //configurable
    parameter MAXITRS = 2;
    parameter ITRWIDTH = 4;//2**4 = 16 > 9
    //non-configurable
    parameter Z=511;
    parameter P=26;
    parameter PIPESTAGES = RCU_PIPESTAGES+1;    //memrd+RCU_PIPESTAGES//+memwr
    parameter PIPECOUNTWIDTH = 4;               //2**4= 16 > 13
    parameter ROWDEPTH=ADDRDEPTH;               //20=Z/P; //Z/P = 73
    parameter ROWWIDTH = ADDRESSWIDTH;          // 2**5 = 32 > 20; //2**7 = 128 > 72
    //last_p rowdepth and pipestages.
    parameter P_LAST = Z-(P*(ROWDEPTH-1));       //511-(26*19)=511-494=17=valid lines in address 20
    
    //bitnodemem (Lmem)
    //Configurable
    parameter maxVal = 6'b011111;
    //non-configurable parameters
    parameter Kb=14;                            //first 14 circulant columns correspond to systematic part
    parameter HDWIDTH=32;                       //taking 32 hard decision bits at a time
    parameter Wt=2;                             //circulant weight
    parameter r=P*Wt;                           //r is predefined to be 52. non configurable.(26x2)
    parameter w=W;
    
    wire decoder_ready;                                       //from controller
    wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;          //output from lmem
    reg unload_en;                                            //from output if
    reg [ADDRESSWIDTH-1:0] unloadAddress;                     //from output if
    reg [(32*Nb*W)-1:0] load_data;                            //from input if
    reg loaden;                                               //from ip if
    reg start;                                                //from ip if
    reg clk,rst;
    parameter nofb=3072;
    parameter lines=17;
    reg [nofb-1:0]membb[lines-1:0];
    parameter nofb1=4992;
    parameter lines1=20;
    reg [nofb1-1:0]membb1[lines1-1:0];
    reg [nofb1-1:0]membb2[lines1-1:0];
    reg [nofb1-1:0]membb3[lines1-1:0];
    reg [nofb1-1:0]membb4[lines1-1:0];
    reg [nofb1-1:0]membb5[lines1-1:0];
    reg [nofb1-1:0]membb6[lines1-1:0];
    reg [nofb1-1:0]membb7[lines1-1:0];
    reg [nofb1-1:0]membb8[lines1-1:0];
    reg [Kb*HDWIDTH-1:0]unload_17x448[17-1:0];
    
    ne_rowcomputer_pipeV3_SRQ_p26 rc(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);
    integer i;
    integer j;
    integer count;
    integer count1,count2,count3,count4,count5;
    integer unload_counter;
    
    reg [2000:0]fn;
    integer f;
    parameter test_iter = 1; // starts from 0
    initial begin
    unload_counter = 0;
    clk=1'b0;
    rst = 1'b0;
    loaden=1'b0;
    load_data=0;
    start=1'b0;
    unload_en=1'b0;
    unloadAddress=0;
    count=0;
    count1=0;
    count2=0;
    count3=0;
    count4=0;
    count5=0;
    
    i=0;
    j=0;
    
    
    
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\input_codeword_17x32x16.txt",membb);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\L0_iter%0d_in_scripted.txt", test_iter );
    $readmemb(fn,membb1);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\L0_iter%0d_out_scripted.txt", test_iter );
    $readmemb(fn,membb2);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\L1_iter%0d_in_scripted.txt", test_iter );
    $readmemb(fn,membb3);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\L1_iter%0d_out_scripted.txt", test_iter );
    $readmemb(fn,membb4);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\D0_iter%0d_in_scripted.txt", test_iter );
    $readmemb(fn,membb5);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\D0_iter%0d_out_scripted.txt", test_iter );
    $readmemb(fn,membb7);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\D1_iter%0d_in_scripted.txt", test_iter );
    $readmemb(fn,membb6);
    
    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\D1_iter%0d_out_scripted.txt", test_iter );
    $readmemb(fn,membb8);    
    
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\unload_17x448.txt",unload_17x448);    
    
    #4
    rst = 1'b1;
    loaden=1'b1;
    start=1'b0;
    unload_en=1'b0;
    unloadAddress=0;
    
    for(i=0;i<17;i=i+1)
        begin
        load_data=membb[i];
        #4;
        end
  
    #1
    loaden=1'b0;
    start=1'b1;
    #4
    start=1'b0;
    #740;
    //$finish;
    end
    always #2 clk = ~clk;
    
    //assign lin_data_display
    /*always@(posedge clk) begin
            #200
            $display("reference: %h",membb1[rc.rd_address-3]);
    end*/
        //integer count;
        integer count_unload;
        
    always@(posedge clk) begin
    
        $display("address: %h",rc.rd_address);
        //$display("read_data: %b",rc.updLLR_regout);
        //$display("read_circ: %b",rc.Lmemout[25:0]);
        //$display("read_data: %b",rc.wr_data);
        
        /*$display("%b",rc.p26_loop[25].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[24].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[23].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[22].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[21].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[20].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[19].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[18].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[17].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[16].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[15].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[14].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[13].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[12].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[11].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[10].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[9].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[8].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[7].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[6].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[5].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[4].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[3].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[2].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[1].rcu.Euncomp_out_reg);
        $display("%b",rc.p26_loop[0].rcu.Euncomp_out_reg);*/
                
                /*$display("%b",rc.p26_loop[0].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[1].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[2].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[3].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[4].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[5].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[6].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[7].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[8].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[9].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[10].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[11].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[12].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[13].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[14].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[15].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[16].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[17].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[18].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[19].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[20].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[21].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[22].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[23].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[24].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[25].rcu.Emem_rd_dataout_regin);
              
              $display("write data : ");
              
                        $display("%b",rc.p26_loop[0].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[1].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[2].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[3].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[4].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[5].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[6].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[7].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[8].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[9].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[10].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[11].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[12].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[13].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[14].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[15].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[16].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[17].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[18].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[19].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[20].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[21].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[22].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[23].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[24].rcu.Ecomp_wr_datain);
                        $display("%b",rc.p26_loop[25].rcu.Ecomp_wr_datain);*/
        
        //$display("writ_data: %b",rc.updLLR_regout[25:0]);
        
        // L_in After L0 processing
        if(count<20&&rc.rd_address>12&&rc.rd_layer==1'b0&&rc.controller.itr==test_iter) begin    
            $write("[Iteration %0d][L_out : After L0 processing]",rc.controller.itr);
            if(membb2[count]==rc.wr_data) begin
                 $write("Write Success on count %d\n", count);
            end
            else begin
                $write("Write Fail on count %d\n",count);
                $display("reference xor output: %b",membb2[count] ^ rc.updLLR_regout[25:0]);
            end
            count=count+1;
        end
        
        //L_out After L1 processing
        if(count1 < 20 && rc.rd_address>12&&rc.rd_layer==1'b1&&rc.controller.itr==test_iter) begin
            $write("[Iteration %0d][L_out : After L1 processing]",rc.controller.itr);
            //$display("reference: %b",membb4[count1]);
            if(membb4[count1]==rc.wr_data) begin
                $write("Write Success on count %d\n", count1);
            end
            else begin
                $write("Write Fail on count %d\n",count1);
                $display("reference xor output: %b",membb4[count1] ^ rc.wr_data);            
            end
            count1=count1+1;
        end
        
        //$display("read_data: %b",rc.rd_data_regout);
        //L_in before L0 processing
        if(rc.rd_address>2&&rc.rd_address<19&&rc.rd_layer==1'b0&&rc.controller.itr==test_iter) begin
            $write("[Iteration %0d][L_in : Before L0 processing]",rc.controller.itr);
            //$display("reference: %b",membb1[rc.rd_address-3]);
            if(membb1[rc.rd_address-3]==rc.rd_data_regout) begin
               $write("Read Success on rd_address %d\n",rc.rd_address-3);
            end        
            else begin
               $write("Read FAIL on rd_address %d\n",rc.rd_address-3);
               $display("reference xor output %b", membb1[rc.rd_address-3]^rc.rd_data_regout); 
            end
        end
        
        //L_in before L1 processing
        if(rc.rd_address>2&&rc.rd_address<19&&rc.rd_layer==1'b1&&rc.controller.itr==test_iter) begin
            //$display("reference: %b",membb3[rc.rd_address-3]);
            $write("[Iteration %0d][L_in : Before L1 processing]",rc.controller.itr);
            if(membb3[rc.rd_address-3]==rc.rd_data_regout) begin
                $write("Read Success on rd_address %d\n",rc.rd_address-3);
            end 
            else begin
                $write("Read FAIL on rd_address %d\n",rc.rd_address-3);
                $display("reference xor output %b", membb3[rc.rd_address-3]^rc.rd_data_regout);
            end
        end
        
        //$display("din_data : %b",rc.dmem_rd_data_regout);
        // D_in before L0
        if(count2 < 20 && rc.rd_address>10&&rc.rd_layer==1'b0&&rc.controller.itr==test_iter) begin
               $write("[Iteration %0d][D_in : Before L0 processing]",rc.controller.itr); 
               //$display("reference: %b",membb5[count2]);
               if(membb5[count2]==rc.dmem_rd_data_regout) begin
                   $write("Read success on count %d\n",count2);
               end
               else begin
                   $write("Read FAIL on count %d\n",count2);
                   $display("din_data         : %b",rc.dmem_rd_data_regout);
                   $display("output ^ reference %b",membb5[count2]^rc.dmem_rd_data_regout);
               end
               count2=count2+1;
        end
        
        // D_in before L1
        if(count3 < 20 && rc.rd_address>10&&rc.rd_layer==1'b1&&rc.controller.itr==test_iter) begin
               $write("[Iteration %0d][D_in : Before L1 processing]",rc.controller.itr); 
               //$display("reference: %b",membb6[count3]);
               if(membb6[count3]==rc.dmem_rd_data_regout) begin
                    $write("Read success on count %d\n",count3);
                    //$display("Dread Success");
               end
               else begin
                    $write("Read FAIL on count %d\n",count2);
                    $display("din_data         : %b",rc.dmem_rd_data_regout);
                    $display("output ^ reference %b",membb6[count3]^rc.dmem_rd_data_regout);
               end
               count3=count3+1;
        end
                
        //$display("dout_data: %b",rc.Dout_regout[25:0]);
        
        if(count4<20&&rc.rd_address>11&&rc.rd_layer==1'b0&&rc.controller.itr==test_iter) begin
           //$display("reference: %b",membb7[count4]);
           $write("[Iteration %0d][D_out : After L0 processing]",rc.controller.itr);
           if(membb7[count4]==rc.Dout_regout[25:0]) begin
               $write("Write success on count %d\n",count4);
           end
           else begin
               $write("Write FAIL on count %d\n",count4); 
               $display("dout_data:         %b",rc.Dout_regout[25:0]);
               $display("output ^ reference %b",membb7[count4]^rc.Dout_regout[25:0]);
           end
           count4=count4+1;
        end
        
        if(count5<20&&rc.rd_address>11&&rc.rd_layer==1'b1&&rc.controller.itr==test_iter) begin
           //$display("reference: %b",membb8[count5]);
           $write("[Iteration %0d][D_out : After L1 processing]",rc.controller.itr);
           if(membb8[count5]==rc.Dout_regout[25:0]) begin
                $write("Write success on count %d\n",count5);
           end
           else begin
                $write("Write FAIL on count %d\n",count5); 
                $display("output ^ reference %b",membb8[count5]^rc.Dout_regout[25:0]);
           end
           count5=count5+1;
        end
        
        //$display("CONTROLLER state : %d, iteration : %d", rc.controller.ps, rc.controller.itr);
        //$display("DECODER READY %b", decoder_ready);
        
        if(count_unload == 1)begin
            unloadAddress = unloadAddress + 1;
        end
        if(decoder_ready)begin
            unload_en = 1'b1;
            count_unload = 1;
        end    
    end
    
    
    always@(unload_HDout_vec_regout)begin
        //$display("%d unload_address %d | UNLOAD OUT : %b ",$time, unloadAddress,unload_HDout_vec_regout);
        
        if(unloadAddress < 18)begin
            if(unload_17x448[unloadAddress-1] == unload_HDout_vec_regout)begin
                $display("Unload success on count (%d/16)",unloadAddress - 1);
            end
            else begin
                 $display("Unload FAIL on count (%d/16)",unloadAddress - 1);
                 $display("%b\n%b\n%b", unload_17x448[unloadAddress-1], unload_HDout_vec_regout, unload_17x448[unloadAddress-1]^unload_HDout_vec_regout);
            end
        end
    end
       //#40;
       //$finish; 
    /*always@(negedge clk) begin
    #1
    
    end*/
endmodule