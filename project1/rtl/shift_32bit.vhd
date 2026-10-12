library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

use work.std_logic_vector_array.all;

entity SHIFT_32BIT is
    generic (
        BITS       : INTEGER := 32;
        LOG2_BITS  : INTEGER := 5
    );
    port (
        i_SIGNED    : in STD_LOGIC;
        i_LEFT      : in STD_LOGIC;
        i_DATA      : in STD_LOGIC_VECTOR(31 downto 0);
        i_SHIFT     : in STD_LOGIC_VECTOR(LOG2_BITS-1 downto 0);
        o_DATA      : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;

architecture rtl of SHIFT_32BIT is
    
    component FLIP_32BIT is
        generic (
            BITS : INTEGER := 32
            );
            port (
                i_FLIP  : in STD_LOGIC;
                i_DATA  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
                o_DATA  : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
                );
            end component;
            component SHIFT_RIGHT_FIXED is
                generic (
        BITS    : INTEGER := 32;
        SHIFT   : INTEGER := 1
        );
        port (
            i_SIGNED    : in STD_LOGIC;
            i_SHIFT     : in STD_LOGIC;
            i_DATA      : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
            o_DATA      : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
            );
        end component;

        signal s_DATA   : STD_LOGIC_VECTOR_ARRAY(LOG2_BITS downto 0)(BITS - 1 downto 0);
        
    begin

    FLIP_32BIT_IN: FLIP_32BIT
     generic map(
        BITS => BITS
    )
     port map(
        i_FLIP => i_LEFT,
        i_DATA => i_DATA,
        o_DATA => s_DATA(0)
    );

    G_LOG_SHIFT_32BIT: for i in 0 to LOG2_BITS - 1 generate
    begin

        SHIFT_LEFT_FIXED_inst: SHIFT_RIGHT_FIXED
            generic map(
            BITS => BITS,
            SHIFT => 2**i
        )
            port map(
            i_SIGNED => i_SIGNED,
            i_SHIFT => i_SHIFT(i),
            i_DATA => s_DATA(i),
            o_DATA => s_DATA(i + 1)
        );

    end generate G_LOG_SHIFT_32BIT;    

    FLIP_32BIT_OUT: FLIP_32BIT
     generic map(
        BITS => BITS
    )
     port map(
        i_FLIP => i_LEFT,
        i_DATA => s_DATA(LOG2_BITS),
        o_DATA => o_DATA
    );

end architecture;
