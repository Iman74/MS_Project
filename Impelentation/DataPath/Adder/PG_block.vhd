library IEEE;

use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity PG_block is 
	Port (	PG_IN_first_P:	In	std_logic;--PG bit 0 is LSB and bit 1 is MSB Propagate with lower index
			PG_IN_second_P:	In	std_logic;--PG bit 0 is LSB and bit 1 is MSB Propagate with higher index
			PG_IN_first_G:	In	std_logic;--G bit 0 is LSB and bit 1 is MSB Generate with lower index 
			PG_IN_second_G:	In	std_logic;--G bit 0 is LSB and bit 1 is MSB Generate with higher index 
			PG_OUT_G:	Out	std_logic; -- all signals are splitted because for our implementation is easier to connect the signal in the port map of generated statement  
			PG_OUT_PG:	Out	std_logic);
end PG_block; 
 
architecture BEHAVIORAL of PG_block is

begin

	PG_OUT_PG <=  PG_IN_second_P and PG_IN_first_P;
	PG_OUT_G <= PG_IN_second_G or (PG_IN_second_P and PG_IN_first_G);

end BEHAVIORAL;






