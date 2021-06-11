library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dlxTypes is
--pipline
    constant PIPLINE_STAGES : integer :=  5;
    
-- Instruction Coding 
    constant Rtype_Instruction_Num   : integer :=  5;                             
    constant Itype_Instruction_Num   : integer :=  10;                            
    constant Jtype_Instruction_Num   : integer :=  20;  
                              
-- Control word
    constant CW_SIZE   : integer :=  20;                            
    constant CW_MEM_SIZE : integer := 5*Itype_Instruction_Num+ 5*Jtype_Instruction_Num+ 8* Rtype_Instruction_Num;  -- 5*I + 5*j 5 + 8*R    
-- Relocate Mem
    constant RELOC_MEM_SIZE : integer :=Itype_Instruction_Num + Jtype_Instruction_Num + 1 ;-- I + J + 1(R)
-- Control unit input sizes
    constant INSTRUCTION_SIZE   : integer :=  32;                             
    constant OP_CODE_SIZE   : integer :=  6;                              -- OPCODE field size
    constant RS1_ADDRESS_SIZE   : integer :=  5;                              -- RS1 field size
    constant RD_ADDRESS_SIZE   : integer :=  5;                              -- RD field size
    constant RS2_ADDRESS_SIZE   : integer :=  5;                              -- RS1 field size (Optinonal --> for R-type)
    constant IMMEDIATE_SIZE   : integer :=  16;                              -- IMMEDIATE field size (Optinonal --> for I-type)
    constant FUNC_SIZE      : integer :=  11;                             -- FUNC field size
    
-- R-Type instruction -> FUNC field
    --constant NOP : std_logic_vector(FUNC_SIZE-1 downto 0) :=  (others => '0');
    constant RTYPE_ADD : std_logic_vector(FUNC_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(0,FUNC_SIZE));    -- ADD RS1,RS2,RD
    constant RTYPE_SUB : std_logic_vector(FUNC_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(1,FUNC_SIZE));    -- SUB RS1,RS2,RD
    constant RTYPE_AND : std_logic_vector(FUNC_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(2,FUNC_SIZE));    -- SUB RS1,RS2,RD
    constant RTYPE_OR  : std_logic_vector(FUNC_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(3,FUNC_SIZE));    -- SUB RS1,RS2,RD

-- R-Type instruction -> OPCODE field
    constant RTYPE : std_logic_vector(OP_CODE_SIZE - 1 downto 0) :=  (others => '0');          -- for ADD, SUB, AND, OR register-to-register operation

-- I-Type instruction -> OPCODE field
    constant ITYPE_ADDI1  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(1,OP_CODE_SIZE));    -- ADDI1 RS1,RD,INP1
    constant ITYPE_SUBI1  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(2,OP_CODE_SIZE));    -- SUBI1 R1,R2,INP1
    constant ITYPE_ANDI1  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(3,OP_CODE_SIZE));    -- ANDI1 R1,R2,INP1    
    constant ITYPE_ORI1   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(4,OP_CODE_SIZE));    -- ORI1 R1,R2,INP1
    constant ITYPE_ADDI2  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(5,OP_CODE_SIZE));    -- ADDI2 R1,R2,INP2
    constant ITYPE_SUBI2  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(6,OP_CODE_SIZE));    -- SUBI2 R1,R2,INP2 
    constant ITYPE_ANDI2  : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(7,OP_CODE_SIZE));    -- ANDI2 R1,R2,INP2
    constant ITYPE_ORI2   : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(8,OP_CODE_SIZE));    -- ORI2 R1,R2,INP2 
    constant ITYPE_MOV    : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(9,OP_CODE_SIZE));    -- MOV R1,R2
    constant ITYPE_S_REG1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(10,OP_CODE_SIZE));    -- S_REG1 R2,INP1
    constant ITYPE_S_REG2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(11,OP_CODE_SIZE));    -- S_REG2 R2,INP2
    constant ITYPE_S_MEM2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(12,OP_CODE_SIZE));    -- S_MEM2 R1,R2,INP2
    constant ITYPE_L_MEM1 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(13,OP_CODE_SIZE));    -- L_MEM1 R1,R2,INP1
    constant ITYPE_L_MEM2 : std_logic_vector(OP_CODE_SIZE - 1 downto 0) := std_logic_vector(to_unsigned(14,OP_CODE_SIZE));    -- L_MEM2 R1,R2,INP2
    
    -- ...................
    -- to be completed with the others I-Type instructions
    -- ...................

-- Change the values of the instructions coding as you want, depending also on the type of control unit choosen

end dlxTypes;

