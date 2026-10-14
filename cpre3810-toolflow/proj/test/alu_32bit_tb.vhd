library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;


use work.std_logic_vector_array.all;

library  std;
use std.env.all;

entity ALU_32BIT_tb is
    generic(
        eighth_clk      : time      := 1.25 ns;
        quarter_clk     : time      := eighth_clk * 2;
        half_clk        : time      :=  quarter_clk * 2;
        full_clk        : time      :=  half_clk * 2;
        BITS            : integer   := 32
    );
end ALU_32BIT_tb;

architecture rtl of ALU_32BIT_tb is

    constant s_ALU_ADD    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant s_ALU_SUB    : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant s_ALU_SLL    : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant s_ALU_SLT    : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant s_ALU_SLTU   : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant s_ALU_XOR    : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant s_ALU_SRL    : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant s_ALU_SRA    : STD_LOGIC_VECTOR(3 downto 0) := "1101";
    constant s_ALU_OR     : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    constant s_ALU_AND    : STD_LOGIC_VECTOR(3 downto 0) := "0111";

    signal i_ALU_CTRL       : STD_LOGIC_VECTOR(3 downto 0);
    signal i_A              : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal i_B              : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal o_RESULT         : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal LESS_UNSIGNED    : STD_LOGIC;
    signal LESS             : STD_LOGIC;
    signal equal            : STD_LOGIC;
    signal o_EQUAL          : STD_LOGIC := '0';
    signal o_LT             : STD_LOGIC := '0';
    signal o_LTU            : STD_LOGIC := '0';
    signal o_OF             : STD_LOGIC := '0';
    signal s_A              : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_B              : STD_LOGIC_VECTOR(BITS-1 downto 0);

    component ALU_32BIT is
        generic (
            DATA_WIDTH : INTEGER := 32
        );
        port (
            i_ALU_CTRL  : in STD_LOGIC_VECTOR(3 downto 0);
            -- ALU_CTRL BIT MEANINGS: 
            -- ALU_CTRL[3]      : ('1' : SHIFT_RIGHT_SIGNED or SUBTRACT, '0' : UNSIGNED or ADD) 
            -- ALU_CTRL[2:0]    :  (000 -> ADD/SUB
            --                      001 -> SLL
            --                      010 -> SLT  (set less than)
            --                      011 -> SLTU (set less than unsigned)
            --                      100 -> XOR
            --                      101 -> SRL or SRA
            --                      110 -> OR
            --                      111 -> AND)
            i_A         : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
            i_B         : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
            o_RESULT    : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
            o_EQUAL     : out STD_LOGIC;
            o_LT        : out STD_LOGIC;
            o_LTU       : out STD_LOGIC;
            o_OF        : out STD_LOGIC
        );
    end component;

