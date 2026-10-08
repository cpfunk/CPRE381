library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;

entity data_path2 is
    generic(
        BITS        : INTEGER := 32;
        IMM_BITS    : INTEGER := 12;
        ADDR_WIDTH   : INTEGER := 30
    );
    port (
        i_CLK           : in STD_LOGIC;
        i_RST           : in STD_LOGIC;
        i_WE            : in STD_LOGIC;
        i_ADD_SUB_N     : in STD_LOGIC;
        i_ALU_SRC       : in STD_LOGIC;
        i_MEM_WRITE     : in STD_LOGIC;
        i_MEM_READ      : in STD_LOGIC;
        i_SIGN_EXT_CTRL : in STD_LOGIC;
        i_IMM           : in STD_LOGIC_VECTOR(IMM_BITS - 1 downto 0);
        i_REG_W_ADDR    : in STD_LOGIC_VECTOR(4 downto 0);
        i_REG_R_ADDR    : in STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0)
    );
end entity;

architecture rtl of data_path2 is

    
    -- memory signals
    signal s_SUM_RES    : STD_LOGIC_VECTOR(BITS-1 downto 0);
    signal s_MUX_OUT    : STD_LOGIC_VECTOR(BITS-1 downto 0);
    
    -- memory signals
    signal BYTE_WIDTH   : INTEGER := 8;
    signal s_MEM_WE     : STD_LOGIC;
    signal s_MEM_BE     : STD_LOGIC_VECTOR(3 downto 0);
    signal s_MEM_ADDR   : STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
    signal s_MEM_O_DATA : STD_LOGIC_VECTOR(BITS-1 downto 0);

    -- regfile signals
    signal s_REG_O_DATA  : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(BITS-1 downto 0);
    signal s_REG_I_DATA : STD_LOGIC_VECTOR(BITS-1 downto 0);

    -- sign extender signal
    signal s_SIGN_EXT_DATA : STD_LOGIC_VECTOR(BITS-1 downto 0);


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
    component MEM_CTRL is

    generic (
        BITS : INTEGER := 32;
        -- ADDR_WIDTH defines the size of memory.
        -- E.g., if ADDR_WIDTH = 10, then there are 32 * 2^10 bits in the memory
        ADDR_WIDTH : INTEGER := 10
    );

    port(
        i_WRITE : in STD_LOGIC;
        i_ADDR  : in STD_LOGIC_VECTOR(BITS-1 downto 0);
        o_WE    : out STD_LOGIC;
        o_BE    : out STD_LOGIC_VECTOR(3 downto 0);
        o_ADDR  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0)
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
    component SIGN_EXTENDER_12B is
    generic (BITS : INTEGER := 32);

    port (
        i_CTRL      : in STD_LOGIC;
        i_DATA_12B  : in STD_LOGIC_VECTOR(11 downto 0);
        o_DATA      : out STD_LOGIC_VECTOR(BITS - 1 downto 0)
    );
    end component;

begin

    MEM_CTRL0: MEM_CTRL
     generic map(
        BITS => BITS,
        ADDR_WIDTH => ADDR_WIDTH
    )
     port map(
        i_WRITE => i_MEM_WRITE,
        i_ADDR => s_SUM_RES,
        o_WE => s_MEM_WE,
        o_BE => s_MEM_BE,
        o_ADDR => s_MEM_ADDR
    );

    mem0: mem
     generic map(
        DATA_WIDTH => BITS,
        ADDR_WIDTH => ADDR_WIDTH,
        BYTE_WIDTH => BYTE_WIDTH
    )
     port map(
        clk => i_CLK,
        addr => s_MEM_ADDR,
        data => s_REG_O_DATA(1),
        be => s_MEM_BE,
        we => s_MEM_WE,
        q => s_MEM_O_DATA
    );

    MEM_READ_BUS_MUX: BUS_MUX_NTO1
     generic map(
        BITS => BITS,
        N => 2
    )
     port map(
        i_S => (0 => i_MEM_READ),
        i_DATA => (1 => s_MEM_O_DATA, 0 => s_SUM_RES),
        o_DATA => s_REG_I_DATA
    );

    REG_FILE: reg_file
     generic map(
        BITS => BITS
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_RD => i_REG_W_ADDR,
        i_RS => i_REG_R_ADDR,
        i_DATA => s_REG_I_DATA,
        o_DATA => s_REG_O_DATA
    );

    SIGN_EXTENDER_12B_0: SIGN_EXTENDER_12B
     generic map(
        BITS => BITS
    )
     port map(
        i_CTRL => i_SIGN_EXT_CTRL,
        i_DATA_12B => i_IMM,
        o_DATA => s_SIGN_EXT_DATA
    );

    IMM_SEL_BUS_MUX: BUS_MUX_NTO1
     generic map(
        BITS => BITS,
        N => 2
    )
     port map(
        i_S => (0 => i_ALU_SRC),
        i_DATA => (0 => s_REG_O_DATA(1), 1 => s_SIGN_EXT_DATA),
        o_DATA => s_MUX_OUT
    );

    ADD_SUB_NBIT_inst: ADD_SUB_NBIT
     generic map(
        BITS => BITS
    )
     port map(
        i_ADD_SUB => i_ADD_SUB_N,
        i_A => s_REG_O_DATA(0),
        i_B => s_MUX_OUT,
        o_F => s_SUM_RES
    );

end architecture;