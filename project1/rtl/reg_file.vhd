library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;
use work.CLOG2.all;

entity reg_file is
    generic(
        BITS        : INTEGER := 32;
        NUM_REGS    : INTEGER := 32
    );
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_RD    : in STD_LOGIC_VECTOR(4 downto 0);
        i_RS    : in STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR_ARRAY(1 downto 0)(BITS-1 downto 0)
    );
end entity;

architecture rtl of reg_file is

    signal s_WE : STD_LOGIC_VECTOR(NUM_REGS - 1 downto 0);
    signal s_DATA : STD_LOGIC_VECTOR_ARRAY(NUM_REGS-1 downto 0)(BITS-1 downto 0);
    

    component BUS_MUX_NTO1 is
    generic(
        BITS: INTEGER   := 32;
        N: INTEGER      := 32
    );
    port(
        i_S: in STD_LOGIC_VECTOR(CLOG2(N)-1 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(BITS - 1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
    end component;
    component DECODER_1TON is
    generic(N : INTEGER := 32);
    port(
        i_SEL   : in STD_LOGIC_VECTOR(CLOG2(N) - 1 downto 0);
        i_EN    : in STD_LOGIC;
        o_D     : out STD_LOGIC_VECTOR(N - 1 downto 0)
    );
    end component;
    component REGS is
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
    end component;

begin

    DECODER0: DECODER_1TON
     generic map(
        N => NUM_REGS
    )
     port map(
        i_SEL => i_RD,
        i_EN => i_WE,
        o_D => s_WE
    );

    REGS0: REGS
     generic map(
        BITS => BITS,
        NUM_REGS => NUM_REGS
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => s_WE,
        i_DATA => i_DATA,
        o_DATA => s_DATA
    );

    BUS_MUX0: BUS_MUX_NTO1
     generic map(
        N => BITS
    )
     port map(
        i_S => i_RS(0),
        i_DATA => s_DATA,
        o_DATA => o_DATA(0)
    );

    BUS_MUX1: BUS_MUX_NTO1
     generic map(
        BITS => BITS,
        N => NUM_REGS
    )
     port map(
        i_S => i_RS(1),
        i_DATA => s_DATA,
        o_DATA => o_DATA(1)
    );

end architecture;