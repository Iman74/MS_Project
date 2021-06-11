library IEEE;

use IEEE.std_logic_1164.all;
--use WORK.ADDER_CONSTANTS.all;

entity G_block is 
	Port (	PG_IN_1:	In	std_logic; -- input from PG 
			PG_IN_2:	In	std_logic; -- input from G
			G_IN:		In	std_logic;
			G_OUT:	Out	std_logic);
end G_block; 
 
architecture BEHAVIORAL of G_block is

begin

	G_OUT <= PG_IN_2 or (PG_IN_1 and G_IN);

end BEHAVIORAL;






