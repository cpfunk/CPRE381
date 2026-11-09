-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RISCV_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a RISCV_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-- 04/10/2025 by AP::Coverted to RISC-V.
-- 02/19/2026 by H3::Renamed PC and handled OVFL
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  RISCV_Processor;

architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_PC instead
  signal s_PC           : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Use WFI with Opcode: 111 0011 func3: 000 and func12: 000100000101 -- func12 is imm field from I-format)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          be           : in std_logic_vector(3 downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  component reg_file is
        generic(
            DATA_WIDTH        : INTEGER := 32;
            NUM_REGS    : INTEGER := 32
        );
        port (
            i_CLK   : in STD_LOGIC;
            i_RST   : in STD_LOGIC;
            i_WE    : in STD_LOGIC;
            i_RD    : in STD_LOGIC_VECTOR(4 downto 0);
            i_RS    : in STD_LOGIC_VECTOR_ARRAY(1 downto 0)(4 downto 0);
            i_DATA  : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_DATA  : out STD_LOGIC_VECTOR_ARRAY(1 downto 0)(DATA_WIDTH-1 downto 0)
        );
    end component;

  component control_unit is
    port(
        -- Instruction field inputs
        i_opcode               : in  std_logic_vector(6 downto 0);   
        i_funct3               : in  std_logic_vector(2 downto 0);   
        i_funct7               : in  std_logic_vector(6 downto 0);
        i_funct12              : in  std_logic_vector(11 downto 0);
        o_CTRL_SIGS            : out CTRL_SIGS;

        -- Immediate generator format selection
        o_IMM_TYPE             : out std_logic_vector(2 downto 0)
      );
    end component;

    component branch_unit is
    port(
      i_opcode     : in  std_logic_vector(6 downto 0);
      i_funct3     : in  std_logic_vector(2 downto 0);
      i_LT         : in  std_logic;
      i_LTU        : in  std_logic;
      i_EQ         : in  std_logic;
      o_J_REG      : out std_logic;
      o_PC_ADD_IMM : out std_logic
    );
  end component;

  component MEM_WB_REG is
    generic(
      DATA_WIDTH : integer := 32
    );
    port (
      i_CLK         : in STD_LOGIC;
      i_RST         : in STD_LOGIC;
      i_WE          : in STD_LOGIC;
      i_FLUSH       : in STD_LOGIC;
      i_MEM_WB_SIGS : in MEM_WB_SIGS;
      o_MEM_WB_SIGS : out MEM_WB_SIGS
    );
  end component;

    component BUS_MUX_NTO1 is
        generic(
            DATA_WIDTH: INTEGER       := 32;
            LOG2_N: INTEGER     := 5;
            N: INTEGER          := 32
        );
        port(
            i_S: in STD_LOGIC_VECTOR(LOG2_N-1 downto 0);
            i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(DATA_WIDTH - 1 downto 0);
            o_DATA: out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
        );
    end component;

    component imm_ctrl is
        port (
            i_IMM_TYPE  : in STD_LOGIC_VECTOR(2 downto 0);
            -- i_IMM_TYPE table: 
            -- "000" : I - signed
            -- "001" : I - unsigned
            -- "010" : S
            -- "011" : U
            -- "100" : SB
            -- "101" : UJ
            -- "110" : I - signed
            -- "111" : I - unsigned
            i_DATA      : in STD_LOGIC_VECTOR(31 downto 0);
            o_DATA      : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component ALU_32BIT is
      generic (
          DATA_WIDTH : INTEGER := 32
      );
      port (
          i_ALU_CTRL  : in STD_LOGIC_VECTOR(3 downto 0);
          -- ALU_CTRL BIT MEANINGS: 
          -- ALU_CTRL[3]      : ('1' : SHIFT_RIGHT_SIGNED or SUBTRACT, '0' : UNSIGNED or ADD) 
          -- ALU_CTRL[2:0]    :  (000 -> ADD/SUB
          --                      001 -> SLL
          --                      010 -> SLT  (set less than)
          --                      011 -> SLTU (set less than unsigned)
          --                      100 -> XOR
          --                      101 -> SRL or SRA
          --                      110 -> OR
          --                      111 -> AND)
          i_A         : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
          i_B         : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
          o_RESULT    : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
          o_EQUAL     : out STD_LOGIC;
          o_LT        : out STD_LOGIC;
          o_LTU       : out STD_LOGIC;
          o_OF        : out STD_LOGIC
      );
    end component;

    component PC is
        generic(
            DATA_WIDTH : INTEGER := 32
        );
        port (
            i_CLK   : in STD_LOGIC;
            i_RST   : in STD_LOGIC;
            i_HALT  : in STD_LOGIC;
            i_NEXT  : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_PC    : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
        );
    end component;

    component ADDER_32BIT is
        generic (
            DATA_WIDTH: INTEGER := 32
        );
        port(
            i_C     : in STD_LOGIC;
            i_A     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            i_B     : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_F     : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            o_C     : out STD_LOGIC;
            o_OF    : out STD_LOGIC
        );
    end component;

    component subword_write is
      port(-- Control inputs from Control Unit
          i_sh          : in  std_logic;                      
          i_sw          : in  std_logic; 

          --Datapath inputs
          i_addr        : in  std_logic_vector(31 downto 0);  
          i_data        : in  std_logic_vector(31 downto 0);
          --inputs to mem.vhd
          o_be          : out std_logic_vector(3 downto 0);                     
          o_data        : out std_logic_vector(31 downto 0));   
    end component;

    component subword_read is
      port(
          i_unsigned        : in  std_logic;                   
          i_lw               : in  std_logic;                      
          i_lh               : in  std_logic;               
          i_byte_offset      : in  std_logic_vector(1 downto 0); 
          i_data             : in  std_logic_vector(31 downto 0); 
          o_data             : out std_logic_vector(31 downto 0));
    end component;

    component IF_DE_REG is
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
  end component;

  component DE_EX_REG is
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
  end component;

  component EX_MEM_REG is
    generic(
        DATA_WIDTH  : integer   := 32
    );
    port (
        i_CLK           : in STD_LOGIC;
        i_RST           : in STD_LOGIC;
        i_WE            : in STD_LOGIC;
        i_FLUSH         : in STD_LOGIC;
        i_EX_MEM_SIGS   : in EX_MEM_SIGS;
        o_EX_MEM_SIGS    : out EX_MEM_SIGS
    );
  end component;

    -------------------
    --  CONSTANTS    --
    -------------------
    constant NUM_REGS   : INTEGER := 32;

    -----------------
    --  SIGNALS    --
    -----------------

    -- Control flow signals
      signal s_J_REG                  : std_logic;
      signal s_PC_ADD_IMM             : STD_LOGIC;

    -- Immediate generator format selection
      signal s_IMM_TYPE               : std_logic_vector(2 downto 0);

    -- for reg_file
      signal s_REG_IN_DATA            : STD_LOGIC_VECTOR(31 downto 0);
        
    -- for ALU
      signal s_ALU_OUT                : STD_LOGIC_VECTOR(N - 1 downto 0);
      signal s_EQUAL                  : STD_LOGIC;
      signal s_LESS_THAN              : STD_LOGIC;
      signal s_LESS_THAN_UNSIGNED     : STD_LOGIC; 

    -- misc
      signal s_N_HALT                 : STD_LOGIC;
      signal s_ALU_SRC_PC_MUX_OUT     : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_ALU_SRC_MUX_OUT        : STD_LOGIC_VECTOR(N-1 downto 0);

      signal s_PC_ADD_IMM_MUX_OUT     : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_PC_ADD_IMM_OUT         : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_J_REG_MUX_OUT          : STD_LOGIC_VECTOR(N-1 downto 0);

    -- dmem signals
      signal s_be               : std_logic_vector(3 downto 0);
      signal s_raw_q            : std_logic_vector(N-1 downto 0);

    -- for pipeline stages
      signal s_IF_DE_IN   : IF_DE_SIGS;
      signal s_IF_DE_OUT  : IF_DE_SIGS;

      signal s_DE_EX_IN   : DE_EX_SIGS;
      signal s_DE_EX_OUT  : DE_EX_SIGS;

      signal s_EX_MEM_IN  : EX_MEM_SIGS;
      signal s_EX_MEM_OUT : EX_MEM_SIGS;

      signal s_MEM_WB_IN  : MEM_WB_SIGS;
      signal s_MEM_WB_OUT : MEM_WB_SIGS;

begin
  s_Ovfl <= '0'; -- RISC-V does not have hardware overflow detection.

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)

  -- TODO: Implement the rest of your processor below this comment!
  --------------------------
  --  SIGNAL ASSIGNMENTS  --
  --------------------------
  s_Halt    <= not s_MEM_WB_OUT.CTRL_SIGS.N_HALT;
  s_N_HALT  <= s_MEM_WB_OUT.CTRL_SIGS.N_HALT;
  s_RegWr   <= s_MEM_WB_OUT.CTRL_SIGS.REG_WE and s_N_HALT;
  oALUOut   <= s_ALU_OUT;


  --------------
  -- #1 FETCH --
  --------------
  
  PC_inst: PC
   generic map(
      DATA_WIDTH => DATA_WIDTH
  )
   port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_HALT => s_HALT,
      i_NEXT => s_PC_ADD_IMM_MUX_OUT,
      o_PC => s_IF_DE_IN.PC
  );

  s_PC <= s_IF_DE_IN.PC;

  PC_J_REG_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      N => 2,
      LOG2_N => 1
  )
    port map(
      i_S => (0 => s_J_REG),
      i_DATA => (0 => s_IF_DE_IN.PC_PLUS_4, 1 => s_ALU_OUT),
      o_DATA => s_J_REG_MUX_OUT
  );

  PC_ADD_IMM_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      N => 2,
      LOG2_N => 1
  )
    port map(
      i_S => (0 => s_PC_ADD_IMM),
      i_DATA => (0 => s_J_REG_MUX_OUT, 1 => s_PC_ADD_IMM_OUT),
      o_DATA => s_PC_ADD_IMM_MUX_OUT
  );

  ADD_4_ADDER: ADDER_32BIT
    generic map(
      DATA_WIDTH => N
  )
    port map(
      i_C => '0',
      i_A => s_IF_DE_IN.PC,
      i_B => x"0000_0004",
      o_F => s_IF_DE_IN.PC_PLUS_4
  );

  ADD_IMM_ADDER: ADDER_32BIT
    generic map(
      DATA_WIDTH => N
  )
    port map(
      i_C => '0',
      i_A => s_DE_EX_OUT.PC,     
      i_B => s_DE_EX_OUT.IMM,
      o_F => s_PC_ADD_IMM_OUT
  );

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_PC when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             be   => "1111",
             we   => iInstLd,
             q    => s_IF_DE_IN.INSTR);

  s_Inst <= s_IF_DE_IN.INSTR;

  ---------------
  -- #2 DECODE --
  ---------------
  
  -- decode pass through signal assignments
  s_DE_EX_IN.PC_PLUS_4  <= s_IF_DE_OUT.PC_PLUS_4;
  s_DE_EX_IN.PC         <= s_IF_DE_OUT.PC;
  s_DE_EX_IN.RD         <= s_IF_DE_OUT.INSTR(11 downto 7);
  s_DE_EX_IN.FUNCT3     <= s_IF_DE_OUT.INSTR(14 downto 12);

  IF_DE_REG_inst: IF_DE_REG
   generic map(
      DATA_WIDTH => DATA_WIDTH
  )
   port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_WE => s_N_HALT,
      i_FLUSH => '0', -- FIXME
      i_IF_DE_SIGS => s_IF_DE_IN,
      o_IF_DE_SIGS => s_IF_DE_OUT
  );

  s_DE_EX_IN.OPCODE <= s_IF_DE_OUT.INSTR(6 downto 0); 

  IDECODE: control_unit
    port map(
      i_opcode => s_DE_EX_IN.OPCODE,
      i_funct3 => s_IF_DE_OUT.INSTR(14 downto 12),
      i_funct7 => s_IF_DE_OUT.INSTR(31 downto 25),
      i_funct12 => s_IF_DE_OUT.INSTR(31 downto 20),
      o_CTRL_SIGS => s_DE_EX_IN.CTRL_SIGS,
      o_IMM_TYPE => s_IMM_TYPE
  );

  s_RegWrAddr <= s_MEM_WB_OUT.RD;
  s_RegWrData <= s_REG_IN_DATA;

  REG_FILE_inst: reg_file
    generic map(
      DATA_WIDTH => N,
      NUM_REGS => NUM_REGS
  )
    port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_WE => s_MEM_WB_OUT.CTRL_SIGS.REG_WE and s_N_HALT,
      i_RD => s_RegWrAddr,
      i_RS => (
          0 => s_IF_DE_OUT.INSTR(19 downto 15), -- RS1
          1 => s_IF_DE_OUT.INSTR(24 downto 20)  -- RS2
      ),
      i_DATA => s_RegWrData,
      o_DATA => (
        0 => s_DE_EX_IN.REG_DATA1,
        1 => s_DE_EX_IN.REG_DATA2
      )
  );

  IMM_CTRL_inst: IMM_CTRL
    port map(
      i_IMM_TYPE => s_IMM_TYPE,
      i_DATA => s_IF_DE_OUT.INSTR,
      o_DATA => s_DE_EX_IN.IMM
  );

  ----------------
  -- #3 EXECUTE --
  ----------------

  -- execute pass through signal assignments
  s_EX_MEM_IN.CTRL_SIGS <= s_DE_EX_OUT.CTRL_SIGS;
  s_EX_MEM_IN.RD        <= s_DE_EX_OUT.RD;
  s_EX_MEM_IN.REG_DATA2 <= s_DE_EX_OUT.REG_DATA2;

  DE_EX_REG_inst: DE_EX_REG
   generic map(
      DATA_WIDTH => DATA_WIDTH
  )
   port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_WE => s_N_HALT,
      i_FLUSH => '0', -- FIXME
      i_DE_EX_SIGS => s_DE_EX_IN,
      o_DE_EX_SIGS => s_DE_EX_OUT
  );

  ALU_SRC_PC_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      LOG2_N => 2,
      N => 4
  )
    port map(
      i_S =>    s_DE_EX_OUT.CTRL_SIGS.ALU_SRC_PC, 
      i_DATA => (
          0 =>  s_DE_EX_OUT.REG_DATA1,   -- RS1
          1 =>  s_DE_EX_OUT.PC,          -- PC
          2 =>  s_EX_MEM_OUT.EX_DATA,    -- forward from MEM stage
          3 =>  s_REG_IN_DATA            -- forward from WB stage
      ),
      o_DATA => s_ALU_SRC_PC_MUX_OUT
  );

  ALU_SRC_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      LOG2_N => 2,
      N => 4
  )
    port map(
      i_S =>    s_DE_EX_OUT.CTRL_SIGS.ALU_SRC,    
      i_DATA => (
          0 =>  s_DE_EX_OUT.REG_DATA2,
          1 =>  s_DE_EX_OUT.IMM,
          2 =>  s_EX_MEM_OUT.EX_DATA,  -- forward from MEM stage
          3 =>  s_REG_IN_DATA          -- forward from WB stage
      ),
      o_DATA => s_ALU_SRC_MUX_OUT
  );

  ALU: ALU_32BIT
    generic map(
      DATA_WIDTH => N
  )
    port map(
      i_ALU_CTRL => s_DE_EX_OUT.CTRL_SIGS.ALU_CTRL,
      i_A => s_ALU_SRC_PC_MUX_OUT,
      i_B => s_ALU_SRC_MUX_OUT,
      o_RESULT => s_ALU_OUT,
      o_EQUAL => s_EQUAL,
      o_LT => s_LESS_THAN,
      o_LTU => s_LESS_THAN_UNSIGNED,
      o_OF => open
  );

  BRANCH_UNIT_inst: branch_unit
    port map(
      i_opcode     => s_DE_EX_OUT.OPCODE,
      i_funct3     => s_DE_EX_OUT.FUNCT3,
      i_LT         => s_LESS_THAN,
      i_LTU        => s_LESS_THAN_UNSIGNED,
      i_EQ         => s_EQUAL,
      o_J_REG      => s_J_REG,
      o_PC_ADD_IMM => s_PC_ADD_IMM
    );

  REG_SRC_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      LOG2_N => 2,
      N => 4
  )
    port map(
      i_S => s_DE_EX_OUT.CTRL_SIGS.REG_SRC,
      i_DATA => (
          0 => s_ALU_OUT,
          1 => s_ALU_OUT,
          2 => s_DE_EX_OUT.PC_PLUS_4,
          3 => s_DE_EX_OUT.IMM
      ),
      o_DATA => s_EX_MEM_IN.EX_DATA
  );

  --------------------
  -- #4 DATA MEMORY -- 
  --------------------

  -- assign data memory pass through signals
  s_MEM_WB_IN.CTRL_SIGS <= s_EX_MEM_OUT.CTRL_SIGS;
  s_MEM_WB_IN.EX_DATA   <= s_EX_MEM_OUT.EX_DATA;
  s_MEM_WB_IN.RD        <= s_EX_MEM_OUT.RD;

  EX_MEM_REG_inst: EX_MEM_REG
   generic map(
      DATA_WIDTH => DATA_WIDTH
  )
   port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_WE => s_N_HALT,
      i_FLUSH => '0', --FIXME
      i_EX_MEM_SIGS => s_EX_MEM_IN,
      o_EX_MEM_SIGS => s_EX_MEM_OUT
  );

  s_DMemWr <= s_EX_MEM_OUT.CTRL_SIGS.MEM_WRITE and s_N_HALT; --Used for halt
  s_DMemAddr <= s_EX_MEM_OUT.EX_DATA;

  u_subword_write: subword_write 
    port map(i_sh           => s_EX_MEM_OUT.CTRL_SIGS.HWRD,
             i_sw           => s_EX_MEM_OUT.CTRL_SIGS.WRD,
             i_addr         => s_DMemAddr,
             i_data         => s_EX_MEM_OUT.REG_DATA2,
             o_be           => s_be,
             o_data         => s_DMemData);

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             be   => s_be,
             we   => s_DMemWr,
             q    => s_raw_q
    );

  u_subword_read: subword_read
    port map(i_unsigned     => s_EX_MEM_OUT.CTRL_SIGS.UNSIGNED,
             i_lw           => s_EX_MEM_OUT.CTRL_SIGS.WRD,
             i_lh           => s_EX_MEM_OUT.CTRL_SIGS.HWRD,
             i_byte_offset  => s_DMemAddr(1 downto 0),
             i_data         => s_raw_q,
             o_data         => s_MEM_WB_IN.DMEM_DATA);

  ------------------
  -- #5 WRITEBACK --
  ------------------
  s_DMemOut <= s_raw_q;

  MEM_WB_REG_inst: MEM_WB_REG
    generic map(
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      i_CLK         => iCLK,
      i_RST         => iRST,
      i_WE          => s_N_HALT,
      i_FLUSH       => '0',
      i_MEM_WB_SIGS => s_MEM_WB_IN,
      o_MEM_WB_SIGS => s_MEM_WB_OUT
    );
  
  WB_MUX: BUS_MUX_NTO1
   generic map(
      DATA_WIDTH => DATA_WIDTH,
      LOG2_N => 1,
      N => 2
  )
   port map(
      i_S => (0 => (not s_MEM_WB_OUT.CTRL_SIGS.REG_SRC(1)) and s_MEM_WB_OUT.CTRL_SIGS.REG_SRC(0)),
      i_DATA => (
        0 => s_MEM_WB_OUT.EX_DATA,
        1 => s_MEM_WB_OUT.DMEM_DATA
      ),
      o_DATA => s_REG_IN_DATA
  );

end structure;
