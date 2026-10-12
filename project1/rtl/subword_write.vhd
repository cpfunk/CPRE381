-- Christopher Funk & Jamison Bice
-- Department of Electrical and Computer Engineering
-- Iowa State University

-- subword_write.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Memory Write Interface (SUB WORD WRITE).

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity subword_write is
  port(-- Control inputs from Control Unit
       i_sh          : in  std_logic;                      
       i_sw          : in  std_logic; 
       i_write       : in  std_logic;                     

       --Datapath inputs
       i_addr        : in  std_logic_vector(31 downto 0);  
       i_data        : in  std_logic_vector(31 downto 0);
       --inputs to mem.vhd
       o_be          : out std_logic_vector(3 downto 0);   
       o_we          : out std_logic;                      
       o_addr        : out std_logic_vector(9 downto 0);
       o_data        : out std_logic_vector(31 downto 0));   
end entity subword_write;

architecture dataflow of subword_write is
begin

 --Addr conversion
  o_addr <=          i_addr(11 downto 2);
 --Write enable
  o_we   <=          i_write;

  
 --Byte Enable
                --Full word
  o_be <=           "1111" when (i_sw = '1') else
                -- Halfword Store
                    "0011" when (i_sh = '1' and i_addr(1) = '0') else
                    "1100" when (i_sh = '1' and i_addr(1) = '1') else
                -- Byte Store 
                    "0001" when (i_addr(1 downto 0) = "00") else
                    "0010" when (i_addr(1 downto 0) = "01") else
                    "0100" when (i_addr(1 downto 0) = "10") else
                    "1000" when (i_addr(1 downto 0) = "11") 
                    else "0000";

 --Data Routing 
  --uses BE as gate --Full word
  o_data <=         i_data when (i_sw = '1') else
                    --Half word
                    i_data(15 downto 0) & i_data(15 downto 0) when (i_sh = '1') else
                    --Byte 
                    i_data(7 downto 0) & i_data(7 downto 0) & i_data(7 downto 0) & i_data(7 downto 0);

end dataflow;