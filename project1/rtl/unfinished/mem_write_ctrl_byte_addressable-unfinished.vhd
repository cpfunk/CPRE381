library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_CTRL_OLD is

    generic (
        BITS : INTEGER := 32;
        -- BYTE_ADDR_WIDTH defines the maximum size of the byte address when the memory is byte addressable.
        -- E.g., if there are 32 * 2^10 bits in the memory, then there are 2^12 addressable bytes in memory
        BYTE_ADDR_WIDTH : INTEGER := 12;

        -- MEM_ADDR_WIDTH defines the size of memory.
        -- E.g., if ADDR_WIDTH = 10, then there are 32 * 2^10 bits in the memory
        MEM_ADDR_WIDTH : INTEGER := 10
    );

    port(
        i_WRD   : in STD_LOGIC;
        i_HWRD  : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_ADDR  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_WE    : out STD_LOGIC;
        o_BE    : out STD_LOGIC_VECTOR(3 downto 0);
        o_ADDR  : out STD_LOGIC_VECTOR(MEM_ADDR_WIDTH - 1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );

    end MEM_CTRL_OLD;

architecture rtl of MEM_CTRL_OLD is

    signal s_ADDR       : STD_LOGIC_VECTOR(BYTE_ADDR_WIDTH-1 downto 0);
    signal s_ADDR_LS_2B : STD_LOGIC_VECTOR(1 downto 0);

begin

    s_ADDR          <= i_ADDR(BYTE_ADDR_WIDTH-1 downto 0);
    s_ADDR_LS_2B    <= i_ADDR(1 downto 0);

    -- decode the lower four bits of the address and assign them to o_BE.
    -- NOTE: this means that the addresses must be word or half-word alligned!!

    -- Starting at 2 is equivalent to a shift right by 2.
    -- This is equivalent to dividing by 4 (there are four bytes in a word).
    o_ADDR <= "00" & i_ADDR(BYTE_ADDR_WIDTH-1 downto 2);

    o_BE <= -- if word-addressed:
            "1111" when (s_ADDR_LS_2B = "00" and i_WRD = '1') else

            -- if half-addressed:
            "0011" when (s_ADDR_LS_2B = "10" and i_HWRD = '1') else
            "1100" when (s_ADDR_LS_2B = "00" and i_HWRD = '1') else
            
            -- if byte-addressed:
            "0001" when (s_ADDR_LS_2B = "00" and i_WE = '1') else
            "0010" when (s_ADDR_LS_2B = "01" and i_WE = '1') else
            "0100" when (s_ADDR_LS_2B = "10" and i_WE = '1') else
            "1000" when (s_ADDR_LS_2B = "11" and i_WE = '1');

    o_DATA <= -- if word-addressed:
            "1111" when (s_ADDR_LS_2B = "00" and i_WRD = '1') else

            -- if half-addressed:
            "0011" when (s_ADDR_LS_2B = "10" and i_HWRD = '1') else
            "1100" when (s_ADDR_LS_2B = "00" and i_HWRD = '1') else
            
            -- if byte-addressed:
            "0001" when (s_ADDR_LS_2B = "00" and i_WE = '1') else
            "0010" when (s_ADDR_LS_2B = "01" and i_WE = '1') else
            "0100" when (s_ADDR_LS_2B = "10" and i_WE = '1') else
            "1000" when (s_ADDR_LS_2B = "11" and i_WE = '1');

end architecture;