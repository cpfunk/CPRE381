library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;


entity data_path1 is
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
end entity;

architecture rtl of data_path1 is
    
    signal s_DATA       : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(BITS-1 downto 0);
    signal s_RES        : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_MUX_OUT    : STD_LOGIC_VECTOR(BITS-1 downto 0);
    

    component ADD_SUB_NBIT is
    generic(BITS : integer := 32);
    port(
        i_ADD_SUB    : in STD_LOGIC;
        i_A         : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        i_B         : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_F         : out STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_C         : out STD_LOGIC
    );
    end component;
    component BUS_MUX_NTO1 is
    generic(
        BITS: INTEGER   := 32;
        N: INTEGER      := 32
    );
    port(
        i_S: in STD_LOGIC_VECTOR(CLOG2(N)-1 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(BITS - 1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(BITS - 1 downto 0)
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

    REG_FILE0: reg_file
     generic map(
        BITS => BITS
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_RD => i_RD,
        i_RS => i_RS,
        i_DATA => s_RES,
        o_DATA => s_DATA
    );

    BUS_MUX_2TO10: BUS_MUX_NTO1
     generic map(
        BITS => BITS,
        N => 2
    )
     port map(
        i_S => (0 => i_ALU_SRC),
        i_DATA => (0 => s_DATA(1), 1 => i_IMM),
        o_DATA => s_MUX_OUT
    );

    ADD_SUB_NBIT0: ADD_SUB_NBIT
     generic map(
        BITS => BITS
    )
     port map(
        i_ADD_SUB => i_ADD_SUB_N,
        i_A => s_DATA(0),
        i_B => s_MUX_OUT,
        o_F => s_RES
    );

end architecture;