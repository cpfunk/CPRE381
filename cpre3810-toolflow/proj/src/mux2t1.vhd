library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
    port(
        i_S     : in std_logic;
        i_D0    : in std_logic;
        i_D1    : in std_logic;
        o_O     : out std_logic
    );
end mux2t1;

architecture structural of mux2t1 is

    signal n_s, x0, x1 : std_logic;


    component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

    end component;
    component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

    end component;
    component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

    end component;

begin

    not0: invg
        port map(
            i_A => i_s,
            o_F => n_s
        );

    and0: andg2
        port map(
            i_A => n_s,
            i_B => i_d0,
            o_F => x0
        );

    and1: andg2
        port map(
            i_A => i_s,
            i_B => i_d1,
            o_F => x1
        );

    or0: org2
        port map(
            i_A => x0,
            i_B => x1,
            o_F => o_O
        );

end structural;

architecture dataflow of mux2t1 is
begin

    o_O <= (i_D0 and (not i_S)) or (i_D1 and i_S);

end dataflow;