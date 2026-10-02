library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

library  std;
use std.env.all;

use work.std_logic_vector_array.all;

entity data_path2_tb is
    generic(
        eighth_clk  : time      := 1.25 ns;
        quarter_clk : time      := eighth_clk * 2;
        half_clk    : time      :=  quarter_clk * 2;
        full_clk    : time      :=  half_clk * 2;
        BITS        : INTEGER   := 32;
        ADDR_WIDTH  : INTEGER   := 10;
        IMM_BITS    : INTEGER   := 12
    );
end entity;

architecture rtl of data_path2_tb is

    -- constants for registers

    constant zero : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16#00#, 5)); 
    constant x1   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(1, 5)); 
    constant x2   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(2, 5)); 
    constant x3   : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(3, 5)); 
    constant x25  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(25, 5)); 
    constant x26  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(26, 5)); 
    constant x27  : STD_LOGIC_VECTOR(4 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(27, 5)); 

    -- input signals

    signal i_CLK            : STD_LOGIC := '0';
    signal i_RST            : STD_LOGIC := '0';
    signal i_REG_WE         : STD_LOGIC := '0';
    signal i_ADD_SUB_N      : STD_LOGIC := '0';
    signal i_ALU_SRC        : STD_LOGIC := '0';
    signal i_MEM_WRITE      : STD_LOGIC := '0';
    signal i_MEM_READ       : STD_LOGIC := '0';
    signal i_IMM            : STD_LOGIC_VECTOR(IMM_BITS-1 downto 0) := x"000";
    signal i_REG_W_ADDR     : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal i_REG_R_ADDR     : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0) := (0 => "00000", 1 => "00000");
    signal s_SIGN_EXT_CTRL  : STD_LOGIC_VECTOR(11 downto 0);

