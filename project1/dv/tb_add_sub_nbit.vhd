library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;              
use std.textio.all;           

entity TB_ADD_SUB_NBIT is
    generic(
        clk_phase   : time := 10 ns;
        N           : integer := 32
    );
end TB_ADD_SUB_NBIT;

architecture mixed of TB_ADD_SUB_NBIT is

    constant clk_period  : time := clk_phase * 2;

    signal clk              : std_logic := '0';
    signal nAdd_Sub, o_c         : std_logic := '0';
    signal i_a, i_b, o_f    : std_logic_vector(N-1 downto 0);
begin

    clk0: process
    begin
        clk <= '1';
        wait for clk_phase;
        clk <= '0'; 
        wait for clk_phase;
    end process;

    
    DUT0: entity work.ADD_SUB_NBIT
     generic map(
        BITS => N
    )
     port map(
        i_ADD_SUB => nAdd_Sub,
        i_A => i_a,
        i_B => i_b,
        o_F => o_f,
        o_C => o_c
    );

    p_test_cases: process
    begin
        wait for clk_phase/2;

        while true loop
            i_b <= x"01010101";
            i_a <= x"09090909";
            wait for clk_phase*2;

            i_b <= x"19191919";
            i_a <= x"E1E1E1E1";
            wait for clk_phase*2;

            i_b <= x"00000001";
            i_a <= x"00000002";
            wait for clk_phase*2;

            i_b <= x"00000003";
            i_a <= x"00000010";
            wait for clk_phase*2;

            i_b <= x"FFFF_FFFB";
            i_a <= x"FFFF_FFF6";
            wait for clk_phase*2;

            nAdd_Sub <= not nAdd_Sub;
        end loop;

    end process;

end mixed;
