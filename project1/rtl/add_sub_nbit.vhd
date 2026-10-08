library IEEE;
use IEEE.std_logic_1164.all;

entity ADD_SUB_NBIT is
    generic(BITS : integer := 32);
    port(
        i_ADD_SUB    : in STD_LOGIC;
        i_A         : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        i_B         : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_F         : out STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_C         : out STD_LOGIC
    );
end ADD_SUB_NBIT;

architecture structural of ADD_SUB_NBIT is

    signal s_b: STD_LOGIC_VECTOR(BITS-1 downto 0); 


    component ADDER_NBIT is
    generic(N : integer := 16);
    port(
        I_C     : in STD_LOGIC;
        I_A     : in STD_LOGIC_VECTOR(N-1 downto 0);
        I_B     : in STD_LOGIC_VECTOR(N-1 downto 0);
        O_F     : out STD_LOGIC_VECTOR(N-1 downto 0);
        O_C     : out STD_LOGIC
    );
    end component;
    component ONES_COMP_NBIT is
    generic(N : integer := 16);
    port(
        i_s : in std_logic;
        i_x : in std_logic_vector(N-1 downto 0);
        o_f : out std_logic_vector(N-1 downto 0)
    );

    end component;

begin

    ones_comp0: ONES_COMP_NBIT
     generic map(
        N => BITS
    )
     port map(
        i_s => i_ADD_SUB,
        i_x => i_B,
        o_f => s_b
    );

    adder0: ADDER_NBIT
     generic map(
        N => BITS
    )
     port map(
        I_C => i_ADD_SUB,
        I_A => i_A,
        I_B => s_b,
        O_F => o_F,
        O_C => o_C
    );
    
end structural;