begin

    ALU_inst: ALU_32BIT
    generic map(
        DATA_WIDTH => BITS
    )
    port map(
        i_ALU_CTRL => i_ALU_CTRL,
        i_A => i_A,
        i_B => i_B,
        o_RESULT => o_RESULT,
        o_EQUAL => o_EQUAL,
        o_LT => o_LT,
        o_LTU => o_LTU,
        o_OF => o_OF
    );
    
    EQUAL           <= '1' when unsigned(s_A) = unsigned(s_B) else '0';
    LESS            <= '1' when signed(s_A) < signed(s_B)  else '0';
    LESS_UNSIGNED   <= '1' when unsigned(s_A) < unsigned(s_B)  else '0';

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
            constant rand_max : integer :=  2**30 - 1;   -- keeps A+B and A-B inside integer range
        begin
            uniform(seed1, seed2, rand_real);
            
            -- 2. Scale it to the desired integer range
            return integer(trunc(rand_real * (real(rand_max) - real(rand_min) + 1.0))) + rand_min;
        end function;

        procedure ADD_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_ADD;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       
            
            wait for quarter_clk;
            CHECK(
                "ADD_TEST",
                "+",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A + B, 32)),
                o_RESULT
            );

        end procedure;
        
        procedure SUB_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
            ) is
        begin
            i_ALU_CTRL  <= s_ALU_SUB;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));
            
            wait for quarter_clk;
            CHECK(
                "SUB_TEST",
                "-",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A - B, 32)),
                o_RESULT
            );
        end procedure;

        procedure SLL_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SLL;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32));
            
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

        procedure XOR_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_XOR;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for quarter_clk;
            CHECK(
                "XOR_TEST",
                "^",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)) XOR STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                o_RESULT
            );
        end procedure;

        procedure OR_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_OR;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for quarter_clk;
            CHECK(
                "OR_TEST",
                "|",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)) OR STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                o_RESULT
            );
        end procedure;

        procedure SRL_TEST(
            constant A      : in INTEGER;
            constant SHIFT  : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_SRL;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32));       

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
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(abs(SHIFT) mod 32, 32));       

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

        procedure AND_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            i_ALU_CTRL  <= s_ALU_AND;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for quarter_clk;
            CHECK(
                "AND_TEST",
                "&",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)) AND STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                o_RESULT
            );
            
        end procedure;

        procedure SLT_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            s_A <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));
            s_B <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));

            i_ALU_CTRL  <= s_ALU_SLT;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));       

            wait for quarter_clk;
            CHECK(
                "SLT_TEST",
                "<",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                (0 => LESS, others => '0'),
                o_RESULT
            );
            
        end procedure;

        procedure SLTU_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            s_A <= STD_LOGIC_VECTOR(TO_UNSIGNED(A, 32));
            s_B <= STD_LOGIC_VECTOR(TO_UNSIGNED(B, 32));

            i_ALU_CTRL  <= s_ALU_SLTU;
            i_A         <= STD_LOGIC_VECTOR(TO_UNSIGNED(A, 32));       
            i_B         <= STD_LOGIC_VECTOR(TO_UNSIGNED(B, 32));       

            wait for quarter_clk;
            CHECK(
                "SLTU_TEST",
                "<",
                STD_LOGIC_VECTOR(TO_UNSIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_UNSIGNED(B, 32)),
                (0 => LESS_UNSIGNED, others => '0'),
                o_RESULT
            );

        end procedure;

        procedure LT_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            s_A <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));
            s_B <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));

            i_ALU_CTRL  <= s_ALU_SUB;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));
            
            wait for quarter_clk;
            CHECK(
                "LT_TEST",
                "<",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                (0 => LESS, others => '0'),
                (0 => o_LT, others => '0')
            );
            
        end procedure;

        procedure LTU_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            s_A <= STD_LOGIC_VECTOR(TO_UNSIGNED(A, 32));
            s_B <= STD_LOGIC_VECTOR(TO_UNSIGNED(B, 32));

            i_ALU_CTRL  <= s_ALU_SUB;
            i_A         <= STD_LOGIC_VECTOR(TO_UNSIGNED(A, 32));
            i_B         <= STD_LOGIC_VECTOR(TO_UNSIGNED(B, 32));

            wait for quarter_clk;
            CHECK(
                "LTU_TEST",
                "<",
                STD_LOGIC_VECTOR(TO_UNSIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_UNSIGNED(B, 32)),
                (0 => LESS_UNSIGNED, others => '0'),
                (0 => o_LTU, others => '0')
            );
            
        end procedure;

        procedure EQ_TEST(
            constant A     : in INTEGER;
            constant B     : in INTEGER
        ) is
        begin
            s_A <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));
            s_B <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));

            i_ALU_CTRL  <= s_ALU_SUB;
            i_A         <= STD_LOGIC_VECTOR(TO_SIGNED(A, 32));
            i_B         <= STD_LOGIC_VECTOR(TO_SIGNED(B, 32));

            wait for quarter_clk;
            CHECK(
                "EQ_TEST",
                "=",
                STD_LOGIC_VECTOR(TO_SIGNED(A, 32)),
                STD_LOGIC_VECTOR(TO_SIGNED(B, 32)),
                (0 => EQUAL, others => '0'),
                (0 => o_EQUAL, others => '0')
            );
            
        end procedure;

    begin

        -- Tests
        for i in 0 to 1000 loop
            ADD_TEST(   RANDOM_INT, RANDOM_INT);
            SUB_TEST(   RANDOM_INT, RANDOM_INT);
            SLL_TEST(   RANDOM_INT, RANDOM_INT);
            XOR_TEST(   RANDOM_INT, RANDOM_INT);
            OR_TEST(    RANDOM_INT, RANDOM_INT);
            SRL_TEST(   RANDOM_INT, RANDOM_INT);
            SRA_TEST(   RANDOM_INT, RANDOM_INT);
            AND_TEST(   RANDOM_INT, RANDOM_INT);
            SLT_TEST(   RANDOM_INT, RANDOM_INT);
            SLTU_TEST(  RANDOM_INT, RANDOM_INT);
            LT_TEST(    RANDOM_INT, RANDOM_INT);
            LTU_TEST(   RANDOM_INT, RANDOM_INT);
            EQ_TEST(    RANDOM_INT, RANDOM_INT);
            EQUAL_VAR := RANDOM_INT;
            EQ_TEST(    EQUAL_VAR, EQUAL_VAR);
        end loop;
        wait for full_clk;
        wait for full_clk;
        stop;

    end process;

end rtl;