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

library work;
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

        i_LT                   : in std_logic;
        i_LTU                  : in std_logic;
        i_EQ                   : in std_logic;

        -- Multiplexer selectors
        o_ALU_SRC_PC           : out std_logic;                      
        o_ALU_SRC              : out std_logic;                      
        o_REG_SRC              : out std_logic_vector(1 downto 0);   
        o_J_REG                : out std_logic;                      

        -- Control-Flow output for controlling PC + IMM 
        o_PC_ADD_IMM           : out std_logic;        

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
        o_Halt                 : out std_logic
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

    -------------------
    --  CONSTANTS    --
    -------------------
    constant NUM_REGS   : INTEGER := 32;

    -----------------
    --  SIGNALS    --
    -----------------
    -- for control unit

    -- Multiplexer selectors
      signal s_ALU_SRC_PC             : std_logic;
      signal s_ALU_SRC                : std_logic;
      signal s_REG_SRC                : std_logic_vector(1 downto 0);
      signal s_J_REG                  : std_logic;

    -- Register file & Data memory enables
      signal s_MEM_WRITE              : std_logic;                      

    -- Sub-word memory controls 
      signal s_WRD                    : std_logic;                      
      signal s_HWRD                   : std_logic;                      
      signal s_UNSIGNED               : std_logic;                     

    -- Immediate generator format selection
      signal s_IMM_TYPE               : std_logic_vector(2 downto 0);

    -- Execution & Framework controls
      signal s_ALU_CTRL               : std_logic_vector(3 downto 0);

    -- for PC_ADD_IMM

        signal s_PC_ADD_IMM             : STD_LOGIC;

    -- for reg_file
        signal s_REG_OUT                : STD_LOGIC_VECTOR_ARRAY(1 downto 0)(N-1 downto 0);
        
    -- for imm control
      signal s_IMM_OUT                : STD_LOGIC_VECTOR(31 downto 0);
        
    -- for ALU
      signal s_ALU_OUT                : STD_LOGIC_VECTOR(N - 1 downto 0);
      signal s_EQUAL                  : STD_LOGIC;
      signal s_LESS_THAN              : STD_LOGIC;
      signal s_LESS_THAN_UNSIGNED     : STD_LOGIC;

    -- for reg_src mux
        signal s_REG_SRC_MUX_OUT        : STD_LOGIC_VECTOR(N-1 downto 0);

    -- misc
      signal s_N_HALT                 : STD_LOGIC;
      signal s_ALU_SRC_PC_MUX_OUT     : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_ALU_SRC_MUX_OUT        : STD_LOGIC_VECTOR(N-1 downto 0);

      signal s_PC_PLUS_FOUR           : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_PC_ADD_IMM_MUX_OUT     : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_PC_ADD_IMM_OUT         : STD_LOGIC_VECTOR(N-1 downto 0);
      signal s_J_REG_MUX_OUT          : STD_LOGIC_VECTOR(N-1 downto 0);

    -- dmem signals
      signal s_gated_write      : std_logic;
      signal s_be               : std_logic_vector(3 downto 0);
      signal s_raw_q            : std_logic_vector(N-1 downto 0);

