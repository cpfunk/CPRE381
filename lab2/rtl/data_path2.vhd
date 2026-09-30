library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;


-- TODO FINISH AND TESTBENCH

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

begin

    MEM_CTRL0: entity work.MEM_CTRL
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

    mem0: entity work.mem
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

    MEM_READ_BUS_MUX:
    entity work.BUS_MUX_2TO1
     generic map(
        BITS => BITS
    )
     port map(
        i_S => i_MEM_READ,
        i_DATA => (1 => s_MEM_O_DATA, 0 => s_SUM_RES),
        o_DATA => s_REG_I_DATA
    );

    REG_FILE: entity work.reg_file
     generic map(
        BITS => BITS
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_W_ADDR => i_REG_W_ADDR,
        i_R_ADDR => i_REG_R_ADDR,
        i_DATA => s_REG_I_DATA,
        o_DATA => s_REG_O_DATA
    );

    SIGN_EXTENDER_12B_0: entity work.SIGN_EXTENDER_12B
     generic map(
        BITS => BITS
    )
     port map(
        i_CTRL => i_SIGN_EXT_CTRL,
        i_DATA_12B => i_IMM,
        o_DATA => s_SIGN_EXT_DATA
    );

    IMM_SEL_BUS_MUX: entity work.BUS_MUX_2TO1
     generic map(
        BITS => BITS
    )
     port map(
        i_S => i_ALU_SRC,
        i_DATA => (0 => s_REG_O_DATA(1), 1 => s_SIGN_EXT_DATA),
        o_DATA => s_MUX_OUT
    );

    ADD_SUB_NBIT_inst: entity work.ADD_SUB_NBIT
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