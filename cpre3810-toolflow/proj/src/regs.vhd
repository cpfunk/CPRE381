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

    signal s_SP_IN  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal s_SP_OUT : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal s_GP_IN  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal s_GP_OUT : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

begin

    -- register x0 is hardwired to zero
    o_DATA(0) <= (others => '0');

    -- register x1 (ra)
    reg_1: reg
     generic map(DATA_WIDTH => DATA_WIDTH)
     port map(
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        i_WE   => i_WE(1),
        i_DATA => i_DATA,
        o_DATA => o_DATA(1)
    );

    -- register x2 (sp) resets to 0x7FFFEFFC to match RARS
    s_SP_IN   <= i_DATA xor x"7FFFEFFC";
    o_DATA(2) <= s_SP_OUT xor x"7FFFEFFC";

    reg_2_sp: reg
     generic map(DATA_WIDTH => DATA_WIDTH)
     port map(
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        i_WE   => i_WE(2),
        i_DATA => s_SP_IN,
        o_DATA => s_SP_OUT
    );

    -- register x3 (gp) resets to 0x10008000 to match RARS
    s_GP_IN   <= i_DATA xor x"10008000";
    o_DATA(3) <= s_GP_OUT xor x"10008000";

    reg_3_gp: reg
     generic map(DATA_WIDTH => DATA_WIDTH)
     port map(
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        i_WE   => i_WE(3),
        i_DATA => s_GP_IN,
        o_DATA => s_GP_OUT
    );

    -- registers x4 to x31
    g_reg_file: for i in 4 to NUM_REGS-1 generate
        reg_i: reg
         generic map(
            DATA_WIDTH => DATA_WIDTH
        )
         port map(
            i_CLK  => i_CLK,
            i_RST  => i_RST,
            i_WE   => i_WE(i),
            i_DATA => i_DATA,
            o_DATA => o_DATA(i)
        );
    end generate g_reg_file;

end architecture;