begin
  s_Ovfl <= '0'; -- RISC-V does not have hardware overflow detection.
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
             q    => s_Inst);
  
  --Used for halt
  s_DMemWr <= s_mem_write and (not s_Halt);
  s_DMemAddr <= s_ALU_OUT;

  u_subword_write: subword_write 
    port map(i_sh           => s_hwrd,
             i_sw           => s_wrd,
             i_addr         => s_DMemAddr,
             i_data         => s_REG_OUT(1),
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
    port map(i_unsigned     => s_unsigned,
             i_lw           => s_wrd,
             i_lh           => s_hwrd,
             i_byte_offset  => s_DMemAddr(1 downto 0),
             i_data         => s_raw_q,
             o_data         => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)

  -- TODO: Implement the rest of your processor below this comment!
  --------------------------
  --  SIGNAL ASSIGNMENTS  --
  --------------------------
  s_N_HALT        <= not s_Halt; -- halt signal
  oALUOut         <= s_ALU_OUT;

  IDECODE: control_unit
    port map(
      i_opcode => s_Inst(6 downto 0),
      i_funct3 => s_Inst(14 downto 12),
      i_funct7 => s_Inst(31 downto 25),
      i_funct12 => s_Inst(31 downto 20),
      i_LT => s_LESS_THAN,
      i_LTU => s_LESS_THAN_UNSIGNED,
      i_EQ => s_EQUAL,
      o_ALU_SRC_PC => s_ALU_SRC_PC,
      o_ALU_SRC => s_ALU_SRC,
      o_REG_SRC => s_REG_SRC,
      o_J_REG => s_J_REG,
      o_PC_ADD_IMM => s_PC_ADD_IMM,
      o_REG_WE => s_RegWr,
      o_MEM_WRITE => s_MEM_WRITE,
      o_WRD => s_WRD,
      o_HWRD => s_HWRD,
      o_UNSIGNED => s_UNSIGNED,
      o_IMM_TYPE => s_IMM_TYPE,
      o_ALU_CTRL => s_ALU_CTRL,
      o_Halt => s_Halt
  );

  s_RegWrAddr <= s_Inst(11 downto 7);
  s_RegWrData <= s_REG_SRC_MUX_OUT;

  REG_FILE_inst: reg_file
    generic map(
      DATA_WIDTH => N,
      NUM_REGS => NUM_REGS
  )
    port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_WE => s_RegWr and s_N_HALT,
      i_RD => s_RegWrAddr,
      i_RS => (
          0 => s_Inst(19 downto 15), -- RS1
          1 => s_Inst(24 downto 20)  -- RS2
      ),
      i_DATA => s_RegWrData,
      o_DATA => s_REG_OUT
  );

  REG_SRC_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      LOG2_N => 2,
      N => 4
  )
    port map(
      i_S => s_REG_SRC,
      i_DATA => (
          0 => s_ALU_OUT,
          1 => s_DMemOut,
          2 => s_PC_PLUS_FOUR,
          3 => s_IMM_OUT
      ),
      o_DATA => s_REG_SRC_MUX_OUT
  );

  IMM_CTRL_inst: IMM_CTRL
    port map(
      i_IMM_TYPE => s_IMM_TYPE,
      i_DATA => s_Inst,
      o_DATA => s_IMM_OUT
  );

  ALU_SRC_PC_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      LOG2_N => 1,
      N => 2
  )
    port map(
      i_S => (0 => s_ALU_SRC_PC),
      i_DATA => (
          0 => s_REG_OUT(0),  -- RS1
          1 => s_PC           -- PC
      ),
      o_DATA => s_ALU_SRC_PC_MUX_OUT
  );

  ALU_SRC_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      LOG2_N => 1,
      N => 2
  )
    port map(
      i_S => (0 => s_ALU_SRC),
      i_DATA => (
          0 => s_REG_OUT(1),
          1 => s_IMM_OUT
      ),
      o_DATA => s_ALU_SRC_MUX_OUT
  );

  ALU: ALU_32BIT
    generic map(
      DATA_WIDTH => N
  )
    port map(
      i_ALU_CTRL => s_ALU_CTRL,
      i_A => s_ALU_SRC_PC_MUX_OUT,
      i_B => s_ALU_SRC_MUX_OUT,
      o_RESULT => s_ALU_OUT,
      o_EQUAL => s_EQUAL,
      o_LT => s_LESS_THAN,
      o_LTU => s_LESS_THAN_UNSIGNED,
      o_OF => s_Ovfl
  );

  PC_inst: PC
   generic map(
      DATA_WIDTH => DATA_WIDTH
  )
   port map(
      i_CLK => iCLK,
      i_RST => iRST,
      i_HALT => s_HALT,
      i_NEXT => s_PC_ADD_IMM_MUX_OUT,
      o_PC => s_PC
  );

  PC_J_REG_MUX: BUS_MUX_NTO1
    generic map(
      DATA_WIDTH => N,
      N => 2,
      LOG2_N => 1
  )
    port map(
      i_S => (0 => s_J_REG),
      i_DATA => (0 => s_PC_PLUS_FOUR, 1 => s_ALU_OUT),
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
      i_A => s_PC,
      i_B => x"0000_0004",
      o_F => s_PC_PLUS_FOUR
  );

  ADD_IMM_ADDER: ADDER_32BIT
    generic map(
      DATA_WIDTH => N
  )
    port map(
      i_C => '0',
      i_A => s_PC,
      i_B => s_IMM_OUT,
      o_F => s_PC_ADD_IMM_OUT
  );

end structure;
