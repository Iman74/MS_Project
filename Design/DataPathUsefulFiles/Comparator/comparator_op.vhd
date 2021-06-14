----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/06 00:16:27
-- Design Name: 
-- Module Name: comparator_op - Behavioral
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

entity comparator_op is
    Port ( adder_cout : in STD_LOGIC;
           adder_output : in STD_LOGIC_VECTOR (31 downto 0);
           eq : out STD_LOGIC;
           low : out STD_LOGIC;
           low_eq : out STD_LOGIC;
           high : out STD_LOGIC;
           high_eq : out STD_LOGIC);
end comparator_op;

architecture Behavioral of comparator_op is
signal adder_zero: std_logic;
component zero is
port(
    a: in std_logic_vector(31 downto 0);
    c: out std_logic
);
end component;
begin
    all_zero: zero port map(a=>adder_output,c=>adder_zero);
    eq<=adder_zero;
    low<=not(adder_cout);
    low_eq<=not(adder_cout) or adder_zero;
    high<=not(adder_zero) or adder_cout;
    high_eq<=adder_cout;
end Behavioral;
