library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity tb_structural_mux2t1 is
  generic(clk_phase   : time := 10 ns);
end tb_structural_mux2t1;

architecture mixed of tb_structural_mux2t1 is

    constant clk_period  : time := clk_phase * 2;

    signal clk : std_logic := '0';

    signal i_s, i_d0, i_d1, o_o: std_logic := '0';
    signal i_x : std_logic_vector(2 downto 0) := "000";


    component mux2t1 is
    port(
        i_S     : in std_logic;
        i_D0    : in std_logic;
        i_D1    : in std_logic;
        o_O     : out std_logic
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

  (i_s, i_d0, i_d1) <= i_x;

  dut0: mux2t1
    port map(
      i_s   => i_s,
      i_d0  => i_d0,
      i_d1  => i_d1,
      o_O   => o_o
    );
    
  P_TEST_CASES: process
  begin
    wait for clk_phase/2;

    while true loop
      i_x <= std_logic_vector(unsigned(i_x) + 1);
      wait for clk_phase*2;
    end loop;

  end process;

end mixed;
