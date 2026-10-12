library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

entity FLIP_32BIT is
    generic (
        BITS : INTEGER := 32
    );
    port (
        i_FLIP  : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
end entity;

architecture rtl of FLIP_32BIT is
    signal s_FLIPPED_DATA : STD_LOGIC_VECTOR(BITS - 1 downto 0);
begin

    G_REVERSE: for i in 0 to BITS - 1 generate
    begin
        s_FLIPPED_DATA(i) <= i_DATA(BITS-i-1);
    end generate;
        
    with i_FLIP select
        o_DATA <=   s_FLIPPED_DATA when '1',
                    i_DATA when others;

end architecture;