----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/05 19:39:07
-- Design Name: 
-- Module Name: logic_op - Behavioral
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

entity logic_op is
    Port ( OP1 : in STD_LOGIC_VECTOR (31 downto 0);
           OP2 : in STD_LOGIC_VECTOR (31 downto 0);
           SL: in STD_LOGIC_VECTOR (3 downto 0);
           logic_out : out STD_LOGIC_VECTOR (31 downto 0));
end logic_op;

architecture Behavioral of logic_op is
begin
    process(OP1,OP2,SL)
    begin
        if (SL="0001") then
            logic_out<=OP1 and OP2;
        elsif (SL="1110") then
            logic_out<=(not(OP1) and not(OP2)) or (not(OP1) and OP2) or (OP1 and not(OP2));
        elsif (SL="0111") then
            logic_out<=(not(OP1) and not(OP2)) or (not(OP1) and OP2) or (OP1 and OP2);
        elsif (SL="1000") then
            logic_out<=not(OP1) and not(OP2);
        elsif (SL="0110") then
            logic_out<=(not(OP1) and OP2) or (OP1 and not(OP2));
        elsif (SL="1001") then
            logic_out<=OP1 xnor OP2;
        else
            logic_out<=(others=>'0');     
        end if;     
    end process;
end Behavioral;
