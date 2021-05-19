library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 
use work.constants.all;

entity TBRCA is 
end TBRCA; 

architecture TEST of TBRCA is

    component P4_adder is 
        generic (NBIT: integer:= NumBit);
        Port (	INPUT_1:	In	std_logic_vector(NBIT-1 downto 0);
                INPUT_2:	In	std_logic_vector(NBIT-1 downto 0);
                C_in:	In	std_logic;
                SUM:	Out	std_logic_vector(NBIT-1 downto 0);
                C_out:	Out	std_logic); 
    end component; 
  
    
    signal A, B, S: std_logic_vector(NumBit-1 downto 0);
    signal Co, Ci: std_logic;

Begin


  UADDER: P4_adder 
	   port map (INPUT_1 => A,INPUT_2 => B, C_in=> Ci,SUM=> S, C_out=> Co);




  STIMULUS1: process
  begin
    Ci <= '0';
    A <= std_logic_vector(to_unsigned(30,32));
    B <= std_logic_vector(to_unsigned(51,32));
    wait for 100NS;
    A <= std_logic_vector(to_unsigned(1,32));
    B <= x"FFFFFFFF";
    wait for 100NS;
    Ci <= '1';
    wait for 100NS;
    WAIT;
  end process STIMULUS1;

end TEST;

