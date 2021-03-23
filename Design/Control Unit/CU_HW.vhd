library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;

entity CU_HW is
    Generic (
            PIPLINE_STAGES : integer :=  3;                              -- Number of pipline stages
            MICROCODE_MEM_SIZE : integer :=  15;                          -- Number of Valid opcodes (14I+ 1R)
            CW_SIZE : integer :=  13);                                    -- Control word size
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
end CU_HW;

architecture Behavioral of CU_HW is
    type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
    constant cw_mem : mem_array := (B"111_11000_10011", -- R type   
                                    
                                    B"101_10000_10011", -- ADDI1 RS1,RD,INP1    
                                    B"101_10001_10011", -- SUBI1 R1,R2,INP1     
                                    B"101_10010_10011", --- ANDI1 R1,R2,INP1    
                                    B"101_10011_10011", -- ORI1 R1,R2,INP1      
                                    
                                    B"110_11100_10011", -- ADDI2 RS1,RD,INP2    
                                    B"110_11101_10011", -- SUBI2 R1,R2,INP2     
                                    B"110_11110_10011", --- ANDI2 R1,R2,INP2    
                                    B"110_11111_10011", -- ORI2 R1,R2,INP2     
                                    
                                    B"110_10011_10011", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    
                                    B"101_10000_10011", -- S_REG1 R2,INP1   
                                    B"110_11100_10011", -- S_REG2 R2,INP2   
                                    
                                    B"110_11100_10100", -- S_MEM2 R1,R2,INP2
                                    B"101_10000_11001", -- L_MEM1 R1,R2,INP1    
                                    B"110_11100_11001"); -- L_MEM2 R1,R2,INP2   
    
    type cw_array is array (integer range 0 to PIPLINE_STAGES - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
    signal cws : cw_array := (others =>(others => '0'));
    signal cwi :std_logic_vector(CW_SIZE - 1 downto 0);

    
    type FUNC_array is array (integer range 0 to PIPLINE_STAGES - 1) of std_logic_vector(FUNC_SIZE - 1 downto 0);
    signal FUNCs : FUNC_array := (others =>(others=>'0'));
    signal FUNCi :std_logic_vector(FUNC_SIZE - 1 downto 0);
    

begin
    
    -- stage one control signals
    EN1  <= cws(0)(12) OR cws(2)(0); --enable in case of write back is needed 
    RF1  <= cws(0)(11);
    RF2  <= cws(0)(10);
    
    -- stage two control signals
    EN2  <= cws(1)(9);
    S1  <= cws(1)(8);
    S2  <= cws(1)(7);
    ALU1  <= cws(1)(6) OR FUNCs(1)(0); --Exception for R-types
    ALU2  <= cws(1)(5) OR FUNCs(1)(1); --Exception for R-types
    
    -- stage three control signals
    EN3  <= cws(2)(4);
    RM  <= cws(2)(3);
    WM  <= cws(2)(2);
    S3  <= cws(2)(1);
    WF1  <= cws(2)(0);

    --
    FUNCi <= FUNC when OPCODE = RTYPE else
                            (others=>'0');
    cwi <= cw_mem(conv_integer(OPCODE));
    -- process to pipeline control words
    CW_PIPE: process (Clk, Rst)
    begin  -- process Clk
    if Rst = '0' then                   -- asynchronous reset (active low)
        cws <= (others =>(others => '0'));
        FUNCs <= (others =>((others=>'0')));
    elsif Clk'event and Clk = '1' then  -- rising clock edge
        for i in 0 to (PIPLINE_STAGES - 2) loop
            if (i=0) then
                cws(0) <= cwi;
                FUNCs(0) <= FUNCi;
            end if;
            cws(i+1) <= cws(i);
            FUNCs(i+1) <= FUNCs(i);
        end loop;
    end if;
    end process CW_PIPE;
    
end Behavioral;
