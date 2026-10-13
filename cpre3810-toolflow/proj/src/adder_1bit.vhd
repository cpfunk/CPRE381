library IEEE;
use IEEE.std_logic_1164.all;

entity adder_1bit is
  port(
        i_c     : in STD_LOGIC;
        i_a     : in STD_LOGIC;
        i_b     : in STD_LOGIC;
        o_f     : out STD_LOGIC;
        o_c     : out STD_LOGIC
    );
end adder_1bit;

architecture structural of adder_1bit is

    signal n_i_c, s0, s1, s2, s3, n_s3, s4, s5, s6, s7, s8: STD_LOGIC;


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
    component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

    end component;

begin
    and0: andg2
    port map(
        i_A => i_c,
        i_B => i_b,
        o_F => s0
    );

    and1: andg2
    port map(
        i_A => i_a,
        i_B => i_c,
        o_F => s1
    );

    and2: andg2
    port map(
        i_A => i_a,
        i_B => i_b,
        o_F => s2
    );

    or0: org2
    port map(
        i_A => i_a,
        i_B => i_b,
        o_F => s3
    );

    not0: invg
    port map(
        i_A => s3,
        o_F => n_s3
    );

    or1: org2
    port map(
        i_A => s0,
        i_B => s1,
        o_F => s4
    );

    or2: org2
    port map(
        i_A => s2,
        i_B => n_s3,
        o_F => s5
    );

    xor0: xorg2
    port map(
        i_A => i_a,
        i_B => i_b,
        o_F => s6
    );

    or3: org2
    port map(
        i_A => s4,
        i_B => s2,
        o_F => o_c
    );

    and3: andg2
    port map(
        i_A => i_c,
        i_B => s5,
        o_F => s7
    );

    not1: invg
    port map(
        i_A => i_c,
        o_F => n_i_c
    );

    and4: andg2
    port map(
        i_A => n_i_c,
        i_B => s6,
        o_F => s8
    );

    or4: org2
    port map(
        i_A => s7,
        i_B => s8,
        o_F => o_f
    );

end structural;
