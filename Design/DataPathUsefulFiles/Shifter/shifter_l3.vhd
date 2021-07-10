----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/21 11:21:10
-- Design Name: 
-- Module Name: shifter_l3 - Behavioral
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

entity shifter_l3 is
    Port ( R2 : in STD_LOGIC_VECTOR (2 downto 0);
           Coarse_input : in STD_LOGIC_VECTOR (63 downto 0);
           Arith_logic_select : in STD_LOGIC;
           Dir: in STD_LOGIC;
           Fine_grain_out : out STD_LOGIC_VECTOR (31 downto 0));
end shifter_l3;

architecture Behavioral of shifter_l3 is
signal output: STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');

begin
process(R2,Coarse_input,Arith_logic_select,Dir)
begin
    if (Arith_logic_select='1') then 
        output(31)<=Coarse_input(31);
        if (Dir='1') then
            if (R2="000") then
                output<=Coarse_input(31 downto 0);
            elsif (R2="001") then
                output(29 downto 0)<=Coarse_input(30 downto 1);
                output(30)<=Coarse_input(32);
            elsif (R2="010") then
                output(28 downto 0)<=Coarse_input(30 downto 2);
                output(30 downto 29)<=Coarse_input(33 downto 32);               
            elsif (R2="011") then
                output(27 downto 0)<=Coarse_input(30 downto 3);
                output(30 downto 28)<=Coarse_input(34 downto 32); 
            elsif (R2="100") then
                output(26 downto 0)<=Coarse_input(30 downto 4);
                output(30 downto 27)<=Coarse_input(35 downto 32);
            elsif (R2="101") then
                output(25 downto 0)<=Coarse_input(30 downto 5);
                output(30 downto 26)<=Coarse_input(36 downto 32);
            elsif (R2="110") then
                output(24 downto 0)<=Coarse_input(30 downto 6);
                output(30 downto 25)<=Coarse_input(37 downto 32);
            elsif (R2="111") then
                output(23 downto 0)<=Coarse_input(30 downto 7);
                output(30 downto 24)<=Coarse_input(38 downto 32);
            end if;
        elsif (Dir='0') then
            if (R2="000") then
                output<=Coarse_input(31 downto 0);
            elsif (R2="001") then
                output(30 downto 1)<=Coarse_input(29 downto 0);
                output(0)<=Coarse_input(63);
            elsif (R2="010") then
                output(30 downto 2)<=Coarse_input(28 downto 0);
                output(1 downto 0)<=Coarse_input(63 downto 62);
            elsif (R2="011") then
                output(30 downto 3)<=Coarse_input(27 downto 0);
                output(2 downto 0)<=Coarse_input(63 downto 61);
            elsif (R2="100") then
                output(30 downto 4)<=Coarse_input(26 downto 0);
                output(3 downto 0)<=Coarse_input(63 downto 60);
            elsif (R2="101") then
                output(30 downto 5)<=Coarse_input(25 downto 0);
                output(4 downto 0)<=Coarse_input(63 downto 59);
            elsif (R2="110") then
                output(30 downto 6)<=Coarse_input(24 downto 0);
                output(5 downto 0)<=Coarse_input(63 downto 58);
            elsif (R2="111") then
                output(30 downto 7)<=Coarse_input(23 downto 0);
                output(6 downto 0)<=Coarse_input(63 downto 57);
            end if;
        end if;
    elsif (Arith_logic_select='0') then
        if (Dir='1') then
            if (R2="000") then
                output<=Coarse_input(31 downto 0);
            elsif (R2="001") then
                output<=Coarse_input(32 downto 1);
            elsif (R2="010") then
                output<=Coarse_input(33 downto 2);
            elsif (R2="011") then
                output<=Coarse_input(34 downto 3);
            elsif (R2="100") then
                output<=Coarse_input(35 downto 4);
            elsif (R2="101") then
                output<=Coarse_input(36 downto 5);
            elsif (R2="110") then
                output<=Coarse_input(37 downto 6);
            elsif (R2="111") then
                output<=Coarse_input(38 downto 7);
            end if;
        elsif (Dir='0') then
            if (R2="000") then
                output<=Coarse_input(31 downto 0);
            elsif (R2="001") then
                output(31 downto 1)<=Coarse_input(30 downto 0);
                output(0)<=Coarse_input(63);
            elsif (R2="010") then
                output(31 downto 2)<=Coarse_input(29 downto 0);
                output(1 downto 0)<=Coarse_input(63 downto 62);
            elsif (R2="011") then
                output(31 downto 3)<=Coarse_input(28 downto 0);
                output(2 downto 0)<=Coarse_input(63 downto 61);
            elsif (R2="100") then
                output(31 downto 4)<=Coarse_input(27 downto 0);
                output(3 downto 0)<=Coarse_input(63 downto 60);
            elsif (R2="101") then
                output(31 downto 5)<=Coarse_input(26 downto 0);
                output(4 downto 0)<=Coarse_input(63 downto 59);
            elsif (R2="110") then
                output(31 downto 6)<=Coarse_input(25 downto 0);
                output(5 downto 0)<=Coarse_input(63 downto 58);
            elsif (R2="111") then
                output(31 downto 7)<=Coarse_input(24 downto 0);
                output(6 downto 0)<=Coarse_input(63 downto 57);
            end if;
        end if;
    end if;
end process;
Fine_grain_out<=output;
end Behavioral;
