library IEEE;
use IEEE.std_logic_1164.all;

use work.std_logic_vector_array.all;

entity imm_ctrl is
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
end entity;

architecture rtl of imm_ctrl is

    signal s_SIGNED         : STD_LOGIC;

    signal s_I_SIGN_EXT     : STD_LOGIC_VECTOR(19 downto 0);
    signal s_S_SIGN_EXT     : STD_LOGIC_VECTOR(19 downto 0);
    signal s_SB_SIGN_EXT    : STD_LOGIC_VECTOR(18 downto 0);
    signal s_UJ_SIGN_EXT    : STD_LOGIC_VECTOR(10 downto 0);

    signal s_I_IMM  : STD_LOGIC_VECTOR(11 downto 0);
    signal s_S_IMM  : STD_LOGIC_VECTOR(11 downto 0);
    signal s_SB_IMM : STD_LOGIC_VECTOR(12 downto 0);
    signal s_U_IMM  : STD_LOGIC_VECTOR(31 downto 0);
    signal s_UJ_IMM : STD_LOGIC_VECTOR(20 downto 0);


    signal s_I_IMM_32B  : STD_LOGIC_VECTOR(31 downto 0);
    signal s_S_IMM_32B  : STD_LOGIC_VECTOR(31 downto 0);
    signal s_SB_IMM_32B : STD_LOGIC_VECTOR(31 downto 0);
    signal s_U_IMM_32B  : STD_LOGIC_VECTOR(31 downto 0);
    signal s_UJ_IMM_32B : STD_LOGIC_VECTOR(31 downto 0);
begin

    s_SIGNED <= i_IMM_TYPE(0);
    
    -- unpacked immediate values
    s_I_IMM         <= i_DATA(31 downto 20);
    s_S_IMM         <= i_DATA(31 downto 25) & i_DATA(11 downto 7);
    s_SB_IMM        <= i_DATA(31) & i_DATA(7) & i_DATA(30 downto 25) & i_DATA(11 downto 8) & '0';
    s_U_IMM         <= (31 downto 12 => i_DATA(31 downto 12), others => '0');
    s_UJ_IMM        <= i_DATA(31) & i_DATA(19 downto 12) & i_DATA(20) & i_DATA(30 downto 21) & '0';
    
    -- build sign extensions
    s_I_SIGN_EXT    <= (others => s_I_IMM(11)) when s_SIGNED else (others => '0');
    s_S_SIGN_EXT    <= (others => s_S_IMM(11));
    s_SB_SIGN_EXT   <= (others => s_SB_IMM(12));
    s_UJ_SIGN_EXT   <= (others => s_UJ_IMM(19));

    -- convert to 32-bit numbers
    s_I_IMM_32B     <= s_I_SIGN_EXT  & s_I_IMM;     -- I-Type
    s_S_IMM_32B     <= s_S_SIGN_EXT  & s_S_IMM;     -- S-Type
    s_SB_IMM_32B    <= s_SB_SIGN_EXT & s_SB_IMM;    -- SB-Type
    s_U_IMM_32B     <= s_U_IMM;                     -- U-Type
    s_UJ_IMM_32B    <= s_UJ_SIGN_EXT & s_UJ_IMM;    -- UJ-Type

    with i_IMM_TYPE select
        o_DATA  <=  s_S_IMM_32B     when "010",
                    s_SB_IMM_32B    when "011",
                    s_U_IMM_32B     when "100",
                    s_UJ_IMM_32B    when "101",
                    s_I_IMM_32B     when others; 

end architecture;