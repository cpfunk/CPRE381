library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

library  std;
use std.env.all;

entity sign_extender_12b_tb is
    generic(
        eighth_clk  : time      := 1.25 ns;
        quarter_clk : time      := eighth_clk * 2;
        half_clk    : time      :=  quarter_clk * 2;
        full_clk    : time      :=  half_clk * 2;
        BITS        : INTEGER   := 32
    );
end entity;

architecture rtl of sign_extender_12b_tb is
    signal 
        i_CLK,
        i_CTRL
     : STD_LOGIC := '0';

    signal i_12BIT  : STD_LOGIC_VECTOR(11 downto 0) := x"000";
    signal o_DATA   : STD_LOGIC_VECTOR(BITS - 1 downto 0) := x"0000_0000";

begin

    DUT0: entity work.sign_extender_12b
     generic map(
        BITS => BITS
    )
     port map(
        i_CTRL => i_CTRL,
        i_DATA_12B => i_12BIT,
        o_DATA => o_DATA
    );

    p_test_cases: process

        -- Procedures

        procedure sign_extend(
            constant VAL_12B    : in INTEGER;
            constant CTRL       : in STD_LOGIC
        ) is
        begin

            i_12BIT     <= STD_LOGIC_VECTOR(to_signed(VAL_12B, 12));
            i_CTRL      <= CTRL;
            
            wait for full_clk;

        end procedure;

    begin

        -- Tests

        wait for eighth_clk; -- offset all the signals from the clock edge

        sign_extend(3,          '0');
        sign_extend(-12,        '1');
        sign_extend(16#FFF#,    '0');
        sign_extend(16#FFF#,    '1');
        sign_extend(16#00F#,    '1');
        
        wait for full_clk;
        stop;

    end process;

end architecture;