begin

    data_path2_inst: entity work.data_path2
     generic map(
        BITS => BITS,
        IMM_BITS => IMM_BITS,
        ADDR_WIDTH => ADDR_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_REG_WE,
        i_ADD_SUB_N => i_ADD_SUB_N,
        i_ALU_SRC => i_ALU_SRC,
        i_MEM_WRITE => i_MEM_WRITE,
        i_MEM_READ => i_MEM_READ,
        i_SIGN_EXT_CTRL => s_SIGN_EXT_CTRL(11),
        i_IMM => i_IMM,
        i_REG_W_ADDR => i_REG_W_ADDR,
        i_REG_R_ADDR => i_REG_R_ADDR
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
            i_RST <= '0';
            i_REG_WE <= '0';
            i_ADD_SUB_N <= '0';
            i_ALU_SRC <= '0';
            i_MEM_WRITE <= '0';
            i_MEM_READ <= '0';
            i_IMM <= x"000";
            i_REG_W_ADDR <= zero;
            i_REG_R_ADDR <= (0 => zero, 1 => zero);
            
            wait for full_clk;

        end procedure;

        procedure add(
            constant R      : in STD_LOGIC_VECTOR(4 downto 0);
            constant R1     : in STD_LOGIC_VECTOR(4 downto 0);
            constant R2     : in STD_LOGIC_VECTOR(4 downto 0)
        ) is
        begin
            i_REG_WE            <= '1';
            i_MEM_READ          <= '0';
            i_ADD_SUB_N         <= '0';
            i_REG_R_ADDR(0)     <= R1;
            i_REG_R_ADDR(1)     <= R2;
            i_REG_W_ADDR        <= R;
            i_IMM               <= x"000";

            wait for full_clk;
            rst_singals;

        end procedure;

        procedure addi(
            constant R      : in STD_LOGIC_VECTOR(4 downto 0);
            constant R1     : in STD_LOGIC_VECTOR(4 downto 0);
            constant IMM    : in INTEGER 
        ) is
        begin

            i_REG_WE            <= '1';
            i_MEM_READ          <= '0';
            i_ADD_SUB_N         <= '0';
            i_ALU_SRC           <= '1';
            i_REG_R_ADDR(0)     <= R1;
            i_REG_R_ADDR(1)     <= zero;
            i_REG_W_ADDR        <= R;
            s_SIGN_EXT_CTRL     <= s_SIGN_EXT_CTRL;
            i_IMM               <= std_logic_vector(to_signed(IMM, 12));
            
            wait for full_clk;
            rst_singals;

        end procedure;

        procedure lw(
            RD  : in STD_LOGIC_VECTOR(4 downto 0);
            IMM : in INTEGER;
            RS1 : in STD_LOGIC_VECTOR(4 downto 0)
        ) is
        begin
            
            i_MEM_WRITE     <= '0';
            i_MEM_READ      <= '1';
            i_ADD_SUB_N     <= '0';
            i_ALU_SRC       <= '1';
            i_REG_WE        <= '1';
            i_REG_R_ADDR(0) <= RS1;
            i_REG_R_ADDR(1) <= zero;
            i_REG_W_ADDR    <= RD;
            s_SIGN_EXT_CTRL <= std_logic_vector(to_signed(IMM, 12));
            i_IMM           <= std_logic_vector(to_signed(IMM, 12));

            wait for full_clk;
            rst_singals;

        end procedure;

        procedure sw(
            RS1 : in STD_LOGIC_VECTOR(4 downto 0);
            IMM : in INTEGER;
            RS2 : in STD_LOGIC_VECTOR(4 downto 0)
        ) is
        begin
            i_MEM_WRITE     <= '1';
            i_MEM_READ      <= '0';
            i_ADD_SUB_N     <= '0';
            i_ALU_SRC       <= '1';
            i_REG_WE        <= '0';
            i_REG_R_ADDR(0) <= RS2;
            i_REG_R_ADDR(1) <= RS1;
            i_REG_W_ADDR    <= zero;
            s_SIGN_EXT_CTRL <= std_logic_vector(to_signed(IMM, 12));
            i_IMM           <= std_logic_vector(to_signed(IMM, 12));

            wait for full_clk;
            rst_singals;

        end procedure;

    begin

        -- Tests

        rst;

        wait for eighth_clk; -- offset all the signals from the clock edge

        -- "run" the instructions
        addi(x25, x25, 0); -- addi x25,x25,0 # Load &A into x25, assuming x25 initially has 0x10010000 and a[0] is at 0x10010000
        
        addi(x26, x26, 256); -- addi x26, x26, 256 # Load &B into x26, assuming x26 initially has 0x10010000 and b[0] is at 0x10010100

        lw(x1, 0, x25); -- lw x1, 0(x25) # Load A[0] into x1
        lw(x2, 4, x25); -- lw x2, 4(x25) # Load A[1] into x2, 
        add(x1, x1, x2); -- add x1, x1, x2 # x1 = x1 + x2 -> x1 = -1; x2 = 2, so, at the end x1 = 1
        sw(x1, 0, x26); -- sw x1, 0(x26) 
        lw(x2, 8, x25); -- lw x2, 8(x25) 
        add(x1, x1, x2); -- add x1, x1, x2 
        sw(x1, 4, x26); -- sw x1, 4(x26) 
        lw(x2, 12, x25); -- lw x2, 12(x25) 
        add(x1, x1, x2); -- add x1, x1, x2 
        sw(x1, 8, x26); -- sw x1, 8(x26) 
        lw(x2, 16, x25); -- lw x2, 16(x25) 
        add(x1, x1, x2); -- add x1, x1, x2 # x1 = x1 + x2 -> x1 = 2; x2 = 5, so, at the end x1 = 7
        sw(x1, 12, x26); -- sw x1, 12(x26) 
        lw(x2, 20, x25); -- lw x2, 20(x25) 
        add(x1, x1, x2); -- add x1, x1, x2 # x1 = x1 + x2 -> x1 = 7; x2 = 6, so, at the end x1 = 13
        sw(x1, 16, x26); -- sw x1, 16(x26) 
        lw(x2, 24, x25); -- lw x2, 24(x25) 
        add(x1, x1, x2); -- add x1, x1, x2
        addi(x27, x27, 512); -- addi x27, x27, 512
        sw(x1, -4, x27); -- sw x1,-4(x27) 
        sw(x1, -4, x27); -- sw x1,-4(x27)

        wait for full_clk;
        wait for full_clk;
        stop;

    end process;

end architecture;