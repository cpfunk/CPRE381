library IEEE;
use IEEE.std_logic_1164.all;

library  std;
use std.env.all;

use work.std_logic_vector_array.all;


entity reg_file_tb is
    generic(
        eighth_clk  : time := 1.25 ns;
        quarter_clk : time := eighth_clk * 2;
        half_clk : time :=  quarter_clk * 2;
        full_clk : time :=  half_clk * 2;
        BITS        : INTEGER := 32
    );
end entity;

architecture rtl of reg_file_tb is
    
    -- Signals

    signal 
        i_CLK,
        i_RST,
        i_WE
     : STD_LOGIC;
    
    signal i_RD : STD_LOGIC_VECTOR(4 downto 0);
    signal i_RS : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);

    signal i_DATA : STD_LOGIC_VECTOR(31 downto 0);
    signal o_DATA : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(31 downto 0);


    component reg_file is
    generic(
        BITS        : INTEGER := 32;
        NUM_REGS    : INTEGER := 32
    );
    port (
        i_CLK   : in STD_LOGIC;
        i_RST   : in STD_LOGIC;
        i_WE    : in STD_LOGIC;
        i_RD    : in STD_LOGIC_VECTOR(4 downto 0);
        i_RS    : in STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);
        i_DATA  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_DATA  : out STD_LOGIC_VECTOR_ARRAY(1 downto 0)(BITS-1 downto 0)
    );
    end component;

begin

    -- DUTs

    reg_file0: reg_file
     generic map(
        BITS => BITS
    )
     port map(
        i_CLK       => i_CLK,
        i_RST       => i_RST,
        i_WE        => i_WE,
        i_W_ADDR    => i_RD,
        i_R_ADDR    => i_RS,
        i_DATA      => i_DATA,
        o_DATA      => o_DATA
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
            constant DATA : in STD_LOGIC_VECTOR(31 downto 0);
            constant READ_WRITE : in STD_LOGIC_VECTOR(4 downto 0)
        ) is
        begin
            -- reset all signals to zero
            i_DATA  <= x"0000_0000";
            i_WE    <= '0';
            i_RD    <= "00000";
            i_RS(0)   <= "00000";
            i_RS(1)   <= "00000";

            wait for eighth_clk;
            i_RD <= READ_WRITE;

            wait for full_clk;
            i_DATA <= DATA;

            wait for full_clk;
            i_WE <= '1';
            
            wait for full_clk;
            i_RD <= "00000";

            wait for full_clk;
            i_RS(0) <= READ_WRITE;

            wait for full_clk;
            i_RS(1) <= READ_WRITE;

            wait for full_clk;
        end procedure;
    begin

        -- Tests

        wait for quarter_clk;

        rst;
        load_reg(x"BAAD_F00D", "00001");
        load_reg(x"AAAA_FFFF", "11111");
        load_reg(x"FFFF_AAAA", "01101");
        load_reg(x"EFEF_FEFE", "00011");
        load_reg(x"FFFF_FFFF", "00000");
        stop;

    end process;

end architecture;
