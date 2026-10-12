library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;

entity SHIFT_LEFT_FIXED is
    generic (
        BITS : INTEGER := 32;
        SHIFT   : INTEGER := 1
    );
    port (
        i_SHIFT : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
end entity;

architecture rtl of SHIFT_LEFT_FIXED is
    signal s_PADDING_BITS : STD_LOGIC_VECTOR(SHIFT - 1 downto 0);
    signal s_SHIFTED_DATA : STD_LOGIC_VECTOR(BITS - 1 downto 0);

    component BUS_MUX_NTO1 is
    generic(
        BITS: INTEGER   := 32;
        LOG2_N: INTEGER := 5;
        N: INTEGER      := 32
    );
    port(
        i_S: in STD_LOGIC_VECTOR(LOG2_N-1 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(BITS - 1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
    end component;

begin

        s_PADDING_BITS <= (others => '0');

        -- shifted signal
        s_SHIFTED_DATA <= i_DATA(BITS - SHIFT - 1 downto 0) & s_PADDING_BITS;

        -- create a N-bit 2-to-1 bus mux
        BUS_MUX_2TO1: BUS_MUX_NTO1
         generic map(
            BITS => BITS,
            N => 2
        )
         port map(
            i_S => (0 => i_SHIFT),
            i_DATA => (0 => i_DATA, 1 => s_SHIFTED_DATA),
            o_DATA => o_DATA
        );

end architecture;
