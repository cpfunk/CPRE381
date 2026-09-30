library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.std_logic_vector_array.all;

entity BUS_MUX_2TO1 is
    generic(BITS: integer := 32);
    port(
        i_S     : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR_ARRAY(1 downto 0 )(BITS-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
end BUS_MUX_2TO1;

architecture structure of BUS_MUX_2TO1 is begin

    with i_S select
        o_DATA <= i_DATA(0)  when '0',
                  i_DATA(1)  when '1',
                  (others => '0') when others;

end structure;
