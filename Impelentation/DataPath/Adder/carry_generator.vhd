library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity carry_generator is 
	generic (NBIT_GEN: integer:= NumBit_generator;
			 NBIT_Co: integer:= NumBit_carry_provided;
			 N_ITERATION: integer:=NumBit_iteration); -- number of iteration=log2(numbit_generator)
	Port (	ADD_1:	In	std_logic_vector(NBIT_GEN-1 downto 0);
		    ADD_2:	In	std_logic_vector(NBIT_GEN-1 downto 0);
		    Ci_carry_gen:	In	std_logic; -- carry in of carry generator block that is the same of the whole system
		    Co:	Out	std_logic_vector(NBIT_Co downto 0));-- the MSB correspond to the Carry out of the whole system
end carry_generator; 


architecture STRUCTURAL of carry_generator is

component PG_block is 
	Port (	PG_IN_first_P:	In	std_logic;--PG bit 0 is LSB and bit 1 is MSB Propagate with lower index
			PG_IN_second_P:	In	std_logic;--PG bit 0 is LSB and bit 1 is MSB Propagate with higher index
			PG_IN_first_G:	In	std_logic;--G bit 0 is LSB and bit 1 is MSB Generate with lower index 
			PG_IN_second_G:	In	std_logic;--G bit 0 is LSB and bit 1 is MSB Generate with higher index 
			PG_OUT_G:	Out	std_logic; -- all signals are splitted because for our implementation is easier to connect the signal in the port map of generated statement  
			PG_OUT_PG:	Out	std_logic);
end component; 

component G_block is 
	Port (	PG_IN_1:	In	std_logic; -- input from PG 
			PG_IN_2:	In	std_logic; -- input from G
			G_IN:		In	std_logic;
			G_OUT:	Out	std_logic);
end component; 

  type SignalVector is array (NBIT_GEN-1 downto 0) of std_logic_vector(NBIT_GEN-1 downto 0) ; -- the matrix of signal is oversized, actually shoul be NBIT_GEN x number of iteration 
  signal G_matrix : SignalVector;
  signal PG_matrix : SignalVector; 
  signal Co_signal: std_logic;
 
begin


input_generation: for i in 0 to NBIT_GEN-1 generate
		assignement_in: G_matrix(i)(i) <= ADD_1(i) and ADD_2(i);
						PG_matrix(i)(i) <= ADD_1(i) xor ADD_2(i);
end generate;

 -- the first two  G_block consider the carry in of the whole system
	 G_block_0: G_block Port Map(PG_IN_1 => PG_matrix(0)(0), PG_IN_2 => G_matrix(0)(0),
	                              G_IN => Ci_carry_gen ,G_OUT =>G_matrix(1)(0) );

	 G_block_2_0: G_block Port Map(PG_IN_1 => PG_matrix(1)(1), PG_IN_2 => G_matrix(1)(1),
	                               G_IN => G_matrix(1)(0) ,G_OUT =>G_matrix(2)(0) );

  G_generation: for n_iter in 0 to N_ITERATION-2 generate
    
	generation_0 : if  n_iter = 0 generate       

	  G_block_3: G_block Port Map(PG_IN_1 => PG_matrix(3)(2), PG_IN_2 => G_matrix(3)(2),
	                              G_IN => G_matrix(2)(0) ,G_OUT => G_matrix(3)(0) );
	end generate;

	 generation_1 : if  n_iter = 1 generate -- generate from i in 1 to 2^n_iteration 
	  G_block_7: G_block Port Map(PG_IN_1 => PG_matrix(7)(4), PG_IN_2 => G_matrix(7)(4),
	                              G_IN => G_matrix(3)(0) ,G_OUT => G_matrix(7)(0) );
	end generate;

     generation_2 : if  n_iter > 1 generate -- generate from i in 1 to 2^n_iteration this is iteration 1 and so on
	  G_block_i: for i in 1 to 2**(n_iter-1) generate
              G_block_cycle: G_block Port Map(PG_IN_1 =>  PG_matrix(2**(n_iter+1)-1+4*i)(2**(n_iter+1)),
											  PG_IN_2 => G_matrix (2**(n_iter+1)-1+4*i)(2**(n_iter+1)),
											  G_IN => G_matrix(2**(n_iter+1)-1)(0) ,
							    			  G_OUT => G_matrix(2**(n_iter+1)-1+4*i)(0) );
	     end generate;
	end generate;
