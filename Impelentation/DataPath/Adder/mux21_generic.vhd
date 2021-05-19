library IEEE;

use IEEE.std_logic_1164.all;
use WORK.constants.all;
use work.constants.all;

entity MUX21_GENERIC is
GENERIC (NBIT: integer:= NumBit);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
			B:	In	std_logic_vector(NBIT-1 downto 0);
			SEL:	In	std_logic;
			Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;
 
architecture BEHAVIORAL of MUX21_GENERIC is

begin
	Y <= A when SEL='1' else B; -- behavioral of mux21 on n bit

end BEHAVIORAL;


