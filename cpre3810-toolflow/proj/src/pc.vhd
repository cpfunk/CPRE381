library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- NOTE: this assumes that the memory has only a 12-bit address,
      -- and the upper bits are:  x"00400XXX"

entity PC is
    generic(
        DATA_WIDTH : INTEGER := 32
    );
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_HALT  : in STD_LOGIC;
        i_NEXT  : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_PC    : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of PC is

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

    signal s_PC : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

begin

    reg_inst: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => not i_HALT,
        i_DATA => i_NEXT,
        o_DATA => s_PC
    );

    o_PC <= x"00400" & s_PC(11 downto 0);

end architecture;