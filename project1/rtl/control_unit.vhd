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

entity control_unit is
  port(-- Instruction field inputs
     i_opcode               : in  std_logic_vector(6 downto 0);   
     i_funct3               : in  std_logic_vector(2 downto 0);   
     i_funct7               : in  std_logic_vector(6 downto 0);  

     -- Multiplexer selectors
     o_ALU_SRC_PC           : out std_logic;                      
     o_ALU_SRC              : out std_logic;                      
     o_REG_SRC              : out std_logic_vector(1 downto 0);   
     o_J_REG                : out std_logic;                      

     -- Control-Flow Flags 
     o_BRANCH               : out std_logic;                      
     o_JAL                  : out std_logic;                      

     -- Register file & Data memory enables
     o_REG_WE               : out std_logic;                      
     o_MEM_WRITE            : out std_logic;                      

     -- Sub-word memory controls 
     o_WRD                  : out std_logic;                      
     o_HWRD                 : out std_logic;                      
     o_UNSIGNED             : out std_logic;                     

     -- Immediate generator format selection
     o_IMM_TYPE             : out std_logic_vector(2 downto 0);

     -- Execution & Framework controls
     o_ALU_CTRL             : out std_logic_vector(3 downto 0);  
     o_Halt                 : out std_logic);
end entity control_unit;

architecture dataflow of control_unit is

-- Standard RV32I Opcodes
  constant OP_R_TYPE       : std_logic_vector(6 downto 0) := "0110011";
  constant OP_I_ARITH      : std_logic_vector(6 downto 0) := "0010011";
  constant OP_LOAD         : std_logic_vector(6 downto 0) := "0000011";
  constant OP_STORE        : std_logic_vector(6 downto 0) := "0100011";
  constant OP_BRANCH       : std_logic_vector(6 downto 0) := "1100011";
  constant OP_JAL          : std_logic_vector(6 downto 0) := "1101111";
  constant OP_JALR         : std_logic_vector(6 downto 0) := "1100111";
  constant OP_LUI          : std_logic_vector(6 downto 0) := "0110111";
  constant OP_AUIPC        : std_logic_vector(6 downto 0) := "0010111";
  constant OP_SYSTEM       : std_logic_vector(6 downto 0) := "1110011";

  -- Internal decode flags
  signal s_sub_sra          : std_logic;

begin

 -- CONTROL FLOW FLAGS 
  o_BRANCH <=               '1' when (i_opcode = OP_BRANCH) 
                                else '0';
  o_JAL    <=               '1' when (i_opcode = OP_JAL)    
                                else '0';
  o_J_REG  <=               '1' when (i_opcode = OP_JALR)   
                                else '0';


 -- ALU OPERAND SOURCE MUX
  -- 1 = PC (AUIPC only) 
  -- 0 = rs1 
  o_ALU_SRC_PC <=           '1' when (i_opcode = OP_AUIPC) 
                                else '0';
  -- 0 = rs2 (R-type, Branch)
  -- 1 = Immediate (all others)
  with i_opcode select
    o_ALU_SRC <=            '0' when OP_R_TYPE | OP_BRANCH,
                            '1' when others; 


 --REGFILE SORUCE MUX (o_REG_SRC)
  -- 00 = ALU Result
  -- 01 = Data Memory Read
  -- 10 = PC + 4 Link Address
  -- 11 = Upper Immediate
  with i_opcode select
    o_REG_SRC <=            "01" when OP_LOAD,
                            "10" when OP_JAL | OP_JALR,
                            "11" when OP_LUI,
                            "00" when others;


 -- REGFILE & MEMORY WE 
  with i_opcode select
    o_REG_WE <=             '1' when OP_R_TYPE 
                                   | OP_I_ARITH 
                                   | OP_LOAD 
                                   | OP_JAL 
                                   | OP_JALR 
                                   | OP_LUI 
                                   | OP_AUIPC,
                            '0' when others;

  o_MEM_WRITE <=            '1' when (i_opcode = OP_STORE) 
                                else '0';


 -- SUBWORD MEMORY DECODING 
  o_WRD <=                  '1' when (i_opcode = OP_LOAD or i_opcode = OP_STORE) 
                                and (i_funct3 = "010")
                                else '0';

  o_HWRD <=                 '1' when (i_opcode = OP_LOAD or i_opcode = OP_STORE) 
                                and (i_funct3 = "001" or i_funct3 = "101") 
                                else '0';

  o_UNSIGNED <=             '1' when (i_opcode = OP_LOAD) 
                                and (i_funct3 = "100" or i_funct3 = "101") 
                                else '0';


 --IMM GEN FORMAT
  -- signal table: 
    -- "001" : I - unsigned (based on method used needs to be first check)
    -- "000" : I - signed
    -- "010" : S
    -- "011" : U
    -- "100" : SB
    -- "101" : UJ
    -- "110" : I - signed
    -- "111" : I - unsigned
  o_IMM_TYPE <=             "001" when (i_opcode = OP_I_ARITH and (i_funct3 = "001" or i_funct3 = "101")) else
                            "000" when (i_opcode = OP_I_ARITH or i_opcode = OP_LOAD or i_opcode = OP_JALR) else
                            "010" when (i_opcode = OP_STORE) else
                            "011" when (i_opcode = OP_LUI or i_opcode = OP_AUIPC) else
                            "100" when (i_opcode = OP_BRANCH) else
                            "101" when (i_opcode = OP_JAL) else
                            "000";                                


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
    o_ALU_CTRL <=           s_sub_sra & i_funct3 when OP_R_TYPE,
                            s_sub_sra & i_funct3 when OP_I_ARITH,
                            '0'       & i_funct3 when OP_BRANCH,   
                            "0000"               when others;     


 --TERMINATION
  o_Halt <=                 '1' when (i_opcode = OP_SYSTEM) else '0';

end dataflow;