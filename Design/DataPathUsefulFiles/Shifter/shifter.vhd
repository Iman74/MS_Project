----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/21 14:51:15
-- Design Name: 
-- Module Name: shifter - Behavioral
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

entity shifter is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           sh_output : out STD_LOGIC_VECTOR (31 downto 0));
end shifter;

architecture Behavioral of shifter is
component shifter_l1 is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           dir : in STD_LOGIC;--0: left 1: right
           logic_arith_sl : in STD_LOGIC;--0: logic shift 1: arithmetic shift
           l1_output0 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output1 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output2 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output3 : out STD_LOGIC_VECTOR (63 downto 0));
end component;
component shifter_l2 is
    Port ( R2 : in STD_LOGIC_VECTOR (1 downto 0);
           msk_input1 : in STD_LOGIC_VECTOR (63 downto 0);
           msk_input2 : in STD_LOGIC_VECTOR (63 downto 0);
           msk_input3 : in STD_LOGIC_VECTOR (63 downto 0);
           msk_input4 : in STD_LOGIC_VECTOR (63 downto 0);
           l2_out: out STD_LOGIC_VECTOR(63 downto 0));
end component;
component shifter_l3 is
    Port ( R2 : in STD_LOGIC_VECTOR (2 downto 0);
           Coarse_input : in STD_LOGIC_VECTOR (63 downto 0);
           Arith_logic_select : in STD_LOGIC;
           Dir: in STD_LOGIC;
           Fine_grain_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal l1_l2_link1: STD_LOGIC_VECTOR (63 downto 0);
signal l1_l2_link2: STD_LOGIC_VECTOR (63 downto 0);
signal l1_l2_link3: STD_LOGIC_VECTOR (63 downto 0);
signal l1_l2_link4: STD_LOGIC_VECTOR (63 downto 0);
signal l2_l3_link: STD_LOGIC_VECTOR(63 downto 0);
begin
layer1: shifter_l1 port map(operand1=>operand1,dir=>operand2(7),logic_arith_sl=>operand2(6),l1_output0=>l1_l2_link1,l1_output1=>l1_l2_link2,l1_output2=>l1_l2_link3,l1_output3=>l1_l2_link4);
layer2: shifter_l2 port map(R2=>operand2(4 downto 3),msk_input1=>l1_l2_link1,msk_input2=>l1_l2_link2,msk_input3=>l1_l2_link3,msk_input4=>l1_l2_link4,l2_out=>l2_l3_link);
layer3: shifter_l3 port map(R2=>operand2(2 downto 0),Coarse_input=>l2_l3_link,Arith_logic_select=>operand2(6),Dir=>operand2(7),Fine_grain_out=>sh_output);

end Behavioral;
