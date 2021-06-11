

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity BOOTHMUL is
    Generic (IN_WIDTTH1 : NATURAL := 6;
             IN_WIDTTH2 : NATURAL := 6);
    Port ( OP1 : in STD_LOGIC_VECTOR (IN_WIDTTH1-1 downto 0);
           OP2 : in STD_LOGIC_VECTOR (IN_WIDTTH2-1 downto 0);
           MUL_RESULT : out STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0));
end BOOTHMUL;

architecture Structural_S of BOOTHMUL is
    component RCAdder is
    generic (N: integer:= 6);
	Port (	A:	In	std_logic_vector(N-1 downto 0);
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic);
    end component;
    component BoothEncoder is
        Port ( INPUT : in STD_LOGIC_VECTOR (2 downto 0);
               OUTPUT : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    component MUX5_1 is
        Generic (WIDTTH : NATURAL := 4);
        Port ( IN0 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
               IN1 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
               IN2 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
               IN3 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
               IN4 : in STD_LOGIC_VECTOR (WIDTTH-1 downto 0);
               SEL : in STD_LOGIC_VECTOR (2 downto 0);
               OUTPUT : out STD_LOGIC_VECTOR (WIDTTH-1 downto 0));
    end component;
    component ADD_N is
    GENERIC (N : INTEGER := 4);
    PORT (A,B:in std_logic_vector (N-1 downto 0 );
        Ci:in std_logic;
        Sum:out std_logic_vector (N-1 downto 0);
        Co, Ovf:out std_logic );
    end component;
    ----------------------------------------------------------------------------------------
    type MUX_in_type IS ARRAY( 0 TO 4 ) OF STD_LOGIC_VECTOR (IN_WIDTTH2+1 downto 0);
    signal MUX_in :  MUX_in_type;
    
    type MUX_shifted_out_type IS ARRAY( 1 TO IN_WIDTTH1/2 ) OF STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0);
    signal MUX_shifted_out :  MUX_shifted_out_type;
    
    type MUX_out_type IS ARRAY( 1 TO IN_WIDTTH1/2 ) OF STD_LOGIC_VECTOR (IN_WIDTTH2+1 downto 0);
    signal MUX_out :  MUX_out_type;
    
    type MUX_sel_type IS ARRAY( 1 TO IN_WIDTTH1/2 ) OF STD_LOGIC_VECTOR (2 downto 0);
    signal MUX_sel :  MUX_sel_type;

    TYPE RCA_out_type IS ARRAY( 1 TO (IN_WIDTTH1/2)-1 ) OF STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0);
    signal RCA_out : RCA_out_type;
    signal RCA_carry_outs : STD_LOGIC_VECTOR (((IN_WIDTTH1/2)-2) downto 0);
    signal RCA_ov : STD_LOGIC_VECTOR (((IN_WIDTTH1/2)-2) downto 0);
    
    signal OP1_Refined : STD_LOGIC_VECTOR (IN_WIDTTH1 downto 0);
    signal OP2_Neg : STD_LOGIC_VECTOR (IN_WIDTTH2 downto 0);
    
    signal msb1_add : STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0); 
    --signal tmp : STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0); 
    signal exception_result : STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0); 
    signal exception_result_CO : std_logic;
    signal exception_result_OV : std_logic;
    --signal tmp_ovrflowDet : std_logic;
    --signal ovrflowDet : std_logic;
