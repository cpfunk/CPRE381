library IEEE;
use IEEE.std_logic_1164.all;

entity ADDER_32BIT is
    generic (
        DATA_WIDTH: INTEGER := 32
    );
    port(
        i_C     : in STD_LOGIC;
        i_A     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        i_B     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_F     : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_C     : out STD_LOGIC;
        o_OF    : out STD_LOGIC
    );
end ADDER_32BIT;

architecture structural of ADDER_32BIT is

    signal s_c: STD_LOGIC_VECTOR(DATA_WIDTH downto 0); 


    component adder_1bit is
    port(
        i_c     : in STD_LOGIC;
        i_a     : in STD_LOGIC;
        i_b     : in STD_LOGIC;
        o_f     : out STD_LOGIC;
        o_c     : out STD_LOGIC
    );
    end component;

begin

    s_c(0) <= I_C;
    
    g_32BIT_adder: for i in 0 to DATA_WIDTH-1 generate
        
        adder_i: adder_1bit
        port map(
            I_C => s_c(i),
            I_A => I_A(i),
            I_B => I_B(i),
            O_F => O_F(i),
            O_C => s_c(i + 1)
        );
            
    end generate g_32BIT_adder;
    
    -- assign carry out signal 
    o_C <= s_c(DATA_WIDTH);

    -- assign overflow signal
    o_OF <= s_c(DATA_WIDTH) xor s_c(DATA_WIDTH - 1);
            
end structural;
