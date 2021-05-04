library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.dlxTypes.all;

entity cw_mem_LUT is
    Generic (LENGTH : integer :=  CW_MEM_SIZE;       -- 5*I + 5*j 5 + 8*R                      
             WIDTH: integer :=  CW_SIZE);                                -- CW width
    port (
            address    : in std_logic_vector(integer(ceil(log2(real(LENGTH))))-1 downto 0);               
            data    : out std_logic_vector(WIDTH - 1 downto 0));               
end cw_mem_LUT;
architecture df of cw_mem_LUT is
    type mem_array is array (integer range 0 to LENGTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
    constant cw_mem : mem_array := (B"101_00000_00000", -- ADDI1 RS1,RD,INP1    
                                    B"000_10000_00000", -- ADDI1 RS1,RD,INP1    
                                    B"000_00000_10011", -- ADDI1 RS1,RD,INP1    
                                    
                                    B"101_00000_00000", -- SUBI1 R1,R2,INP1     
                                    B"000_10001_00000", -- SUBI1 R1,R2,INP1     
                                    B"000_00000_10011", -- SUBI1 R1,R2,INP1     
                                    
                                    B"101_00000_00000", --- ANDI1 R1,R2,INP1    
                                    B"000_10010_10011", --- ANDI1 R1,R2,INP1    
                                    B"000_00000_10011", --- ANDI1 R1,R2,INP1    
                                    
                                    B"101_00000_00000", -- ORI1 R1,R2,INP1      
                                    B"000_10011_00000", -- ORI1 R1,R2,INP1      
                                    B"000_00000_10011", -- ORI1 R1,R2,INP1      
                                    
                                    B"110_00000_00000", -- ADDI2 RS1,RD,INP2    
                                    B"000_11100_00000", -- ADDI2 RS1,RD,INP2    
                                    B"000_00000_10011", -- ADDI2 RS1,RD,INP2    
                                    
                                    B"110_00000_00000", -- SUBI2 R1,R2,INP2     
                                    B"000_11101_00000", -- SUBI2 R1,R2,INP2     
                                    B"000_00000_10011", -- SUBI2 R1,R2,INP2     
                                    
                                    B"110_00000_00000", --- ANDI2 R1,R2,INP2    
                                    B"000_11110_00000", --- ANDI2 R1,R2,INP2    
                                    B"000_00000_10011", --- ANDI2 R1,R2,INP2
                                        
                                    B"110_00000_00000", -- ORI2 R1,R2,INP2     
                                    B"000_11111_00000", -- ORI2 R1,R2,INP2     
                                    B"000_00000_10011", -- ORI2 R1,R2,INP2     
                                    
                                    B"110_00000_00000", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    B"000_10011_00000", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    B"000_00000_10011", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    
                                    B"101_00000_00000", -- S_REG1 R2,INP1   
                                    B"000_10000_00000", -- S_REG1 R2,INP1   
                                    B"000_00000_10011", -- S_REG1 R2,INP1 
                                      
                                    B"110_00000_00000", -- S_REG2 R2,INP2   
                                    B"000_11100_00000", -- S_REG2 R2,INP2   
                                    B"000_00000_10011", -- S_REG2 R2,INP2   
                                    
                                    B"110_00000_00000", -- S_MEM2 R1,R2,INP2
                                    B"000_11100_00000", -- S_MEM2 R1,R2,INP2
                                    B"000_00000_10100", -- S_MEM2 R1,R2,INP2
                                    
                                    B"101_00000_00000", -- L_MEM1 R1,R2,INP1    
                                    B"000_10000_00000", -- L_MEM1 R1,R2,INP1    
                                    B"000_00000_11001", -- L_MEM1 R1,R2,INP1    
                                    
                                    B"110_00000_00000",-- L_MEM2 R1,R2,INP2
                                    B"000_11100_00000",-- L_MEM2 R1,R2,INP2
                                    B"000_00000_11001",-- L_MEM2 R1,R2,INP2
                                    
                                    B"111_00000_00000", -- R type 
                                    B"000_11000_00000", -- R type add  
                                    B"000_00000_10011", -- R type 
                                    B"000_00000_00000", -- R type dummy
                                    
                                    B"111_00000_00000", -- R type  
                                    B"000_11001_00000", -- R type   sub
                                    B"000_00000_10011", -- R type 
                                    B"000_00000_00000", -- R type dummy
                                    
                                    B"111_00000_00000", -- R type  
                                    B"000_11010_00000", -- R type   and
                                    B"000_00000_10011", -- R type 
                                    B"000_00000_00000", -- R type dummy
                                    
                                    B"111_00000_00000", -- R type   
                                    B"000_11011_00000", -- R type   or
                                    B"000_00000_10011", -- R type   
                                    B"000_00000_00000"  -- R type   dummy
                                    );
begin
    data <= cw_mem(conv_integer(address));
end df;
