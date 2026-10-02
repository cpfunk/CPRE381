library IEEE;
use IEEE.std_logic_1164.all;

entity SIGN_EXTENDER_12B is
    generic (BITS : INTEGER := 32);

    port (
        i_CTRL      : in STD_LOGIC;
        i_DATA_12B  : in STD_LOGIC_VECTOR(11 downto 0);
        o_DATA      : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
end entity;

architecture rtl of SIGN_EXTENDER_12B is

begin

    o_DATA(11 downto 0) <= i_DATA_12B;

    with i_CTRL select
        o_DATA(BITS - 1 downto 12) <= (others => '1') when '1',
                                      (others => '0') when '0',
                                      (others => '0') when others;

end architecture;