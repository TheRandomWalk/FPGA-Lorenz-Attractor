# FPGA 3D Lorenz Attractor

The design generates a 3D rotating Lorenz Attractor by outputing two (X,Y) delta-sigma modulated signals to two pins of the FPGA (Digilent Cmod S7). Two low-pass filters at each of the output pins are required to produce the analog signals that when fed into an oscilloscope in X-Y mode produce a 3D animation. Adaptation to other Xilinx 7th generation FPGAs should be trivial. 

A short video demonstration on an analog oscilloscope can be found 
[here](https://youtu.be/wsKYDP7gW8k).

