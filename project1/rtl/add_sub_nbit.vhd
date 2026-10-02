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

begin

    ones_comp0: entity work.ONES_COMP_NBIT
     generic map(
        N => BITS
    )
     port map(
        i_s => i_ADD_SUB,
        i_x => i_B,
        o_f => s_b
    );

    adder0: entity work.ADDER_NBIT
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