begin
    
    --OP1_Refined <=  '0' & OP1(IN_WIDTTH1-2 downto 0) & '0';
    OP1_Refined <=  op1 & '0';
    
    ENCODERS: for i in 1 to IN_WIDTTH1/2 generate 
       enc0: BoothEncoder  PORT MAP (INPUT=> OP1_Refined(2*i downto 2*i-2), OUTPUT=> MUX_sel(i));
    end generate ENCODERS;
    
    OP2_Neg <= STD_LOGIC_VECTOR(signed(not(op2(IN_WIDTTH2-1) & op2))+1);
    MUX_in(0) <= (others => '0'); --(0)
    MUX_in(1) <= (op2(IN_WIDTTH2-1) & op2(IN_WIDTTH2-1) & OP2); --(A)
    MUX_in(2) <= (OP2_Neg(IN_WIDTTH2) & OP2_Neg); --(-A)
    MUX_in(3) <= (op2(IN_WIDTTH2-1) & OP2 & '0'); --(2A)
    MUX_in(4) <= (OP2_Neg & '0'); -- (-2A)
    MUXS: for i in 1 to IN_WIDTTH1/2 generate 
        mux0: MUX5_1 GENERIC MAP (IN_WIDTTH2+2)
                     Port Map (IN0 => MUX_in(0), IN1 => MUX_in(1), IN2 => MUX_in(2), IN3 => MUX_in(3),
                                  IN4 => MUX_in(4), SEL => MUX_sel(i), OUTPUT => MUX_out(i));
        MUX_shifted_out(i) <= STD_LOGIC_VECTOR(shift_left(RESIZE((signed(MUX_out(i))),IN_WIDTTH1+IN_WIDTTH2), 2*(i-1)));                      
    end generate MUXS;
    
    ADDERS: FOR i IN 1 TO (IN_WIDTTH1/2)-1 GENERATE
        ADDERS0: IF i =1 GENERATE
            rca0: ADD_N   GENERIC MAP (N => (IN_WIDTTH1+IN_WIDTTH2))
                            PORT MAP (A=> MUX_shifted_out(i), B=> MUX_shifted_out(i+1), Ci=> '0',
                                    sum=>RCA_out(i),Co => RCA_carry_outs(i-1),Ovf => RCA_ov(i-1));
        END GENERATE ADDERS0;
        ADDERS1: IF (i >1 ) GENERATE
            rca0: ADD_N GENERIC MAP (N => (IN_WIDTTH1+IN_WIDTTH2))
                          PORT MAP (A=> RCA_out(i-1), B=> MUX_shifted_out(i+1), Ci=> '0',
                          --Ci=> RCA_carry_outs(i-2),
                                    sum=>RCA_out(i),Co => RCA_carry_outs(i-1),Ovf => RCA_ov(i-1));
        END GENERATE ADDERS1;
--        ADDERS2: IF (i = IN_WIDTTH1/2-1) GENERATE
--            rca0: RCAdder GENERIC MAP (N => (IN_WIDTTH1+IN_WIDTTH2)-1)
--                          PORT MAP (A=> RCA_out(i-1), B=> MUX_shifted_out(i+1), Ci=> RCA_carry_outs(i-1),
--                                    s=>RCA_out(i),Co => RCA_carry_outs(i));
--        END GENERATE ADDERS2;
    END GENERATE ADDERS;
    
    
    msb1_add <= STD_LOGIC_VECTOR(shift_left(RESIZE(unsigned(OP2),(IN_WIDTTH1+IN_WIDTTH2)),IN_WIDTTH1-1));
    --tmp <= STD_LOGIC_VECTOR(RESIZE(signed(RCA_out((IN_WIDTTH1/2)-1)),(IN_WIDTTH1+IN_WIDTTH2)));
    rca1: ADD_N GENERIC MAP (N => IN_WIDTTH1+IN_WIDTTH2)
                   PORT MAP (A=>RCA_out((IN_WIDTTH1/2)-1), 
                             B=> msb1_add, 
                             --Ci=> RCA_carry_outs((IN_WIDTTH1/2)-2),
                             Ci=> '0',
                             sum=>exception_result,
                             Co =>exception_result_CO,
                             Ovf=> exception_result_OV);
    --tmp_ovrflowDet <=  temp_CO xor RCA_carry_outs((IN_WIDTTH1/2)-2);
    
    --OV2:if ((IN_WIDTTH1/2)-2 > 0) generate 
    --    ovrflowDet <= RCA_carry_outs((IN_WIDTTH1/2)-3) xor RCA_carry_outs((IN_WIDTTH1/2)-2);
    --end generate OV2;
    --OV1:if ((IN_WIDTTH1/2)-2 = 0) generate 
    --    ovrflowDet <= (MUX_shifted_out(1)((IN_WIDTTH1+IN_WIDTTH2)-2) and MUX_shifted_out(2)((IN_WIDTTH1+IN_WIDTTH2)-2) and RCA_carry_outs((IN_WIDTTH1/2)-2));
    --end generate OV1;
    
    --uncomment for unsigned inputs
    --MUL_RESULT <= exception_result when OP1(IN_WIDTTH1-1) = '1' else
    --              RCA_out((IN_WIDTTH1/2)-1) ;
    --uncomment forsigned inputs
    MUL_RESULT <= RCA_out((IN_WIDTTH1/2)-1) ;
             
  
    --MUL_RESULT <='0'& RCA_out((IN_WIDTTH1/2)-1);
    --MUL_RESULT <= RCA_carry_outs((IN_WIDTTH1/2)-2)& RCA_out((IN_WIDTTH1/2)-1);


    
end Structural_S;
