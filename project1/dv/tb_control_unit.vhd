

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
    port(i_opcode    			: in  std_logic_vector(6 downto 0);
	       o_ALUSrcPC   		: out std_logic;
         o_ALUSrc         : out std_logic;
         o_RegWrite       : out std_logic;
         o_MemWrite       : out std_logic;
         o_MemRead        : out std_logic;
         o_ResultSrc      : out std_logic_vector(1 downto 0); 
         o_Branch         : out std_logic;
         o_Jump           : out std_logic_vector(1 downto 0); 
         o_ImmType        : out std_logic_vector(2 downto 0);
         o_ALUOp          : out std_logic_vector(1 downto 0); 
         o_Halt           : out std_logic);
  end component;

  signal s_CLK            : std_logic := '0';
  signal s_opcode         : std_logic_vector(6 downto 0) := (others => '0');

  signal s_ALUSrcPC       : std_logic;
  signal s_ALUSrc         : std_logic;
  signal s_RegWrite       : std_logic;
  signal s_MemWrite       : std_logic;
  signal s_MemRead        : std_logic;
  signal s_ResultSrc      : std_logic_vector(1 downto 0);
  signal s_Branch         : std_logic;
  signal s_Jump           : std_logic_vector(1 downto 0);
  signal s_ImmType        : std_logic_vector(2 downto 0);
  signal s_ALUOp          : std_logic_vector(1 downto 0);
  signal s_Halt           : std_logic;

begin

  DUT0: control_unit
    port map(i_opcode     => s_opcode,
             o_ALUSrcPC   => s_ALUSrcPC,
             o_ALUSrc     => s_ALUSrc,
             o_RegWrite   => s_RegWrite,
             o_MemWrite   => s_MemWrite,
             o_MemRead    => s_MemRead,
             o_ResultSrc  => s_ResultSrc,
             o_Branch     => s_Branch,
             o_Jump       => s_Jump,
             o_ImmType    => s_ImmType,
             o_ALUOp      => s_ALUOp,
             o_Halt       => s_Halt
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

	--R-Type 
    s_opcode <= "0110011";
    -- Expected Outputs:
    -- RegWrite  = '1'  (Write back ALU result to destination register rd)
    -- ALUOp     = "10" (Evaluate Funct3 / Funct7 for exact operation)
    wait for cCLK_PER;

    --I-Type ALU 
    s_opcode <= "0010011";
    -- Expected Outputs:
    -- ALUSrc   = '1'  (Operand B is sign-extended immediate)
    -- RegWrite  = '1'  (Write back ALU result to destination register rd)
    -- ALUOp     = "10" (Evaluate Funct3 / Funct7 for exact operation)
    wait for cCLK_PER;

    --Loads 
    s_opcode <= "0000011";
    -- Expected Outputs:
    -- ALUSrc   = '1'  (Operand B is 12-bit offset immediate)
    -- RegWrite  = '1'  (Write loaded memory data into register rd)
    -- MemRead   = '1'  (Assert read enable to data memory)
    -- ResultSrc = "01" (Write-Back Mux selects Data Memory output)
    wait for cCLK_PER;

    --Stores 
    s_opcode <= "0100011";
    -- Expected Outputs:
    -- ALUSrc   = '1'  (Operand B is split 12-bit offset immediate)
    -- MemWrite  = '1'  (Assert write enable to data memory)
    -- ImmType   = "001" (S-type immediate format)
    wait for cCLK_PER;

    --Branches 
    s_opcode <= "1100011";
    -- Expected Outputs:
    -- Branch    = '1'  (Branch flag asserted to branch comparator logic)
    -- ImmType   = "010" (B-type immediate format)
    -- ALUOp     = "01" (ALU performs condition evaluation / subtraction)
    wait for cCLK_PER;

    --JAL 
    s_opcode <= "1101111";
    -- Expected Outputs:
    -- RegWrite  = '1'  (Save PC + 4 return link address into rd)
    -- ResultSrc = "10" (Write-Back Mux selects PC + 4)
    -- Jump      = "01" (PC Mux selects PC + Imm target)
    -- ImmType   = "100" (J-type immediate format)
    wait for cCLK_PER;

    --JALR 
    s_opcode <= "1100111";
    -- Expected Outputs:
    -- ALUSrc   = '1'  (Operand B is 12-bit offset immediate)
    -- RegWrite  = '1'  (Save PC + 4 return link address into rd)
    -- ResultSrc = "10" (Write-Back Mux selects PC + 4)
    -- Jump      = "10" (PC Mux selects rs1 + Imm target)
    wait for cCLK_PER;

    --LUI 
    s_opcode <= "0110111";
    -- Expected Outputs:
    -- ALUSrc   = '1'  (Immediate operand routed)
    -- RegWrite  = '1'  (Write upper immediate into destination rd)
    -- ResultSrc = "11" (Write-Back Mux selects Immediate directly)
    -- ImmType   = "011" (U-type immediate format)
    wait for cCLK_PER;

    --AUIPC 
    s_opcode <= "0010111";
    -- Expected Outputs:
    -- ALUSrcPC   = '1'  (Operand A selects current Program Counter PC)
    -- ALUSrc   = '1'  (Operand B selects shifted U-type immediate)
    -- RegWrite  = '1'  (Write calculated PC + Upper Imm into rd)
    -- ImmType   = "011" (U-type immediate format)
    wait for cCLK_PER;

    --HALT 
    s_opcode <= "1110011";
    -- Expected Outputs:
    -- Halt      = '1'  
    wait for cCLK_PER;

    --Unknown / Default Opcode Handling
    s_opcode <= "0000000";
  
    wait for cCLK_PER;

    wait for cCLK_PER * 2;
    wait;
  end process;
  
end mixed;
