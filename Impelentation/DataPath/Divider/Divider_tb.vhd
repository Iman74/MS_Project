----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2021 01:16:07 PM
-- Design Name: 
-- Module Name: Divider_tb - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Divider_tb is
--  Port ( );
end Divider_tb;


architecture TEST of Divider_tb is


  constant numBit : integer := 32;    -- :=8  --:=16 
--:=32
   

  --  input	 
  signal DIVIDEND_div_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal DIVISOR_div_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal START_div_i : std_logic :='0';
  signal CLK_div_i : std_logic :='0';
  signal RESET_div_i : std_logic :='0';

  -- output
  signal QUOTIENT_div_i : std_logic_vector(numBit-1 downto 0);
  signal RESIDUAL_div_i : std_logic_vector(numBit-1 downto 0) ;
  signal BUSY_div_i : std_logic ;


-- Divide component declaration
component DIVIDER is
    generic(N_op : INTEGER := 32);
    port
    (
        CLK, START, RESET : in STD_LOGIC;
        BUSY : out STD_LOGIC;
        DIVIDEND, DIVISOR : in STD_LOGIC_VECTOR(N_op-1 downto 0);
        QUOTIENT, RESIDUAL : out STD_LOGIC_VECTOR(N_op-1 downto 0)
    );
end component;

constant half_period : time := 5 ns;


begin

    -- Divide instantiation
    --
    DUT : Divider   Generic MAP(N_op => 32)
                    PORT MAP (CLK =>CLK_div_i,
                            START =>START_div_i,
                            RESET =>RESET_div_i,
                            BUSY =>BUSY_div_i,
                            DIVIDEND =>DIVIDEND_div_i,
                            DIVISOR =>DIVISOR_div_i,
                            QUOTIENT =>QUOTIENT_div_i,
                            RESIDUAL =>RESIDUAL_div_i);
    
   clk_process :process
   begin
        CLK_div_i <= '0';
        wait for half_period;  
        CLK_div_i <= '1';
        wait for half_period;     
    end process clk_process;

    -- PROCESS FOR TESTING TEST - COMLETE CYCLE ---------
    test: process
    begin       
        RESET_div_i <='1';
        wait for 4*half_period;
        RESET_div_i <='0';
        
        loop1 : for i in 1 to 10 loop
            DIVISOR_div_i <= std_logic_vector(TO_UNSIGNED(1,32));
            DIVIDEND_div_i <= std_logic_vector(TO_UNSIGNED(2*i,32));
            START_div_i <='1';
            wait for 2*half_period;
            START_div_i <='0';
            wait until BUSY_div_i = '0';
            wait for 2*half_period;
            -- X/Y = Q + (R/Y)*2^(n-1)
            assert (unsigned(DIVIDEND_div_i) = unsigned(QUOTIENT_div_i)*unsigned(DIVISOR_div_i) + unsigned(RESIDUAL_div_i)) 
                    report 
                        "wrong result. QUOTIENT_div_i = " & integer'image( to_integer(unsigned(QUOTIENT_div_i))) & ", should be -> ans = " & integer'image( to_integer(unsigned(DIVIDEND_div_i)/unsigned(DIVISOR_div_i))) 
                        severity error; -- note, warning, error, failure
        end loop loop1 ;
    
        wait;          
        end process test;
    

end TEST;
