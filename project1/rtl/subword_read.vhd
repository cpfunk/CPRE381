-- Christopher Funk & Jamison Bice
-- Department of Electrical and Computer Engineering
-- Iowa State University

-- subword_read.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Memory READ Interface.

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity subword_read is
  port(i_unsigned       : in  std_logic;                   
       i_lw             : in  std_logic;                      
       i_lh             : in  std_logic;               
       i_byte_offset    : in  std_logic_vector(1 downto 0); 
       i_data           : in  std_logic_vector(31 downto 0); 
       o_data           : out std_logic_vector(31 downto 0)   
  );
end entity subword_read;

architecture dataflow of subword_read is

  signal s_byte         : std_logic_vector(7 downto 0);
  signal s_hwrd         : std_logic_vector(15 downto 0);

begin

 --Target Subword Slices
  with i_byte_offset select
    s_byte <=           i_data(7 downto 0)   when "00",
                        i_data(15 downto 8)  when "01",
                        i_data(23 downto 16) when "10",
                        i_data(31 downto 24) when "11",
                        (others => '0')      when others;

  s_hwrd <=             i_data(15 downto 0)  when (i_byte_offset(1) = '0') else
                        i_data(31 downto 16);


  --Format Output lb is default
  o_data <=           --Load Word 
                        i_data when (i_lw = '1') else

                      --Load Halfword Unsigned 
                        x"0000" & s_hwrd when (i_lh = '1' and i_unsigned = '1') else

                      --Load Halfword Signed 
                        x"FFFF" & s_hwrd when (i_lh = '1' and s_hwrd(15) = '1') else
                        x"0000" & s_hwrd when (i_lh = '1') else

                      --Load Byte Unsigned
                        x"000000" & s_byte when (i_unsigned = '1') else

                      --Load Byte Signed default
                        x"FFFFFF" & s_byte when (s_byte(7) = '1') else
                        x"000000" & s_byte;

end dataflow;