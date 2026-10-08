library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECODER_1TO32 is
    generic(BITS : integer := 32);
    port(
        i_RD:       in STD_LOGIC_VECTOR(4 downto 0);
        i_WRITE_EN: in STD_LOGIC;
        o_D:     out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
end DECODER_1TO32;

architecture rtl of DECODER_1TO32 is

begin

    o_D <= (x"0000_0001" sll to_integer(unsigned(i_RD))) when (i_WRITE_EN = '1') else x"0000_0000";

end architecture;