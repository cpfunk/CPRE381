library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;

entity XOR_32BIT is
    generic (
        BITS : INTEGER := 32
    );
    port (

        i_A  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        i_B  : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        o_F  : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
end entity;

architecture rtl of XOR_32BIT is


    component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

    end component;

begin

    G_XOR_32BIT: for i in 0 to 31 generate begin

        xorg2_inst: xorg2
         port map(
            i_A => i_A(i),
            i_B => i_B(i),
            o_F => o_F(i)
        );

    end generate G_XOR_32BIT;

end architecture;
