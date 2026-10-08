library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library  std;
use std.env.all;

use work.std_logic_vector_array.all;

entity DECODER_1TO32_tb is

    generic(
        eighth_clk  : time := 1.25 ns;
        quarter_clk : time := eighth_clk * 2;
        half_clk    : time :=  quarter_clk * 2;
        full_clk    : time :=  half_clk * 2;
        BITS        : integer := 32
    );

end DECODER_1TO32_tb;

architecture rtl of DECODER_1TO32_tb is

    signal i_WRITE_EN   : STD_LOGIC;
    signal i_RD         : STD_LOGIC_VECTOR(4 downto 0);
    signal o_D       : STD_LOGIC_VECTOR(BITS-1 downto 0);


    component DECODER_1TO32 is
    generic(
        BITS : integer := 32
    );
    port(
        i_RD       : in STD_LOGIC_VECTOR(4 downto 0);
        i_WRITE_EN : in STD_LOGIC;
        o_D        : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
    end component;

begin

    DUT0: DECODER_1TO32
     generic map(
        BITS => BITS
    )
     port map(
        i_RD => i_RD,
        i_WRITE_EN => i_WRITE_EN,
        o_D => o_D
    );

    process
    begin

    wait for full_clk;

    i_WRITE_EN <= '1';

    wait for eighth_clk;

    for i in 0 to 31 loop
      i_RD <= std_logic_vector(TO_UNSIGNED(i, 5));
      wait for full_clk;
    end loop;

    wait for eighth_clk;

    i_WRITE_EN <= '0';

    wait for eighth_clk;

    for i in 0 to 31 loop
      i_RD <= std_logic_vector(TO_UNSIGNED(i, 5));
      wait for full_clk;
    end loop;

    wait for eighth_clk;

    stop;

    end process;

end architecture;