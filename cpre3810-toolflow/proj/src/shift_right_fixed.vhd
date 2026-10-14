library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.all;

-- shifter used to shift right by a fixed amount

entity SHIFT_RIGHT_FIXED is
    generic (
        DATA_WIDTH    : INTEGER := 32;
        SHIFT   : INTEGER := 1
    );
    port (
        i_SIGNED    : in STD_LOGIC;
        i_SHIFT     : in STD_LOGIC;
        i_DATA      : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        o_DATA      : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end entity;

architecture rtl of SHIFT_RIGHT_FIXED is
    signal s_SIGN_BITS : STD_LOGIC_VECTOR(SHIFT - 1 downto 0);
    signal s_SHIFTED_DATA : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

    component BUS_MUX_NTO1 is
    generic(
        DATA_WIDTH :      INTEGER := 32;
        LOG2_N :    INTEGER := 5;
        N :         INTEGER := 32
    );
    port(
        i_S: in STD_LOGIC_VECTOR(LOG2_N-1 downto 0);
        i_DATA: in STD_LOGIC_VECTOR_ARRAY(N - 1 downto 0)(DATA_WIDTH - 1 downto 0);
        o_DATA: out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
    end component;

begin
    
        -- sign DATA_WIDTH
        with i_SIGNED select
            s_SIGN_BITS <=  (others => i_DATA(DATA_WIDTH-1)) when '1', -- duplicate last bit when signed
                            (others => '0') when others; -- otherwise use zero

        -- shifted signal
        s_SHIFTED_DATA <= s_SIGN_BITS & i_DATA(DATA_WIDTH - 1 downto SHIFT);

        -- create a N-bit 2-to-1 bus mux
        BUS_MUX_2TO1: BUS_MUX_NTO1
         generic map(
            DATA_WIDTH => DATA_WIDTH,
            N => 2,
            LOG2_N => 1
        )
         port map(
            i_S => (0 => i_SHIFT),
            i_DATA => (0 => i_DATA, 1 => s_SHIFTED_DATA),
            o_DATA => o_DATA
        );

end architecture;
