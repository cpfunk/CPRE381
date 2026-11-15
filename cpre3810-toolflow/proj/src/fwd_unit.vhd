library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity FWD_UNIT is
    port(
        i_RS1           : in STD_LOGIC_VECTOR(4 downto 0);
        i_RS2           : in STD_LOGIC_VECTOR(4 downto 0);
        i_MEM_REG_WRITE : in STD_LOGIC;
        i_MEM_REG_SRC   : in STD_LOGIC_VECTOR(1 downto 0);
        i_WB_REG_WRITE  : in STD_LOGIC;
        i_RD_MEM        : in STD_LOGIC_VECTOR(4 downto 0);
        i_RD_WB         : in STD_LOGIC_VECTOR(4 downto 0);
        i_ALU_SEL_S1    : in STD_LOGIC_VECTOR(1 downto 0);
        i_ALU_SEL_S2    : in STD_LOGIC_VECTOR(1 downto 0);
        o_SEL_S1        : out STD_LOGIC_VECTOR(1 downto 0);
        o_SEL_S2        : out STD_LOGIC_VECTOR(1 downto 0);
        o_EX_STALL      : out STD_LOGIC
    );
end entity;

architecture rtl of FWD_UNIT is

    constant SEL_MEM : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant SEL_WB  : STD_LOGIC_VECTOR(1 downto 0) := "11";
    

    signal s_LOAD_USE       : STD_LOGIC;
    signal s_RS1_IN_MEM     : STD_LOGIC;
    signal s_RS2_IN_MEM     : STD_LOGIC;

    signal s_RS1_IN_WB      : STD_LOGIC;
    signal s_RS2_IN_WB      : STD_LOGIC;

    signal s_RS1_LOAD_USE   : STD_LOGIC; 
    signal s_RS2_LOAD_USE   : STD_LOGIC;
begin

    s_RS1_IN_MEM    <=  '1' when ((i_RD_MEM = i_RS1) and (i_MEM_REG_WRITE = '1')) else '0';
    s_RS2_IN_MEM    <=  '1' when ((i_RD_MEM = i_RS2) and (i_MEM_REG_WRITE = '1')) else '0';

    s_RS1_IN_WB     <=  '1' when ((i_RD_WB = i_RS1) and (i_WB_REG_WRITE = '1')) else '0';
    s_RS2_IN_WB     <=  '1' when ((i_RD_WB = i_RS2) and (i_WB_REG_WRITE = '1')) else '0';

    s_RS1_LOAD_USE  <=  '1' when (s_RS1_IN_MEM = '1') and (i_MEM_REG_WRITE = '1') and (i_MEM_REG_SRC = "01") else '0';
    s_RS2_LOAD_USE  <=  '1' when (s_RS2_IN_MEM = '1') and (i_MEM_REG_WRITE = '1') and (i_MEM_REG_SRC = "01") else '0';

    -- for load-use hazards, the instruction needs to stay in the EX stage
    -- until the needed data moves to the WB stage. So, while the data is in the MEM stage, the o_EX_STALL signal must be asserted
    o_EX_STALL      <=  s_RS1_LOAD_USE or s_RS2_LOAD_USE;

    o_SEL_S1        <=  SEL_MEM when (s_RS1_IN_MEM and (not s_RS1_LOAD_USE)) else 
                        SEL_WB  when (s_RS1_IN_WB  and (not s_RS1_LOAD_USE)) else
                        i_ALU_SEL_S1;
                
    o_SEL_S2        <=  SEL_MEM when (s_RS2_IN_MEM and (not s_RS2_LOAD_USE)) else 
                        SEL_WB  when (s_RS2_IN_WB  and (not s_RS2_LOAD_USE)) else
                        i_ALU_SEL_S2;


end architecture;