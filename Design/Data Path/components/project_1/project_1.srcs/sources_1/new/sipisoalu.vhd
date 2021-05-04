library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is 
	Port (
	OP1: in std_logic_vector(31 downto 0);
	OP2: in std_logic_vector(31 downto 0);
	OP_SL: in std_logic_vector(10 downto 0);
	O_reg: out std_logic_vector(31 downto 0);
	O_branch: out std_logic_vector(31 downto 0);
	O_WB: out std_logic_vector(31 downto 0);
	CLK: in std_logic);
end ALU; 

architecture behavior of ALU is
signal o: std_logic_vector(31 downto 0);
signal add_o: std_logic_vector(31 downto 0);
--signal sub_o: std_logic_vector(31 downto 0);
signal sh_l_o: std_logic_vector(31 downto 0);
--signal sh_r_o: std_logic_vector(31 downto 0);
signal c_sh_l_o: std_logic_vector(31 downto 0);
--signal c_sh_r_o: std_logic_vector(31 downto 0);
signal mul_o: std_logic_vector(31 downto 0);
signal div_o: std_logic_vector(31 downto 0);
signal mul_1,mul_2: std_logic_vector(15 downto 0);

--component definition
component add is 
port(
    a,b: in std_logic_vector(31 downto 0);
    c: out std_logic_vector(31 downto 0);
    cout: out std_logic
);
end component;

component sh_l is
port (
    a,b: in std_logic_vector(31 downto 0);-- a <- b bit, if b<0 dir: ->
    c: out std_logic_vector(31 downto 0)
);
end component;

component c_sh_l is 
port(
    a,b: in std_logic_vector(31 downto 0);-- a <- b bit, if b<0 dir: ->
    c: out std_logic_vector(31 downto 0)
);
end component;

component mul is
port(
    a,b: in std_logic_vector(15 downto 0);
    c: out std_logic_vector(31 downto 0)
);
end component;

component div is
port (
    a,b: in std_logic_vector(31 downto 0);
    c: out std_logic_vector(31 downto 0)
); 
end component;

begin
    mul_1<=OP1(15 downto 0);
    mul_2<=OP2(15 downto 0);
    
    adder: add port map(a=>OP1,b=>OP2,c=>add_o);
    shifter: sh_l port map(a=>OP1,b=>OP2,c=>sh_l_o);
    c_shifter: c_sh_l port map(a=>OP1,b=>OP2,c=>c_sh_l_o);
    multiplier: mul port map(a=>mul_1,b=>mul_2,c=>mul_o);
    divider: div port map(a=>OP1,b=>OP2,c=>div_o);
    
    process(OP1,OP2,OP_SL)
    begin
    --00000000000 to 00000000101 are + - sh_r sh_l c_sh_r c_shl and or xor nor inv
        if OP_SL="0000000000" then
            o<=add_o;
--        elsif OP_SL="0000000001" then
--            o<=sub_o;
        elsif OP_SL="0000000010" then
            o<=sh_l_o;
--        elsif OP_SL="0000000011" then
--            o<=sh_r_o;
        elsif OP_SL="0000000100" then
            o<=c_sh_l_o;
--        elsif OP_SL="0000000101" then
--            o<=c_sh_r_o;
        elsif OP_SL="0000000110" then
            o<= OP1 and OP2;
        elsif OP_SL="0000000111" then
            o<= OP1 or OP2;
        elsif OP_SL="0000001000" then
            o<= OP1 xor OP2;
        elsif OP_SL="0000001001" then
            o<= OP1 nor OP2;   
        --00000001010 to 00000001011 are * /
        elsif OP_SL="0000001010" then
            o<= mul_o;
        elsif OP_SL="0000001011" then
            o<= div_o;
        else
            null;
        end if;        
    end process;

    process(clk)
    begin
        if (clk'event and clk='1') then
            O_reg<=o;
            O_branch<=o;
            O_WB<=o;
        end if;
    end process;
end behavior;

