library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity add_sub_32bit is
    generic(BITS: INTEGER := 32);
    port(
        -- ADD_SUB_COMPARE_CTRL BIT MEANINGS: 
        -- ADD_SUB_COMPARE_CTRL :  (00 : ADD
        --                          01 : SUB
        --                          10 : SLT  (set less than)
        --                          11 : SLTU (set less than unsigned)
        i_A                     : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        i_B                     : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_F                     : out STD_LOGIC_VECTOR(BITS-1 downto 0)
    );
end add_sub_32bit;

architecture rtl of add_sub_32bit is
    signal s_SUBTRACT       : STD_LOGIC;
    signal s_b              : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_ADD_SUB_RES    : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_LT_RES         : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_LTU_RES        : STD_LOGIC_VECTOR(BITS-1 downto 0);
    

    component ADDER_32BIT is
    generic (BITS: INTEGER := 32);
    port(
        i_C     : in STD_LOGIC;
        i_A     : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        i_B     : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_F     : out STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_C     : out STD_LOGIC;
        o_OF    : out STD_LOGIC
    );
    end component;
    component ONES_COMP_32BIT is
    generic(BITS: integer := 16);
    port(
        i_s     : in std_logic;
        i_x     : in std_logic_vector(BITS-1 downto 0);
        o_f     : out std_logic_vector(BITS-1 downto 0)
    );

    end component;

begin
    ones_comp0: ONES_COMP_32BIT
     generic map(
        BITS => BITS
    )
     port map(
        i_s => s_SUBTRACT,
        i_x => i_B,
        o_f => s_b
    );

    adder0: ADDER_32BIT
     generic map(
        BITS => BITS
    )
     port map(
        I_C => s_SUBTRACT,
        I_A => i_A,
        I_B => s_b,
        O_F => s_ADD_SUB_RES,
        O_C => s_C,
        o_OF => s_OF
    );

end rtl;
