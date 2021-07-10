----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/15 16:16:41
-- Design Name: 
-- Module Name: shifter_l1_tb - Behavioral
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

entity shifter_l1_tb is
--  Port ( );
end shifter_l1_tb;

architecture Behavioral of shifter_l1_tb is
component shifter_l1 is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           dir : in STD_LOGIC;
           logic_arith_sl : in STD_LOGIC;
           l1_output0 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output1 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output2 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output3 : out STD_LOGIC_VECTOR (63 downto 0));
end component;
signal op1:STD_LOGIC_VECTOR (31 downto 0);
signal dir_in,lasl_in: STD_LOGIC;
signal sh_out1: STD_LOGIC_VECTOR (63 downto 0);
signal sh_out2: STD_LOGIC_VECTOR (63 downto 0);
signal sh_out3: STD_LOGIC_VECTOR (63 downto 0);
signal sh_out4: STD_LOGIC_VECTOR (63 downto 0);
begin 
    sh_l1_tb: shifter_l1 port map (operand1=>op1,dir=>dir_in,logic_arith_sl=>lasl_in,l1_output0=>sh_out1,l1_output1=>sh_out2,l1_output2=>sh_out3,l1_output3=>sh_out4);
    process
    begin
        op1<=x"00ab010b";
        dir_in<='0';--la
        lasl_in<='1';
        wait for 10 ns;
        dir_in<='1';--ra
        lasl_in<='1';
        wait for 10 ns;
        dir_in<='0';--ll
        lasl_in<='0';
        wait for 10 ns;
        dir_in<='1';--rl
        lasl_in<='0';
        wait for 10 ns;
        
        op1<=x"a0ab010b";
        dir_in<='0';
        lasl_in<='1';
        wait for 10 ns;
        dir_in<='1';
        lasl_in<='1';
        wait for 10 ns;
        dir_in<='0';
        lasl_in<='0';
        wait for 10 ns;
        dir_in<='1';
        lasl_in<='0';
        wait;
    end process;
end Behavioral;
