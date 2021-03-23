library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.myTypes.all;


entity CU_UP is
    Generic (
            PIPLINE_STAGES : integer :=  3;                              -- Number of pipline stages
            CW_SIZE : integer :=  13);                                   -- Control word size
    port (
            -- FIRST PIPE STAGE OUTPUTS
            EN1    : out std_logic;               -- enables the register file and the pipeline registers
            RF1    : out std_logic;               -- enables the read port 1 of the register file
            RF2    : out std_logic;               -- enables the read port 2 of the register file
            WF1    : out std_logic;               -- enables the write port of the register file
            -- SECOND PIPE STAGE OUTPUTS
            EN2    : out std_logic;               -- enables the pipe registers
            S1     : out std_logic;               -- input selection of the first multiplexer
            S2     : out std_logic;               -- input selection of the second multiplexer
            ALU1   : out std_logic;               -- alu control bit
            ALU2   : out std_logic;               -- alu control bit
            -- THIRD PIPE STAGE OUTPUTS
            EN3    : out std_logic;               -- enables the memory and the pipeline registers
            RM     : out std_logic;               -- enables the read-out of the memory
            WM     : out std_logic;               -- enables the write-in of the memory
            S3     : out std_logic;               -- input selection of the multiplexer
            -- INPUTS
            OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
            FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);              
            Clk : in std_logic;
            Rst : in std_logic);                  -- Active Low
end CU_UP;

architecture Behavioral of CU_UP is
    constant MICROCODE_MEM_SIZE : integer :=  18*PIPLINE_STAGES +4;                          -- Number of Valid opcodes (14I+ 1R)
    constant RELOC_MEM_SIZE: integer :=15;  -- Microcode Relocation

    type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
    constant cw_mem : mem_array := (B"101_00000_00000", -- ADDI1 RS1,RD,INP1    
                                    B"000_10000_00000", -- ADDI1 RS1,RD,INP1    
                                    B"000_00000_10011", -- ADDI1 RS1,RD,INP1    
                                    
                                    B"101_00000_00000", -- SUBI1 R1,R2,INP1     
                                    B"000_10001_00000", -- SUBI1 R1,R2,INP1     
                                    B"000_00000_10011", -- SUBI1 R1,R2,INP1     
                                    
                                    B"101_00000_00000", --- ANDI1 R1,R2,INP1    
                                    B"000_10010_10011", --- ANDI1 R1,R2,INP1    
                                    B"000_00000_10011", --- ANDI1 R1,R2,INP1    
                                    
                                    B"101_00000_00000", -- ORI1 R1,R2,INP1      
                                    B"000_10011_00000", -- ORI1 R1,R2,INP1      
                                    B"000_00000_10011", -- ORI1 R1,R2,INP1      
                                    
                                    B"110_00000_00000", -- ADDI2 RS1,RD,INP2    
                                    B"000_11100_00000", -- ADDI2 RS1,RD,INP2    
                                    B"000_00000_10011", -- ADDI2 RS1,RD,INP2    
                                    
                                    B"110_00000_00000", -- SUBI2 R1,R2,INP2     
                                    B"000_11101_00000", -- SUBI2 R1,R2,INP2     
                                    B"000_00000_10011", -- SUBI2 R1,R2,INP2     
                                    
                                    B"110_00000_00000", --- ANDI2 R1,R2,INP2    
                                    B"000_11110_00000", --- ANDI2 R1,R2,INP2    
                                    B"000_00000_10011", --- ANDI2 R1,R2,INP2
                                        
                                    B"110_00000_00000", -- ORI2 R1,R2,INP2     
                                    B"000_11111_00000", -- ORI2 R1,R2,INP2     
                                    B"000_00000_10011", -- ORI2 R1,R2,INP2     
                                    
                                    B"110_00000_00000", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    B"000_10011_00000", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    B"000_00000_10011", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    
                                    B"101_00000_00000", -- S_REG1 R2,INP1   
                                    B"000_10000_00000", -- S_REG1 R2,INP1   
                                    B"000_00000_10011", -- S_REG1 R2,INP1 
                                      
                                    B"110_00000_00000", -- S_REG2 R2,INP2   
                                    B"000_11100_00000", -- S_REG2 R2,INP2   
                                    B"000_00000_10011", -- S_REG2 R2,INP2   
                                    
                                    B"110_00000_00000", -- S_MEM2 R1,R2,INP2
                                    B"000_11100_00000", -- S_MEM2 R1,R2,INP2
                                    B"000_00000_10100", -- S_MEM2 R1,R2,INP2
                                    
                                    B"101_00000_00000", -- L_MEM1 R1,R2,INP1    
                                    B"000_10000_00000", -- L_MEM1 R1,R2,INP1    
                                    B"000_00000_11001", -- L_MEM1 R1,R2,INP1    
                                    
                                    B"110_00000_00000",-- L_MEM2 R1,R2,INP2
                                    B"000_11100_00000",-- L_MEM2 R1,R2,INP2
                                    B"000_00000_11001",-- L_MEM2 R1,R2,INP2
                                    
                                    B"111_00000_00000", -- R type 
                                    B"000_11000_00000", -- R type add  
                                    B"000_00000_10011", -- R type 
                                    B"000_00000_00000", -- R type dummy
                                    
                                    B"111_00000_00000", -- R type  
                                    B"000_11001_00000", -- R type   sub
                                    B"000_00000_10011", -- R type 
                                    B"000_00000_00000", -- R type dummy
                                    
                                    B"111_00000_00000", -- R type  
                                    B"000_11010_00000", -- R type   and
                                    B"000_00000_10011", -- R type 
                                    B"000_00000_00000", -- R type dummy
                                    
                                    B"111_00000_00000", -- R type   
                                    B"000_11011_00000", -- R type   or
                                    B"000_00000_10011", -- R type   
                                    B"000_00000_00000"  -- R type   dummy
                                    ); 
    type reloc_mem_array is array (0 to RELOC_MEM_SIZE - 1) of std_logic_vector(integer(ceil(log2(real(MICROCODE_MEM_SIZE))))-1 downto 0);
    signal reloc_mem : reloc_mem_array := (  6X"2A", -- All R-Type Instructions               
                                             6X"00", --ADDI1
                                             6X"03", --SUBI1
                                             6X"06", --ANDI1
                                             6X"09", --ORI1
                                             6X"0C", --ADDI2
                                             6X"0F", --SUBI2
                                             6X"12", --ANDI2
                                             6X"15", --ORI2
                                             6X"18", --MOV
                                             6X"1B", --S_REG1
                                             6X"1E", --S_REG2
                                             6X"21", --S_MEM2
                                             6X"24", --L_MEM1
                                             6X"27"); --L_MEM2
   
  signal cw :std_logic_vector(CW_SIZE - 1 downto 0);
  signal Stage : integer range 0 to PIPLINE_STAGES;
  signal uPC : integer range 0 to MICROCODE_MEM_SIZE-1;
  signal OpCode_Reloc : std_logic_vector(integer(ceil(log2(real(MICROCODE_MEM_SIZE))))-1 downto 0);

