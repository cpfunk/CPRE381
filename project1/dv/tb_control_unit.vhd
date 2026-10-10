

-- tb_second_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_unit is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control_unit;

architecture mixed of tb_control_unit is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

 component control_unit is
    port(i_opcode               : in  std_logic_vector(6 downto 0);   
         i_funct3               : in  std_logic_vector(2 downto 0);   
         i_funct7               : in  std_logic_vector(6 downto 0);  

         o_ALU_SRC_PC           : out std_logic;                      
         o_ALU_SRC              : out std_logic;                      
         o_REG_SRC              : out std_logic_vector(1 downto 0);   
         o_J_REG                : out std_logic;                      

         o_BRANCH               : out std_logic;                      
         o_JAL                  : out std_logic;                      

         o_REG_WE               : out std_logic;                      
         o_MEM_WRITE            : out std_logic;                      

         o_WRD                  : out std_logic;                      
         o_HWRD                 : out std_logic;                      
         o_UNSIGNED             : out std_logic;                     

         o_IMM_TYPE             : out std_logic_vector(2 downto 0);
         o_ALU_CTRL             : out std_logic_vector(3 downto 0);  
         o_Halt                 : out std_logic
    );
  end component;

  -- Clock signal
  signal s_CLK                  : std_logic := '0';

  -- DUT Inputs
  signal s_opcode               : std_logic_vector(6 downto 0) := (others => '0');
  signal s_funct3               : std_logic_vector(2 downto 0) := (others => '0');
  signal s_funct7               : std_logic_vector(6 downto 0) := (others => '0');

  -- DUT Outputs
  signal s_ALU_SRC_PC           : std_logic;
  signal s_ALU_SRC              : std_logic;
  signal s_REG_SRC              : std_logic_vector(1 downto 0);
  signal s_J_REG                : std_logic;
  signal s_BRANCH               : std_logic;
  signal s_JAL                  : std_logic;
  signal s_REG_WE               : std_logic;
  signal s_MEM_WRITE            : std_logic;
  signal s_WRD                  : std_logic;
  signal s_HWRD                 : std_logic;
  signal s_UNSIGNED             : std_logic;
  signal s_IMM_TYPE             : std_logic_vector(2 downto 0);
  signal s_ALU_CTRL             : std_logic_vector(3 downto 0);
  signal s_Halt                 : std_logic;

