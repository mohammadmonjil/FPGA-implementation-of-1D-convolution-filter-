
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-349h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px� 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
82default:defaultZ35-254h px� 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
[
%s*common2B
.Phase 1 Build RT Design | Checksum: 1eb278965
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:32 ; elapsed = 00:00:21 . Memory (MB): peak = 3041.305 ; gain = 0.000 ; free physical = 3655 ; free virtual = 124622default:defaulth px� 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
{

Phase %s%s
101*constraints2
2.1 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
f
%s*common2M
9Phase 2.1 Fix Topology Constraints | Checksum: 1eb278965
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:32 ; elapsed = 00:00:21 . Memory (MB): peak = 3041.305 ; gain = 0.000 ; free physical = 3624 ; free virtual = 124302default:defaulth px� 
t

Phase %s%s
101*constraints2
2.2 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
_
%s*common2F
2Phase 2.2 Pre Route Cleanup | Checksum: 1eb278965
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:32 ; elapsed = 00:00:21 . Memory (MB): peak = 3041.305 ; gain = 0.000 ; free physical = 3624 ; free virtual = 124302default:defaulth px� 
p

Phase %s%s
101*constraints2
2.3 2default:default2!
Update Timing2default:defaultZ18-101h px� 
[
%s*common2B
.Phase 2.3 Update Timing | Checksum: 1730b9f4c
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:46 ; elapsed = 00:00:25 . Memory (MB): peak = 3041.305 ; gain = 0.000 ; free physical = 3582 ; free virtual = 123892default:defaulth px� 
�
Intermediate Timing Summary %s164*route2K
7| WNS=-5.087 | TNS=-50.147| WHS=-2.125 | THS=-180.116|
2default:defaultZ35-416h px� 
}

Phase %s%s
101*constraints2
2.4 2default:default2.
Update Timing for Bus Skew2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
2.4.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
\
%s*common2C
/Phase 2.4.1 Update Timing | Checksum: e068d3fc
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:57 ; elapsed = 00:00:28 . Memory (MB): peak = 3047.438 ; gain = 6.133 ; free physical = 3578 ; free virtual = 123852default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=-5.087 | TNS=-50.140| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
h
%s*common2O
;Phase 2.4 Update Timing for Bus Skew | Checksum: 10ef3fc12
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:57 ; elapsed = 00:00:28 . Memory (MB): peak = 3063.438 ; gain = 22.133 ; free physical = 3577 ; free virtual = 123842default:defaulth px� 
a
%s*common2H
4Phase 2 Router Initialization | Checksum: 11a6c6fb9
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:58 ; elapsed = 00:00:28 . Memory (MB): peak = 3063.438 ; gain = 22.133 ; free physical = 3564 ; free virtual = 123722default:defaulth px� 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
3.1 2default:default2"
Global Routing2default:defaultZ18-101h px� 
\
%s*common2C
/Phase 3.1 Global Routing | Checksum: 11a6c6fb9
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:58 ; elapsed = 00:00:28 . Memory (MB): peak = 3063.438 ; gain = 22.133 ; free physical = 3564 ; free virtual = 123722default:defaulth px� 
[
%s*common2B
.Phase 3 Initial Routing | Checksum: 18fbb037f
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:19 ; elapsed = 00:00:33 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3540 ; free virtual = 123472default:defaulth px� 
�
>Design has %s pins with tight setup and hold constraints.

%s
244*route2
182default:default2�
�The top 5 pins with tight setup and hold constraints:

+===============================+===============================+====================================================================================================================================================================================================================================+
| Launch Setup Clock            | Launch Hold Clock             | Pin                                                                                                                                                                                                                                |
+===============================+===============================+====================================================================================================================================================================================================================================+
| clk_out1_design_1_clk_wiz_0_0 | clk_out1_design_1_clk_wiz_0_0 | design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[12]/D                                                                                                                                   |
| clk_out1_design_1_clk_wiz_0_0 | clk_out1_design_1_clk_wiz_0_0 | design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[9]/D                                                                                                                                    |
| clk_out1_design_1_clk_wiz_0_0 | clk_out1_design_1_clk_wiz_0_0 | design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM0_RD/DMA_READ_FIFO/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/rstblk/ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.xpm_cdc_single_inst_rrst_wr/syncstages_ff_reg[0]/D |
| clk_out1_design_1_clk_wiz_0_0 | clk_out1_design_1_clk_wiz_0_0 | design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[8]/D                                                                                                                                    |
| clk_out1_design_1_clk_wiz_0_0 | clk_out1_design_1_clk_wiz_0_0 | design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[6]/D                                                                                                                                    |
+-------------------------------+-------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

File with complete list of pins: tight_setup_hold_pins.txt
2default:defaultZ35-580h px� 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2K
7| WNS=-5.110 | TNS=-268.343| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
`
%s*common2G
3Phase 4.1 Global Iteration 0 | Checksum: 1497694a4
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:38 ; elapsed = 00:00:41 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3570 ; free virtual = 123762default:defaulth px� 
u

Phase %s%s
101*constraints2
4.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2K
7| WNS=-5.110 | TNS=-111.462| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
`
%s*common2G
3Phase 4.2 Global Iteration 1 | Checksum: 10011f9d1
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:40 ; elapsed = 00:00:41 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3571 ; free virtual = 123772default:defaulth px� 
^
%s*common2E
1Phase 4 Rip-up And Reroute | Checksum: 10011f9d1
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:40 ; elapsed = 00:00:41 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3571 ; free virtual = 123772default:defaulth px� 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
\
%s*common2C
/Phase 5.1.1 Update Timing | Checksum: db862edd
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:43 ; elapsed = 00:00:42 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3570 ; free virtual = 123772default:defaulth px� 
�
Intermediate Timing Summary %s164*route2K
7| WNS=-5.110 | TNS=-111.462| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
[
%s*common2B
.Phase 5.1 Delay CleanUp | Checksum: 13b1dd193
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:44 ; elapsed = 00:00:42 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3565 ; free virtual = 123712default:defaulth px� 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
e
%s*common2L
8Phase 5.2 Clock Skew Optimization | Checksum: 13b1dd193
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:44 ; elapsed = 00:00:42 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3565 ; free virtual = 123712default:defaulth px� 
g
%s*common2N
:Phase 5 Delay and Skew Optimization | Checksum: 13b1dd193
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:44 ; elapsed = 00:00:42 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3565 ; free virtual = 123712default:defaulth px� 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
\
%s*common2C
/Phase 6.1.1 Update Timing | Checksum: 81650b7e
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:48 ; elapsed = 00:00:44 . Memory (MB): peak = 3077.438 ; gain = 36.133 ; free physical = 3564 ; free virtual = 123702default:defaulth px� 
�
Intermediate Timing Summary %s164*route2K
7| WNS=-5.110 | TNS=-111.332| WHS=-0.657 | THS=-4.885 |
2default:defaultZ35-416h px� 
[
%s*common2B
.Phase 6.1 Hold Fix Iter | Checksum: 10047c231
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:56 ; elapsed = 00:00:50 . Memory (MB): peak = 3337.438 ; gain = 296.133 ; free physical = 3512 ; free virtual = 123182default:defaulth px� 
�	
�The router encountered %s pins that are both setup-critical and hold-critical and tried to fix hold violations at the expense of setup slack. Such pins are:
%s201*route2
182default:default2�
�	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[0]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[1]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[2]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[3]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[4]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[5]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[6]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[7]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[10]/D
	design_1_i/convolve_0/U0/accelerator_v1_0_S00_AXI_inst/U_WRAPPER/U_DRAM1_WR/dma_size_r_reg[11]/D
	.. and 8 more pins.
2default:defaultZ35-468h px� 
X
%s*common2?
+Phase 6 Post Hold Fix | Checksum: d0d42931
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:56 ; elapsed = 00:00:50 . Memory (MB): peak = 3337.438 ; gain = 296.133 ; free physical = 3512 ; free virtual = 123182default:defaulth px� 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px� 
Z
%s*common2A
-Phase 7 Route finalize | Checksum: 15a2d7475
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:57 ; elapsed = 00:00:50 . Memory (MB): peak = 3337.438 ; gain = 296.133 ; free physical = 3515 ; free virtual = 123222default:defaulth px� 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px� 
a
%s*common2H
4Phase 8 Verifying routed nets | Checksum: 15a2d7475
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:57 ; elapsed = 00:00:50 . Memory (MB): peak = 3337.438 ; gain = 296.133 ; free physical = 3515 ; free virtual = 123222default:defaulth px� 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px� 
]
%s*common2D
0Phase 9 Depositing Routes | Checksum: 1122fbf64
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:01:58 ; elapsed = 00:00:51 . Memory (MB): peak = 3353.445 ; gain = 312.141 ; free physical = 3529 ; free virtual = 123302default:defaulth px� 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px� 
q

Phase %s%s
101*constraints2
10.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
\
%s*common2C
/Phase 10.1 Update Timing | Checksum: 122708d69
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:02 ; elapsed = 00:00:52 . Memory (MB): peak = 3353.445 ; gain = 312.141 ; free physical = 3553 ; free virtual = 123542default:defaulth px� 
�
Estimated Timing Summary %s
57*route2K
7| WNS=-5.110 | TNS=-140.495| WHS=0.052  | THS=0.000  |
2default:defaultZ35-57h px� 
B
!Router estimated timing not met.
128*routeZ35-328h px� 
_
%s*common2F
2Phase 10 Post Router Timing | Checksum: 122708d69
2default:defaulth px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:02 ; elapsed = 00:00:52 . Memory (MB): peak = 3353.445 ; gain = 312.141 ; free physical = 3553 ; free virtual = 123542default:defaulth px� 
@
Router Completed Successfully
2*	routeflowZ35-16h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:02:02 ; elapsed = 00:00:52 . Memory (MB): peak = 3353.445 ; gain = 312.141 ; free physical = 3642 ; free virtual = 124432default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1332default:default2
42default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
route_design: 2default:default2
00:02:062default:default2
00:00:542default:default2
3353.4452default:default2
312.1412default:default2
36422default:default2
124432default:defaultZ17-722h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2)
Write XDEF Complete: 2default:default2
00:00:052default:default2
00:00:022default:default2
3353.4452default:default2
0.0002default:default2
36162default:default2
124432default:defaultZ17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
r/home/sekiro/Desktop/Shortcuts/Vivado/RC/Final/convolve_test/convolve_test.runs/impl_1/design_1_wrapper_routed.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
�Executing : report_drc -file design_1_wrapper_drc_routed.rpt -pb design_1_wrapper_drc_routed.pb -rpx design_1_wrapper_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
xreport_drc -file design_1_wrapper_drc_routed.rpt -pb design_1_wrapper_drc_routed.pb -rpx design_1_wrapper_drc_routed.rpx2default:defaultZ4-113h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
586*	vivadotcl2�
v/home/sekiro/Desktop/Shortcuts/Vivado/RC/Final/convolve_test/convolve_test.runs/impl_1/design_1_wrapper_drc_routed.rptv/home/sekiro/Desktop/Shortcuts/Vivado/RC/Final/convolve_test/convolve_test.runs/impl_1/design_1_wrapper_drc_routed.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
%s4*runtcl2�
�Executing : report_methodology -file design_1_wrapper_methodology_drc_routed.rpt -pb design_1_wrapper_methodology_drc_routed.pb -rpx design_1_wrapper_methodology_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_methodology -file design_1_wrapper_methodology_drc_routed.rpt -pb design_1_wrapper_methodology_drc_routed.pb -rpx design_1_wrapper_methodology_drc_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
Y
$Running Methodology with %s threads
74*drc2
82default:defaultZ23-133h px� 
�
2The results of Report Methodology are in file %s.
609*	vivadotcl2�
�/home/sekiro/Desktop/Shortcuts/Vivado/RC/Final/convolve_test/convolve_test.runs/impl_1/design_1_wrapper_methodology_drc_routed.rpt�/home/sekiro/Desktop/Shortcuts/Vivado/RC/Final/convolve_test/convolve_test.runs/impl_1/design_1_wrapper_methodology_drc_routed.rpt2default:default8Z2-1520h px� 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2(
report_methodology: 2default:default2
00:00:252default:default2
00:00:062default:default2
3369.4532default:default2
0.0002default:default2
35972default:default2
124152default:defaultZ17-722h px� 
�
%s4*runtcl2�
�Executing : report_power -file design_1_wrapper_power_routed.rpt -pb design_1_wrapper_power_summary_routed.pb -rpx design_1_wrapper_power_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_power -file design_1_wrapper_power_routed.rpt -pb design_1_wrapper_power_summary_routed.pb -rpx design_1_wrapper_power_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1452default:default2
42default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px� 
�
%s4*runtcl2�
mExecuting : report_route_status -file design_1_wrapper_route_status.rpt -pb design_1_wrapper_route_status.pb
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_timing_summary -max_paths 10 -report_unconstrained -file design_1_wrapper_timing_summary_routed.rpt -pb design_1_wrapper_timing_summary_routed.pb -rpx design_1_wrapper_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px� 
�
rThe design failed to meet the timing requirements. Please see the %s report for details on the timing violations.
188*timing2"
timing summary2default:defaultZ38-282h px� 
�
}There are set_bus_skew constraint(s) in this design. Please run report_bus_skew to ensure that bus skew requirements are met.223*timingZ38-436h px� 
�
%s4*runtcl2m
YExecuting : report_incremental_reuse -file design_1_wrapper_incremental_reuse_routed.rpt
2default:defaulth px� 
g
BIncremental flow is disabled. No incremental reuse Info to report.423*	vivadotclZ4-1062h px� 
�
%s4*runtcl2m
YExecuting : report_clock_utilization -file design_1_wrapper_clock_utilization_routed.rpt
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_bus_skew -warn_on_violation -file design_1_wrapper_bus_skew_routed.rpt -pb design_1_wrapper_bus_skew_routed.pb -rpx design_1_wrapper_bus_skew_routed.rpx
2default:defaulth px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px� 


End Record