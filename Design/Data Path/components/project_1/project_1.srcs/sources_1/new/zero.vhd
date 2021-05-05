----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/06 00:29:58
-- Design Name: 
-- Module Name: zero - Behavioral
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

entity zero is
Port (OP1: in STD_LOGIC_VECTOR (31 downto 0);
      OP2: in STD_LOGIC_VECTOR (31 downto 0);
      cin: in STD_LOGIC;
      c: out STD_LOGIC);
end zero;

architecture Behavioral of zero is
signal p: std_logic_vector(31 downto 0);
signal k: std_logic_vector(30 downto 0);
signal z: std_logic_vector(31 downto 0);
begin
    process(OP1,OP2,cin)
    begin
        p<=OP1 or OP2;
        k<=not(OP1(30 downto 0)) and not(OP2(30 downto 0));
        z(31 downto 1)<=p(31 downto 1) or k;
        z(0)<=not(cin) or p(0);
        if z=x"00000000" then
            c<='1';
        end if;
    end process;

end Behavioral;
