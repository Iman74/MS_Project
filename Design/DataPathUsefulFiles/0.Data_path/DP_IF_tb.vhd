----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/07/08 10:10:25
-- Design Name: 
-- Module Name: IF_tb - Behavioral
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

entity IF_tb is
--  Port ( );
end IF_tb;

architecture Behavioral of IF_tb is
component DP_stage1 is
port (
    next_pointer: in std_logic_vector(31 downto 0) :=(others=>'0');
    clk_if: in std_logic;
    NPC_out: out std_logic_vector(31 downto 0);
    IR_out: out std_logic_vector(31 downto 0)-- 6 bits opcode, 26 bits regfile
);
end component;
signal tb_clk: std_logic;
signal tb_next_pointer: std_logic_vector(31 downto 0);
signal out1,out2: std_logic_vector(31 downto 0);
begin

tb: DP_stage1 port map(clk_if=>tb_clk,next_pointer=>tb_next_pointer, NPC_out=>out1, IR_out=>out2); 

process
begin
    tb_clk<='1';
    wait for 1 ns;
    tb_clk<='0';
    wait for 1 ns;
end process;

process
begin
    tb_next_pointer<=x"00000001";
    wait for 10 ns;
    tb_next_pointer<=x"00000002";
    wait for 10 ns;
    tb_next_pointer<=x"00000002";
    wait for 10 ns;
    tb_next_pointer<=x"00000003";
    wait for 10 ns;
    tb_next_pointer<=x"00000004";
    wait for 10 ns;
    tb_next_pointer<=x"00000005";
    wait for 10 ns;
    tb_next_pointer<=x"00000006";
    wait for 10 ns;
    tb_next_pointer<=x"00000007";
    wait for 10 ns;
    tb_next_pointer<=x"00000008";
    wait for 10 ns;
    tb_next_pointer<=x"00000009";
    wait for 10 ns;
    tb_next_pointer<=x"0000000a";
    
    wait;
end process;

end Behavioral;
