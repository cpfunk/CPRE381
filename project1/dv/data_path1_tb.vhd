library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

library  std;
use std.env.all;

use work.std_logic_vector_array.all;

entity data_path1_tb is
    generic(
        eighth_clk  : time      := 1.25 ns;
        quarter_clk : time      := eighth_clk * 2;
        half_clk    : time      :=  quarter_clk * 2;
        full_clk    : time      :=  half_clk * 2;
        BITS        : INTEGER   := 32
    );
end entity;

architecture rtl of data_path1_tb is
    
    -- Signals

    signal 
        i_CLK,
        i_RST,
        i_WE,
        i_ADD_SUB_N,
        i_ALU_SRC
     : STD_LOGIC := '0';
    
    signal i_RD : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal i_RS : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);

    signal i_IMM  : STD_LOGIC_VECTOR(31 downto 0);

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


    component data_path1 is
    generic(
        BITS : INTEGER := 32
    );
    port (
        i_CLK       : in STD_LOGIC;
        i_RST       : in STD_LOGIC;
        i_WE        : in STD_LOGIC;
        i_ADD_SUB_N : in STD_LOGIC;
        i_ALU_SRC   : in STD_LOGIC;
        i_IMM       : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        i_RD        : in STD_LOGIC_VECTOR(4 downto 0);
        i_RS        : in STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0)
    );
    end component;

begin

    -- DUTs

    data_path1_inst: data_path1
     generic map(
        BITS => BITS
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_ADD_SUB_N => i_ADD_SUB_N,
        i_ALU_SRC => i_ALU_SRC,
        i_IMM => i_IMM,
        i_RD => i_RD,
        i_RS => i_RS
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
        end procedure;

        procedure rst_singals is
        begin
            i_WE        <= '0';
            i_ADD_SUB_N <= '0';
            i_RD        <= zero;
            i_RS(0)     <= zero;
            i_RS(1)     <= zero;
            i_IMM       <= x"0000_0000";
            i_ALU_SRC   <= '0';
            wait for full_clk;

        end procedure;

        procedure add_sub(
            constant R      : in STD_LOGIC_VECTOR(4 downto 0);
            constant R1     : in STD_LOGIC_VECTOR(4 downto 0);
            constant R2     : in STD_LOGIC_VECTOR(4 downto 0);
            constant sel    : in STD_LOGIC
        ) is 
        begin

            i_WE        <= '1';
            i_ADD_SUB_N <= sel;
            i_RD        <= R;
            i_RS(0)     <= R1;
            i_RS(1)     <= R2;
            i_IMM       <= x"0000_0000";

            wait for full_clk;
            rst_singals;
        end procedure;

        procedure add(
            constant R      : in STD_LOGIC_VECTOR(4 downto 0);
            constant R1     : in STD_LOGIC_VECTOR(4 downto 0);
            constant R2     : in STD_LOGIC_VECTOR(4 downto 0)
        ) is
        begin
            add_sub(R, R1, R2, '0');
        end procedure;

        procedure sub(
            constant R      : in STD_LOGIC_VECTOR(4 downto 0);
            constant R1     : in STD_LOGIC_VECTOR(4 downto 0);
            constant R2     : in STD_LOGIC_VECTOR(4 downto 0)
        ) is
        begin
            add_sub(R, R1, R2, '1');
        end procedure;

        procedure addi(
            constant R      : in STD_LOGIC_VECTOR(4 downto 0);
            constant R1     : in STD_LOGIC_VECTOR(4 downto 0);
            constant IMM    : in INTEGER 
        ) is
        begin

            i_WE        <= '1';
            i_ADD_SUB_N <= '0';
            i_RD        <= R;
            i_RS(0)     <= R1;
            i_RS(1)     <= zero;
            i_IMM       <= std_logic_vector(to_signed(IMM, 32));
            i_ALU_SRC   <= '1';
            
            wait for full_clk;
            rst_singals;

        end procedure;

    begin

        -- Tests

        rst;

        wait for eighth_clk; -- offset all the signals from the clock edge

        addi(x1, zero, 1); -- addi x1, zero, 1 # Place "1" in x1
        addi(x2, zero, 2); -- addi x2, zero, 2 # Place "2" in x2
        addi(x3, zero, 3); -- addi x3, zero, 3 # Place "3" in x3
        addi(x4, zero, 4); -- addi x4, zero, 4 # Place "4" in x4
        addi(x5, zero, 5); -- addi x5, zero, 5 # Place "5" in x5
        addi(x6, zero, 6); -- addi x6, zero, 6 # Place "6" in x6
        addi(x7, zero, 7); -- addi x7, zero, 7 # Place "7" in x7
        addi(x8, zero, 8); -- addi x8, zero, 8 # Place "8" in x8
        addi(x9, zero, 9); -- addi x9, zero, 9 # Place "9" in x9
        addi(x10, zero, 10); -- addi x10, zero, 10 # Place "10" in x10
        add(x11, x1, x2); -- add x11, x1, x2 # x11 = x1 + x2
        sub(x12, x11, x3); -- sub x12, x11, x3 # x12 = x11- x3
        add(x13, x12, x4); -- add x13, x12, x4 # x13 = x12 + x4
        sub(x14, x13, x5); -- sub x14, x13, x5 # x14 = x13- x5
        add(x15, x14, x6); -- add x15, x14, x6 # x15 = x14 + x6
        sub(x16, x15, x7); -- sub x16, x15, x7 # x16 = x15- x7
        add(x17, x16, x8); -- add x17, x16, x8 # x17 = x16 + x8
        sub(x18, x17, x9); -- sub x18, x17, x9 # x18 = x17- x9
        add(x19, x18, x10); -- add x19, x18, x10 # x19 = x18 + x10
        addi(x20, zero, -35); -- addi x20, zero,-35 # Place "-35" in x20
        add(x21, x19, x10); -- add x21, x19, x20 # x21 = x19 + x20
        addi(x22, zero, 16#FEED2000#); -- lui x22, 0XFEED2 # Place "0xFEED2000" in x22
        addi(x22, x22, 16#050#); -- addi x22, x22, 0x050 # Complete loading x22 with a large immediate

        wait for full_clk;
        wait for full_clk;
        stop;

    end process;

end architecture;
