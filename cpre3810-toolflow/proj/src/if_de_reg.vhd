library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;


use work.RISCV_types.all;



entity IF_DE_REG is
    generic(
        DATA_WIDTH  : integer   := 32
    );
    port (
        i_CLK           : in STD_LOGIC;
        i_RST           : in STD_LOGIC;
        i_WE            : in STD_LOGIC;
        i_FLUSH         : in STD_LOGIC;
        i_IF_DE_SIGS    : in IF_DE_SIGS;
        o_IF_DE_SIGS    : out IF_DE_SIGS
    );
end entity;

architecture rtl of IF_DE_REG is
    
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

    constant NOP    : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := x"00000013";

    signal s_INSTR  : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

begin

    with i_FLUSH select
        s_INSTR <=  NOP when '1',
                    i_IF_DE_SIGS.INSTR when others;


    ISTR_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => s_INSTR,
        o_DATA => o_IF_DE_SIGS.INSTR
    );

    PC_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_IF_DE_SIGS.PC,
        o_DATA => o_IF_DE_SIGS.PC
    );

    PC_PLUS_4_REG: reg
     generic map(
        DATA_WIDTH => DATA_WIDTH
    )
     port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_DATA => i_IF_DE_SIGS.PC_PLUS_4,
        o_DATA => o_IF_DE_SIGS.PC_PLUS_4
    );

end architecture;