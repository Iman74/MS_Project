----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/07/08 09:21:11
-- Design Name: 
-- Module Name: DP_stage1 - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.STD_LOGIC_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DP_stage1 is--instruction fetch stage
port(
    next_pointer: in std_logic_vector(31 downto 0) :=(others=>'0');
    clk_if: in std_logic;
    NPC_out: out std_logic_vector(31 downto 0);
    IR_out: out std_logic_vector(31 downto 0)-- 6 bits opcode, 26 bits regfile
);
end DP_stage1;

architecture Behavioral of DP_stage1 is
component ins_mem is
    generic(
    nbit_address : natural :=5;
    nbit_data : natural :=31
    );
    port (
    clk: in std_logic;
    data_addr_out: in integer range nbit_address downto 0;
    data_out: out std_logic_vector(nbit_data downto 0)
    );
end component;
signal instruction_code: std_logic_vector(31 downto 0);
signal curr_ins_addr: std_logic_vector(31 downto 0);


begin
process(next_pointer, clk_if)
begin
if (clk_if='1' and clk_if'event) then
    curr_ins_addr<=next_pointer;
end if;
end process;

process(curr_ins_addr, clk_if)
begin
if (clk_if='1' and clk_if'event) then
    if (curr_ins_addr+4<=x"ffffffff") then
        NPC_out<=curr_ins_addr + 4;
    else
        NPC_out<=(others=>'0');
    end if;
end if;
end process;

instruction_memory: ins_mem port map(clk=>clk_if, data_addr_out=>conv_integer(curr_ins_addr),data_out=>IR_out);

end Behavioral;
