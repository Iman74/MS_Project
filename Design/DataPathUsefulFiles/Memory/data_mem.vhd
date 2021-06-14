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

entity data_mem is
    generic(
    nbit_address : natural :=5;
    nbit_data : natural :=31
    );
    port (
    clk: in std_logic;
    data_in: in std_logic_vector(nbit_data downto 0);
    wr: in std_logic;
    data_addr_in: in integer range nbit_address downto 0;--什么时候用什么样的变量不是很懂
    data_addr_out: in integer range nbit_address downto 0;
    data_out: out std_logic_vector(nbit_data downto 0)
    );
end data_mem;

architecture Behavioral of data_mem is
    type mem is array(63 downto 0) of std_logic_vector(nbit_data downto 0);
    signal ram_block : mem;
begin
    process (clk)
    begin
        if (clk='1' and clk'event) then
            if (wr='1') then
                ram_block(data_addr_in)<=data_in;--write
            else
                data_out<=ram_block(data_addr_out);--read
            end if;
        end if; 
    end process;
end Behavioral;
