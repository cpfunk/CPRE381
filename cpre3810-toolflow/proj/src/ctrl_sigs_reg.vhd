library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;


use work.RISCV_types.all;



entity CTRL_SIGS_REG is
    port (
        i_CLK           : in STD_LOGIC;
        i_RST           : in STD_LOGIC;
        i_WE            : in STD_LOGIC;
        i_FLUSH         : in STD_LOGIC;
        i_CTRL_SIGS     : in CTRL_SIGS;
        o_CTRL_SIGS     : out CTRL_SIGS
    );
end entity;

architecture rtl of CTRL_SIGS_REG is
    
    component reg is
        generic(DATA_WIDTH : integer := 32);
        port (
            i_CLK   : in STD_LOGIC;
            i_RST   : in STD_LOGIC;
            i_WE    : in STD_LOGIC;
            i_DATA  : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_DATA  : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
        );
    end component;

    component dffg_rst_hi is
        port(
            i_CLK        : in std_logic;     -- Clock input
            i_RST        : in std_logic;     -- Reset input
            i_WE         : in std_logic;     -- Write enable input
            i_D          : in std_logic;     -- Data value input
            o_Q          : out std_logic
        );   -- Data value output
    end component;
    
    signal s_CTRL_SIGS          : CTRL_SIGS;
    signal s_NOP_SIGS           : CTRL_SIGS; 
    signal s_STD_LOGIC_SIGS_IN  : STD_LOGIC_VECTOR(8 downto 0);
    signal s_STD_LOGIC_SIGS_OUT : STD_LOGIC_VECTOR(8 downto 0);


begin

    s_NOP_SIGS.ALU_SRC_PC      <= "00";
    s_NOP_SIGS.ALU_SRC         <= "00";
    s_NOP_SIGS.REG_SRC         <= "00";
    s_NOP_SIGS.REG_WE          <= '0';
    s_NOP_SIGS.MEM_WRITE       <= '0';
    s_NOP_SIGS.WRD             <= '0';
    s_NOP_SIGS.HWRD            <= '0';
    s_NOP_SIGS.UNSIGNED        <= '0';
    s_NOP_SIGS.ALU_CTRL        <= "0000";
    s_NOP_SIGS.N_HALT          <= '1'; -- don't halt!

    with i_FLUSH select
        s_CTRL_SIGS <=  s_NOP_SIGS  when '1',
                        i_CTRL_SIGS when others;

    -- input signals
    s_STD_LOGIC_SIGS_IN(1 downto 0) <= s_CTRL_SIGS.ALU_SRC_PC;
    s_STD_LOGIC_SIGS_IN(3 downto 2) <= s_CTRL_SIGS.ALU_SRC;
    s_STD_LOGIC_SIGS_IN(4) <= s_CTRL_SIGS.REG_WE;
    s_STD_LOGIC_SIGS_IN(5) <= s_CTRL_SIGS.MEM_WRITE;
    s_STD_LOGIC_SIGS_IN(6) <= s_CTRL_SIGS.WRD;
    s_STD_LOGIC_SIGS_IN(7) <= s_CTRL_SIGS.HWRD;
    s_STD_LOGIC_SIGS_IN(8) <= s_CTRL_SIGS.UNSIGNED;

    -- output signals
    o_CTRL_SIGS.ALU_SRC_PC  <= s_STD_LOGIC_SIGS_OUT(1 downto 0);
    o_CTRL_SIGS.ALU_SRC     <= s_STD_LOGIC_SIGS_OUT(3 downto 2);
    o_CTRL_SIGS.REG_WE      <= s_STD_LOGIC_SIGS_OUT(4);
    o_CTRL_SIGS.MEM_WRITE   <= s_STD_LOGIC_SIGS_OUT(5);
    o_CTRL_SIGS.WRD         <= s_STD_LOGIC_SIGS_OUT(6);
    o_CTRL_SIGS.HWRD        <= s_STD_LOGIC_SIGS_OUT(7);
    o_CTRL_SIGS.UNSIGNED    <= s_STD_LOGIC_SIGS_OUT(8);

    HALT_N_REG: dffg_rst_hi
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_D => s_CTRL_SIGS.N_HALT,
        o_Q => o_CTRL_SIGS.N_HALT
    );

    STD_LOGIC_SIGS: reg
     generic map(
        DATA_WIDTH => 9
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => s_STD_LOGIC_SIGS_IN,
        o_DATA => s_STD_LOGIC_SIGS_OUT
    );

    REG_SRC_REG: reg
     generic map(
        DATA_WIDTH => 2
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => s_CTRL_SIGS.REG_SRC,
        o_DATA => o_CTRL_SIGS.REG_SRC
    );

    ALU_CTRL_REG: reg
     generic map(
        DATA_WIDTH => 4
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => s_CTRL_SIGS.ALU_CTRL,
        o_DATA => o_CTRL_SIGS.ALU_CTRL
    );

end architecture;