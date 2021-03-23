library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.myTypes.all;


entity CU_FSM is
    Generic (
        PIPLINE_STAGES : integer :=  3;                              -- Number of pipline stages
        MICROCODE_MEM_SIZE : integer :=  15;                          -- Number of Valid opcodes (14I+ 1R)
        CW_SIZE : integer :=  13);                                    -- Control word size
    port (
        -- FIRST PIPE STAGE OUTPUTS
        EN1    : out std_logic;               -- enables the register file and the pipeline registers
        RF1    : out std_logic;               -- enables the read port 1 of the register file
        RF2    : out std_logic;               -- enables the read port 2 of the register file
        WF1    : out std_logic;               -- enables the write port of the register file
        -- SECOND PIPE STAGE OUTPUTS
        EN2    : out std_logic;               -- enables the pipe registers
        S1     : out std_logic;               -- input selection of the first multiplexer
        S2     : out std_logic;               -- input selection of the second multiplexer
        ALU1   : out std_logic;               -- alu control bit
        ALU2   : out std_logic;               -- alu control bit
        -- THIRD PIPE STAGE OUTPUTS
        EN3    : out std_logic;               -- enables the memory and the pipeline registers
        RM     : out std_logic;               -- enables the read-out of the memory
        WM     : out std_logic;               -- enables the write-in of the memory
        S3     : out std_logic;               -- input selection of the multiplexer
        -- INPUTS
        OPCODE : in  std_logic_vector(OP_CODE_SIZE - 1 downto 0);
        FUNC   : in  std_logic_vector(FUNC_SIZE - 1 downto 0);              
        Clk : in std_logic;
        Rst : in std_logic);                  -- Active Low
end CU_FSM;

architecture Behavioral of CU_FSM is
    type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
    constant cw_mem : mem_array := (B"111_11000_10011", -- R type   -next cycle WF1 <= '1'
                                    
                                    B"101_10000_10011", -- ADDI1 RS1,RD,INP1    
                                    B"101_10001_10011", -- SUBI1 R1,R2,INP1     
                                    B"101_10010_10011", --- ANDI1 R1,R2,INP1    
                                    B"101_10011_10011", -- ORI1 R1,R2,INP1      
                                    
                                    B"110_11100_10011", -- ADDI2 RS1,RD,INP2    
                                    B"110_11101_10011", -- SUBI2 R1,R2,INP2     
                                    B"110_11110_10011", --- ANDI2 R1,R2,INP2    
                                    B"110_11111_10011", -- ORI2 R1,R2,INP2     
                                    
                                    B"110_10011_10011", -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                                    
                                    B"101_10000_10011", -- S_REG1 R2,INP1   
                                    B"110_11100_10011", -- S_REG2 R2,INP2   
                                    
                                    B"110_11100_10100", -- S_MEM2 R1,R2,INP2
                                    B"101_10000_11001", -- L_MEM1 R1,R2,INP1    
                                    B"110_11100_11001"); -- L_MEM2 R1,R2,INP2
    -- declarations for FSM implementation 
	type TYPE_STATE is (Reset, FetchDecode,Execute,WriteBack);
	signal CURRENT_STATE,NEXT_STATE : TYPE_STATE := reset;

    signal cwi,cwo :std_logic_vector(CW_SIZE - 1 downto 0);
    signal FUNCi :std_logic_vector(FUNC_SIZE - 1 downto 0);
begin
    FUNCi <= FUNC when OPCODE = RTYPE else
                            (others=>'0');
    --
    -- stage one control signals
    EN1  <= cwo(12) OR cwo(0); --enable in case of write back is needed 
    RF1  <= cwo(11);
    RF2  <= cwo(10);
    
    -- stage two control signals
    EN2  <= cwo(9);
    S1  <= cwo(8);
    S2  <= cwo(7);
    ALU1  <= cwo(6) OR FUNCi(0); --Exception for R-types
    ALU2  <= cwo(5) OR FUNCi(1); --Exception for R-types
    
    -- stage three control signals
    EN3  <= cwo(4);
    RM  <= cwo(3);
    WM  <= cwo(2);
    S3  <= cwo(1);
    WF1  <= cwo(0);
    
    --
    P_OPC : process(Clk, Rst)		
	begin
		if Rst='0' then
	        CURRENT_STATE <= reset;
		elsif (Clk ='1' and Clk'EVENT) then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process P_OPC;

	P_NEXT_STATE : process(CURRENT_STATE, OpCode)
	begin
		NEXT_STATE <= CURRENT_STATE;
		case CURRENT_STATE is
			when Reset =>
				NEXT_STATE <= FetchDecode;
				cwi <= (others => '0');
			when FetchDecode => 
                NEXT_STATE <= Execute;
                if OpCode = ITYPE_ADDI1 then
				    cwi <=B"111_11000_10011"; -- R type   -next cycle WF1 <= '1'
                elsif OpCode = ITYPE_ADDI1 then
                    cwi <=B"101_10000_10011"; -- ADDI1 RS1;RD,INP1 
                elsif OpCode = ITYPE_SUBI1 then
                    cwi <=B"101_10001_10011"; -- SUBI1 R1,R2,INP1 
                elsif OpCode = ITYPE_ANDI1 then
                    cwi <=B"101_10010_10011"; --- ANDI1 R1,R2,INP1
                elsif OpCode = ITYPE_ORI1 then
                    cwi <=B"101_10011_10011"; -- ORI1 R1,R2,INP1      
                elsif OpCode = ITYPE_ADDI2 then
                    cwi <=B"110_11100_10011"; -- ADDI2 RS1,RD,INP2 
                elsif OpCode = ITYPE_SUBI2 then
                    cwi <=B"110_11101_10011"; -- SUBI2 R1,R2,INP2
                elsif OpCode = ITYPE_ANDI2 then
                    cwi <=B"110_11110_10011"; --- ANDI2 R1,R2,INP2   
                elsif OpCode = ITYPE_ORI2 then
                    cwi <=B"110_11111_10011"; -- ORI2 R1,R2,INP2     
                elsif OpCode = ITYPE_MOV then
                    cwi <=B"110_10011_10011"; -- MOV R1,R2 ( The value of the immediate must be equal to 0) 
                elsif OpCode = ITYPE_S_REG1 then
                    cwi <=B"101_10000_10011"; -- S_REG1 R2,INP1 
                elsif OpCode = ITYPE_S_REG2 then
                    cwi <=B"110_11100_10011"; -- S_REG2 R2,INP2   
                elsif OpCode = ITYPE_S_MEM2 then
                    cwi <=B"110_11100_10100"; -- S_MEM2 R1,R2,INP2
                elsif OpCode = ITYPE_L_MEM1 then
                    cwi <=B"101_10000_11001"; -- L_MEM1 R1,R2,INP1 
                elsif OpCode = ITYPE_L_MEM2 then
                    cwi <=B"110_11100_11001"; -- L_MEM2 R1,R2,INP2
				end if;
			when Execute => 
                NEXT_STATE <= WriteBack;
			when WriteBack => 
                NEXT_STATE <= FetchDecode;
		end case;	
	end process P_NEXT_STATE;
	
	P_OUTPUTS: process(CURRENT_STATE, cwi)
	begin
		case CURRENT_STATE is	
			when Reset =>
			    cwo <= cwi;
			when FetchDecode => 
				cwo <= cwi AND B"111_00000_00000";
			when Execute => 
                cwo <= cwi AND B"000_11111_00000";
			when WriteBack => 
                cwo <= cwi AND B"000_00000_11111";
		end case; 	
	end process P_OUTPUTS;
end Behavioral;
