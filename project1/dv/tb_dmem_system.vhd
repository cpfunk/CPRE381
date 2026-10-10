-- Christopher Funk & Jamison Bice
-- Department of Electrical and Computer Engineering
-- Iowa State University

-- tb_dmem_subsystem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for the structural data memory subsystem.
-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem_subsystem is
  generic(gCLK_HPER : time := 50 ns);
end entity tb_dmem_subsystem;

architecture mixed of tb_dmem_subsystem is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

 component dmem_subsystem is
    generic(ADDR_WIDTH : integer := 10;
            DATA_WIDTH : integer := 32);

    port(i_clk                  : in  std_logic;
         i_mem_write            : in  std_logic;
         i_halt                 : in  std_logic;
         i_wrd                  : in  std_logic;
         i_hwrd                 : in  std_logic;
         i_unsigned             : in  std_logic;
         i_addr                 : in  std_logic_vector(DATA_WIDTH-1 downto 0);
         i_data                 : in  std_logic_vector(DATA_WIDTH-1 downto 0);
         o_data                 : out std_logic_vector(DATA_WIDTH-1 downto 0);
         o_DMemWr               : out std_logic;
         o_DMemAddr             : out std_logic_vector(DATA_WIDTH-1 downto 0);
         o_DMemData             : out std_logic_vector(DATA_WIDTH-1 downto 0);
         o_DMemOut              : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  -- Clock signal
  signal s_CLK                  : std_logic := '0';

  -- DUT Control Inputs
  signal s_mem_write  : std_logic := '0';
  signal s_halt       : std_logic := '0';
  signal s_wrd        : std_logic := '0';
  signal s_hwrd       : std_logic := '0';
  signal s_unsigned   : std_logic := '0';

  -- DUT Datapath Inputs
  signal s_addr       : std_logic_vector(31 downto 0) := (others => '0');
  signal s_data       : std_logic_vector(31 downto 0) := (others => '0');

  -- DUT Datapath Output
  signal s_data_out   : std_logic_vector(31 downto 0);

  -- Verification Probe Outputs
  signal s_DMemWr     : std_logic;
  signal s_DMemAddr   : std_logic_vector(31 downto 0);
  signal s_DMemData   : std_logic_vector(31 downto 0);
  signal s_DMemOut    : std_logic_vector(31 downto 0);

begin

  DUT: dmem_subsystem
    generic map(
      ADDR_WIDTH => 10,
      DATA_WIDTH => 32
    )
    port map(
      i_clk       => s_clk,
      i_mem_write => s_mem_write,
      i_halt      => s_halt,
      i_wrd       => s_wrd,
      i_hwrd      => s_hwrd,
      i_unsigned  => s_unsigned,
      i_addr      => s_addr,
      i_data      => s_data,
      o_data      => s_data_out,
      o_DMemWr    => s_DMemWr,
      o_DMemAddr  => s_DMemAddr,
      o_DMemData  => s_DMemData,
      o_DMemOut   => s_DMemOut
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

    --Store Word at Address 0x00000000
    s_addr      <= X"00000000";
    s_data      <= X"DEADBEEF";
    s_mem_write <= '1';
    s_halt      <= '0';
    s_wrd       <= '1';
    s_hwrd      <= '0';
    s_unsigned  <= '0';
    -- Expected verification probes:
    -- o_DMemWr   = '1'
    -- o_DMemAddr = 0x00000000
    -- o_DMemData = 0xDEADBEEF
    wait for cCLK_PER;

    -- Load Word from Address 0x00000000
    s_mem_write <= '0';
    s_wrd       <= '1';
    s_hwrd      <= '0';
    s_unsigned  <= '0';
    -- Expected output:
    -- o_data    = 0xDEADBEEF
    -- o_DMemWr  = '0'
    -- o_DMemOut = 0xDEADBEEF
    wait for cCLK_PER;

    -- Store Halfword at Address 0x00000004
    -- negative when signed
    s_addr      <= X"00000004";
    s_data      <= X"12348ABC"; -- 0x8ABC should be stored
    s_mem_write <= '1';
    s_wrd       <= '0';
    s_hwrd      <= '1';
    wait for cCLK_PER;

    -- Store Halfword at Address 0x00000006 (Upper half, offset "10")
    -- positive
    s_addr      <= X"00000006";
    s_data      <= X"99990123"; --0x0123 should be stored
    s_mem_write <= '1';
    s_wrd       <= '0';
    s_hwrd      <= '1';
    wait for cCLK_PER;

    -- Verify Entire Word at 0x00000004
    s_mem_write <= '0';
    s_addr      <= X"00000004";
    s_wrd       <= '1';
    s_hwrd      <= '0';
    -- Expected o_data: 0x01238ABC
    wait for cCLK_PER;

    -- Load Halfword Signed from 0x00000004 
    -- Should sign-extend 
    s_wrd      <= '0';
    s_hwrd     <= '1';
    s_unsigned <= '0';
    -- Expected o_data: 0xFFFF8ABC
    wait for cCLK_PER;

    -- Load Halfword Unsigned from 0x00000004 
    -- Should zero-extend 
    s_unsigned <= '1';
    -- Expected o_data: 0x00008ABC
    wait for cCLK_PER;

    -- Load Halfword Signed from 0x00000006 (Offset "10")
    -- Should sign-extend
    s_addr     <= X"00000006";
    s_unsigned <= '0';
    -- Expected o_data: 0x00000123
    wait for cCLK_PER;

    -- Store 4 Individual Bytes into Word 0x00000008
    s_mem_write <= '1';
    s_wrd       <= '0';
    s_hwrd      <= '0';

    -- Byte offset 00: Write 0xFE (negative byte)
    s_addr <= X"00000008";
    s_data <= X"000000FE";
    wait for cCLK_PER;

    -- Byte offset 01: Write 0x22 (positive byte)
    s_addr <= X"00000009";
    s_data <= X"00000022";
    wait for cCLK_PER;

    -- Byte offset 10: Write 0xCD (negative byte)
    s_addr <= X"0000000A";
    s_data <= X"000000CD";
    wait for cCLK_PER;

    -- Byte offset 11: Write 0x45 (positive byte)
    s_addr <= X"0000000B";
    s_data <= X"00000045";
    wait for cCLK_PER;

    -- Verify Assembled Word at 0x00000008
    s_mem_write <= '0';
    s_addr      <= X"00000008";
    s_wrd       <= '1';
    s_hwrd      <= '0';
    -- Expected o_data: 0x45CD22FE
    wait for cCLK_PER;

    -- Load Byte Signed from 0x00000008 (Offset "00")
    -- Should sign-extend
    s_wrd      <= '0';
    s_hwrd     <= '0';
    s_unsigned <= '0';
    -- Expected o_data: 0xFFFFFFFE
    wait for cCLK_PER;

    -- Load Byte Unsigned from 0x00000008 (Offset "00")
    -- Should zero-extend
    s_unsigned <= '1';
    -- Expected o_data: 0x000000FE
    wait for cCLK_PER;

    -- Load Byte Signed from 0x00000009 (Offset "01")
    -- Should sign-extend
    s_addr     <= X"00000009";
    s_unsigned <= '0';
    -- Expected o_data: 0x00000022
    wait for cCLK_PER;

    -- Halt Write-Gating Test
    s_addr      <= X"00000000";
    s_data      <= X"11111111";
    s_mem_write <= '1';
    s_halt      <= '1';
    s_wrd       <= '1';
    -- Expected probe:
    -- o_DMemWr = '0'
    wait for cCLK_PER;

    -- Read back 0x00000000 to verify original data was preserved
    s_mem_write <= '0';
    s_halt      <= '0';
    s_wrd       <= '1';
    -- Expected o_data: 0xDEADBEEF 
    wait for cCLK_PER;

    wait for cCLK_PER * 2;
    wait;
  end process;

end mixed;