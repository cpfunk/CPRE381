library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity AND_32BIT is
    generic (
        DATA_WIDTH : INTEGER := 32
    );
    port (

        i_A  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        i_B  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        o_F  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end entity;

architecture rtl of AND_32BIT is

    component andg2 is
        port(i_A          : in std_logic;
            i_B          : in std_logic;
            o_F          : out std_logic);
    end component;

begin

    G_AND_32BIT: for i in 0 to 31 generate begin

        and2_inst: andg2
         port map(
            i_A => i_A(i),
            i_B => i_B(i),
            o_F => o_F(i)
        );

    end generate G_AND_32BIT;

end architecture;