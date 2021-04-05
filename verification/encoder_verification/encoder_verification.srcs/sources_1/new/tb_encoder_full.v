`timescale 1ns / 1ps

module tb_encoder_full(

    );
    
    parameter Z=511;
    parameter K=7136;
    parameter Kunshort = 7154; //sys bits with reference to G-matrix
    parameter DW=16;
    parameter COUNTDEPTH = K/DW;//K/DW = 7136/16 = 446
    parameter COUNTWIDTH = 9;//ceil(log2(K/DW)) = ceil(log2(7136/16)) = 9
    parameter KB=14;
    parameter Kunshortwithzeros = Kunshort + KB; //7154 + 14 = 7168
    parameter Lm=16;
    parameter READDEPTH = Kunshortwithzeros/Lm;//K/Lm = 7168/16 = 448
    parameter ADDRESSWIDTH = 9;//ceil(log2(K/DW)) = ceil(log2(7136/16)) = 9
    parameter Z_LM_MSG_DEPTH=(Z+1)/Lm;//(Z+1)/Lm = (511+1)/16) = 32
    parameter ROMADDRESSWIDTH = 4; //ceil(log2(KB)) = ceil(log2(14))= 4
    parameter Z_LM_MSG_WIDTH = 5;// ceil(log2(Z_LM_MSG_DEPTH)) = ceil(log2(32))=5;
    parameter MB=2;//num of blk columns of G parity part
    parameter M = 1022;
    parameter Zeroappend =2;
    parameter M_z = M + Zeroappend;
    parameter DW_opintf=16;
    parameter SYSCOUNT = K/DW_opintf;//K/DW = 7136/16 = 446
    parameter SYSCOUNTWIDTH = 9;//ceil(log2(SYSCOUNT)) = 9
    parameter PARITYCOUNT = M_z/DW; // M_z/DW= 1024 /16 = 64
    parameter PARITYCOUNTWIDTH = 6;//ceil(log2(PARITYCOUNT)) = 6
    
    wire  codevalid;
    wire [DW-1:0] codeTx;
    reg[DW-1:0] msg_data_regin;
    reg datavalid_regin;
    reg outclk;
    reg inclk;
    reg clk;
    reg rst;
    
    ne_enc_top_v0 dut(codevalid,codeTx, msg_data_regin, datavalid_regin, outclk, inclk, clk, rst);
    
    reg [DW-1:0]mem_inp[446-1:0];
    reg [DW-1:0]mem_op[511-1:0];
    
    parameter T_out_h = 2;
    parameter T_in_h = 2;
    parameter T_h = 1;
    
    
    integer incount = 0;
    integer outcount = 0;
    
    integer output_flag=1;
    
    integer show_inpintf_state = 1;
    integer show_inpintf_loadstate = 0;
    integer show_outputintf = 0;
    initial begin
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\encoder\\30-03-2021\\scripts\\outputs\\inp_446x16.txt", mem_inp);
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\encoder\\30-03-2021\\scripts\\outputs\\op_511x16.txt", mem_op);
        
        clk = 0;
        inclk = 0;
        outclk = 0;
        
        rst = 1;
        @(posedge inclk);
        #0.01;
        rst = 0;
        
        incount = 0;
        outcount = 0;
        #T_in_h;
        #T_in_h;
        #0.5 show_inpintf_loadstate = 0;
    end
    
    always #T_h clk = ~clk;
    always #T_in_h inclk = ~inclk;
    always #T_out_h outclk = ~outclk;
    
  

    always@(negedge dut.inpintf.datavalid)begin
        #0.4;
        show_inpintf_state = 0;
        $display("No longer monitoring input interface");
        
        
        //show_inpintf_loadstate = 1;
        //$display("Monitoring input interface's loading portion");
    end
    always@(posedge dut.inpintf.datavalid)begin
        show_inpintf_state = 1;
        $display("Monitoring input interface");
    end
    
    integer stop_input = 0;
    integer input_feed = 1;
    always@(posedge inclk)begin
        if(input_feed == 0 && show_outputintf == 0)begin
            
            #0.01;
            datavalid_regin = 0;
            

            
        end
        #0.01;
        
        
        if(incount < 446 && input_feed == 1)begin
            $display("Feeding input %d",incount);
            $display("-%b\n%b\n%b", mem_inp[incount],dut.inpintf.D_SR[0],dut.inpintf.D_SR[445]);
            datavalid_regin = 1;
            msg_data_regin= mem_inp[incount];
            show_inpintf_loadstate = 0; 
            
            if(incount == COUNTDEPTH-1)begin
                $display("[inck %d] 445th input has been fed, stopping input_feed",incount);
                input_feed = 0;
                
            end
            
            if(incount == COUNTDEPTH+2)begin
                $display("Monitoring input interface's loading portion");
                show_inpintf_loadstate = 1;

            end
        end
        else begin
            //$display("BEGUN monitoring input loader");
            //datavalid_regin = 0;
            //show_inpintf_loadstate = 1;
        end

         
        if(show_inpintf_state==1) begin
            $display("inpintrf state : %d, count : %d, datavalid = %b, nextfifofull = %b", dut.inpintf.ps, dut.inpintf.count, dut.inpintf.datavalid, dut.inpintf.nextfifofull);
        end
        

        
        incount = incount + 1;
    end
    
    integer monitor_parity_clk = 0;

    always@(posedge clk)begin
        if(show_inpintf_loadstate==1)begin
            $display("-----------------------------------------------");
            //$display("[inclk %d]inpintrf state : %d, count : %d, datavalid = %b, fifofull =%b, nextfifofull = %b", incount, dut.inpintf.ps, dut.inpintf.count, dut.inpintf.datavalid, dut.inpintf.fifofull, dut.inpintf.nextfifofull);
            $display("[CLK][inpintf load] psload = %b, dut.address = %d, wren = %b, dut.controller.ps = %b, loaden[0] = %b, loaden[1] = %b", dut.inpintf.psload, dut.address, dut.wren, dut.controller.ps, dut.inpintf.loaden[0], dut.inpintf.loaden[1]);
            $display(" %b", dut.msgLmtoencode);
            
            $display("---u_reg monitor---");
            $display("%b\n%b", dut.u_reg_0, dut.u_reg_1);
            $display("---parity out monitor--");
            $display("%b\n%b",dut.parityout_0,dut.parityout_1);
            $display("-- output interface wren = %b",dut.wren);
        end
        if(dut.address == 447)begin
            $display("Disabling input load monitor");
            show_outputintf = 0;
        end
        


    end
    
    always@(dut.parity_parloaden)begin
        $display("\n\n\n\n-------------------parity_parloaden active !---------------------\n\n\n");
    end
    always@(posedge codevalid)begin
        #0.01;
        if(output_flag == 1)begin
            output_flag = 0;
            $display("-------Output ready-------");
        end
    end
    always@(posedge outclk)begin
        $display("[outclk outcount %d], op controller state %d, dut.controller state %d, parity_regin %h", outcount, dut.opintf.ps, dut.controller.ps, dut.parityout_regin);
        #0.02;
        if(output_flag == 0 && outcount < 512)begin
            $display("outclk = %d",outclk);
            $display("Reference :%b", mem_op[outcount]);        
            $display("Output    :%b", dut.codeTx);   
            
            if(mem_op[outcount] == dut.codeTx)begin
                $display("MATCH !");
            end
            else begin
                $display("NO MATCH :(");
            end
            outcount = outcount + 1;     
        end
        
        if(dut.opintf.ps > 0)begin
            $display("opintrf state : %d",dut.opintf.ps);
        end
        
    end
    
    always@(dut.controller.ps)begin
        $display("\t[DUT CONTROLLER STATE CHANGED] %d",dut.controller.ps);
    end
    
endmodule
