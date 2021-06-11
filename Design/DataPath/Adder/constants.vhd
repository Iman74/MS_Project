package ADDER_CONSTANTS is
--   constant IVDELAY : time := 0 ns;
--   constant NDDELAY : time := 0 ns;
--   constant NDDELAYRISE : time := 0 ns;
--   constant NDDELAYFALL : time := 0 ns;
--   constant NRDELAY : time := 0 ns;
--   constant DRCAS : time := 0 ns;
--   constant DRCAC : time := 0 ns;
--   constant TP_MUX : time := 0 ns; 	
   constant NumBit : integer := 32;	
   constant NumBit_sel_block :integer := 4; 
   constant NumBit_generator_block : integer:= 8; -- length of the carry vector
   constant NumBit_carry_provided : integer := 8;
   constant NumBit_iteration : integer := 5;
   constant NumBit_generator : integer:= 32;
end ADDER_CONSTANTS;
