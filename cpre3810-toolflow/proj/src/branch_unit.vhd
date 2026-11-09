library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity BRANCH_UNIT is
    port(
        i_opcode     : in  std_logic_vector(6 downto 0);
        i_funct3     : in  std_logic_vector(2 downto 0);
        i_LT         : in  std_logic;
        i_LTU        : in  std_logic;
        i_EQ         : in  std_logic;
        o_J_REG      : out std_logic;
        o_PC_ADD_IMM : out std_logic
    );
end entity;

architecture rtl of BRANCH_UNIT is

    -- Standard RV32I Opcodes
    constant OP_BRANCH        : std_logic_vector(6 downto 0) := "1100011";
    constant OP_JAL           : std_logic_vector(6 downto 0) := "1101111";
    constant OP_JALR          : std_logic_vector(6 downto 0) := "1100111";

    -- Signals for control flow
    signal s_NE               : std_logic;
    signal s_GE               : std_logic;
    signal s_GEU              : std_logic;

begin

    -- CONTROL FLOW SIGNALS
    s_NE  <=    not i_EQ;
    s_GE  <=    not i_LT;
    s_GEU <=    not i_LTU;

    o_J_REG <=  '1' when (i_opcode = OP_JALR) else '0';

    --(BRANCH) : (000 -> BEQ  
    --            001 -> BNE  
    --            100 -> BLT  
    --            101 -> BGE  
    --            110 -> BLTU 
    --            111 -> BGEU 
    --            010 / 011 -> Unused)
    
    -- CONDITIONAL BRANCHING TYPE MUX
    o_PC_ADD_IMM <= '1'   when (i_opcode = OP_JAL) else
                    i_EQ  when (i_opcode = OP_BRANCH and i_funct3 = "000") else
                    s_NE  when (i_opcode = OP_BRANCH and i_funct3 = "001") else
                    i_LT  when (i_opcode = OP_BRANCH and i_funct3 = "100") else
                    s_GE  when (i_opcode = OP_BRANCH and i_funct3 = "101") else
                    i_LTU when (i_opcode = OP_BRANCH and i_funct3 = "110") else
                    s_GEU when (i_opcode = OP_BRANCH and i_funct3 = "111") else
                    '0';

end architecture;