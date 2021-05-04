----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/20 18:12:01
-- Design Name: 
-- Module Name: top_layer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_layer is
    port (
    --pipeline stage 1
    RF1: in std_logic;
    RF2: in std_logic;
    WF1: in std_logic;
    EN1: in std_logic;
    --pipeline stage 2
    S1: in std_logic;
    S2: in std_logic;
    ALU1: in std_logic;
    ALU2: in std_logic;
    EN2: in std_logic;
    --pipeline stage 3
    RM: in std_logic;
    WM: in std_logic;
    EN3: in std_logic;
    S3: in std_logic;
    --input signal
    CK: in std_logic;
    --output signal
    OUTPUT: out std_logic_vector(31 downto 0)
    );
end top_layer;

architecture Behavioral of top_layer is
--components will be used
--instruction memory
component ins_mem is
    generic(
    nbit_address : natural :=5;
    nbit_data : natural :=31
    );
    port (
    data_add: in std_logic_vector(nbit_address downto 0);
    data_out: out std_logic_vector(nbit_data downto 0)
    );
end component;
--register file
component register_file is
    generic (
    nbit_address : natural :=5;
    nbit_data  : natural :=64 
    );
    port (  
    CLK: 		IN std_logic;
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
    OUT2: 		OUT std_logic_vector(nbit_data-1 downto 0)
    );
end component;
--ALU
component SIPISOALU is 
	Port (	CLK	:	In	std_logic;
		RESET	:  	In      std_logic;
		STARTA	:  	In 	std_logic;
		A	:	In	std_logic;
		LOADB	:	In 	std_logic;
		B	:	In	std_logic_vector(3 downto 0);
		STARTC	:	Out	std_logic;
		C	:	Out	std_logic);
end component; 
--data memory
component data_mem is 
    generic(
    nbit_address : natural :=5;
    nbit_data : natural :=31
    );
    port (
    data_in: in std_logic_vector(nbit_data downto 0);
    WR: in std_logic;
    data_add: in std_logic_vector(nbit_address downto 0);
    data_out: out std_logic_vector(nbit_data downto 0)
    );
end component;
----inner signal
----fetch_in
--signal curr_ins_add: std_logic_vector(7 downto 0);
----fetch_out
--signal next_ins_add: std_logic_vector(7 downto 0);
--signal instr: std_logic_vector(31 downto 0);
----decode_in
--signal r_addr1: std_logic_vector();
--signal r_addr2: std_logic_vector();
--signal w_addr: std_logic_vector();--rd2_out
--signal data: std_logic_vector();--wb_reg_out
--signal inp1_in: std_logic_vector();
--signal inp2_in: std_logic_vector();
--signal rd: std_logic;
----decode_out
--signal reg_a: std_logic_vector();
--signal reg_b: std_logic_vector();
--signal inp1_out: std_logic_vector();
--signal inp2_out: std_logic_vector();
--signal rd1: std_logic;
----execute_out
--signal aul_out: std_logic_vector();--addr_data_in--wb_reg_in2
--signal b2mem_out: std_logic_vector();--data_in
----memory_in
----memory_out
--signal mem_reg_out: std_logic_vector();--wb_reg_in1
----write back in
----write back out
signal test: bit_vector(31 downto 0):=x"00f0";
signal test2: std_logic_vector(31 downto 0):=x"00f0";
begin
    process
    variable num: integer:=16#38#;
    variable num2: real;
    begin
        test<=test and bit_vector(test2);
        num2:=real(num);
    end process;

end Behavioral;
