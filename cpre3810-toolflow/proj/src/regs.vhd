library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.all;

entity REGS is
    generic(
        DATA_WIDTH : INTEGER := 32;
        NUM_REGS : INTEGER := 32
    );
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR_ARRAY(DATA_WIDTH-1 downto 0)(DATA_WIDTH-1 downto 0)
    );
end REGS;

architecture rtl of REGS is 
    component reg is
    generic(DATA_WIDTH : integer := 32);
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
    end component;

begin

    -- register x0 is hardwired to zero
    o_DATA(0) <= (others => '0');

    g_reg_file: for i in 0 to NUM_REGS-2 generate

        reg_i: reg
         generic map(
            DATA_WIDTH => DATA_WIDTH
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