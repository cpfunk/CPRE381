library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

entity CTRL_HAZARD_UNIT is
    port(
        i_TAKEN     : in STD_LOGIC;
        o_BUBBLE    : out STD_LOGIC
    );
end entity;

architecture rtl of CTRL_HAZARD_UNIT is
begin
    
    o_BUBBLE <= i_TAKEN;

end architecture;