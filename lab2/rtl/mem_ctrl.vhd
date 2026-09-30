library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_CTRL is

    generic (
        BITS : INTEGER := 32;
        -- ADDR_WIDTH defines the size of memory.
        -- E.g., if ADDR_WIDTH = 10, then there are 32 * 2^10 bits in the memory
        ADDR_WIDTH : INTEGER := 10
    );

    port(
        i_WRITE : in STD_LOGIC;
        i_ADDR  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_WE    : out STD_LOGIC;
        o_BE    : out STD_LOGIC_VECTOR(3 downto 0);
        o_ADDR  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0)
    );

    end MEM_CTRL;

architecture rtl of MEM_CTRL is begin

    o_WE <= i_WRITE;
    o_BE <= (others => i_WRITE);

    o_ADDR <= "00" & i_ADDR(ADDR_WIDTH-1 downto 2);

end architecture;