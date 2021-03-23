@[TOC]

# instruction fetch
## PC
address regester.
- describe:
    curr_addr=next_addr 
- input: 
    + next_addr(inner)
    + CLK(extern)
- output:
    + curr_addr(inner)

## adder (+4)
- describe:
    next_addr=curr_addr+4
- input: 
    + curr_addr(inner)
- output:
    + next_addr'(inner)

## instruction memory
- describe:
    curr_instruction=instruction(curr_addr)
- input: 
    + curr_addr(inner)
- output:
    + curr_instruction'(inner)

## NPC
- describe:
    next_addr=next_addr'
- input:
    + next_addr'(inner)
    + CLK(extern)
- output:
    + next_addr(inner)

## instruction register
- describe:
    curr_instruction=curr_instruction'
- input:
    + curr_instruction'(inner)
    + CLK(extern)
- output:
    + curr_instruction(inner)

# instruction decode/register fetch
## register file
- describe:
    rf_addr_A=curr_instruction & 0x00ff
    rf_addr_B=(curr_instruction & 0xff00)>>8
    or
    rf_addr=curr_instruction(8bit)  **?**

    data_out_A'=RF[rf_addr_A]
    data_out_B'=RF[rf_addr_B]
    or
    RF[rf_addr]=data_writeback
- input:
    + curr_instruction(inner)
    + write_back_data(inner)
    + CLK (extern)
    + EN (extern)
- output:
    + data_out_A'
    + data_out_B'

## A register
- describe:
    operand_A=data_out_A'
- input:
    + data_out_A'(inner)
    + CLK (extern)
- output:
    + operand_A(inner)

## B register
- describe:
    operand_B=data_out_B'
- input:
    + data_out_B'(inner)
    + CLK (extern)
- output:
    + operand_B(inner)

## sign extend
- describe:
    imm_out'(31 downto 16)<=sign
    imm_out'(15 downto 0)<=curr_instruction
- input:
    + curr_instruction(inner)
- output:
    + imm_out'(inner)

## immidiate register(32 bit)
- describe:
    imm_out=imm_out'
- input:
    + imm_out'(inner)
    + CLK (extern)
- output:
    + imm_out(inner)

# Excute/addr calculation
## branch
- describe:
    if(operand_A==0){
        Mux=jump
    }else{
        Mux=Nojump
    }
- input:
    + operand_A(inner)
    + CLK(extern)
- output:
    + Mux(inner)

## ALU
- describe:
    porcess1:
    {
    if(Mux_1==A){
        A=operand_A
    }else if(Mux_1==NPC){
        A=next_addr
    }

    if(Mux_2==B){
        B=operand_B
    }else if(Mux_2==imm){
        B=imm_out
    }

    switch operation:
    case add:
        ALU_out'=A+B
    case sub:
        ALU_out'=A-B
        ...
    }

    process2:
    if(CLK=1 and CLK'event){
        ALU_out=ALU_out'
    }
- input:
    + operand_A(inner)
    + operand_B(inner)
    + imm_out(inner)
    + next_addr(inner)
    + CLK(extern)
- output:
    + ALU_output(inner)

## data mem
- input
    data
    addr
    rw
- output
    data
