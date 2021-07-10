----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/15 15:15:01
-- Design Name: 
-- Module Name: shifter_l1 - Behavioral
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

entity shifter_l1 is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0):=(others=>'0') ;
           dir : in STD_LOGIC:='0';--0: left 1: right
           logic_arith_sl : in STD_LOGIC:='0';--0: logic shift 1: arithmetic shift
           l1_output0 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output1 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output2 : out STD_LOGIC_VECTOR (63 downto 0);
           l1_output3 : out STD_LOGIC_VECTOR (63 downto 0));
end shifter_l1;

architecture Behavioral of shifter_l1 is
signal lo0,lo8_l,lo8_r,lo16_l,lo16_r,lo24_l,lo24_r: std_logic_vector(63 downto 0):=(others=>'0');
signal ao0,ao8_l,ao8_r,ao16_l,ao16_r,ao24_l,ao24_r: std_logic_vector(63 downto 0):=(others=>'0');
begin
    
--logic shift
    lo0_sh: for i in 31 downto 0 generate 
        lo0(i)<=operand1(i);
    end generate;
--    lo0(31 downto 0)<=operand1;
    --right
    lo8_right: for i in 31 downto 8 generate
        lo8_r(i-8)<=operand1(i);
    end generate; 
    lo8_right_rec: for i in 7 downto 0 generate
        lo8_r(i+56)<=operand1(i);
    end generate;
--    lo8_r(23 downto 0)<=operand1(31 downto 8);
--    lo8_r(63 downto 56)<=operand1(7 downto 0);
    
--    lo16_right: for i in 31 downto 16 generate
--        lo16_r(i-8)<=operand1(i);
--    end generate; 
--    lo16_right_rec: for i in 15 downto 0 generate
--        lo16_r(i+48)<=operand1(i);
--    end generate;
    lo16_r(15 downto 0)<=operand1(31 downto 16);
    lo16_r(63 downto 48)<=operand1(15 downto 0);
    
--    lo24_right: for i in 31 downto 24 generate
--        lo24_r(i-8)<=operand1(i);
--    end generate; 
--    lo24_right_rec: for i in 23 downto 0 generate
--        lo24_r(i+40)<=operand1(i);
--    end generate;
    lo24_r(7 downto 0)<=operand1(31 downto 24);
    lo24_r(63 downto 40)<=operand1(23 downto 0);
    
    --left
    lo8_left: for i in 31 downto 0 generate
        lo8_l(i+8)<=operand1(i);
    end generate; 

    lo16_left: for i in 31 downto 0 generate
        lo16_l(i+16)<=operand1(i);
    end generate;
    
    lo24_left: for i in 31 downto 0 generate
        lo24_l(i+24)<=operand1(i);
    end generate;  
    
--arith shift   
    ao0_sh: for i in 31 downto 0 generate 
        ao0(i)<=operand1(i);
    end generate;
    
    --right
    ao8_right: for i in 30 downto 8 generate
        ao8_r(i-8)<=operand1(i);
    end generate; 
    ao8_right_rec: for i in 7 downto 0 generate
        ao8_r(i+56)<=operand1(i);
    end generate;
    ao8_r(31)<=operand1(31);

        
    ao16_right: for i in 30 downto 16 generate
        ao16_r(i-16)<=operand1(i);
    end generate; 
    ao16_right_rec: for i in 15 downto 0 generate
        ao16_r(i+48)<=operand1(i);
    end generate;
    ao16_r(31)<=operand1(31);
    
    ao24_right: for i in 30 downto 24 generate
        ao24_r(i-24)<=operand1(i);
    end generate; 
    ao24_right_rec: for i in 23 downto 0 generate
        ao24_r(i+40)<=operand1(i);
    end generate;
    ao24_r(31)<=operand1(31);
    
    --left
    ao8_left: for i in 30 downto 23 generate
        ao8_l(i+9)<=operand1(i);
    end generate;
    ao8_left_remain: for i in 22 downto 0 generate
        ao8_l(i+8)<=operand1(i);
    end generate;
    ao8_l(31)<=operand1(31);
   
    ao16_left: for i in 30 downto 15 generate
        ao16_l(i+17)<=operand1(i);
    end generate;
    ao16_left_remain: for i in 14 downto 0 generate
        ao16_l(i+16)<=operand1(i);
    end generate;
    ao16_l(31)<=operand1(31);
    
    ao24_left: for i in 30 downto 7 generate
        ao24_l(i+25)<=operand1(i);
    end generate;
    ao24_left_remain: for i in 6 downto 0 generate
        ao24_l(i+24)<=operand1(i);
    end generate;
    ao24_l(31)<=operand1(31);
   
    process(lo0, lo8_l, lo8_r, lo16_l, lo16_r, lo24_l, lo24_r, ao0, ao8_l, ao8_r, ao16_l, ao16_r, ao24_l, ao24_r, dir, logic_arith_sl)
    begin
        
        if logic_arith_sl='0' then --logic
            l1_output0<=lo0;
            if dir='1' then--right
                l1_output1<=lo8_r;
                l1_output2<=lo16_r;
                l1_output3<=lo24_r;
            elsif dir='0' then--left
                l1_output1<=lo8_l;
                l1_output2<=lo16_l;
                l1_output3<=lo24_l;
            end if;
        elsif logic_arith_sl='1' then --arith
            l1_output0<=ao0;
            if dir='1' then--right
                l1_output1<=ao8_r;
                l1_output2<=ao16_r;
                l1_output3<=ao24_r;
            elsif dir='0' then--left
                l1_output1<=ao8_l;
                l1_output2<=ao16_l;
                l1_output3<=ao24_l;
            end if;
        end if;
    end process;
    
            

end Behavioral;
