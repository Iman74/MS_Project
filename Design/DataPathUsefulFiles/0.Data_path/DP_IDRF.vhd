----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/07/10 03:50:13
-- Design Name: 
-- Module Name: DP_IDRF - Behavioral
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

entity DP_IDRF is
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
end DP_IDRF;

architecture Behavioral of DP_IDRF is
component register_file is
    Generic (nbit_address : natural :=5;
             nbit_data  : natural :=64 );
    port (  CLK: 		IN std_logic;
            RESET: 	    IN std_logic;
            ENABLE: 	IN std_logic;
            RD1: 		IN std_logic;
            RD2: 		IN std_logic;
            WR: 		IN std_logic;
            ADD_WR: 	IN std_logic_vector(nbit_address-1 downto 0);
            ADD_RD1: 	IN std_logic_vector(nbit_address-1 downto 0);
            ADD_RD2: 	IN std_logic_vector(nbit_address-1 downto 0);
            DATAIN: 	IN std_logic_vector(nbit_data-1 downto 0);
            OUT1: 		OUT std_logic_vector(nbit_data-1 downto 0);
            OUT2: 		OUT std_logic_vector(nbit_data-1 downto 0));
end component;
signal rfout1,rfout2: std_logic_vector(31 downto 0);
signal imm_generator: std_logic_vector(31 downto 0);
begin
RF: register_file generic map (nbit_data=>32) 
    port map(CLK=>clk_idrf,RESET=>reset_in,ENABLE=>'1',WR=>wr_ctrl,RD1=>rd1_ctrl,RD2=>rd2_ctrl,ADD_RD1=>register_fetch(4 downto 0),ADD_RD2=>register_fetch(9 downto 5),ADD_WR=>register_fetch(14 downto 10),DATAIN=>datain,OUT1=>rfout1,OUT2=>rfout2);

process (clk_idrf)
begin
    if (clk_idrf'event and clk_idrf='1') then
        outputA<=rfout1;
        outputB<=rfout2;
        ALU_func<=register_fetch(25 downto 15);
    end if;
end process;

process (clk_idrf,register_fetch(25 downto 5))
begin
    if(clk_idrf='1' and clk_idrf'event) then
        if (register_fetch(25)='1') then
            imm_generator(31 downto 16)<=(others=>'1');
        else
            imm_generator(31 downto 16)<=(others=>'0');
        end if;
        imm_generator(15 downto 0)<=register_fetch(25 downto 10);
    end if;
end process;
outputImm<=imm_generator;

end Behavioral;
