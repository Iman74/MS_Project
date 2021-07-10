library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use WORK.all;

entity register_file is
    Generic (nbit_address : natural :=5;
             nbit_data  : natural :=64 );
    port (  CLK: 		IN std_logic;
            RESET: 	    IN std_logic;
            ENABLE: 	IN std_logic;
            RD1: 		IN std_logic;
            RD2: 		IN std_logic;
            WR: 		IN std_logic;
            ADD_WR: 	IN std_logic_vector(nbit_address-1 downto 0);
            ADD_RD1: 	IN std_logic_vector(nbit_address-1 downto 0);
            ADD_RD2: 	IN std_logic_vector(nbit_address-1 downto 0);
            DATAIN: 	IN std_logic_vector(nbit_data-1 downto 0);
            OUT1: 		OUT std_logic_vector(nbit_data-1 downto 0);
            OUT2: 		OUT std_logic_vector(nbit_data-1 downto 0));
end register_file;

architecture behavioral of register_file is

        -- suggested structures
    subtype REG_ADDR is natural range 0 to (2**nbit_address) -1; -- using natural type
    type REG_ARRAY is array(REG_ADDR) of std_logic_vector(nbit_data-1 downto 0); 
    signal REGISTERS : REG_ARRAY; 	
begin 
   seq: PROCESS (Clk)
   BEGIN
      IF (Clk'EVENT AND Clk = '1') THEN
         IF (RESET = '1') THEN
           REGISTERS <= (OTHERS => (OTHERS =>'0'));                         
         ELSIF (ENABLE = '1') THEN
            IF (WR = '1') THEN
                REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN; 
            END IF;
            IF (RD1 = '1') THEN
                OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1))); 
            END IF;
            IF (RD2 = '1') THEN
                OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2))); 
            END IF;
         END IF;
      END IF;
   END PROCESS seq;

end behavioral;
