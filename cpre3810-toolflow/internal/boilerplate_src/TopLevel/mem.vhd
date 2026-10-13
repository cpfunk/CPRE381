-- Quartus Prime VHDL Template
-- Single-port RAM with single read/write address

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is

    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10;
        BYTE_WIDTH : natural := 8
    );

    port 
    (
        clk        : in std_logic;
        addr            : in std_logic_vector((ADDR_WIDTH-1) downto 0);
        data            : in std_logic_vector((DATA_WIDTH-1) downto 0);
        be              : in std_logic_vector (3 downto 0);   -- 4 bytes per word
        we        : in std_logic := '1';
        q        : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );

end mem;

architecture rtl of mem is

    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Declare the RAM signal and specify a default value.    Quartus Prime
    -- will load the provided memory initialization file (.mif).
    signal ram : memory_t;
    signal q_local : word_t;

begin

    -- Re-organize the read data from the RAM to match the output
    q <= q_local;

    process(clk)
    begin
    if(rising_edge(clk)) then
        if(we = '1') then
            if(be(0) = '1') then
                ram(to_integer(unsigned(addr)))(7 downto 0) <= data(7 downto 0);
            end if;
            if be(1) = '1' then
                ram(to_integer(unsigned(addr)))(15 downto 8) <= data(15 downto 8);
            end if;
            if be(2) = '1' then
                ram(to_integer(unsigned(addr)))(23 downto 16) <= data(23 downto 16);
            end if;
            if be(3) = '1' then
                ram(to_integer(unsigned(addr)))(31 downto 24) <= data(31 downto 24);
            end if;
        end if;
    end if;
    end process;

    q_local <= ram(to_integer(unsigned(addr)));

end rtl;

