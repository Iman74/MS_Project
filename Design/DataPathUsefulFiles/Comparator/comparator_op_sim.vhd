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

entity simtb is
--  Port ( );
end simtb;

architecture behavior of simtb is
component comparator_op is
    Port ( adder_cout : in STD_LOGIC;
           adder_output : in STD_LOGIC_VECTOR (31 downto 0);
           eq : out STD_LOGIC;
           low : out STD_LOGIC;
           low_eq : out STD_LOGIC;
           high : out STD_LOGIC;
           high_eq : out STD_LOGIC);
end component;
signal cout: std_logic;
signal output: std_logic_vector(31 downto 0);
signal eq_o,low_o,low_eq_o,high_o,high_eq_o: std_logic;
begin
    comp2: comparator_op port map(adder_cout=>cout,adder_output=>output,eq=>eq_o,low=>low_o,low_eq=>low_eq_o,high=>high_o,high_eq=>high_eq_o);
    process
    begin
        cout<='0';
        output<=x"00000000";
        wait for 10 ns;
        output<=x"00001000";
        wait for 10 ns;
        cout<='1';
        wait for 10 ns;
        output<=x"00000000";
        wait;
    end process;
end behavior;
