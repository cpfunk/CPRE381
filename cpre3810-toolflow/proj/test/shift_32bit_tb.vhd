library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;


use work.std_logic_vector_array.all;

library  std;
use std.env.all;

entity SHIFT_32BIT_tb is
    generic(
        eighth_clk      : time      := 1.25 ns;
        quarter_clk     : time      := eighth_clk * 2;
        half_clk        : time      :=  quarter_clk * 2;
        full_clk        : time      :=  half_clk * 2;
        BITS            : integer   := 32
    );
end SHIFT_32BIT_tb;

architecture rtl of SHIFT_32BIT_tb is

    constant s_ALU_SLL    : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant s_ALU_SRL    : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant s_ALU_SRA    : STD_LOGIC_VECTOR(3 downto 0) := "1101";

    signal i_ALU_CTRL       : STD_LOGIC_VECTOR(3 downto 0);
    signal s_DATA           : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal o_RESULT         : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_SHIFT          : STD_LOGIC_VECTOR(BITS-1 downto 0);

    component SHIFT_32BIT is
        generic (
            DATA_WIDTH       : INTEGER := 32;
            LOG2_BITS  : INTEGER := 5
        );
        port (
            i_SIGNED    : in STD_LOGIC;
            i_LEFT      : in STD_LOGIC;
            i_DATA      : in STD_LOGIC_VECTOR(31 downto 0);
            i_SHIFT     : in STD_LOGIC_VECTOR(LOG2_BITS-1 downto 0);
            o_DATA      : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

begin

    SHIFT_inst: SHIFT_32BIT
    generic map(
        DATA_WIDTH => BITS,
        LOG2_BITS  => 5
    )
    port map(
        i_SIGNED => i_ALU_CTRL(3),
        i_LEFT => not i_ALU_CTRL(2),
        i_DATA => s_DATA,
        i_SHIFT => s_SHIFT(4 downto 0),
        o_DATA => o_RESULT
    );

    p_test_cases: process
        variable EQUAL_VAR   : INTEGER := 0;

        procedure CHECK(
            constant TEST       : in STRING;
            constant OPERAND    : in STRING;
            constant A          : in STD_LOGIC_VECTOR(BITS-1 downto 0);
            constant B          : in STD_LOGIC_VECTOR(BITS-1 downto 0);
            EXPECTED            : in STD_LOGIC_VECTOR(BITS-1 downto 0);
            RESULT              : in STD_LOGIC_VECTOR(BITS-1 downto 0)
        ) is
        begin

            if (EXPECTED /= RESULT) then
                report  TEST & " FAILED: " &
                        to_hstring(A) &
                        " " & OPERAND & " " &
                        to_hstring(B) &
                        " = " &
                        to_hstring(EXPECTED) &
                        " but got: " &
                        to_hstring(RESULT)
                severity FAILURE;
            else
                report  TEST & " PASSED: " &
                        to_hstring(A) &
                        " " & OPERAND & " " &
                        to_hstring(B) &
                        " = " &
                        to_hstring(EXPECTED) &
                        " got: " &
                        to_hstring(RESULT)
                severity NOTE;
            end if;

        end procedure;
        
        variable seed1 : positive := 1;  
        variable seed2 : positive := 42;

        impure function RANDOM_INT return integer is
            variable rand_real : real;
            constant rand_min : integer := -2**30;
            constant rand_max : integer :=  2**30 - 1;
        begin
            uniform(seed1, seed2, rand_real);
            
            return integer(trunc(rand_real * (real(rand_max) - real(rand_min) + 1.0))) + rand_min;
        end function;

        procedure SLL_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SLL;
            s_DATA         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            s_SHIFT         <= STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32));
            
            wait for quarter_clk;
            CHECK(
                "SLL_TEST",
                "<<",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)) sll abs(SHIFT) mod 32,
                o_RESULT
            );
        end procedure;

        procedure SRL_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SRL;
            s_DATA         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            s_SHIFT         <= STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32));       

            wait for quarter_clk;
            CHECK(
                "SRL_TEST",
                ">>",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(SHIFT, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32) srl abs(SHIFT) mod 32),
                o_RESULT
            );
        end procedure;

        procedure SRA_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SRA;
            s_DATA         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            s_SHIFT         <= STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32));       

            wait for quarter_clk;
            CHECK(
                "SRA_TEST",
                ">>>",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32) sra abs(SHIFT) mod 32),
                o_RESULT
            );
        end procedure;

    begin

        -- Tests
        for i in 0 to 1000 loop
            SLL_TEST(   RANDOM_INT, RANDOM_INT);
            SRL_TEST(   RANDOM_INT, RANDOM_INT);
            SRA_TEST(   RANDOM_INT, RANDOM_INT);
            EQUAL_VAR := RANDOM_INT;
        end loop;
        wait for full_clk;
        wait for full_clk;
        stop;

    end process;

end rtl;