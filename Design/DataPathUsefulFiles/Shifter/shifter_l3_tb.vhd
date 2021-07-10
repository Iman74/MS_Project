----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/21 13:38:47
-- Design Name: 
-- Module Name: shift_l3_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_l3_tb is
--  Port ( );
end shift_l3_tb;

architecture Behavioral of shift_l3_tb is
component shifter_l3 is
    Port ( R2 : in STD_LOGIC_VECTOR (2 downto 0);
           Coarse_input : in STD_LOGIC_VECTOR (63 downto 0);
           Arith_logic_select : in STD_LOGIC;
           Dir: in STD_LOGIC;
           Fine_grain_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal R2: STD_LOGIC_VECTOR (2 downto 0);
signal Coarse_input: STD_LOGIC_VECTOR (63 downto 0);
signal Arith_logic_select : STD_LOGIC;
signal Dir: STD_LOGIC;
signal Fine_grain_out : STD_LOGIC_VECTOR (31 downto 0);

begin
l3_tb: shifter_l3 port map (R2,Coarse_input,Arith_logic_select,Dir,Fine_grain_out);
process
begin
    R2<="000";
    Arith_logic_select<='0';--logic left
    Dir<='0';
    Coarse_input<=x"0000000080000100";
    wait for 10 ns;
    R2<="001";
    wait for 10 ns;
    R2<="010";
    wait for 10 ns;
    R2<="011";
    wait for 10 ns;
    R2<="100";
    wait for 10 ns;
    R2<="101";
    wait for 10 ns;
    R2<="110";
    wait for 10 ns;
    R2<="111";
    wait for 10 ns;
    

    Dir<='1';--arith right
    wait for 10 ns;
    R2<="001";
    wait for 10 ns;
    R2<="010";
    wait for 10 ns;
    R2<="011";
    wait for 10 ns;
    R2<="100";
    wait for 10 ns;
    R2<="101";
    wait for 10 ns;
    R2<="110";
    wait for 10 ns;
    R2<="111";
    
    Arith_logic_select<='1';
    Dir<='0';--logic left
    wait for 10 ns;
    R2<="001";
    wait for 10 ns;
    R2<="010";
    wait for 10 ns;
    R2<="011";
    wait for 10 ns;
    R2<="100";
    wait for 10 ns;
    R2<="101";
    wait for 10 ns;
    R2<="110";
    wait for 10 ns;
    R2<="111";
    
    Arith_logic_select<='1';
    Dir<='1';--logic left
    wait for 10 ns;
    R2<="001";
    wait for 10 ns;
    R2<="010";
    wait for 10 ns;
    R2<="011";
    wait for 10 ns;
    R2<="100";
    wait for 10 ns;
    R2<="101";
    wait for 10 ns;
    R2<="110";
    wait for 10 ns;
    R2<="111";
    wait ;   
    
end process;
end Behavioral;
