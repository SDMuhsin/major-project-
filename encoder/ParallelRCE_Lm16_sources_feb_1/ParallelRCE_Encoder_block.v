`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 10:21:48 AM
// Design Name: 
// Module Name: ParallelRCE_Encoder_block
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
// Tclkin/Tclk = 5/4
// Tclkin > 41.871 , taking Tclkin = 45ns
// Tclkout = (4/5)*45 = 36ns
// for simulation: Tclkin = 4.5ns, Tclkout = 3.6ns
//////////////////////////////////////////////////////////////////////////////////

module ParallelRCE_Encoder_block(y,msg,datavalid,rst,clk_in,clk);
parameter K=1024;
parameter K_N=256;
parameter Lm=16;
parameter La=8;
parameter M=32;
parameter LMLA = M*La;
parameter MSEL_BITSIZE = 3;//log2(K/(Lm*La))
output y;
//output p;
input msg;
input datavalid;
input rst;
input clk_in,clk;
wire [K_N-1:0]pr,pr1,pr2,pr3,pr4,pr5,pr6,pr7,pr8;
wire y;
wire sm;//spi message actitive uopto four cycle
wire[LMLA-1:0]msg_to_encode; // 
wire  t_en,p_en,en;
wire [MSEL_BITSIZE-1:0]m_en;
wire[1:0] f_sel;
wire [K_N-1:0]f[7:0];
wire msg_to_tx;
//wire [ q11;
wire[K_N-1:0]q12;
wire [(K_N/8-1):0]p11,p12,p13,p14,p15,p16,p17,p18;
wire [(K_N/8-1):0]p21,p22,p23,p24,p25,p26,p27,p28;
wire [(K_N/8-1):0]p31,p32,p33,p34,p35,p36,p37,p38;
wire [(K_N/8-1):0]p41,p42,p43,p44,p45,p46,p47,p48;
wire [(K_N/8-1):0]p51,p52,p53,p54,p55,p56,p57,p58;
wire [(K_N/8-1):0]p61,p62,p63,p64,p65,p66,p67,p68;
wire [(K_N/8-1):0]p71,p72,p73,p74,p75,p76,p77,p78;
wire [(K_N/8-1):0]p81,p82,p83,p84,p85,p86,p87,p88;
//wire [M-1:0]msg_to_encode;
defparam spi.K=K, spi.Lm=Lm, spi.La=La, spi.M=M, spi.MSEL_BITSIZE=MSEL_BITSIZE;
 SPI_final_size spi(msg_to_tx,msg_to_encode,en,sm,f_sel,msg,datavalid,rst,clk_in,clk);

//Final_fsm(en,parity_parload_en,t_en,f_sel,m_en,sm,start,rst,clk_in,clk);
defparam controllerfsm.K=K,controllerfsm.K_N=256;
defparam controllerfsm.Lm=Lm, controllerfsm.La=La, controllerfsm.MSEL_BITSIZE=MSEL_BITSIZE;
Final_fsm controllerfsm(en,p_en,t_en,f_sel,m_en,sm,datavalid,rst,clk_in,clk);

//Layer-1: Msg MSB(8th 256 section), F0 --> Pr1
defparam g_lut0.K_N=K_N;                                                                                                
Function_generator0 g_lut0(f[0],f_sel,rst);                                                                          
Encoding_Unit DUT01( pr1[(1*K_N/8-1):0*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1 
Encoding_Unit DUT02( pr1[(2*K_N/8-1):1*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2 
Encoding_Unit DUT03( pr1[(3*K_N/8-1):2*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT04( pr1[(4*K_N/8-1):3*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT05( pr1[(5*K_N/8-1):4*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT06( pr1[(6*K_N/8-1):5*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT07( pr1[(7*K_N/8-1):6*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT08( pr1[(8*K_N/8-1):7*K_N/8],msg_to_encode[(8*LMLA/8-1):7*LMLA/8],f[0][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8

     ////final parity corresponding column1                                       
           // assign pr1={p11,p12,p13,p14,p15,p16,p17,p18};                               

//Layer-2: Msg (7th 256 section), F1 --. pr2
defparam g_lut1.K_N=K_N;
Function_generator1 g_lut1(f[1],f_sel,rst);          //7                           
Encoding_Unit DUT11( pr2[(1*K_N/8-1):0*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT12( pr2[(2*K_N/8-1):1*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT13( pr2[(3*K_N/8-1):2*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT14( pr2[(4*K_N/8-1):3*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT15( pr2[(5*K_N/8-1):4*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT16( pr2[(6*K_N/8-1):5*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT17( pr2[(7*K_N/8-1):6*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT18( pr2[(8*K_N/8-1):7*K_N/8],msg_to_encode[(7*LMLA/8-1):6*LMLA/8],f[1][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8

       ////final parity corresponding column2                                      
         //  assign pr2={p21,p22,p23,p24,p25,p26,p27,p28};  

//Layer-2: Msg (6th 256 section), F2 --. pr3      
defparam g_lut2.K_N=K_N;
Function_generator2 g_lut2(f[2],f_sel,rst);      //6                                
Encoding_Unit DUT21( pr3[(1*K_N/8-1):0*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT22( pr3[(2*K_N/8-1):1*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT23( pr3[(3*K_N/8-1):2*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT24( pr3[(4*K_N/8-1):3*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT25( pr3[(5*K_N/8-1):4*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT26( pr3[(6*K_N/8-1):5*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT27( pr3[(7*K_N/8-1):6*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT28( pr3[(8*K_N/8-1):7*K_N/8],msg_to_encode[(6*LMLA/8-1):5*LMLA/8],f[2][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8
        // //final parity corresponding column3                                    
         //  assign pr3={p31,p32,p33,p34,p35,p36,p37,p38};

//Layer-3: Msg (5th 256 section), F3 --. pr4
defparam g_lut3.K_N=K_N;
Function_generator3 g_lut3(f[3],f_sel,rst);     //5                           
Encoding_Unit DUT31( pr4[(1*K_N/8-1):0*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT32( pr4[(2*K_N/8-1):1*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT33( pr4[(3*K_N/8-1):2*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT34( pr4[(4*K_N/8-1):3*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT35( pr4[(5*K_N/8-1):4*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT36( pr4[(6*K_N/8-1):5*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT37( pr4[(7*K_N/8-1):6*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT38( pr4[(8*K_N/8-1):7*K_N/8],msg_to_encode[(5*LMLA/8-1):4*LMLA/8],f[3][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8
           /////final parity corresponding column4 
         // assign pr4={p41,p42,p43,p44,p45,p46,p47,p48};

//Layer-4: Msg (4th 256 section), F4 --. pr5
defparam g_lut4.K_N=K_N;
Function_generator4 g_lut4(f[4],f_sel,rst);    //4                         
Encoding_Unit DUT41( pr5[(1*K_N/8-1):0*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT42( pr5[(2*K_N/8-1):1*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT43( pr5[(3*K_N/8-1):2*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT44( pr5[(4*K_N/8-1):3*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT45( pr5[(5*K_N/8-1):4*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT46( pr5[(6*K_N/8-1):5*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT47( pr5[(7*K_N/8-1):6*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT48( pr5[(8*K_N/8-1):7*K_N/8],msg_to_encode[(4*LMLA/8-1):3*LMLA/8],f[4][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8
               ////final parity corresponding column5                              
         // assign pr5={p51,p52,p53,p54,p55,p56,p57,p58};

//Layer-5: Msg (3th 256 section), F5 --. pr6
defparam g_lut5.K_N=K_N;
Function_generator5 g_lut5(f[5],f_sel,rst);  //3                         
Encoding_Unit DUT51( pr6[(1*K_N/8-1):0*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT52( pr6[(2*K_N/8-1):1*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT53( pr6[(3*K_N/8-1):2*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT54( pr6[(4*K_N/8-1):3*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT55( pr6[(5*K_N/8-1):4*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT56( pr6[(6*K_N/8-1):5*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT57( pr6[(7*K_N/8-1):6*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT58( pr6[(8*K_N/8-1):7*K_N/8],msg_to_encode[(3*LMLA/8-1):2*LMLA/8],f[5][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8
                //// final parity corresponding column6                            
           //assign pr6={p16,p62,p63,p64,p65,p66,p67,p68};

//Layer-6: Msg (2nd 256 section), F6 --. pr7
defparam g_lut6.K_N=K_N;
Function_generator6 g_lut6(f[6],f_sel,rst);            //2              
Encoding_Unit DUT61( pr7[(1*K_N/8-1):0*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT62( pr7[(2*K_N/8-1):1*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT63( pr7[(3*K_N/8-1):2*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT64( pr7[(4*K_N/8-1):3*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT65( pr7[(5*K_N/8-1):4*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT66( pr7[(6*K_N/8-1):5*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT67( pr7[(7*K_N/8-1):6*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT68( pr7[(8*K_N/8-1):7*K_N/8],msg_to_encode[(2*LMLA/8-1):LMLA/8],f[6][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8
                    //// final parity corresponding column7                        
         // assign pr7={p71,p72,p73,p74,p75,p76,p77,p78};

//Layer-7: Msg (1st 256 section), F7 --. pr8
defparam g_lut7.K_N=K_N;
Function_generator7 g_lut7(f[7],f_sel,rst);       //1                  
Encoding_Unit DUT71( pr8[(1*K_N/8-1):0*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(1*K_N/8-1):0*K_N/8],m_en[0],rst,clk_in);//processing unit-1
Encoding_Unit DUT72( pr8[(2*K_N/8-1):1*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(2*K_N/8-1):1*K_N/8],m_en[0],rst,clk_in);//processing unit-2
Encoding_Unit DUT73( pr8[(3*K_N/8-1):2*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(3*K_N/8-1):2*K_N/8],m_en[0],rst,clk_in);//processing unit-3
Encoding_Unit DUT74( pr8[(4*K_N/8-1):3*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(4*K_N/8-1):3*K_N/8],m_en[0],rst,clk_in);//processing unit-4
Encoding_Unit DUT75( pr8[(5*K_N/8-1):4*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(5*K_N/8-1):4*K_N/8],m_en[0],rst,clk_in);//processing unit-5
Encoding_Unit DUT76( pr8[(6*K_N/8-1):5*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(6*K_N/8-1):5*K_N/8],m_en[0],rst,clk_in);//processing unit-6
Encoding_Unit DUT77( pr8[(7*K_N/8-1):6*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(7*K_N/8-1):6*K_N/8],m_en[0],rst,clk_in);//processing unit-7
Encoding_Unit DUT78( pr8[(8*K_N/8-1):7*K_N/8],msg_to_encode[(LMLA/8-1):0],f[7][(8*K_N/8-1):7*K_N/8],m_en[0],rst,clk_in);//processing unit-8
                   ////  final parity corresponding column8  
    // assign pr8={p81,p82,p83,p84,p85,p86,p87,p88};
     assign pr=pr1^pr2^pr3^pr4^pr5^pr6^pr7^pr8;
//     defparam parityacc.M=M;
//     Parity_accumulation parityacc(q12,pr,rst,clk_in);// not needed if Lm
     defparam parity_shifter.K_N=K_N;
     Parity_tx parity_shifter(p,pr,p_en,t_en,rst,clk);//p_en is parload_en
     transmitter_mux code_tx_mux(y,p,msg_to_tx,t_en);//transmitter_mux(y,s==1,s==0,s);
endmodule
