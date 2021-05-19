library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity P4_adder is 
	generic (NBIT: integer:= NumBit);
	Port (	INPUT_1:	In	std_logic_vector(NBIT-1 downto 0);
		    INPUT_2:	In	std_logic_vector(NBIT-1 downto 0);
		    C_in:	In	std_logic;
		    SUM:	Out	std_logic_vector(NBIT-1 downto 0);
		    C_out:	Out	std_logic); 
end P4_adder; 

architecture STRUCTURAL of P4_adder is
	
component sum_generator is 
	generic (NBIT_GEN: integer:= NumBit_generator;
			 NBIT_GEN_BLOCK: integer:= NumBit_generator_block); -- total number of bits of inputs (multiple of nbit of carry select block) 
	Port (	ADD_1:	In	std_logic_vector(NBIT_GEN-1 downto 0);
		    ADD_2:	In	std_logic_vector(NBIT_GEN-1 downto 0);
		    Ci:	In	std_logic_vector(NBIT_GEN_BLOCK-1 downto 0); -- carry in of each stage
		    SUM:	Out	std_logic_vector(NBIT_GEN-1 downto 0));
		    --Co:	Out	std_logic); isn't needed because the carry out is provided to the other block by a carry_generator_block 
end component; 

component carry_generator is 
	generic (NBIT_GEN: integer:= NumBit_generator;
			 NBIT_Co: integer:= NumBit_carry_provided;
			 N_ITERATION: integer:=NumBit_iteration); -- number of iteration=log2(numbit_generator)
	Port (	ADD_1:	In	std_logic_vector(NBIT_GEN-1 downto 0);
		    ADD_2:	In	std_logic_vector(NBIT_GEN-1 downto 0);
		    Ci_carry_gen:	In	std_logic; -- carry in of carry generator block that is the same of the whole system
		    Co:	Out	std_logic_vector(NBIT_Co downto 0));
end component; 

  signal Carry_from_carry_gen: std_logic_vector(NumBit_carry_provided downto 0);

begin

  Carry_gen:carry_generator 
	  generic map (NBIT_GEN => NumBit_generator, NBIT_Co => NumBit_carry_provided, N_ITERATION => NumBit_iteration) 
	  Port Map (ADD_1 => INPUT_1, ADD_2 => INPUT_2, Ci_carry_gen => C_in, Co =>  Carry_from_carry_gen); -- COMPONENT=>SIGNAL
  
  Sum_gen:sum_generator 
	  generic map (NBIT_GEN => NumBit_generator, NBIT_GEN_BLOCK => NumBit_generator_block) 
	  Port Map (ADD_1 => INPUT_1, ADD_2 => INPUT_2, Ci =>  Carry_from_carry_gen(NumBit_carry_provided-1 downto 0), SUM => SUM); -- COMPONENT=>SIGNAL
  	
	C_out <= Carry_from_carry_gen(NumBit_carry_provided);

end STRUCTURAL;


