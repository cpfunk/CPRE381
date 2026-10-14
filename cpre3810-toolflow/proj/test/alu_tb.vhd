library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

use work.std_logic_vector_array.all;

library  std;
use std.env.all;

entity ALU_tb is
    generic(
        eighth_clk  : time := 1.25 ns;
        quarter_clk : time := eighth_clk * 2;
        half_clk : time :=  quarter_clk * 2;
        full_clk : time :=  half_clk * 2;
        BITS : integer := 32
    );
end ALU_tb;

architecture rtl of ALU_tb is

    signal s_ALU_ADD    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal s_ALU_SUB    : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    signal s_ALU_SLL    : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    signal s_ALU_SLT    : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    signal s_ALU_SLTU   : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    signal s_ALU_XOR    : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    signal s_ALU_SRL    : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    signal s_ALU_SRA    : STD_LOGIC_VECTOR(3 downto 0) := "1101";
    signal s_ALU_OR     : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    signal s_ALU_AND    : STD_LOGIC_VECTOR(3 downto 0) := "0111";

    signal i_ALU_CTRL   : STD_LOGIC_VECTOR(4 downto 0);
    signal i_A          : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal i_B          : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal o_RESULT     : STD_LOGIC_VECTOR(BITS-1 downto 0);


    component ALU is
    generic (
        BITS : INTEGER := 32
    );
    port (
        i_ALU_CTRL  : in STD_LOGIC_VECTOR(3 downto 0);
        i_A         : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        i_B         : in STD_LOGIC_VECTOR(BITS - 1 downto 0);
        o_RESULT    : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
    end component;

begin

    ALU_inst: ALU
    generic map(
        BITS => BITS
    )
    port map(
        i_ALU_CTRL => i_ALU_CTRL,
        i_A => i_A,
        i_B => i_B,
        o_RESULT => o_RESULT
    );

    p_test_cases: process

        -- Procedures

        procedure ADD_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_ADD;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       
            
            wait for full_clk;
        end procedure;
        
        procedure SUB_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
            ) is
            begin
                i_ALU_CTRL  <= s_ALU_SUB;
                i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
                i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       
                
            wait for full_clk;
        end procedure;

        procedure SLL_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SLL;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(SHIFT, 32));       

            wait for full_clk;
        end procedure;

        procedure XOR_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_XOR;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for full_clk;
        end procedure;

        procedure OR_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_OR;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for full_clk;
        end procedure;

        procedure SRL_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SRL;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(SHIFT, 32));       

            wait for full_clk;
        end procedure;

        procedure SRA_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SRA;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(SHIFT, 32));       

            wait for full_clk;
        end procedure;

        procedure AND_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_AND;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for full_clk;
        end procedure;

    begin

        -- Tests
        ADD_TEST(   2#01011#   ,2#01011#);
        SUB_TEST(   2#01011#   ,2#01011#);
        SLL_TEST(   2#01011#   ,2#01011#);
        XOR_TEST(   2#01011#   ,2#01011#);
        OR_TEST(    2#01011#   ,2#01011#);
        SRL_TEST(   2#01011#   ,2#01011#);
        SRA_TEST(   2#01011#   ,2#01011#);
        AND_TEST(   2#01011#   ,2#01011#);
        wait for full_clk;
        wait for full_clk;
        stop;

    end process;

end rtl;
