library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;              
use std.textio.all;           

entity TB_ADDER_NBIT is
    generic(
        clk_phase   : time      := 10 ns;
        N           : integer   := 32
    );
end TB_ADDER_NBIT;

architecture mixed of TB_ADDER_NBIT is

    constant clk_period  : time := clk_phase * 2;

    signal clk              : std_logic := '0';
    signal i_c, o_c         : std_logic := '0';
    signal i_a, i_b, o_f    : std_logic_vector(N-1 downto 0);
begin

    clk0: process
    begin
        clk <= '1';
        wait for clk_phase;
        clk <= '0'; 
        wait for clk_phase;
    end process;

    dut0: entity work.ADDER_NBIT
     generic map(
        N => N
    )
     port map(
        I_C => i_c,
        I_A => i_a,
        I_B => i_b,
        O_F => o_f,
        O_C => o_c
    );
        
    p_test_cases: process
    begin
        wait for clk_phase/2;

        while true loop
            i_a <= x"0101_0101";
            i_b <= x"0909_0909";
            wait for clk_phase*2;

            i_a <= x"E1E1_E1E1";
            i_b <= x"1919_1919";
            wait for clk_phase*2;

            i_a <= x"EEEE_EEEE";
            i_b <= x"FFFF_FFFF";
            wait for clk_phase*2;

            i_c <= not i_c;
        end loop;

    end process;

end mixed;
