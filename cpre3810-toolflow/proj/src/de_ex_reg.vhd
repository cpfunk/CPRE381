library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;


use work.RISCV_types.all;

library  std;
use std.env.all;

entity DE_EX_REG is
    generic(
        DATA_WIDTH  : integer   := 32
    );
    port (
        i_CLK           : in STD_LOGIC;
        i_RST           : in STD_LOGIC;
        i_WE            : in STD_LOGIC;
        i_FLUSH         : in STD_LOGIC;
        i_DE_EX_SIGS    : in DE_EX_SIGS;
        o_DE_EX_SIGS    : out DE_EX_SIGS
    );
end entity;

architecture rtl of DE_EX_REG is
    
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

    OPCODE_REG: reg
     generic map(
        DATA_WIDTH => 7
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.OPCODE,
        o_DATA => o_DE_EX_SIGS.OPCODE
    );

    CTRL_SIGS_REG_inst: CTRL_SIGS_REG
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_FLUSH => i_FLUSH,
        i_CTRL_SIGS => i_DE_EX_SIGS.CTRL_SIGS,
        o_CTRL_SIGS => o_DE_EX_SIGS.CTRL_SIGS
    );

    PC_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.PC,
        o_DATA => o_DE_EX_SIGS.PC
    );


    REG_DATA1_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.REG_DATA_OUT(0),
        o_DATA => o_DE_EX_SIGS.REG_DATA_OUT(0)
    );

    REG_DATA2_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.REG_DATA_OUT(1),
        o_DATA => o_DE_EX_SIGS.REG_DATA_OUT(1)
    );

    PC_PLUS_4_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.PC_PLUS_4,
        o_DATA => o_DE_EX_SIGS.PC_PLUS_4
    );

    RD_REG: reg
     generic map(
        DATA_WIDTH => 5
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.RD,
        o_DATA => o_DE_EX_SIGS.RD
    );

    IMM_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_DE_EX_SIGS.IMM,
        o_DATA => o_DE_EX_SIGS.IMM
    );

end architecture;