
-- datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: File contains a RISC-V datapath
--
--
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
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
end entity control_unit;

architecture dataflow of control_unit is

  signal s_ctrl         : std_logic_vector(13 downto 0);

begin
  -- format 
  -- [13]   : ALUSrcPC
  -- [12]   : ALUSrc
  -- [11]   : RegWrite
  -- [10]   : MemWrite
  -- [9]    : MemRead
  -- [8:7]  : ResultSrc (2 bits)
  -- [6]    : Branch
  -- [5:4]  : Jump (2 bits)
  -- [3:1]  : ImmType (3 bits)
  -- [0]    : Halt
  with i_opcode select
    s_ctrl <=           "00100000000000" when "0110011", -- R-type
                        "01100000000000" when "0010011", -- I-type ALU
                        "01101010000000" when "0000011", -- Load
                        "01010000000010" when "0100011", -- Store
                        "00000001000100" when "1100011", -- Branch
                        "00100100011000" when "1101111", -- JAL
                        "01100100100000" when "1100111", -- JALR
                        "00100110000110" when "0110111", -- LUI
                        "11100000000110" when "0010111", -- AUIPC
                        "00000000000001" when "1110011", -- WFI (Halt)
                        "00000000000000" when others;

  o_ALUSrcPC            <= s_ctrl(13);
  o_ALUSrc              <= s_ctrl(12);
  o_RegWrite            <= s_ctrl(11);
  o_MemWrite            <= s_ctrl(10);
  o_MemRead             <= s_ctrl(9);
  o_ResultSrc           <= s_ctrl(8 downto 7);
  o_Branch              <= s_ctrl(6);
  o_Jump                <= s_ctrl(5 downto 4);
  o_ImmType             <= s_ctrl(3 downto 1);
  o_Halt                <= s_ctrl(0);

  with i_opcode select
    o_ALUOp <=          "10" when "0110011" | "0010011",  -- R-type and I-type 
                        "01" when "1100011",              -- Branch
                        "00" when others;                 -- Everything else and default
end dataflow;