begin
    cw <= cw_mem(uPC);
    -- stage one control signals
    EN1  <= cw(12) OR cw(0); -- in case of WR in need at last stage 
    RF1  <= cw(11);
    RF2  <= cw(10);
    
    -- stage two control signals
    EN2  <= cw(9);
    S1  <= cw(8);
    S2  <= cw(7);
    ALU1  <= cw(6) ; 
    ALU2  <= cw(5) ; 
    
    -- stage three control signals
    EN3  <= cw(4);
    RM  <= cw(3);
    WM  <= cw(2);
    S3  <= cw(1);
    WF1  <= cw(0);
    
    OpCode_Reloc <= reloc_mem(conv_integer(OpCode));

    uPC_Proc: process (Clk, Rst)
    begin  -- process uPC_Proc
        if Rst = '0' then                   -- asynchronous reset (active low)
          uPC <= 0;
          Stage <= 0;
        elsif Clk'event and Clk = '1' then  -- rising clock edge
            if (Stage < 1) then
               if (OpCode = RTYPE) then
                    uPC <= conv_integer((func&"00") + OpCode_Reloc);
                else
                    uPC <= conv_integer(OpCode_Reloc);
                end if;
                Stage <= Stage + 1;
            elsif (Stage < PIPLINE_STAGES-1) then
                upc <= upc + 1;
                Stage <= Stage + 1;
            else
                Stage <= 0;
                upc <= upc + 1;
            end if;
     end if;
  end process uPC_Proc;
end Behavioral;
