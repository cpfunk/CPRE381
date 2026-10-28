library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity ALU_32BIT is
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
end entity;

architecture rtl of ALU_32BIT is

    constant LOG2_BITS : INTEGER := 5;
    
    signal s_OF         : STD_LOGIC; -- overflow
    signal s_C          : STD_LOGIC; -- carry out
    signal s_NF         : STD_LOGIC; -- negative flag
    signal s_EQ         : STD_LOGIC; -- equality flag
    signal s_LT         : STD_LOGIC; -- less than (signed)
    signal s_LTU        : STD_LOGIC; -- less than (unsigned)
    signal s_SUB        : STD_LOGIC; -- subtract control

    signal s_ADD_SUB    : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal s_SHIFT      : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal s_SLT        : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal s_SLTU       : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal s_XOR        : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal s_OR         : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal s_AND        : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);


    component ADD_SUB_32BIT is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i_SUB   : in STD_LOGIC;
        i_A     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        i_B     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_F     : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_C     : out STD_LOGIC;
        o_OF    : out STD_LOGIC
    );
    end component;

    component AND_32BIT is
    generic (
        DATA_WIDTH : INTEGER := 32
    );
    port (
        i_A  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        i_B  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        o_F  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
    end component;

    component OR_32BIT is
    generic (
        DATA_WIDTH : INTEGER := 32
    );
    port (

        i_A  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        i_B  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        o_F  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
    end component;

    component SHIFT_32BIT is
    generic(
        DATA_WIDTH : INTEGER := 32;
        LOG2_BITS  : INTEGER := 5
    );
    port (
        i_SIGNED    : in STD_LOGIC;
        i_LEFT      : in STD_LOGIC;
        i_DATA      : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        i_SHIFT     : in STD_LOGIC_VECTOR(LOG2_BITS - 1 downto 0);
        o_DATA      : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
    end component;
    
    component XOR_32BIT is
    generic (
        DATA_WIDTH : INTEGER := 32
    );
    port (

        i_A  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        i_B  : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        o_F  : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
    end component;

begin

    ADD_SUB_32BIT_inst: ADD_SUB_32BIT
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_SUB => s_SUB,
        i_A => i_A,
        i_B => i_B,
        o_F => s_ADD_SUB,
        o_C => s_C,
        o_OF => s_OF
    );
    
    XOR_32BIT_inst: XOR_32BIT
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_A => i_A,
        i_B => i_B,
        o_F => s_XOR
    );

    SHIFT_32BIT_inst: SHIFT_32BIT
     generic map(
        DATA_WIDTH => DATA_WIDTH,
        LOG2_BITS => LOG2_BITS
    )
     port map(
        i_SIGNED => i_ALU_CTRL(3),
        i_LEFT => not i_ALU_CTRL(2),
        i_DATA => i_A,
        i_SHIFT => i_B(LOG2_BITS-1 downto 0), -- only use the lower 5 DATA_WIDTH
        o_DATA => s_SHIFT
    );

    OR_32BIT_inst: OR_32BIT
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_A => i_A,
        i_B => i_B,
        o_F => s_OR
    );

    AND_32BIT_inst: AND_32BIT
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_A => i_A,
        i_B => i_B,
        o_F => s_AND
    );

    ---------------------------
    --  SIGNAL ASSIGNMENTS   --
    ---------------------------
    
    -- subtraction should occur for both subtract (bit 3) or "set less than" operations (bit 1)
    s_SUB <= i_ALU_CTRL(3) or i_ALU_CTRL(1);
    
    -- negative flag signal
    s_NF <= s_ADD_SUB(DATA_WIDTH-1);
    
    -- signed less than comparison flag signal
    s_LT <= s_NF xor s_OF;
    
    -- unsigned comparison
    s_LTU <= not s_C;

    -- equality comparison
    s_EQ <= '1' when (s_ADD_SUB = x"00000000") else '0';
    -------------------------------
    --  FLAG OUTPUT ASSIGNMENTS  --
    -------------------------------

    o_EQUAL <= s_EQ;
    o_LT    <= s_LT;
    o_LTU   <= s_LTU;
    o_OF    <= s_OF;
    
    --------------------------
    --  COMPARISON SIGNALS  --
    --------------------------

    -- set less than result
    s_SLT <= (0 => s_LT, others => '0');
    
    -- set less than unsigned result
    s_SLTU <= (0 => s_LTU, others => '0');

    ----------------------------------
    --  FUNCTION OUTPUT SELECT MUX  --
    ----------------------------------

    with i_ALU_CTRL(2 downto 0) select
        o_RESULT <= s_ADD_SUB   when "000",
                    s_SHIFT     when "001", -- shift right
                    s_SLT       when "010",
                    s_SLTU      when "011",
                    s_XOR       when "100",
                    s_SHIFT     when "101", -- shift left
                    s_OR        when "110",
                    s_AND       when others; -- "111"

end architecture;