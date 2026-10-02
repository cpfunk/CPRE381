library IEEE;
use IEEE.std_logic_1164.all;

entity ADDER_NBIT is
    generic(N : integer := 16);
    port(
        I_C     : in STD_LOGIC;
        I_A     : in STD_LOGIC_VECTOR(N-1 downto 0);
        I_B     : in STD_LOGIC_VECTOR(N-1 downto 0);
        O_F     : out STD_LOGIC_VECTOR(N-1 downto 0);
        O_C     : out STD_LOGIC
    );
end ADDER_NBIT;

architecture structural of ADDER_NBIT is

    signal s_c: STD_LOGIC_VECTOR(N downto 0); 

begin

    s_c(0) <= I_C;
    
    g_nbit_adder: for i in 0 to N-1 generate
        
        adder_i: entity work.adder_1bit
        port map(
            I_C => s_c(i),
            I_A => I_A(i),
            I_B => I_B(i),
            O_F => O_F(i),
            O_C => s_c(i + 1)
            );
            
    end generate g_nbit_adder;
            
    O_C <= s_c(N);
            
end structural;
