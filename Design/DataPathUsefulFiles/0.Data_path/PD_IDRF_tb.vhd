----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/07/10 07:56:49
-- Design Name: 
-- Module Name: PD_IDRF_tb - Behavioral
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

entity PD_IDRF_tb is
--  Port ( );
end PD_IDRF_tb;

architecture Behavioral of PD_IDRF_tb is
component DP_IDRF is
port (
    register_fetch: in std_logic_vector(25 downto 0);--0~4: ADD_RD1/ 5~9: ADD_RD2/ 10~14: ADD_RW/ 15~25 ALU_func/ 10~25 imm_generator
    datain: in std_logic_vector(31 downto 0);
    outputA: out std_logic_vector(31 downto 0);
    outputB: out std_logic_vector(31 downto 0);
    outputImm: out std_logic_vector(31 downto 0);
    clk_idrf: in std_logic;
    reset_in: in std_logic;
    wr_ctrl: in std_logic;
    rd1_ctrl: in std_logic;
    rd2_ctrl: in std_logic;
    ALU_func: out std_logic_vector(10 downto 0)
    );
end component;

signal IR_output: std_logic_vector(25 downto 0);
signal FB_datain: std_logic_vector(31 downto 0);
signal clk_input: std_logic;
signal rst: std_logic;
signal wr_enable: std_logic;
signal rd1_enable: std_logic;
signal rd2_enable: std_logic;

signal regout_A: std_logic_vector(31 downto 0);
signal regout_B: std_logic_vector(31 downto 0);
signal immidiate_gen: std_logic_vector(31 downto 0);
signal ALU_function_select: std_logic_vector(10 downto 0);

begin
IDRF_tb: DP_IDRF port map(outputA=>regout_A,outputB=>regout_B,outputImm=>immidiate_gen,ALU_func=>ALU_function_select,register_fetch=>IR_output,datain=>FB_datain,clk_idrf=>clk_input,reset_in=>rst,wr_ctrl=>wr_enable,rd1_ctrl=>rd1_enable,rd2_ctrl=>rd2_enable);

process
begin
    clk_input<='0';
    wait for 1 ns;
    clk_input<='1';
    wait for 1 ns;
end process;

--function:
--1. store 2 data into the register
--2. output the data stored in onto the output port A and B respectivly
--3. generate an immediate number 
--4. rst
process
begin
--initialization
    rst<='0';
    wr_enable<='0';
    rd1_enable<='0';
    rd2_enable<='0';
    IR_output<=(others=>'0');
    FB_datain<=(others=>'0');   
    wait for 10 ns;
--write something in 00001 and 00010
    FB_datain<=x"1234abcd";
    IR_output(14 downto 10)<="00001";
    wr_enable<='1';
    wait for 5 ns;
    wr_enable<='0';
    wait for 5 ns;
    FB_datain<=x"abcd1234";
    IR_output(14 downto 10)<="00010";
    wr_enable<='1';
    wait for 5 ns;
    wr_enable<='0';
    wait for 5 ns;
--read from 00001 and 00010
    IR_output(4 downto 0)<="00001";
    IR_output(9 downto 5)<="00010";
    rd1_enable<='1';
    rd2_enable<='1';
    wait for 10 ns;
    
    IR_output(25 downto 10)<=x"a1b1";
    wait;
end process;

end Behavioral;
