library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;


use work.RISCV_types.all;

library  std;
use std.env.all;

entity EX_MEM_REG is
    generic(
        DATA_WIDTH  : integer   := 32
    );
    port (
        i_CLK           : in STD_LOGIC;
        i_RST           : in STD_LOGIC;
        i_WE            : in STD_LOGIC;
        i_FLUSH         : in STD_LOGIC;
        i_EX_MEM_SIGS   : in EX_MEM_SIGS;
        o_EX_MEM_SIGS   : out EX_MEM_SIGS
    );
end entity;

architecture rtl of EX_MEM_REG is
    
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

    component CTRL_SIGS_REG is
        port (
            i_CLK           : in STD_LOGIC;
            i_RST           : in STD_LOGIC;
            i_WE            : in STD_LOGIC;
            i_FLUSH         : in STD_LOGIC;
            i_CTRL_SIGS     : in CTRL_SIGS;
            o_CTRL_SIGS     : out CTRL_SIGS
        );
    end component;

begin

    CTRL_SIGS_REG_inst: CTRL_SIGS_REG
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_FLUSH => i_FLUSH,
        i_CTRL_SIGS => i_EX_MEM_SIGS.CTRL_SIGS,
        o_CTRL_SIGS => o_EX_MEM_SIGS.CTRL_SIGS
    );

    EX_DATA_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_EX_MEM_SIGS.EX_DATA,
        o_DATA => o_EX_MEM_SIGS.EX_DATA
    );

    REG_DATA2_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_EX_MEM_SIGS.REG_DATA2,
        o_DATA => o_EX_MEM_SIGS.REG_DATA2
    );

    RD_REG: reg
     generic map(
        DATA_WIDTH => 5
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_EX_MEM_SIGS.RD,
        o_DATA => o_EX_MEM_SIGS.RD
    );

end architecture;