end generate G_generation;

PG_pre_generation_0: for m in 1 to NBIT_GEN/2-1 generate 
 pre_generation_0: PG_block port map(PG_IN_second_P => PG_matrix(2*m+1)(2*m+1), PG_IN_first_P => PG_matrix(2*m)(2*m),
 PG_IN_second_G =>G_matrix(2*m+1)(2*m+1), PG_IN_first_G => G_matrix(2*m)(2*m) ,PG_OUT_PG => PG_matrix(2*m+1)(2*m), PG_OUT_G => G_matrix(2*m+1)(2*m));
 end generate;
 
PG_pre_generation_1: for m in 0 to NBIT_GEN/4-2 generate 
 pre_generation_1: PG_block port map(PG_IN_second_P => PG_matrix(5+(2*(2*m+1)))(4+(2*(2*m+1))), PG_IN_first_P => PG_matrix(3+(2*(2*m+1)))(2+(2*(2*m+1))),
 PG_IN_second_G =>G_matrix(5+(2*(2*m+1)))(4+(2*(2*m+1))), PG_IN_first_G => G_matrix(3+(2*(2*m+1)))(2+(2*(2*m+1))) ,
 PG_OUT_PG => PG_matrix(5+(2*(2*m+1)))(2+(2*(2*m+1))), PG_OUT_G => G_matrix(5+(2*(2*m+1)))(2+(2*(2*m+1))) );
 end generate;
 
 PG_generation: for n_iter in 0 to n_iteration-4 generate
    
	generation_2 : if  n_iter = 0 generate
	  PG_block_3: for m in 0 to NBIT_GEN/8-2 generate -- numbit_gen/16 +1 is equal to the number of new block to generate
gen_2:PG_block port map(PG_IN_second_P => PG_matrix(13+(2*(4*m+1)))(10+(2*(4*m+1))), PG_IN_first_P => PG_matrix(9+(2*(4*m+1)))(6+(2*(4*m+1))),
 PG_IN_second_G =>G_matrix(13+(2*(4*m+1)))(10+(2*(4*m+1))), PG_IN_first_G => G_matrix(9+(2*(4*m+1)))(6+(2*(4*m+1))) ,
 PG_OUT_PG => PG_matrix(13+(2*(4*m+1)))(6+(2*(4*m+1))), PG_OUT_G => G_matrix(13+(2*(4*m+1)))(6+(2*(4*m+1))) ); 
	end generate;
end generate;


	 generation_3 : if  n_iter > 0 generate -- after the over all #2 iteration (from the 3rd ) the behavior is the same

	  PG_block_m: for m in 1 to NBIT_GEN/2**(n_iter+3)-1 generate -- number of PG blocks with common PG sons 
			PG_block_i: for i in 1 to 2**n_iter generate -- number of sons for each  father PG block
					PG_block_cycle : PG_block port map(PG_IN_second_P => PG_matrix(2**(n_iter+2)*(1+2*m)-1+4*i)(2**(n_iter+2)*(1+2*m)),
																  PG_IN_first_P => PG_matrix(2**(n_iter+2)*(1+2*m)-1)(m*2**(n_iter+3)),
																  PG_IN_second_G =>G_matrix(2**(n_iter+2)*(1+2*m)-1+4*i)(2**(n_iter+2)*(1+2*m)), 
																  PG_IN_first_G =>G_matrix(2**(n_iter+2)*(1+2*m)-1)(m*2**(n_iter+3)),
																  PG_OUT_PG => PG_matrix(2**(n_iter+2)*(1+2*m)-1+4*i)(m*2**(n_iter+3)), 
																  PG_OUT_G => G_matrix(2**(n_iter+2)*(1+2*m)-1+4*i)(m*2**(n_iter+3)));

					end generate;
			end generate;
	end generate;			 
 end generate;

	Co(0) <= Ci_carry_gen; -- the carry for the first adder block is the Carry in of the whole system

 output_generation: for i in 0 to NBIT_Co-1 generate
		assignement: Co(i+1) <= G_matrix(3+4*i)(0); -- THE FIRST IS CARRY IN OF THE WHOLE SYSTEM!!!!!!! TO BE MODIFIED
end generate;

end STRUCTURAL;
