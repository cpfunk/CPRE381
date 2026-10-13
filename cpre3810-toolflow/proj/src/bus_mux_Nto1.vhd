library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.RISCV_types.all;

entity BUS_MUX_NTO1 is
    generic(
        DATA_WIDTH: INTEGER   := 32;
        LOG2_N: INTEGER := 5;
        N: INTEGER      := 32
    );
    port(
        i_S: in STD_LOGIC_VECTOR(LOG2_N-1 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(DATA_WIDTH - 1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end BUS_MUX_NTO1;

architecture structure of BUS_MUX_NTO1 is

begin

    o_DATA <= i_DATA(TO_INTEGER(UNSIGNED(i_S)));

end structure;
