library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.std_logic_vector_array.all;

entity BUS_MUX_NTO1 is
    generic(
        BITS: INTEGER   := 32;
        LOG2_BITS: INTEGER := 5;
        N: INTEGER      := 32
    );
    port(
        i_S: in STD_LOGIC_VECTOR(LOG2_BITS-1 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(BITS - 1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
end BUS_MUX_NTO1;

architecture structure of BUS_MUX_NTO1 is

begin

    o_DATA <= i_DATA(TO_INTEGER(UNSIGNED(i_S)));

end structure;
