library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity music_piano is
    port(
            clk:        in std_logic;                         --clock signal
            rst:        in std_logic;                         --reset signal
			   c:          in std_logic_vector(4 downto 1);      --column signal
			   r:          buffer std_logic_vector(4 downto 1);  --row signal 
            beep_o:     out std_logic;                        --buzzer output 
				led:        out std_logic_vector(3 downto 0);     --led key
				sel:        out std_logic_vector(5 downto 0);	  --nixie tube segment selection
				ledag:		out std_logic_vector(7 downto 0)		  --nixie tube bit selection
        );
end music_piano;

architecture an of music_piano is 
	signal  keyvalue:   std_logic_vector(4 downto 0);   --key value
	signal  keyfinish:  std_logic;                      --key latch signal

begin 
	scankeyboard_debounce_inst    :entity work.scankeyboard_debounce      port map(clk,rst,c,r,keyvalue,keyfinish);
	musical_piano_inst    :entity work.musical_piano      port map(clk,rst,keyfinish,keyvalue,beep_o,led,sel,ledag);

end an;