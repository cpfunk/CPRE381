-- Christopher Funk & Jamison Bice
-- Department of Electrical and Computer Engineering
-- Iowa State University

-- control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: File contains a RISC-V datapath
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.all;

entity control_unit is
  port(
    i_opcode                : in  std_logic_vector(6 downto 0);   
    i_funct3                : in  std_logic_vector(2 downto 0);   
    i_funct7                : in  std_logic_vector(6 downto 0);
    i_funct12               : in  std_logic_vector(11 downto 0);
    
    o_CTRL_SIGS             : out CTRL_SIGS;
    o_IMM_TYPE              : out std_logic_vector(2 downto 0)
  );
end entity control_unit;
    

architecture dataflow of control_unit is

-- Standard RV32I Opcodes
  constant OP_R_TYPE        : std_logic_vector(6 downto 0) := "0110011";
  constant OP_I_ARITH       : std_logic_vector(6 downto 0) := "0010011";
  constant OP_LOAD          : std_logic_vector(6 downto 0) := "0000011";
  constant OP_STORE         : std_logic_vector(6 downto 0) := "0100011";
  constant OP_BRANCH        : std_logic_vector(6 downto 0) := "1100011";
  constant OP_JAL           : std_logic_vector(6 downto 0) := "1101111";
  constant OP_JALR          : std_logic_vector(6 downto 0) := "1100111";
  constant OP_LUI           : std_logic_vector(6 downto 0) := "0110111";
  constant OP_AUIPC         : std_logic_vector(6 downto 0) := "0010111";
  constant OP_SYSTEM        : std_logic_vector(6 downto 0) := "1110011";

 -- wifi funct12  
  constant FUNCT12_WIFI     : std_logic_vector(11 downto 0) := "000100000101";

  -- Internal decode flags
  signal s_sub_sra          : std_logic;

begin

 -- ALU OPERAND SOURCE MUX
  -- "01" = PC (AUIPC only) 
  -- "00" = rs1 
  o_CTRL_SIGS.ALU_SRC_PC <= "01" when (i_opcode = OP_AUIPC) 
                            else "00";

  -- "00" = rs2 (R-type, Branch)
  -- "01" = Immediate (all others)
  with i_opcode select
    o_CTRL_SIGS.ALU_SRC <=  "00" when OP_R_TYPE | OP_BRANCH,
                            "01" when others;


 --REGFILE SORUCE MUX (o_REG_SRC)
  -- 00 = ALU Result
  -- 01 = Data Memory Read
  -- 10 = PC + 4 Link Address
  -- 11 = Upper Immediate
  with i_opcode select
    o_CTRL_SIGS.REG_SRC <=            "01" when OP_LOAD,
                            "10" when OP_JAL | OP_JALR,
                            "11" when OP_LUI,
                            "00" when others;


 -- REGFILE & MEMORY WE 
  with i_opcode select
    o_CTRL_SIGS.REG_WE <=             '1' when OP_R_TYPE 
                                   | OP_I_ARITH 
                                   | OP_LOAD 
                                   | OP_JAL 
                                   | OP_JALR 
                                   | OP_LUI 
                                   | OP_AUIPC,
                            '0' when others;

  o_CTRL_SIGS.MEM_WRITE <=            '1' when (i_opcode = OP_STORE) 
                                else '0';


 -- SUBWORD MEMORY DECODING 
  o_CTRL_SIGS.WRD <=                  '1' when (i_opcode = OP_LOAD or i_opcode = OP_STORE) 
                                and (i_funct3 = "010")
                                else '0';

  o_CTRL_SIGS.HWRD <=                 '1' when (i_opcode = OP_LOAD or i_opcode = OP_STORE) 
                                and (i_funct3 = "001" or i_funct3 = "101") 
                                else '0';

  o_CTRL_SIGS.UNSIGNED <=             '1' when (i_opcode = OP_LOAD) 
                                and (i_funct3 = "100" or i_funct3 = "101") 
                                else '0';


 --IMM GEN FORMAT
  -- signal table: 
  -- "000"  : I
  -- "001"  : S
  -- "010"  : U
  -- "011"  : SB
  -- "100"  : UJ
  -- others : I
  with i_opcode select
    o_IMM_TYPE <=           "000" when OP_I_ARITH,
                            "001" when OP_STORE,
                            "010" when OP_LUI     | OP_AUIPC,
                            "011" when OP_BRANCH,
                            "100" when OP_JAL,
                            "000" when others; -- defaults to I-type
                  

 -- ALU OPERATION CONTROL  
  -- ALU_CTRL[3]      : (1 ->SUBTRACT or SHIFT_RIGHT_SIGNED , 0 -> UNSIGNED or ADD)
  s_sub_sra <=              i_funct7(5) when (i_opcode = OP_R_TYPE) else 
                            i_funct7(5) when (i_opcode = OP_I_ARITH and i_funct3 = "101") 
                            else '0';

  -- ALU_CTRL[2:0]    : (000 -> ADD/SUB
  --                     001 -> SLL
  --                     010 -> SLT    
  --                     011 -> SLTU 
  --                     100 -> XOR
  --                     101 -> SRL
  --                     110 -> OR
  --                     111 -> AND)
  --(BRANCH) : (000 -> BEQ  
  --            001 -> BNE  
  --            100 -> BLT  
  --            101 -> BGE  
  --            110 -> BLTU 
  --            111 -> BGEU 
  --            010 / 011 -> Unused)
  with i_opcode select
    o_CTRL_SIGS.ALU_CTRL <=     s_sub_sra & i_funct3 when OP_R_TYPE,
                                  s_sub_sra & i_funct3 when OP_I_ARITH,
                                  "1000"               when OP_BRANCH,   
                                  "0000"               when others;     


 --TERMINATION
  o_CTRL_SIGS.N_HALT     <= '0' when (i_opcode = OP_SYSTEM and i_funct3 = "000" and i_funct12 = FUNCT12_WIFI) else '1';

end dataflow;