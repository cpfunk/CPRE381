library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

use work.std_logic_vector_array.all;

entity SHIFT_LEFT_32BIT is
    generic (
        BITS        : INTEGER := 32;
        LOG2_BITS   : INTEGER := 5
    );
    port (
        i_SHIFT : in STD_LOGIC_VECTOR(LOG2_BITS - 1 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
end entity;

architecture rtl of SHIFT_LEFT_32BIT is
    signal s_DATA : STD_LOGIC_VECTOR_ARRAY(c_SELECT_BITS - 2 downto 0)(BITS - 1 downto 0);

    component SHIFT_LEFT_FIXED is
    generic (
        BITS : INTEGER := 32;
        SHIFT   : INTEGER := 1
    );
    port (
        i_SHIFT : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
    end component;

begin

    -- check edge case to ensure BITS > 2 (will not work for BITS =< 2)

    assert BITS > 2
        report "BITS must be greater than 2"
        severity failure;

    G_BARREL_SHIFT_32BIT: for i in 0 to LOG2_BITS - 1 generate
    begin

        G_COND: if (i = 0) generate

            SHIFT_LEFT_FIXED_inst: SHIFT_LEFT_FIXED
             generic map(
                BITS => BITS,
                SHIFT => 2**i
            )
             port map(
                i_SHIFT => i_SHIFT(i),
                i_DATA => i_DATA,
                o_DATA => s_DATA(i)
            );
            
        elsif (i = LOG2_BITS - 1) generate

            SHIFT_LEFT_FIXED_inst: SHIFT_LEFT_FIXED
             generic map(
                BITS => BITS,
                SHIFT => 2**i
            )
             port map(
                i_SHIFT => i_SHIFT(i),
                i_DATA => s_DATA(i - 1),
                o_DATA => o_DATA
            );

        else generate

            SHIFT_LEFT_FIXED_inst: SHIFT_LEFT_FIXED
             generic map(
                BITS => BITS,
                SHIFT => 2**i
            )
             port map(
                i_SHIFT => i_SHIFT(i),
                i_DATA => s_DATA(i - 1),
                o_DATA => s_DATA(i)
            );

        end generate G_COND;

    end generate G_BARREL_SHIFT_32BIT;

end architecture;
