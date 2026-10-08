library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.std_logic_vector_array.all;

entity BUS_MUX_32TO1 is
    generic(BITS: integer := 32);
    port(
        i_S: in STD_LOGIC_VECTOR(4 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(31 downto 0 )(BITS-1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
end BUS_MUX_32TO1;

architecture structure of BUS_MUX_32TO1 is begin

    with i_S select
        o_DATA <= i_DATA(0)  when STD_LOGIC_VECTOR(TO_UNSIGNED(0, 5)),
                  i_DATA(1)  when STD_LOGIC_VECTOR(TO_UNSIGNED(1, 5)),
                  i_DATA(2)  when STD_LOGIC_VECTOR(TO_UNSIGNED(2, 5)),
                  i_DATA(3)  when STD_LOGIC_VECTOR(TO_UNSIGNED(3, 5)),
                  i_DATA(4)  when STD_LOGIC_VECTOR(TO_UNSIGNED(4, 5)),
                  i_DATA(5)  when STD_LOGIC_VECTOR(TO_UNSIGNED(5, 5)),
                  i_DATA(6)  when STD_LOGIC_VECTOR(TO_UNSIGNED(6, 5)),
                  i_DATA(7)  when STD_LOGIC_VECTOR(TO_UNSIGNED(7, 5)),
                  i_DATA(8)  when STD_LOGIC_VECTOR(TO_UNSIGNED(8, 5)),
                  i_DATA(9)  when STD_LOGIC_VECTOR(TO_UNSIGNED(9, 5)),
                  i_DATA(10) when STD_LOGIC_VECTOR(TO_UNSIGNED(10, 5)),
                  i_DATA(11) when STD_LOGIC_VECTOR(TO_UNSIGNED(11, 5)),
                  i_DATA(12) when STD_LOGIC_VECTOR(TO_UNSIGNED(12, 5)),
                  i_DATA(13) when STD_LOGIC_VECTOR(TO_UNSIGNED(13, 5)),
                  i_DATA(14) when STD_LOGIC_VECTOR(TO_UNSIGNED(14, 5)),
                  i_DATA(15) when STD_LOGIC_VECTOR(TO_UNSIGNED(15, 5)),
                  i_DATA(16) when STD_LOGIC_VECTOR(TO_UNSIGNED(16, 5)),
                  i_DATA(17) when STD_LOGIC_VECTOR(TO_UNSIGNED(17, 5)),
                  i_DATA(18) when STD_LOGIC_VECTOR(TO_UNSIGNED(18, 5)),
                  i_DATA(19) when STD_LOGIC_VECTOR(TO_UNSIGNED(19, 5)),
                  i_DATA(20) when STD_LOGIC_VECTOR(TO_UNSIGNED(20, 5)),
                  i_DATA(21) when STD_LOGIC_VECTOR(TO_UNSIGNED(21, 5)),
                  i_DATA(22) when STD_LOGIC_VECTOR(TO_UNSIGNED(22, 5)),
                  i_DATA(23) when STD_LOGIC_VECTOR(TO_UNSIGNED(23, 5)),
                  i_DATA(24) when STD_LOGIC_VECTOR(TO_UNSIGNED(24, 5)),
                  i_DATA(25) when STD_LOGIC_VECTOR(TO_UNSIGNED(25, 5)),
                  i_DATA(26) when STD_LOGIC_VECTOR(TO_UNSIGNED(26, 5)),
                  i_DATA(27) when STD_LOGIC_VECTOR(TO_UNSIGNED(27, 5)),
                  i_DATA(28) when STD_LOGIC_VECTOR(TO_UNSIGNED(28, 5)),
                  i_DATA(29) when STD_LOGIC_VECTOR(TO_UNSIGNED(29, 5)),
                  i_DATA(30) when STD_LOGIC_VECTOR(TO_UNSIGNED(30, 5)),
                  i_DATA(31) when STD_LOGIC_VECTOR(TO_UNSIGNED(31, 5)),
                  (others => '0') when others;

end structure;
