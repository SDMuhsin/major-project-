@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim LMem1To0_511_circ0_ys_yu_scripted_behav -key {Behavioral:sim_1:Functional:LMem1To0_511_circ0_ys_yu_scripted} -tclbatch LMem1To0_511_circ0_ys_yu_scripted.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
