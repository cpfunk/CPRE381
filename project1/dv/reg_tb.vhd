library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

library  std;
use std.env.all;

use work.std_logic_vector_array.all;


entity regs_tb is
    generic(
        eighth_clk  : time := 1.25 ns;
        quarter_clk : time := eighth_clk * 2;
        half_clk : time :=  quarter_clk * 2;
        full_clk : time :=  half_clk * 2;
        BITS : INTEGER := 32;
        NUM_REGS : INTEGER := 32
    );
end regs_tb;

architecture rtl of regs_tb is

    signal 
        i_CLK,
        i_RST,
        i_WE
     : STD_LOGIC;

    signal i_RD : STD_LOGIC_VECTOR(4 downto 0);
    signal i_RS : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);

    signal i_DATA : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal o_DATA : STD_LOGIC_VECTOR(BITS-1 downto 0);


    component reg is
    generic(BITS : integer := 32);
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
    end component;

begin

    REGS_inst: reg
     generic map(
        BITS => BITS
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DATA,
        o_DATA => o_DATA
    );

    clk0: process
    begin
        i_CLK <= '1';
        wait for half_clk;
        i_CLK <= '0';
        wait for half_clk;
    end process;

    p_test_cases: process
        -- Procedures

        procedure rst is
        begin
            wait for quarter_clk;
            i_RST <= '1';

            wait for quarter_clk;
            i_RST <= '0';

            wait for half_clk;
        end procedure;

        procedure load_reg(
            constant DATA : in INTEGER
        ) is
        begin
            -- reset all signals to zero

            i_WE <= '1';
            i_DATA <= STD_LOGIC_VECTOR(TO_UNSIGNED(DATA, 32));
            wait for full_clk;
            
            i_DATA  <= x"0000_0000";
            i_WE    <= '0';
            wait for full_clk;

        end procedure;

    begin
        -- Tests

        wait for eighth_clk;

        rst;

        load_reg(16#FFFF_FFFF#);
        load_reg(16#1234_5678#);
        load_reg(16#BAAD_F00D#);
        load_reg(16#FEEEA5_EE#);


        stop;

    end process;

end architecture;