----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/04/02 17:21:50
-- Design Name: 
-- Module Name: data_mem - Behavioral
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

entity ins_mem is
    generic(
    nbit_address : natural :=5;
    nbit_data : natural :=31
    );
    port (
    clk: in std_logic;
    data_addr_out: in integer range nbit_address downto 0;
    data_out: out std_logic_vector(nbit_data downto 0)
    );
end ins_mem;

architecture Behavioral of ins_mem is
type mem is array(63 downto 0) of std_logic_vector(32 downto 0);  
signal rom_mem: mem;
begin
    process(clk)
    begin
        if (clk'event and clk='1') then
            data_out<=rom_mem(data_addr_out);
        end if; 
    end process;
end Behavioral;
