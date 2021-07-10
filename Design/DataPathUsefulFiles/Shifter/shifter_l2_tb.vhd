----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/21 10:56:23
-- Design Name: 
-- Module Name: shift_l2_tb - Behavioral
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

entity shift_l2_tb is
--  Port ( );
end shift_l2_tb;

architecture Behavioral of shift_l2_tb is
component shifter_l2 is
Port ( R2 : in STD_LOGIC_VECTOR (1 downto 0);
       msk_input1 : in STD_LOGIC_VECTOR (63 downto 0);
       msk_input2 : in STD_LOGIC_VECTOR (63 downto 0);
       msk_input3 : in STD_LOGIC_VECTOR (63 downto 0);
       msk_input4 : in STD_LOGIC_VECTOR (63 downto 0);
       l2_out: out STD_LOGIC_VECTOR(63 downto 0));
end component;
signal R2_in: STD_LOGIC_VECTOR (1 downto 0);
signal msk_in1,msk_in2,msk_in3,msk_in4,o: STD_LOGIC_VECTOR (63 downto 0);
begin
l2_tb: shifter_l2 port map(R2=>R2_in,msk_input1=>msk_in1,msk_input2=>msk_in2,msk_input3=>msk_in3,msk_input4=>msk_in4,l2_out=>o);
process
begin
    msk_in1<=x"abcd01238765ddca";
    msk_in2<=x"34ca01230078bcab";
    msk_in3<=x"1212909087875656";
    msk_in4<=x"cdcdabcdabcdabcd";
    R2_in<="00";
    wait for 10 ns;
    R2_in<="01";
    wait for 10 ns;
    R2_in<="10";
    wait for 10 ns;
    R2_in<="11";
    wait;
end process;

end Behavioral;
