----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/14 04:13:08
-- Design Name: 
-- Module Name: logic_op_sim - logic_op_sim
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_op_sim is
--  Port ( );
end logic_op_sim;

architecture logic_op_sim of logic_op_sim is
component logic_op is 
    port (
        OP1 : in STD_LOGIC_VECTOR (31 downto 0);
        OP2 : in STD_LOGIC_VECTOR (31 downto 0);
        SL: in STD_LOGIC_VECTOR (3 downto 0);
        logic_out : out STD_LOGIC_VECTOR (31 downto 0)
    );
end component;
signal r1,r2,output: std_logic_vector(31 downto 0);
signal s: std_logic_vector(3 downto 0);

begin
    tb: logic_op port map (op1=>r1,op2=>r2,sl=>s,logic_out=>output);
    process
    begin
        s<="0001";
        r1<=x"0AE11EA0";
        r2<=x"1EA00AE1";
        wait for 10 ns;
        s<="1110";
        wait for 10 ns;
        s<="0111";
        wait for 10 ns;
        s<="1000";
        wait for 10 ns;
        s<="0110";
        wait for 10 ns;
        s<="1001";
        wait;
    end process;
end logic_op_sim;
