library IEEE;
use IEEE.std_logic_1164.all;

entity ONES_COMP_NBIT is
    generic(N : integer := 16);
    port(
        i_s : in std_logic;
        i_x : in std_logic_vector(N-1 downto 0);
        o_f : out std_logic_vector(N-1 downto 0)
    );

end ONES_COMP_NBIT;

architecture structural of ONES_COMP_NBIT is

    signal sig : std_logic_vector(N-1 downto 0);


    component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

    end component;
    component mux2t1 is
    port(
        i_S     : in std_logic;
        i_D0    : in std_logic;
        i_D1    : in std_logic;
        o_O     : out std_logic
    );
    end component;

begin

  -- Instantiate N mux instances and N inverter instances.
  g_nbit_ones_comp: for i in 0 to N-1 generate
    
    inv_i: invg port map(
        i_A     => i_x(i),
        o_F     => sig(i)
    );

    mux_i: mux2t1 port map(
        i_S      => i_s,
        i_D0     => i_x(i),
        i_D1     => sig(i),
        o_O      => o_f(i)
    );

  end generate g_nbit_ones_comp;
  
end structural;
