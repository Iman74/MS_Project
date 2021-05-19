

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

architecture Structural of BOOTHMUL is
--Booth Encoder
    component BoothEncoder is
        Port ( INPUT : in STD_LOGIC_VECTOR (2 downto 0);
               OUTPUT : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
--MUX5 to 1 Generic
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
--RCA adder
    component ADD_N is
    GENERIC (N : INTEGER := 4);
    PORT (A,B:in std_logic_vector (N-1 downto 0 );
        Ci:in std_logic;
        Sum:out std_logic_vector (N-1 downto 0);
        Co, Ovf:out std_logic );
    end component;
    --------------------------------------signals--------------------------------------------------
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
    --exception handling signals
    signal msb1_add : STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0); 
    signal exception_result : STD_LOGIC_VECTOR ((IN_WIDTTH1+IN_WIDTTH2)-1 downto 0); 
    signal exception_result_CO : std_logic;
    signal exception_result_OV : std_logic;

begin
    --make MSB of Oprand1 zero(if it's 1) and take care of it later and also add zero to first part for encoder
    OP1_Refined <=  '0' & OP1(IN_WIDTTH1-2 downto 0) & '0';
    ENCODERS: for i in 1 to IN_WIDTTH1/2 generate 
       enc0: BoothEncoder  PORT MAP (INPUT=> OP1_Refined(2*i downto 2*i-2), OUTPUT=> MUX_sel(i));
    end generate ENCODERS;

    --make all muxes input
    OP2_Neg <= STD_LOGIC_VECTOR(signed(not('0' & op2))+1);
    MUX_in(0) <= (others => '0'); --(0)
    MUX_in(1) <= ("00" & OP2); --(A)
    MUX_in(2) <= (OP2_Neg(IN_WIDTTH2) & OP2_Neg); --(-A)
    MUX_in(3) <= ('0' & OP2 & '0'); --(2A)
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
                                    sum=>RCA_out(i),Co => RCA_carry_outs(i-1),Ovf => RCA_ov(i-1));
        END GENERATE ADDERS1;
    END GENERATE ADDERS;
    
    --exception handling
    msb1_add <= STD_LOGIC_VECTOR(shift_left(RESIZE(unsigned(OP2),(IN_WIDTTH1+IN_WIDTTH2)),IN_WIDTTH1-1));
    rca1: ADD_N GENERIC MAP (N => IN_WIDTTH1+IN_WIDTTH2)
                   PORT MAP (A=>RCA_out((IN_WIDTTH1/2)-1), 
                             B=> msb1_add, 
                             Ci=> '0',
                             sum=>exception_result,
                             Co =>exception_result_CO,
                             Ovf=> exception_result_OV);
    --assign output
    MUL_RESULT <= exception_result when OP1(IN_WIDTTH1-1) = '1' else
                  RCA_out((IN_WIDTTH1/2)-1) ;

end Structural;
