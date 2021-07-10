----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/20 18:27:59
-- Design Name: 
-- Module Name: shifter_l2 - Behavioral
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

entity shifter_l2 is
    Port ( R2 : in STD_LOGIC_VECTOR (1 downto 0);
           msk_input1 : in STD_LOGIC_VECTOR (63 downto 0);
           msk_input2 : in STD_LOGIC_VECTOR (63 downto 0);
           msk_input3 : in STD_LOGIC_VECTOR (63 downto 0);
           msk_input4 : in STD_LOGIC_VECTOR (63 downto 0);
           l2_out: out STD_LOGIC_VECTOR(63 downto 0));
end shifter_l2;

architecture Behavioral of shifter_l2 is

begin
l2_out<= msk_input1 when R2="00" else
        msk_input2 when R2="01" else
        msk_input3 when R2="10" else
        msk_input4;

end Behavioral;
