-- Christopher Funk & Jamison Bice
-- Department of Electrical and Computer Engineering
-- Iowa State University

-- dmem_system.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural Data Memory Subsystem for RV32I.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dmem_subsystem is
  generic(ADDR_WIDTH : integer := 10;
          DATA_WIDTH : integer := 32);

  port(i_clk                : in  std_logic;
       -- Control signals
       i_mem_write          : in  std_logic;                      
       i_halt               : in  std_logic;                     
       i_wrd                : in  std_logic;                     
       i_hwrd               : in  std_logic;                      
       i_unsigned           : in  std_logic;                     
       -- Datapath inputs
       i_addr               : in  std_logic_vector(DATA_WIDTH-1 downto 0);
       i_data               : in  std_logic_vector(DATA_WIDTH-1 downto 0);
       -- Datapath output
       o_data               : out std_logic_vector(DATA_WIDTH-1 downto 0);
       -- Required Verification Outputs
       o_DMemWr             : out std_logic;                      
       o_DMemAddr           : out std_logic_vector(DATA_WIDTH-1 downto 0); 
       o_DMemData           : out std_logic_vector(DATA_WIDTH-1 downto 0); 
       o_DMemOut            : out std_logic_vector(DATA_WIDTH-1 downto 0));
end entity dmem_subsystem;

architecture structural of dmem_subsystem is

  component subword_write is
    port(i_sh               : in  std_logic;                      
         i_sw               : in  std_logic; 
         i_write            : in  std_logic;                     
         i_addr             : in  std_logic_vector(31 downto 0);  
         i_data             : in  std_logic_vector(31 downto 0);
         o_be               : out std_logic_vector(3 downto 0);   
         o_we               : out std_logic;                      
         o_addr             : out std_logic_vector(9 downto 0);
         o_data             : out std_logic_vector(31 downto 0));
  end component;

  component mem is
    generic(DATA_WIDTH      : natural := 32;
            ADDR_WIDTH      : natural := 10;
            BYTE_WIDTH      : natural := 8);

    port(clk                : in  std_logic;
         addr               : in  std_logic_vector((ADDR_WIDTH-1) downto 0);
         data               : in  std_logic_vector((DATA_WIDTH-1) downto 0);
         be                 : in  std_logic_vector(3 downto 0);
         we                 : in  std_logic;
         q                  : out std_logic_vector((DATA_WIDTH-1) downto 0));
  end component;

  component subword_read is
    port(i_unsigned         : in  std_logic;                   
         i_lw               : in  std_logic;                      
         i_lh               : in  std_logic;               
         i_byte_offset      : in  std_logic_vector(1 downto 0); 
         i_data             : in  std_logic_vector(31 downto 0); 
         o_data             : out std_logic_vector(31 downto 0));
  end component;


  signal s_gated_write      : std_logic;
  signal s_be               : std_logic_vector(3 downto 0);
  signal s_we               : std_logic;
  signal s_word_addr        : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal s_write_data       : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal s_raw_q            : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  --Used for halt
  s_gated_write <= i_mem_write and (not i_halt);

  u_subword_write: subword_write
    port map(i_sh           => i_hwrd,
             i_sw           => i_wrd,
             i_write    => s_gated_write,
             i_addr         => i_addr,
             i_data         => i_data,
             o_be           => s_be,
             o_we           => s_we,
             o_addr         => s_word_addr,
             o_data         => s_write_data);

  dmem: mem
    generic map(DATA_WIDTH  => DATA_WIDTH,
                ADDR_WIDTH  => ADDR_WIDTH,
                BYTE_WIDTH  => 8)

    port map(clk            => i_clk,
             addr           => s_word_addr,
             data           => s_write_data,
             be             => s_be,
             we             => s_we,
             q              => s_raw_q);

  u_subword_read: subword_read
    port map(i_unsigned     => i_unsigned,
             i_lw           => i_wrd,
             i_lh           => i_hwrd,
             i_byte_offset  => i_addr(1 downto 0),
             i_data         => s_raw_q,
             o_data         => o_data);

 -- Verification for the framework 
  o_DMemWr   <= s_we;          
  o_DMemAddr <= i_addr;        
  o_DMemData <= s_write_data;  
  o_DMemOut  <= s_raw_q;      

end architecture structural;