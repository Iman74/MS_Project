library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

--use WORK.constants.all;

entity MULTIPLIER_tb is
end MULTIPLIER_tb;


architecture TEST of MULTIPLIER_tb is


  constant numBit : integer := 8;    -- :=8  --:=16 
--:=32
   

  --  input	 
  signal A_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');

  -- output
  signal Y_mp_i : std_logic_vector(2*numBit-1 downto 0);


-- MUL component declaration
component BOOTHMUL is
    Generic (IN_WIDTTH1 : NATURAL := 6;
             IN_WIDTTH2 : NATURAL := 6);
    Port ( OP1 : in STD_LOGIC_VECTOR (IN_WIDTTH1-1 downto 0);
           OP2 : in STD_LOGIC_VECTOR (IN_WIDTTH2-1 downto 0);
           MUL_RESULT : out STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0));
end component;--


begin

-- MUL instantiation
--
DUT : BOOTHMUL GENERIC MAP (numBit,numBit)
               PORT MAP (A_mp_i,B_mp_i,Y_mp_i);

-- PROCESS FOR TESTING TEST - COMLETE CYCLE ---------
  test: process
  begin

    -- cycle for operand A
    NumROW : for i in 0 to 2**(NumBit)-1 loop

        -- cycle for operand B
    	NumCOL : for i in 0 to 2**(NumBit)-1 loop
            wait for 10 ns;
            assert (Y_mp_i = B_mp_i*A_mp_i) 
                    report 
                        "wrong result. Y_mp_i = " & integer'image( to_integer(unsigned(Y_mp_i))) & ", should be -> ans = " & integer'image( to_integer(unsigned(B_mp_i*A_mp_i))) 
                        severity error; -- note, warning, error, failure
            B_mp_i <= B_mp_i + '1';
        end loop NumCOL ;
        
	   A_mp_i <= A_mp_i + '1'; 	
    end loop NumROW ;

    wait;          
  end process test;


end TEST;
