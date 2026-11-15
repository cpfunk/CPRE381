library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity DATA_HAZARD_UNIT is
    port(
        i_RS1     : in STD_LOGIC_VECTOR(4 downto 0);
        i_RS2     : in STD_LOGIC_VECTOR(4 downto 0);
        i_RD_EX   : in STD_LOGIC_VECTOR(4 downto 0);
        i_RD_MEM  : in STD_LOGIC_VECTOR(4 downto 0);
        i_RD_WB   : in STD_LOGIC_VECTOR(4 downto 0);
        i_FWRD    : in STD_LOGIC; -- Signal used to indicate to the DHDU that the data is being forwarded
        o_DE_STALL   : out STD_LOGIC
    );
end entity;

architecture rtl of DATA_HAZARD_UNIT is
begin



end architecture;