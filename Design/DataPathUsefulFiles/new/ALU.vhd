----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2021 08:12:39 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
USE ieee.numeric_std.ALL;
   --constant NumBit : integer := 32;	-- to do ---> delete
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    generic(NumFunc : integer := 4;
            NumBit : integer := 32);
    port ( ALU_OP1 : in STD_LOGIC_VECTOR (NumBit-1 downto 0);
           ALU_OP2 : in STD_LOGIC_VECTOR (NumBit-1 downto 0);
           ALU_SEL : in STD_LOGIC_VECTOR (integer(ceil(log2(real(NumFunc))))-1 downto 0);
           ALU_OUTPUT : out STD_LOGIC_VECTOR (NumBit-1 downto 0));            
end ALU;

architecture Behavioral of ALU is
    
    -- Moduls
        component P4_adder is 
            generic (NBIT: integer:= 32;
                     NBLOCK: integer:= 8);
            Port (	INPUT_1:	In	std_logic_vector(NBIT-1 downto 0);
                    INPUT_2:	In	std_logic_vector(NBIT-1 downto 0);
                    C_in:	In	std_logic;
                    SUM:	Out	std_logic_vector(NBIT-1 downto 0);
                    C_out:	Out	std_logic); 
        end component; 
        
        component BOOTHMUL is
            Generic (IN_WIDTTH1 : NATURAL := 6;
                     IN_WIDTTH2 : NATURAL := 6);
            Port ( OP1 : in STD_LOGIC_VECTOR (IN_WIDTTH1-1 downto 0);
                   OP2 : in STD_LOGIC_VECTOR (IN_WIDTTH2-1 downto 0);
                   MUL_RESULT : out STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0));
        end component;--

    --Constants
        constant FuncSelLength : integer :=integer(ceil(log2(real(NumFunc))));
        --Functions
            constant  Func_ADD :STD_LOGIC_VECTOR := STD_LOGIC_VECTOR(to_unsigned(0,FuncSelLength));
            constant Func_SUB :STD_LOGIC_VECTOR := STD_LOGIC_VECTOR(to_unsigned(1,FuncSelLength));
            constant Func_MULL :STD_LOGIC_VECTOR := STD_LOGIC_VECTOR(to_unsigned(2,FuncSelLength));
    -- Internal Signals
        --Adder
        signal ADD_Op1 : STD_LOGIC_VECTOR (NumBit-1 downto 0);
        signal ADD_Op2 : STD_LOGIC_VECTOR (NumBit-1 downto 0);
        signal ADD_Res : STD_LOGIC_VECTOR (NumBit-1 downto 0);
        signal ADD_Ci : STD_LOGIC;
        signal ADD_Co : STD_LOGIC;
        --Multiplier
        signal MUL_Op1 : STD_LOGIC_VECTOR (NumBit-1 downto 0);
        signal MUL_Op2 : STD_LOGIC_VECTOR (NumBit-1 downto 0);
        signal MUL_Res : STD_LOGIC_VECTOR (NumBit-1 downto 0);

    
    
begin
    -- Modules Instantiations
        -- Multiplier
        MUL:BOOTHMUL GENERIC MAP (NumBit,NumBit)
                   PORT MAP (OP1=>MUL_Op1,
                             OP2=>MUL_Op2,
                             MUL_RESULT=>MUL_Res);
        -- Adder & subtracter                   
        ADD:P4_adder GENERIC MAP(NumBit,8)
                     PORT MAP (	INPUT_1 => ADD_Op1,
                                INPUT_2=>ADD_Op2,
                                C_in=>ADD_Ci,
                                SUM=>ADD_Res,
                                C_out=>ADD_Co); 
    process
    begin
        -- set other inputs HIGH-Z
            ADD_Op1 <= (others => 'Z');
            ADD_Op2 <= (others => 'Z');
            ADD_Ci <= 'Z';
            MUL_Op1 <= (others => 'Z');
            MUL_Op2 <= (others => 'Z');
        
        -- multiplxer process
        case ALU_SEL is
            when Func_ADD => --addition
                 ADD_Op1 <= ALU_OP1;
                 ADD_Op2 <= ALU_OP2;
                 ADD_Ci <= '0';
                 ALU_OUTPUT <= ADD_Res;
                 --CO flag  <= ADD_Co; --flages to be added later
            when Func_SUB => --subtraction
                 ADD_Op1 <= ALU_OP1;
                 ADD_Op2 <= not ALU_OP2;
                 ADD_Ci <= '1';
                 ALU_OUTPUT <= ADD_Res;
                 --CO flag  <= ADD_Co; --flages to be added later
            when Func_MULL => --Multiplier
                 MUL_Op1 <= ALU_OP1;
                 MUL_Op2 <= not ALU_OP2;
                 ALU_OUTPUT <= MUL_Res; 
--            when "011" =>
--                Reg3 <= Reg1 nand Reg2; --NAND gate
--            when "100" =>
--                Reg3 <= Reg1 nor Reg2; --NOR gate              
--            when "101" =>
--                Reg3 <= Reg1 and Reg2;  --AND gate
--            when "110" =>
--                Reg3 <= Reg1 or Reg2;  --OR gate   
--            when "111" =>
--                Reg3 <= Reg1 xor Reg2; --XOR gate  --NOT gate
            when others =>
                NULL;
        end case;         
    end process;    
end Behavioral;
