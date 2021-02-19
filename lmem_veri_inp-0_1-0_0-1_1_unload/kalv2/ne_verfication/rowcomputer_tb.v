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


module rowcomputer_tb(

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
    parameter MAXITRS = 10;
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
    
    reg [47-1:0]E_out_26x47[26-1:0];
    ne_rowcomputer_pipeV3_SRQ_p26 rc(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);
    integer i;
    integer j;
    integer count;
    integer count1;
    initial begin
    clk=1'b0;
    rst = 1'b0;
    loaden=1'b0;
    load_data=0;
    start=1'b0;
    unload_en=1'b0;
    unloadAddress=0;
    count=0;
    count1=0;
    i=0;
    j=0;
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\input_codeword_17x32x16.txt",membb);
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\L0_in_scripted.txt",membb1);
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\L0_out_scripted.txt",membb2);
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\L1_in_scripted.txt",membb3);
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\L1_out_scripted.txt",membb4);
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
    
    
    end
    always #2 clk = ~clk;
    
    //assign lin_data_display
    /*always@(posedge clk) begin
            #200
            $display("reference: %h",membb1[rc.rd_address-3]);
    end*/
        //integer count;
    integer f;
    reg [1400:0]fn;
    integer wa_count;
    
    reg [47-1:0]E_in_26x47[26-1:0];
    always@(posedge clk) begin
            
            if(  rc.rd_address == 8'h0a  ) begin
                $display("WA START");
                wa_count = 0;
            end
            
            if( wa_count < 20 )begin
                
                $display("address: %h",rc.rd_address);
                $display("WR\n");
                
                $display("itr = %b, wr_en = %b, wr_layer = %b, rd_en = %b, rd_layer = %b", rc.controller.itr,rc.wr_en,rc.wr_layer,rc.rd_en,rc.rd_layer);
                $display("count = %d",wa_count);
                
                $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\E_out_i%0d_l%0d_s%0d_scripted.txt", rc.controller.itr, rc.wr_layer, wa_count);//count);
                $readmemb(fn, E_out_26x47);
                    
                $display("E_WA %d %b",rc.p26_loop[25].rcu.E_WA,rc.p26_loop[25].rcu.Ecomp_wr_datain);
                
                if(rc.p26_loop[25].rcu.Ecomp_wr_datain != E_out_26x47[0])begin
                    $display("NO MATCH on P[25]");
                    $display("XOR %b ", rc.p26_loop[25].rcu.Ecomp_wr_datain ^ E_out_26x47[0]);
                end
                
                $display("E_WA %d %b",rc.p26_loop[24].rcu.E_WA,rc.p26_loop[24].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[23].rcu.E_WA,rc.p26_loop[23].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[22].rcu.E_WA,rc.p26_loop[22].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[21].rcu.E_WA,rc.p26_loop[21].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[20].rcu.E_WA,rc.p26_loop[20].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[19].rcu.E_WA,rc.p26_loop[19].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[18].rcu.E_WA,rc.p26_loop[18].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[17].rcu.E_WA,rc.p26_loop[17].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[16].rcu.E_WA,rc.p26_loop[16].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[15].rcu.E_WA,rc.p26_loop[15].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[14].rcu.E_WA,rc.p26_loop[14].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[13].rcu.E_WA,rc.p26_loop[13].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[12].rcu.E_WA,rc.p26_loop[12].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[11].rcu.E_WA,rc.p26_loop[11].rcu.Ecomp_wr_datain);
                
                if(rc.p26_loop[10].rcu.Ecomp_wr_datain != E_out_26x47[15])begin
                    $display("NO MATCH on P[10]");
                    $display("XOR %b ", rc.p26_loop[10].rcu.Ecomp_wr_datain ^ E_out_26x47[15]);
                end
                $display("E_WA %d %b",rc.p26_loop[10].rcu.E_WA,rc.p26_loop[10].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[9].rcu.E_WA,rc.p26_loop[9].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[8].rcu.E_WA,rc.p26_loop[8].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[7].rcu.E_WA,rc.p26_loop[7].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[6].rcu.E_WA,rc.p26_loop[6].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[5].rcu.E_WA,rc.p26_loop[5].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[4].rcu.E_WA,rc.p26_loop[4].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[3].rcu.E_WA,rc.p26_loop[3].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[2].rcu.E_WA,rc.p26_loop[2].rcu.Ecomp_wr_datain);
                $display("E_WA %d %b",rc.p26_loop[1].rcu.E_WA,rc.p26_loop[1].rcu.Ecomp_wr_datain);
                
                if(rc.p26_loop[0].rcu.Ecomp_wr_datain != E_out_26x47[25])begin
                    $display("NO MATCH on P[0]");
                    $display("XOR %b ",rc.p26_loop[0].rcu.Ecomp_wr_datain ^ E_out_26x47[25]);
                end
                $display("E_WA %d %b",rc.p26_loop[0].rcu.E_WA,rc.p26_loop[0].rcu.Ecomp_wr_datain);
            
                wa_count = wa_count + 1;            
            end
                /*
                $display("RD\n%b",rc.p26_loop[24].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[23].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[22].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[21].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[20].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[19].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[18].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[17].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[16].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[15].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[14].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[13].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[12].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[11].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[10].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[9].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[8].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[7].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[6].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[5].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[4].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[3].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[2].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[1].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[0].rcu.Emem_rd_dataout_regin);
                */
        /*
        if(rc.rd_address>12&&rc.rd_layer==1'b0) begin
            $display("----------------------------------------------------");
            $display("[RCU output after L0 processing]");
            $display("reference: %b",membb2[count]);
            if(membb2[count]==rc.wr_data) begin
                 $display("L0 Write Success on count %d",count);
            end
            else begin
                $display("L0 Write FAIL     on count %d",count);
            end
            
            
            $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\E_out_l%0d_s%0d_scripted.txt", 0, 0);//count);
            $readmemb(fn, E_out_26x47);
            
                
            $display("[E_out check]");
            $display("[E_out into EMEM]");
                
                       
                    if(rc.p26_loop[25].rcu.Ecomp_wr_datain[31:0] == E_out_26x47[0][31:0])begin
                        $display("DING");
                    end
                
                        $display("  %b",rc.p26_loop[25].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[24].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[23].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[22].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[21].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[20].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[19].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[18].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[17].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[16].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[15].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[14].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[13].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[12].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[11].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[10].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[9].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[8].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[7].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[6].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[5].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[4].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[3].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[2].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[1].rcu.Ecomp_wr_datain);
                        $display("  %b",rc.p26_loop[0].rcu.Ecomp_wr_datain);
                        

                
                $display("%b",rc.p26_loop[24].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[23].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[22].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[21].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[20].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[19].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[18].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[17].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[16].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[15].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[14].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[13].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[12].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[11].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[10].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[9].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[8].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[7].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[6].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[5].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[4].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[3].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[2].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[1].rcu.Emem_rd_dataout_regin);
                $display("%b",rc.p26_loop[0].rcu.Emem_rd_dataout_regin);
            $display("----------------------------------------------------");
            count=count+1;
        end*/
        /*
        if(rc.rd_address>12&&rc.rd_layer==1'b1) begin
            $display("----------------------------------------------------");
            $display("[RCU output after L1 processing]");
            $display("reference: %b",membb4[count1]);
            if(membb4[count1]==rc.wr_data) begin
                $display("Write Success");
            end
            count1=count1+1;
            $display("----------------------------------------------------");
            
        end
        $display("read_data: %b",rc.rd_data_regout);
        if(rc.rd_address>2&&rc.rd_address<19&&rc.rd_layer==1'b0) begin
            $display("reference: %b",membb1[rc.rd_address-3]);
            if(membb1[rc.rd_address-3]==rc.rd_data_regout) begin
               $display("Read Success on address %d",rc.rd_address-3);
            end 
        //i=i+1;
        end */
        /*
        if(rc.rd_address>2&&rc.rd_address<19&&rc.rd_layer==1'b1) begin
            $display("----------------------------------------------------");
            $display("L01 out into RCU for L1 processing");
            $display("reference:         %b",membb3[rc.rd_address-3]);
            $display("rc.rd_data_regout: %b",rc.rd_data_regout);
            $display("xor              : %b",membb3[rc.rd_address-3]^rc.rd_data_regout);
            
            if(membb3[rc.rd_address-3]==rc.rd_data_regout) begin
                $display("Read Success on address %d", rc.rd_address-3);
            end
            else begin
                $display("Failure on add %d",rc.rd_address-3);
                
                $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\from_tb_ref%0d.txt",rc.rd_address-3 );
                f = $fopen(fn ,"w");
                $fwrite(f,"%b",membb3[rc.rd_address-3]);
                $fclose(f);
                
                $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\kal\\ne_verfication\\Scripts\\outputs\\from_tb_op%0d.txt",rc.rd_address-3);
                f = $fopen( fn,"w");
                $fwrite(f,"%b",rc.rd_data_regout);
                $fclose(f);
               
                
            end
            $display("----------------------------------------------------");
        //j=j+1;
        end*/
        //$display("din_data : %b",rc.dmem_rd_data_regout);
        //$display("dout_data: %b",rc.Dout_regout[25:0]);
        /*if(rc.rd_address==5'b10011) begin
        count=count+1;
        end
        if(count>0) begin
        $display("reference: %h",membb1[15+count]);
        end */       
    end
       //#40;
       //$finish; 
    /*always@(negedge clk) begin
    #1
    
    end*/
endmodule