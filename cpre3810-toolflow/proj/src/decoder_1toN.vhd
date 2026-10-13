library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity DECODER_1TON is
    generic(
        N       : INTEGER := 32;
        LOG2_N  : INTEGER := 5
    );
    port(
        i_SEL   : in STD_LOGIC_VECTOR(LOG2_N - 1 downto 0);
        i_EN    : in STD_LOGIC;
        o_D     : out STD_LOGIC_VECTOR(N - 1 downto 0)
    );
end DECODER_1TON;

architecture rtl of DECODER_1TON is
begin

    G_DEC: for i in 0 to N - 1 generate
        o_D(i) <= '1' when (i_EN = '1' and i = TO_INTEGER(UNSIGNED(i_SEL))) else '0';
    end generate G_DEC;

end architecture;