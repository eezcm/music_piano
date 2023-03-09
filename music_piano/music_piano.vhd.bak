library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity music_piano is
    port(
            clk:        in std_logic;                       --时钟信号
            rst:        in std_logic;                       --复位信号
			   c:          in std_logic_vector(4 downto 1);    --行信号      
			   r:          buffer std_logic_vector(4 downto 1);   --列信号 
            beep_o:     out std_logic;                      --蜂鸣器输出 
				led:        out std_logic_vector(3 downto 0);   --led按键
				sel:        out std_logic_vector(5 downto 0);	--数码管段选
				ledag:		out std_logic_vector(7 downto 0)		--数码管位选
        );
end music_piano;

architecture an of music_piano is 
	signal  keyvalue:   std_logic_vector(4 downto 0);   --键值
	signal  keyfinish:  std_logic;                       --按键锁存标志   
begin 
	scankeyboard_debounce_inst    :entity work.scankeyboard_debounce      port map(clk,rst,c,r,keyvalue,keyfinish);
	musical_piano_inst    :entity work.musical_piano      port map(clk,rst,keyfinish,keyvalue,beep_o,led,sel,ledag);

end an;