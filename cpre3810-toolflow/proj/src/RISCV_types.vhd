-------------------------------------------------------------------------
-- Author: Braedon Giblin
-- Date: 2022.02.12
-- Files: RISCV_types.vhd
-------------------------------------------------------------------------
-- Description: This file contains a skeleton for some types that 381 students
-- may want to use. This file is guarenteed to compile first, so if any types,
-- constants, functions, etc., etc., are wanted, students should declare them
-- here.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package RISCV_types is

  -- Example Constants. Declare more as needed
  constant DATA_WIDTH : integer := 32;
  constant ADDR_WIDTH : integer := 10;
  
  type STD_LOGIC_VECTOR_ARRAY is array (natural range <>) of std_logic_vector; 
  
  -- Example record type. Declare whatever types you need here
  type control_t is record
    reg_wr : std_logic;
    reg_to_mem : std_logic;
  end record control_t;

  type CTRL_SIGS is record
    -- Multiplexer selectors
    ALU_SRC_PC           : std_logic_vector(1 downto 0);                      
    ALU_SRC              : std_logic_vector(1 downto 0);                      
    REG_SRC              : std_logic_vector(1 downto 0);   

    -- Register file & Data memory enables
    REG_WE               : std_logic;                      
    MEM_WRITE            : std_logic;           

    -- Sub-word memory controls 
    WRD                  : std_logic;                      
    HWRD                 : std_logic;                      
    UNSIGNED             : std_logic;                     

    -- Immediate generator format selection only needed in decode stage
    -- directly output from instruction decoder
    -- IMM_TYPE             : std_logic_vector(2 downto 0);

    -- Execution & Framework controls
    ALU_CTRL             : std_logic_vector(3 downto 0);  
    N_HALT               : std_logic; -- inverted halt signal
  end record;

  type IF_DE_SIGS is record
    INSTR     : STD_LOGIC_VECTOR(31 downto 0);
    PC        : STD_LOGIC_VECTOR(31 downto 0);
    PC_PLUS_4 : STD_LOGIC_VECTOR(31 downto 0);
  end record;

  type DE_EX_SIGS is record
    CTRL_SIGS   : CTRL_SIGS;
    OPCODE      : STD_LOGIC_VECTOR(6 downto 0);
    REG_DATA1   : STD_LOGIC_VECTOR(31 downto 0);
    REG_DATA2   : STD_LOGIC_VECTOR(31 downto 0);
    PC          : STD_LOGIC_VECTOR(31 downto 0);
    PC_PLUS_4   : STD_LOGIC_VECTOR(31 downto 0);
    RD          : STD_LOGIC_VECTOR(5 downto 0);
    IMM         : STD_LOGIC_VECTOR(31 downto 0);
  end record;

  type EX_MEM_SIGS is record
    CTRL_SIGS   : CTRL_SIGS;
    EX_DATA     : STD_LOGIC_VECTOR(31 downto 0);
    REG_DATA2   : STD_LOGIC_VECTOR(31 downto 0);
    RD          : STD_LOGIC_VECTOR(5 downto 0);
  end record;

  type MEM_WB_SIGS is record
    CTRL_SIGS   : CTRL_SIGS;
    EX_DATA     : STD_LOGIC_VECTOR(31 downto 0);
    DMEM_DATA   : STD_LOGIC_VECTOR(31 downto 0);
    RD          : STD_LOGIC_VECTOR(5 downto 0);
  end record;

end package RISCV_types;

package body RISCV_types is
  -- Probably won't need anything here... function bodies, etc.
end package body RISCV_types;
