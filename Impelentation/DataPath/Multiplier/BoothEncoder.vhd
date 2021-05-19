library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BoothEncoder is
    Port ( INPUT : in STD_LOGIC_VECTOR (2 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (2 downto 0));
end BoothEncoder;

architecture Behavioral of BoothEncoder is

begin
    OUTPUT <= "000" when INPUT = "000" OR INPUT = "111" else
              "001" when INPUT ="001" OR INPUT ="010" else
              "010" when INPUT ="101" OR INPUT ="110" else
              "011" when INPUT ="011" else
              "100" when INPUT ="100"  ;
end Behavioral;
