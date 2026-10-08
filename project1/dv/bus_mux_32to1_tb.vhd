library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.std_logic_vector_array.all;

library  std;
use std.env.all;

entity BUS_MUX_32TO1_tb is
    generic(
        eighth_clk  : time := 1.25 ns;
        quarter_clk : time := eighth_clk * 2;
        half_clk : time :=  quarter_clk * 2;
        full_clk : time :=  half_clk * 2;
        BITS : integer := 32
    );
end BUS_MUX_32TO1_tb;

architecture structure of BUS_MUX_32TO1_tb is

    signal i_S : STD_LOGIC_VECTOR(4 downto 0);
    signal i_DATA : STD_LOGIC_VECTOR_ARRAY(BITS-1 downto 0)(BITS-1 downto 0);
    signal o_DATA : STD_LOGIC_VECTOR(BITS-1 downto 0);


    component BUS_MUX_32TO1 is
    generic(
        BITS : integer := 32
    );
    port(
        i_S    : in STD_LOGIC_VECTOR(4 downto 0);
        i_DATA : in STD_LOGIC_VECTOR_ARRAY(BITS-1 downto 0)(BITS-1 downto 0);
        o_DATA : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
    end component;

begin

    BUS_MUX_32TO1_inst: BUS_MUX_32TO1
     generic map(
        BITS => BITS
    )
     port map(
        i_S => i_S,
        i_DATA => i_DATA,
        o_DATA => o_DATA
    );

    i_DATA <= (
        0 => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
        1 => STD_LOGIC_VECTOR(TO_UNSIGNED(1, 32)),
        2 => STD_LOGIC_VECTOR(TO_UNSIGNED(2, 32)),
        3 => STD_LOGIC_VECTOR(TO_UNSIGNED(3, 32)),
        4 => STD_LOGIC_VECTOR(TO_UNSIGNED(4, 32)),
        5 => STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32)),
        6 => STD_LOGIC_VECTOR(TO_UNSIGNED(6, 32)),
        7 => STD_LOGIC_VECTOR(TO_UNSIGNED(7, 32)),
        8 => STD_LOGIC_VECTOR(TO_UNSIGNED(8, 32)),
        9 => STD_LOGIC_VECTOR(TO_UNSIGNED(9, 32)),
        10 => STD_LOGIC_VECTOR(TO_UNSIGNED(10, 32)),
        11 => STD_LOGIC_VECTOR(TO_UNSIGNED(11, 32)),
        12 => STD_LOGIC_VECTOR(TO_UNSIGNED(12, 32)),
        13 => STD_LOGIC_VECTOR(TO_UNSIGNED(13, 32)),
        14 => STD_LOGIC_VECTOR(TO_UNSIGNED(14, 32)),
        15 => STD_LOGIC_VECTOR(TO_UNSIGNED(15, 32)),
        16 => STD_LOGIC_VECTOR(TO_UNSIGNED(16, 32)),
        17 => STD_LOGIC_VECTOR(TO_UNSIGNED(17, 32)),
        18 => STD_LOGIC_VECTOR(TO_UNSIGNED(18, 32)),
        19 => STD_LOGIC_VECTOR(TO_UNSIGNED(19, 32)),
        20 => STD_LOGIC_VECTOR(TO_UNSIGNED(20, 32)),
        21 => STD_LOGIC_VECTOR(TO_UNSIGNED(21, 32)),
        22 => STD_LOGIC_VECTOR(TO_UNSIGNED(22, 32)),
        23 => STD_LOGIC_VECTOR(TO_UNSIGNED(23, 32)),
        24 => STD_LOGIC_VECTOR(TO_UNSIGNED(24, 32)),
        25 => STD_LOGIC_VECTOR(TO_UNSIGNED(25, 32)),
        26 => STD_LOGIC_VECTOR(TO_UNSIGNED(26, 32)),
        27 => STD_LOGIC_VECTOR(TO_UNSIGNED(27, 32)),
        28 => STD_LOGIC_VECTOR(TO_UNSIGNED(28, 32)),
        29 => STD_LOGIC_VECTOR(TO_UNSIGNED(29, 32)),
        30 => STD_LOGIC_VECTOR(TO_UNSIGNED(30, 32)),
        31 => STD_LOGIC_VECTOR(TO_UNSIGNED(31, 32))
    );

    process
        begin

        wait for full_clk;

        for i in 0 to 31 loop
        i_S <= std_logic_vector(TO_UNSIGNED(i, 5));
        wait for full_clk;
        end loop;

        wait for full_clk;

        stop;

    end process;

end structure;
