----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/06/21 15:07:28
-- Design Name: 
-- Module Name: shifter_tb - Behavioral
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

entity shifter_tb is
--  Port ( );
end shifter_tb;

architecture Behavioral of shifter_tb is
component shifter is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           sh_output : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal tb_operand1:STD_LOGIC_VECTOR (31 downto 0);
signal tb_operand2:STD_LOGIC_VECTOR (31 downto 0);
signal tb_sh_output:STD_LOGIC_VECTOR (31 downto 0);
begin

    shifter_tb: shifter port map (operand1=>tb_operand1,operand2=>tb_operand2,sh_output=>tb_sh_output);
    process
    begin
        tb_operand1<=x"80010001";
------------------------------------------------
--logic left 16+
------------------------------------------------
        tb_operand2<=x"0000000f";--15
        wait for 10 ns;
        tb_operand2<=x"00000010";--16
        wait for 10 ns;
        tb_operand2<=x"00000011";--17
        wait for 10 ns;
        tb_operand2<=x"00000012";
                wait for 10 ns;
        tb_operand2<=x"00000013";
                wait for 10 ns;
        tb_operand2<=x"00000014";
                wait for 10 ns;
        tb_operand2<=x"00000015";
                wait for 10 ns;
        tb_operand2<=x"00000016";
                wait for 10 ns;
        tb_operand2<=x"00000017";
                wait for 10 ns;
        tb_operand2<=x"00000018";
                wait for 10 ns;
        tb_operand2<=x"00000009";
                wait for 10 ns;
        tb_operand2<=x"0000000a";
                wait for 10 ns;
        tb_operand2<=x"0000000b";
                wait for 10 ns;
        tb_operand2<=x"0000000c";
                wait for 10 ns;
        tb_operand2<=x"0000000d";
                wait for 10 ns;
        tb_operand2<=x"0000000e";
                wait for 10 ns;
        tb_operand2<=x"0000000f";
---------------------------------------------      
--logic right 16+
---------------------------------------------
        wait for 10 ns;
        tb_operand2<=x"00000081";
        wait for 10 ns;
        tb_operand2<=x"00000082";       
        wait for 10 ns;
        tb_operand2<=x"00000083";
        wait for 10 ns;
        tb_operand2<=x"00000084";
        wait for 10 ns;
        tb_operand2<=x"00000085";
        wait for 10 ns;
        tb_operand2<=x"00000086";
        wait for 10 ns;
        tb_operand2<=x"00000087";
        wait for 10 ns;
        tb_operand2<=x"00000098";
        wait for 10 ns;
        tb_operand2<=x"0000009a";
        wait for 10 ns;
        tb_operand2<=x"0000009b";
        wait for 10 ns;
        tb_operand2<=x"0000009c";
        wait for 10 ns;
        tb_operand2<=x"0000009d";
        wait for 10 ns;
        tb_operand2<=x"0000009e";
        wait for 10 ns;
        tb_operand2<=x"0000009f";
--arith left
        wait for 10 ns;
        tb_operand2<=x"000000cd";
        wait for 10 ns;
        tb_operand2<=x"000000ce";       
        wait for 10 ns;
        tb_operand2<=x"000000cf";
        wait for 10 ns;
        tb_operand2<=x"000000d1";
        wait for 10 ns;
        tb_operand2<=x"000000d2";
        wait for 10 ns;
        tb_operand2<=x"000000d3";
        wait for 10 ns;
        tb_operand2<=x"000000d4";
        wait for 10 ns;
        tb_operand2<=x"000000d5";
        wait for 10 ns;
        tb_operand2<=x"000000da";
        wait for 10 ns;
        tb_operand2<=x"000000db";
        wait for 10 ns;
        tb_operand2<=x"000000dc";
        wait for 10 ns;
        tb_operand2<=x"000000dd";
        wait for 10 ns;
        tb_operand2<=x"000000de";
        wait for 10 ns;
        tb_operand2<=x"000000df";
--arith right        
        wait for 10 ns;
        tb_operand2<=x"00000051";
        wait for 10 ns;
        tb_operand2<=x"00000052";       
        wait for 10 ns;
        tb_operand2<=x"00000053";
        wait for 10 ns;
        tb_operand2<=x"00000054";
        wait for 10 ns;
        tb_operand2<=x"00000055";
        wait for 10 ns;
        tb_operand2<=x"00000056";
        wait for 10 ns;
        tb_operand2<=x"00000057";
        wait for 10 ns;
        tb_operand2<=x"00000058";
        wait for 10 ns;
        tb_operand2<=x"0000005a";
        wait for 10 ns;
        tb_operand2<=x"0000005b";
        wait for 10 ns;
        tb_operand2<=x"0000005c";
        wait for 10 ns;
        tb_operand2<=x"0000005d";
        wait for 10 ns;
        tb_operand2<=x"0000005e";
        wait for 10 ns;
        tb_operand2<=x"0000005f";
        wait for 10 ns;
        wait;
    end process;

end Behavioral;