begin

  DUT0: control_unit
    port map(
      i_opcode                  => s_opcode,
      i_funct3                  => s_funct3,
      i_funct7                  => s_funct7,

      o_ALU_SRC_PC              => s_ALU_SRC_PC,
      o_ALU_SRC                 => s_ALU_SRC,
      o_REG_SRC                 => s_REG_SRC,
      o_J_REG                   => s_J_REG,

      o_BRANCH                  => s_BRANCH,
      o_JAL                     => s_JAL,

      o_REG_WE                  => s_REG_WE,
      o_MEM_WRITE               => s_MEM_WRITE,

      o_WRD                     => s_WRD,
      o_HWRD                    => s_HWRD,
      o_UNSIGNED                => s_UNSIGNED,

      o_IMM_TYPE                => s_IMM_TYPE,
      o_ALU_CTRL                => s_ALU_CTRL,
      o_Halt                    => s_Halt
    );

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    wait for gCLK_HPER/2;

    -- R-Type ADD
    s_opcode <= "0110011";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_ALU_SRC_PC = '0', o_ALU_SRC = '0' (rs1, rs2)
    -- o_REG_SRC    = "00" (ALU Result)
    -- o_REG_WE     = '1'
    -- o_ALU_CTRL   = "0000" (ADD)
    wait for cCLK_PER;

    -- R-Type SUB (checks funct7[5] modifier)
    s_opcode <= "0110011";
    s_funct3 <= "000";
    s_funct7 <= "0100000";
    -- Expected Outputs:
    -- o_ALU_SRC_PC = '0', o_ALU_SRC = '0'
    -- o_REG_WE     = '1'
    -- o_ALU_CTRL   = "1000" (SUB: bit 3 asserted)
    wait for cCLK_PER;

    -- I-Type ADDI with negative immediate (Inst[30] = '1')
    s_opcode <= "0010011";
    s_funct3 <= "000";
    s_funct7 <= "0100000"; -- Inst[30] is '1', but MUST NOT turn ADDI into SUB
    -- Expected Outputs:
    -- o_ALU_SRC    = '1'  (Immediate operand)
    -- o_REG_WE     = '1'
    -- o_IMM_TYPE   = "000" (I-type signed)
    -- o_ALU_CTRL   = "0000" (ADD, bit 3 must stay '0')
    wait for cCLK_PER;

    -- I-Type SRAI 
    s_opcode <= "0010011";
    s_funct3 <= "101";
    s_funct7 <= "0100000"; -- Inst[30] is '1', selects arithmetic shift
    -- Expected Outputs:
    -- o_ALU_SRC    = '1'  (Immediate operand)
    -- o_REG_WE     = '1'
    -- o_IMM_TYPE   = "001" (I-type shift)
    -- o_ALU_CTRL   = "1101" (SRA: bit 3 asserted)
    wait for cCLK_PER;

    -- Load Word 
    s_opcode <= "0000011";
    s_funct3 <= "010";     -- Word access
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_ALU_SRC    = '1'  (Base + offset)
    -- o_REG_SRC    = "01" (DMEM read data)
    -- o_REG_WE     = '1'
    -- o_WRD        = '1', o_HWRD = '0', o_UNSIGNED = '0'
    -- o_IMM_TYPE   = "000" (I-type signed)
    -- o_ALU_CTRL   = "0000" (Address ADD)
    wait for cCLK_PER;

    -- Load Halfword Unsigned 
    s_opcode <= "0000011";
    s_funct3 <= "101";     -- Unsigned halfword
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_REG_SRC    = "01" (DMEM read data)
    -- o_REG_WE     = '1'
    -- o_WRD        = '0', o_HWRD = '1', o_UNSIGNED = '1'
    -- o_IMM_TYPE   = "000"
    wait for cCLK_PER;

    -- Store Word 
    s_opcode <= "0100011";
    s_funct3 <= "010";     -- Word store
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_ALU_SRC    = '1'
    -- o_REG_WE     = '0'  (Stores must NOT write to RegFile)
    -- o_MEM_WRITE  = '1'  (DMEM write enable)
    -- o_WRD        = '1', o_HWRD = '0'
    -- o_IMM_TYPE   = "010" (S-type)
    -- o_ALU_CTRL   = "0000" (Address ADD)
    wait for cCLK_PER;

    -- Store Byte (SB)
    s_opcode <= "0100011";
    s_funct3 <= "000";     -- Byte store
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_REG_WE     = '0'
    -- o_MEM_WRITE  = '1'
    -- o_WRD        = '0', o_HWRD = '0' (Byte implied)
    -- o_IMM_TYPE   = "010" (S-type)
    wait for cCLK_PER;

    -- Branch Equal (BEQ)
    s_opcode <= "1100011";
    s_funct3 <= "000";     -- BEQ condition code
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_ALU_SRC    = '0'  (Compares rs1 and rs2)
    -- o_BRANCH     = '1'  (Branch flag asserted)
    -- o_REG_WE     = '0'
    -- o_MEM_WRITE  = '0'
    -- o_IMM_TYPE   = "100" (SB-type branch offset)
    -- o_ALU_CTRL   = "0000" (Condition code forwarded)
    wait for cCLK_PER;

    -- Branch Less Than Signed (BLT)
    s_opcode <= "1100011";
    s_funct3 <= "100";     -- BLT condition code
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_BRANCH     = '1'
    -- o_IMM_TYPE   = "100" (SB-type)
    -- o_ALU_CTRL   = "0100" (BLT code forwarded)
    wait for cCLK_PER;

    -- JAL 
    s_opcode <= "1101111";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_JAL        = '1'  (Directly triggers Next-PC Mux)
    -- o_REG_SRC    = "10" (Link address PC + 4)
    -- o_REG_WE     = '1'  (Saves link address into rd)
    -- o_IMM_TYPE   = "101" (UJ-type target offset)
    wait for cCLK_PER;

    -- JALR (Register Indirect Jump and Link)
    s_opcode <= "1100111";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_J_REG      = '1'  (Next-PC Mux selects ALU output)
    -- o_REG_SRC    = "10" (Link address PC + 4)
    -- o_REG_WE     = '1'
    -- o_ALU_SRC    = '1'  (rs1 + 12-bit Imm)
    -- o_IMM_TYPE   = "000" (I-type signed)
    wait for cCLK_PER;

    -- LUI 
    s_opcode <= "0110111";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_REG_SRC    = "11" (Selects raw Immediate bus)
    -- o_REG_WE     = '1'
    -- o_IMM_TYPE   = "011" (U-type immediate)
    wait for cCLK_PER;

    -- AUIPC (Add Upper Immediate to PC)
    s_opcode <= "0010111";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_ALU_SRC_PC = '1'  (ALU Port A selects PC)
    -- o_ALU_SRC    = '1'  (ALU Port B selects Immediate)
    -- o_REG_SRC    = "00" (Write back calculated ALU result)
    -- o_REG_WE     = '1'
    -- o_IMM_TYPE   = "011" (U-type)
    -- o_ALU_CTRL   = "0000" (Addition)
    wait for cCLK_PER;

    -- HALT / WFI (Wait For Interrupt)
    s_opcode <= "1110011";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_Halt       = '1'  (Signals testbench halt)
    -- o_REG_WE     = '0'
    wait for cCLK_PER;

    -- Unknown Opcode (Default / Reset state)
    s_opcode <= "0000000";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    -- Expected Outputs:
    -- o_MEM_WRITE  = '0'
    -- o_Halt       = '0'
    -- o_ALU_CTRL   = "0000"
    wait for cCLK_PER;

    wait for cCLK_PER * 2;
    wait;
  end process;
  
end mixed;
