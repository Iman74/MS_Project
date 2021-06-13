library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.dlxTypes.all;


entity reloc_mem_LUT is
    Generic (LENGTH : integer :=  RELOC_MEM_SIZE; -- I + J + 1(R)
             WIDTH :  integer :=  integer(ceil(log2(real(CW_MEM_SIZE))))
    );  
    port (
            address    : in std_logic_vector(integer(ceil(log2(real(LENGTH))))-1 downto 0);               
            data    : out std_logic_vector(WIDTH-1 downto 0));               
end reloc_mem_LUT;
architecture df of reloc_mem_LUT is
    type reloc_mem_array is array (0 to LENGTH - 1) of std_logic_vector(WIDTH-1 downto 0);
    signal reloc_mem : reloc_mem_array := (  std_logic_vector(to_unsigned(70,WIDTH)), -- All R-Type Instructions               
                                             std_logic_vector(to_unsigned(0,WIDTH)), --ADDI1
                                             std_logic_vector(to_unsigned(5,WIDTH)), --SUBI1
                                             std_logic_vector(to_unsigned(10,WIDTH)), --ANDI1
                                             std_logic_vector(to_unsigned(15,WIDTH)), --ORI1
                                             std_logic_vector(to_unsigned(20,WIDTH)), --ADDI2
                                             std_logic_vector(to_unsigned(25,WIDTH)), --SUBI2
                                             std_logic_vector(to_unsigned(30,WIDTH)), --ANDI2
                                             std_logic_vector(to_unsigned(35,WIDTH)), --ORI2
                                             std_logic_vector(to_unsigned(40,WIDTH)), --MOV
                                             std_logic_vector(to_unsigned(45,WIDTH)), --S_REG1
                                             std_logic_vector(to_unsigned(50,WIDTH)), --S_REG2
                                             std_logic_vector(to_unsigned(55,WIDTH)), --S_MEM2
                                             std_logic_vector(to_unsigned(60,WIDTH)), --L_MEM1
                                             std_logic_vector(to_unsigned(65,WIDTH))); --L_MEM2
begin
    data <= reloc_mem(conv_integer(address));
end df;
