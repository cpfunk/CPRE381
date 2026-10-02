library IEEE;
use IEEE.std_logic_1164.all;
use work.std_logic_vector_array.all;

entity REGS is
    generic(
        BITS : INTEGER := 32;
        NUM_REGS : INTEGER := 32
    );
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR_ARRAY(BITS-1 downto 0)(BITS-1 downto 0)
    );
end REGS;

architecture rtl of REGS is begin

    -- register x0 is hardwired to zero
    o_DATA(0) <= (others => '0');

    g_reg_file: for i in 0 to NUM_REGS-2 generate

        reg_i: entity work.reg
         generic map(
            BITS => BITS
        )
         port map(
            i_CLK => i_CLK,
            i_RST => i_RST,
            i_WE => i_WE(i+1),
            i_DATA => i_DATA,
            o_DATA => o_DATA(i+1)
        );

    end generate g_reg_file;

end architecture;