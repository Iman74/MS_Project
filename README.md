<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Components in lab](#components-in-lab)
- [Components to be done](#components-to-be-done)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
</br>

# Components in lab
| Component | lab | Input | Output | Description |
|:---:|:---|:---:|:---:|:---|
| P4 adder  | 2 | a,b(32bit) </br> cin | s(32bit) </br> co | a+b+cin=cout & s |
| Booth multiplier | 2 |-|-|miss|
| Register file | 3 |CLK </br> reset </br> enable </br> RD1 </br> RD2 </br> WR</br> ADD_WR(5bit) </br> ADD_RD1(5bit) </br> ADD_RD2(5bit) </br> DATAIN (64bit)|OUT1(64bit)</br> OUT2(64bit)|1. enable: enable this component(high)</br> 2. RD1,RD2,WR: enable read from OUT1 and OUT2 respectively and enable write</br> 3. ADD_xxx: the target address of input or output data</br> 4. OUTx: output port 5. DATAIN: input port|
| Windowed RF| 3 | CLK </br> reset </br> enable </br> RD1 </br> RD2 </br> WR</br> ADD_WR(5bit) </br> ADD_RD1(5bit) </br> ADD_RD2(5bit) </br> DATAIN (64bit) </br> **CALL** </br> **RETURN** </br> **DATAfromMEM** (64bit) | OUT1(64bit)</br> OUT2(64bit)</br> **SPILL** </br> **FILL** </br> **DATA2MEM**(64bit) |1. CALL,RETURN: signal that used to call in and quit out from the subroutine</br> 2. SPILL: overflow signal(when all the reg are occupied),transfer data to external block</br> 3. FILL: deal with the subroutine which raises the SPILL signal </br> 4. DATAfromMEM, DATA2MEM: the data-flow under spill condition</br>(3 and 4 not sure)|
| SI-PI-SO ALU | 3 | CLK</br> RESET</br> STARTA</br> A</br> B(4bit)</br> |STARTC</br> C| 1. LOADB: during the signal high B should be loaded in parallel(4 bits) </br> 2. STARTA: start serial load operand A </br> 3. STARTC: start output C in serial(Only sum)</br> suggest redo this component |
| Datapath structure | 4 |-|-|miss|
| Control unit| 4 |-|-|available|

</br>

# Components to be done

| Component | Input | Output | Description |
|:---:|:---:|:---:|:---|
| Instruction memory | addr(8bit) | instr_out(32bit) | ROM |
| Data memory | addr(8bit)</br> datain(32bit)|dataout(32bit)| RAM |
| Booth multiplier |-|-||
| Divider |-|-||
| PC |-|-||
| WB register |-|-||

# Testbench
(edit by neda)
qiondoiqnwidqnwidnq



