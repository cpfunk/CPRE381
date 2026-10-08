library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;              
use std.textio.all;           

entity tb_ones_comp is
    generic(
        clk_phase   : time := 10 ns;
        N           : integer := 32
    );
end tb_ones_comp;

architecture mixed of tb_ones_comp is

    constant clk_period  : time := clk_phase * 2;

    signal clk : std_logic := '0';
    signal i_s : std_logic := '0';
    signal i_x, o_f     : std_logic_vector(N-1 downto 0);

    component ONES_COMP_NBIT is
    generic(N : integer := 16);
    port(
        i_s : in std_logic;
        i_x : in std_logic_vector(N-1 downto 0);
        o_f : out std_logic_vector(N-1 downto 0)
    );

    end component;

begin

    clk0: process
    begin
        clk <= '1';
        wait for clk_phase;
        clk <= '0'; 
        wait for clk_phase;
    end process;

    dut0: ONES_COMP_NBIT
        generic map(N => N)
        port map(
            i_s => i_s,
            i_x => i_x,
            o_f => o_f
        );
        
    P_TEST_CASES: process
    begin
        wait for clk_phase/2;

        while true loop
            i_x <= x"0101_0101";
            wait for clk_phase*2;
            i_x <= x"FFFF_FFFF";
            wait for clk_phase*2;
            i_x <= x"5050_5050";
            wait for clk_phase*2;
            i_s <= not i_s;
        end loop;

    end process;

end mixed;
