library IEEE;
use IEEE.std_logic_1164.all;

entity ADD_SUB_32BIT is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i_SUB       : in STD_LOGIC;
        i_A         : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        i_B         : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_F         : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        o_C         : out STD_LOGIC;
        o_OF        : out STD_LOGIC
    );
end ADD_SUB_32BIT;

architecture structural of ADD_SUB_32BIT is

    signal s_b : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); 

    component ADDER_32BIT is
        generic (
            DATA_WIDTH: INTEGER := 32
        );
        port(
            i_C     : in STD_LOGIC;
            i_A     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            i_B     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_F     : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_C     : out STD_LOGIC;
            o_OF    : out STD_LOGIC
        );
    end component;

    component ONES_COMP_32BIT is
        generic(DATA_WIDTH : integer := 32);
        port(
            i_s : in std_logic;
            i_x : in std_logic_vector(DATA_WIDTH-1 downto 0);
            o_f : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

begin

    ones_comp0: ONES_COMP_32BIT
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_s => i_SUB,
        i_x => i_B,
        o_f => s_b
    );

    adder0: ADDER_32BIT
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_C => i_SUB,
        i_A => i_A,
        i_B => s_b,
        o_F => o_F,
        o_C => o_C,
        o_OF => o_OF
    );
    
end structural;
