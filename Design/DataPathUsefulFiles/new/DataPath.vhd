

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

entity DataPath is
    port ( INP1 : in STD_LOGIC_VECTOR (31 downto 0);
           INP2 : in STD_LOGIC_VECTOR (31 downto 0);
           RD : in STD_LOGIC_VECTOR (31 downto 0);
           RS1 : out STD_LOGIC_VECTOR (4 downto 0);
           RS2 : out STD_LOGIC_VECTOR (4 downto 0));
    end DataPath;
    
architecture Behavioral of DataPath is
    -- Modules
        component ALU is
            generic(NumFunc : integer := 4;
                    NumBit : integer := 32);
            port ( ALU_OP1 : in STD_LOGIC_VECTOR (NumBit-1 downto 0);
                   ALU_OP2 : in STD_LOGIC_VECTOR (NumBit-1 downto 0);
                   ALU_SEL : in STD_LOGIC_VECTOR (integer(ceil(log2(real(NumFunc))))-1 downto 0);
                   ALU_OUTPUT : out STD_LOGIC_VECTOR (NumBit-1 downto 0));            
        end component;
        
        component register_file is
        Generic (nbit_address : natural :=5;
                 nbit_data  : natural :=64 );
        port (  CLK: 		IN std_logic;
                RESET: 	IN std_logic;
                ENABLE: 	IN std_logic;
                RD1: 		IN std_logic;
                RD2: 		IN std_logic;
                WR: 		IN std_logic;
                ADD_WR: 	IN std_logic_vector(nbit_address-1 downto 0);
                ADD_RD1: 	IN std_logic_vector(nbit_address-1 downto 0);
                ADD_RD2: 	IN std_logic_vector(nbit_address-1 downto 0);
                DATAIN: 	IN std_logic_vector(nbit_data-1 downto 0);
                OUT1: 		OUT std_logic_vector(nbit_data-1 downto 0);
                OUT2: 		OUT std_logic_vector(nbit_data-1 downto 0));
        end component;
    
    -- Internal Signals
        --PIPE STAGE 2
        -- ALU
        signal ALU_OP1 : STD_LOGIC_VECTOR (31 downto 0);
        signal ALU_OP2 : STD_LOGIC_VECTOR (31 downto 0);
        signal ALU_OUTPUT : STD_LOGIC_VECTOR (31 downto 0);
        signal ALU_SEL : STD_LOGIC_VECTOR (integer(ceil(log2(real(4))))-1 downto 0);
        --Multiplier
begin
    -- Modules Instantiations
    -- ALU
    ALU_1:ALU GENERIC MAP (NumFunc => 4,NumBit =>32)
               PORT MAP (ALU_OP1=>ALU_OP1,
                         ALU_OP2=>ALU_OP2,
                         ALU_SEL=>ALU_SEL,
                         ALU_OUTPUT=>ALU_OUTPUT);

end Behavioral;
