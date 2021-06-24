library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity ADD_N is
    GENERIC (N : INTEGER := 4);
    PORT (A,B:in std_logic_vector (N-1 downto 0 );
        Ci:in std_logic;
        Sum:out std_logic_vector (N-1 downto 0);
        Co, Ovf:out std_logic );
end ADD_N;

architecture Behavioral of ADD_N is
begin
    AddNProcess: PROCESS(A,B,Ci)
    VARIABLE A_N,B_N,Sum_N : unsigned (N downto 0);
    begin
        A_N := unsigned('0' & A);
        B_N := unsigned('0' & B);
        Sum_N := A_N + B_N +('0' & Ci);
        Co <= Sum_N(N);
        Sum <= std_logic_vector (Sum_N(N-1 DOWNTO 0));
        Ovf <= Sum_N(N) XOR ( A_N(N-1) XOR B_N(N-1) XOR Sum_N(N-1));
    end PROCESS AddNProcess;
end Behavioral;