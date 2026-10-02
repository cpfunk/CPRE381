library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
    generic(BITS : integer := 32);
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
end reg;

architecture rtl of reg is begin

    g_reg: for i in 0 to BITS-1 generate

        dff_i: entity work.dffg
         port map(
            i_CLK => i_CLK,
            i_RST => i_RST,
            i_WE => i_WE,
            i_D => i_DATA(i),
            o_Q => o_DATA(i)
        );

    end generate g_reg;

end rtl;