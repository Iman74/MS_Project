library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX5_1 is
    Generic (WIDTTH : NATURAL := 4);
    Port ( IN0 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
           IN1 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
           IN2 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
           IN3 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
           IN4 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
           SEL : in STD_LOGIC_VECTOR (2 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (WIDTTH-1 downto 0));
end MUX5_1;

architecture Behavioral of MUX5_1 is
begin
	OUTPUT <= IN0 when SEL= "000" else 
              IN1 when SEL= "001" else 
              IN2 when SEL= "010" else 
              IN3 when SEL= "011" else 
              IN4 ; 
             
end Behavioral;
