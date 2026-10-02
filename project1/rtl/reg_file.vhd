library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;


entity reg_file is
    generic(
        BITS : INTEGER := 32
    );
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_W_ADDR    : in STD_LOGIC_VECTOR(4 downto 0);
        i_R_ADDR   : in STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_DATA : out STD_LOGIC_VECTOR_ARRAY(1 downto 0)(BITS-1 downto 0)
    );
end entity;

architecture rtl of reg_file is
    
    signal NUM_REGS : INTEGER := 32;
    
    signal s_WE : STD_LOGIC_VECTOR(NUM_REGS - 1 downto 0);
    signal s_DATA : STD_LOGIC_VECTOR_ARRAY(BITS-1 downto 0)(BITS-1 downto 0);
    
begin

    DECODER0: entity work.DECODER_1TO32
     generic map(
        BITS => BITS
    )
     port map(
        i_RD => i_W_ADDR,
        i_WRITE_EN => i_WE,
        o_D => s_WE
    );

    REGS0: entity work.REGS
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

    BUS_MUX0: entity work.BUS_MUX_32TO1
     generic map(
        BITS => BITS
    )
     port map(
        i_S => i_R_ADDR(0),
        i_DATA => s_DATA,
        o_DATA => o_DATA(0)
    );

    BUS_MUX1: entity work.BUS_MUX_32TO1
     generic map(
        BITS => BITS
    )
     port map(
        i_S => i_R_ADDR(1),
        i_DATA => s_DATA,
        o_DATA => o_DATA(1)
    );

end architecture;