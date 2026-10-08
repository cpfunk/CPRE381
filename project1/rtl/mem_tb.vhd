library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

library  std;
use std.env.all;

use work.std_logic_vector_array.all;

-- NOTE: the problem was that you had an extra wire between the output
-- of the memory 'q' and the data input of the regfile. Questasim was treating this
-- wire as a latch.   

entity mem_tb is
    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10;
        BYTE_WIDTH : natural := 8;

        eighth_clk  : time      := 1.25 ns;
        quarter_clk : time      := eighth_clk * 2;
        half_clk    : time      :=  quarter_clk * 2;
        full_clk    : time      :=  half_clk * 2
    );
end entity;

architecture rtl of mem_tb is
    
    -- Signals

    signal clk, we : STD_LOGIC := '0';
    
    signal addr         : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0) := "0000000000";
    signal be           : STD_LOGIC_VECTOR(3 downto 0)  := x"F";
    signal q            : STD_LOGIC_VECTOR(31 downto 0) := x"0000_0000";
    
    signal REGFILE_RST    : STD_LOGIC := '0';
    signal REGFILE_WE     : STD_LOGIC := '0';
    signal REGFILE_W_ADDR     : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal REGFILE_R_ADDR     : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal REGFILE_O_DATA : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(31 downto 0);

    constant zero : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#00#, 5));
    constant x1   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#01#, 5)); 
    constant x2   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#02#, 5)); 
    constant x3   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#03#, 5)); 
    constant x4   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#04#, 5)); 
    constant x5   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#05#, 5)); 
    constant x6   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#06#, 5)); 
    constant x7   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#07#, 5)); 
    constant x8   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#08#, 5)); 
    constant x9   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#09#, 5)); 
    constant x10  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#0A#, 5)); 
    constant x11  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#0B#, 5)); 
    constant x12  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#0C#, 5)); 
    constant x13  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#0D#, 5)); 
    constant x14  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#0E#, 5)); 
    constant x15  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#0F#, 5)); 
    constant x16  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#10#, 5)); 
    constant x17  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#11#, 5)); 
    constant x18  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#12#, 5)); 
    constant x19  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#13#, 5)); 
    constant x20  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#14#, 5)); 
    constant x21  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#15#, 5)); 
    constant x22  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#16#, 5)); 


    component mem is

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

    end component;
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

    dut: mem
     generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH,
        BYTE_WIDTH => BYTE_WIDTH
    )
     port map(
        clk => clk,
        addr => addr,
        data => REGFILE_O_DATA(0),
        be => be,
        we => we,
        q => q
    );

    -- instantiate reg to hold temporary value
    reg_file_inst: reg_file
     generic map(
        BITS => DATA_WIDTH
    )
     port map(
        i_RST => REGFILE_RST,
        i_CLK => clk,
        i_WE => REGFILE_WE,
        i_RD => REGFILE_W_ADDR,
        i_RS => (0 => REGFILE_R_ADDR, 1 => ((others => '0') )),
        i_DATA => q,
        o_DATA => REGFILE_O_DATA
    );

    clk0: process
    begin
        clk <= '0';
        wait for half_clk;
        clk <= '1';
        wait for half_clk;
    end process;


    p_test_cases: process

        -- Procedures
        
        procedure rst is
        begin
            wait for quarter_clk;
            REGFILE_RST <= '1';

            wait for quarter_clk;
            REGFILE_RST <= '0';
        end procedure;

        procedure rst_singals is
        begin
            we      <= '0';
            
            REGFILE_RST       <= '0';
            REGFILE_WE        <= '0';
            REGFILE_W_ADDR        <= "00000";
            addr                <= "0000000001";

            wait for full_clk;

        end procedure;

        procedure sw(
            constant i_reg  : in STD_LOGIC_VECTOR(4 downto 0);
            constant i_addr : in INTEGER
        ) is
        begin

            -- write from register file to memory

            REGFILE_R_ADDR      <= i_reg;
            addr                <= STD_LOGIC_VECTOR(TO_UNSIGNED(i_addr, 10));

            -- wait for full_clk; --FIXME
            we                  <= '1';

            wait for full_clk;
            rst_singals;

        end procedure;

        procedure lw(
            constant i_reg  : in STD_LOGIC_VECTOR(4 downto 0);
            constant i_addr : in INTEGER
        ) is
        begin
            
            -- write from memory to i_reg in register file
            
            addr                <= STD_LOGIC_VECTOR(TO_UNSIGNED(i_addr, 10));
            REGFILE_W_ADDR      <= i_reg;
            
            -- wait for full_clk; --FIXME
            REGFILE_WE          <= '1';

            wait for full_clk;
            rst_singals;
            
        end procedure;

    begin

        -- Tests

        -- reset the regfile
        rst;
        
        wait for eighth_clk; -- offset all the signals from the clock edge
        
        -- load all the signals into the regfile
        lw(x1, 0);
        lw(x2, 1);
        lw(x3, 2);
        lw(x4, 3);
        lw(x5, 4);
        lw(x6, 5);
        lw(x7, 6);
        lw(x8, 7);
        lw(x9, 8);
        lw(x10, 9);

        -- store all the signals back to memory
        sw(x1, 16#100#);
        sw(x2, 16#101#);
        sw(x3, 16#102#);
        sw(x4, 16#103#);
        sw(x5, 16#104#);
        sw(x6, 16#105#);
        sw(x7, 16#106#);
        sw(x8, 16#107#);
        sw(x9, 16#108#);
        sw(x10,  16#109#);

        -- reset the regfile
        rst;

        -- load all the data back into the regfile
        lw(x1, 16#100#);
        lw(x2, 16#101#);
        lw(x3, 16#102#);
        lw(x4, 16#103#);
        lw(x5, 16#104#);
        lw(x6, 16#105#);
        lw(x7, 16#106#);
        lw(x8, 16#107#);
        lw(x9, 16#108#);
        lw(x10, 16#109#);

        wait for full_clk*8;

        stop;

    end process;

end architecture;
