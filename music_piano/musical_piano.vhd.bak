library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity musical_piano is
    port(
            clk:        in std_logic;                       --时钟信号
            rst:        in std_logic;                       --复位信号
			   keyfinish:  in std_logic;                       --按键锁存信号
            keyvalue:   in std_logic_vector(4 downto 0);    --键值
				beep_o:     out std_logic;                      --蜂鸣器输出 
				led:        out std_logic_vector(3 downto 0);   --led按键
				sel:        out std_logic_vector(5 downto 0);	--数码管段选
				ledag:		out std_logic_vector(7 downto 0)		--数码管位选
        );
end musical_piano;

architecture an of musical_piano is 
	 --低音音符
	 type fretab_type is array(12 downto 0) of integer range 0 to 1000;--低音音符集
    signal fretab:fretab_type;
	 --低音音符1234567所在的位置
	 type signtab_type is array(7 downto 0) of integer range 0 to 12;
    signal signtab:signtab_type;
	 --频率计数器对应
	 signal  fre_cnt:      	integer range 0 to 50000000:=0;
	 signal  current_fre:    integer range 0 to 50000000:=0;
	 --矩阵键盘转独立按键
	 signal  key,key_n1,key_n2,key_fin:        std_logic_vector(15 downto 0);
	 --模式切换
	 signal  musical_piano_mode:      	integer range 0 to 1:=0; 
	 signal  current_fre1:    integer range 0 to 50000000:=0; --给模式1用的频率
	 signal  current_fre2:    integer range 0 to 50000000:=0; --给模式2用的频率
	 signal  beep1:    std_logic ; --给模式1
	 signal  beep2:    std_logic ; --给模式2
	 signal  cnt1:    integer range 0 to 50000000:=0; --给模式1用的计数器
	 signal  cnt2:    integer range 0 to 50000000:=0; --给模式2用的计数器
	 --音调模式切换
	 signal  fre_mode:    integer range 0 to 2; --3个模式分别为low mid high
	 --节拍切换
	 signal  Freq_flag:   integer range 0 to 2; --3个节拍分别为八分之一、四分之一、二分之一
	 --存储相关
	 signal  keynumber:    integer range 0 to 200:=0; --锁存键值
	 type key_record_type is array(199 downto 0) of std_logic_vector(4 downto 0);--存储的键值
	 signal key_record:key_record_type;
	 type fre_mode_record_type is array(199 downto 0) of integer range 0 to 2;--存储的键值
	 signal fre_mode_record:fre_mode_record_type;
	 type Freq_flag_record_type is array(199 downto 0) of integer range 0 to 2; --三种节拍八分之一、四分之一、二分之一
	 signal Freq_flag_record:Freq_flag_record_type;--存储的节拍值
	 --播放回声模块
	 signal  cnt:      	integer range 0 to 50000000:=0;--记录响的时间
	 signal  state:      	integer range 0 to 50000000:=0;--播放回声的状态
	 signal  counter:      	integer range 0 to 50000000:=0;--纪录当前是第几个音符
	 signal  key_record_now:std_logic_vector(4 downto 0);
	 signal  fre_mode_record_now:integer range 0 to 2;
	 signal  Freq_flag_record_now:integer range 0 to 2;
	 signal  delete_flag:integer range 0 to 1;
	 --暂停开始信号
	 signal  stop_flag:    integer range 0 to 1; --0为开始 1为暂停
	 --数码管相关信号
	 signal  cp:			integer range 0 to 50000000:=0;
	 signal  count:		std_logic_vector(2 downto 0);
	 signal  sel_1:		std_logic_vector(5 downto 0);
	 
begin 
  
	 process(clk,rst)--扫描进程
    begin
        if rst='0' then--如果复位
            key <= "0000000000000000";
        elsif clk'event and clk='1' then--时钟上升沿
            case keyvalue is
                when "00000"=>key<="0000000000000001";
                when "00001"=>key<="0000000000000010";
                when "00010"=>key<="0000000000000100";
                when "00011"=>key<="0000000000001000";
                when "00100"=>key<="0000000000010000";
                when "00101"=>key<="0000000000100000";
                when "00110"=>key<="0000000001000000";
                when "00111"=>key<="0000000010000000";
					 
                when "01000"=>key<="0000000100000000";
                when "01001"=>key<="0000001000000000";
                when "01010"=>key<="0000010000000000";
                when "01011"=>key<="0000100000000000";
                when "01100"=>key<="0001000000000000";
                when "01101"=>key<="0010000000000000";
                when "01110"=>key<="0100000000000000";
                when "01111"=>key<="1000000000000000";
                when "10000"=>key<="0000000000000000";
                when others=> key<="0000000000000000";
            end case;
        end if;
    end process; 
    
	 process(clk,rst)
    begin
        if rst='0' then
            key_n1<="0000000000000000";
				key_n2<="0000000000000000";
        elsif clk'event and clk='1' then--时钟上升沿
				key_n1<=key;
				key_n2<=key_n1;
        end if;
    end process;     
    key_fin<=key_n1 and (not key_n2);
	 
	 process(clk,rst)--时序电路,切换模式暂停开始电路
    begin
        if rst='0' then--如果复位
            musical_piano_mode <= 0;
				stop_flag <= 0;	
        elsif clk'event and clk='1' then--时钟上升沿
				if key_fin(11)='1' then
					if musical_piano_mode = 0 then
						musical_piano_mode <= 1;
						stop_flag <= 0;
					else
						musical_piano_mode <= 0;
					end if;
--				elsif key_fin(12)='1' then
--					if stop_flag = 0 then
--						stop_flag <= 1;
--					else
--						stop_flag <= 0;
--					end if;
				elsif counter=keynumber-1 and state=4 then
					stop_flag <= 1;
				end if;
        end if;
    end process; 

--	 process(clk,rst)--暂停开始电路
--    begin
--        if rst='0' then--如果复位
--            stop_flag <= 0;	
--        elsif clk'event and clk='1' then--时钟上升沿
--				if key_fin(12)='1' then
--					if stop_flag = 0 then
--						stop_flag <= 1;
--					else
--						stop_flag <= 0;
--					end if;
--				elsif counter=keynumber-1 then
--					stop_flag <= 1;
--				end if;
--        end if;
--    end process; 
	 
	 process(clk,rst)--时序电路,切换音调
    begin
        if rst='0' then--如果复位
            fre_mode <= 0;	
        elsif clk'event and clk='1' then--时钟上升沿
				if key_fin(10)='1' then
					fre_mode<= 2;
				elsif key_fin(9)='1' then
					fre_mode<= 1;
				elsif key_fin(8)='1' then
					fre_mode<= 0;
				end if;
        end if;
    end process; 
	
	 process(clk,rst)--时序电路,切换音调
    begin
        if rst='0' then--如果复位
            Freq_flag <= 0;	
        elsif clk'event and clk='1' then--时钟上升沿
				if key_fin(12)='1' then
					Freq_flag<= 0;
				elsif key_fin(13)='1' then
					Freq_flag<= 1;
				elsif key_fin(14)='1' then
					Freq_flag<= 2;
				end if;
        end if;
    end process; 
	
	 process(clk,rst)--模式0 按键发声
    begin
        if rst='0' then--如果复位
            current_fre1 <= 0;	
        elsif clk'event and clk='1' then--时钟上升沿
				if musical_piano_mode=0 then
					if keyfinish='0' then
						case keyvalue is
							when "00000"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(0));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(0))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(0))*4;
												else 
													current_fre1<=0;
												end if;
							when "00001"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(1));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(1))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(1))*4;
												else 
													current_fre1<=0;
												end if;
							when "00010"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(2));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(2))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(2))*4;
												else 
													current_fre1<=0;
												end if;
							when "00011"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(3));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(3))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(3))*4;
												else 
													current_fre1<=0;
												end if;
							when "00100"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(4));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(4))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(4))*4;
												else 
													current_fre1<=0;
												end if;
							when "00101"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(5));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(5))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(5))*4;
												else 
													current_fre1<=0;
												end if;
							when "00110"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(6));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(6))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(6))*4;
												else 
													current_fre1<=0;
												end if;
							when "00111"=>	if fre_mode=0 then
													current_fre1<=fretab(signtab(7));
												elsif fre_mode=1 then
													current_fre1<=fretab(signtab(7))*2;
												elsif fre_mode=2 then
													current_fre1<=fretab(signtab(7))*4;
												else 
													current_fre1<=0;
												end if;
							when others=> current_fre1<=0;
						end case;
				end if;
			end if;
		end if;
    end process; 
	 
	 --发声模块0 用于按键发声
	 process(clk,rst)
    begin
        if rst='0' then--如果复位
            beep1<='1';
				cnt1<=0;	
        elsif clk'event and clk='1' then--时钟上升沿
            if musical_piano_mode=0 then
					if keyfinish='0' and fre_cnt/=0 then
						if cnt1 < fre_cnt then
							cnt1 <= cnt1+1;
						else cnt1 <= 0;
						end if;
						if cnt1 <= (fre_cnt/2-1) then
							beep1<='1';
						else 
							beep1<='0';
						end if;
					else 
						beep1<='1';
						cnt1<=0;	
					end if;
				else
					beep1<='1';
					cnt1<=0;	
				end if;
        end if;
    end process; 
	 
	 --按键键值对应音频锁存信号
	 process(keyfinish,rst)--时序电路,用来给keyflag寄存器赋值
    begin
        if rst='0' then--如果复位
            keynumber<=0;
				delete_flag<=0;	
        elsif keyfinish'event and keyfinish='1' then--时钟上升沿
            if musical_piano_mode=0 then
					if delete_flag=1 then
						delete_flag<=0;
						keynumber<=0;
					elsif keyvalue="00000" or keyvalue="00001" or keyvalue="00010" or keyvalue="00011" or keyvalue="00100" or keyvalue="00101" or keyvalue="00110" or keyvalue="00111" or keyvalue="01111"then
						if keynumber < 200 then
							Freq_flag_record(keynumber) <= Freq_flag;
							key_record(keynumber) <= keyvalue;
							fre_mode_record(keynumber) <= fre_mode;
							keynumber <= keynumber + 1;
						end if;
					end if;
				else 
					delete_flag<=1;
				end if;
        end if;
    end process; 
	 
	 --播放回声进程
	 process(clk,rst)--时序电路,用来给keyflag寄存器赋值
    begin
        if rst='0' then--如果复位
				counter<=0;
				state<=0;
				cnt<=0;
				current_fre2<=0;
				Freq_flag_record_now<=0;
				key_record_now<="00000";
				fre_mode_record_now<=0;
        elsif clk'event and clk='1' then--时钟上升沿
				if musical_piano_mode=1 and stop_flag = 0 then
					if state=0 then
						Freq_flag_record_now<=Freq_flag_record(counter);
						key_record_now<=key_record(counter);
						fre_mode_record_now<=fre_mode_record(counter);
						state<=1;
					elsif state=1 then
						case key_record_now is
								when "00000"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(0));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(0))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(0))*4;
													else 
														current_fre2<=0;
													end if;
								when "00001"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(1));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(1))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(1))*4;
													else 
														current_fre2<=0;
													end if;
								when "00010"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(2));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(2))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(2))*4;
													else 
														current_fre2<=0;
													end if;
								when "00011"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(3));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(3))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(3))*4;
													else 
														current_fre2<=0;
													end if;
								when "00100"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(4));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(4))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(4))*4;
													else 
														current_fre2<=0;
													end if;
								when "00101"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(5));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(5))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(5))*4;
													else 
														current_fre2<=0;
													end if;
								when "00110"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(6));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(6))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(6))*4;
													else 
														current_fre2<=0;
													end if;
								when "00111"=>	if fre_mode_record_now=0 then
														current_fre2<=fretab(signtab(7));
													elsif fre_mode_record_now=1 then
														current_fre2<=fretab(signtab(7))*2;
													elsif fre_mode_record_now=2 then
														current_fre2<=fretab(signtab(7))*4;
													else 
														current_fre2<=0;
													end if;
								when others=> current_fre2<=0;
							end case;
							state<=2;
					elsif state=2 then
						if current_fre2=0 then
							if cnt=2500000 then
								cnt<=0;
								state<=4;
							else cnt<=cnt+1;
							end if;

						elsif Freq_flag_record_now=0 then
							if cnt=10000000 then
								cnt<=0;
								state<=3;
								current_fre2<=0;
							else
								cnt<=cnt+1;
							end if;
						elsif Freq_flag_record_now=1 then
							if cnt=15000000 then
								cnt<=0;
								state<=3;
								current_fre2<=0;
							else
								cnt<=cnt+1;
							end if;
						elsif Freq_flag_record_now=2 then
							if cnt=30000000 then
								cnt<=0;
								state<=3;
								current_fre2<=0;
							else
								cnt<=cnt+1;
							end if;
						end if;
					elsif state=3 then
						if cnt=2500000 then
							cnt<=0;
							state<=4;
						else
							cnt<=cnt+1;
						end if;
					elsif state=4 then
						state<=0;
						cnt<=0;
						current_fre2<=0;
						key_record_now<="00000";
						fre_mode_record_now<=0;
						if counter=keynumber-1 then
							counter<=0;
                  else 
							counter<=counter+1;
						end if;
					end if;
				else
					counter<=0;
					state<=0;
					cnt<=0;
					current_fre2<=0;
					key_record_now<="00000";
					fre_mode_record_now<=0;
				end if;
        end if;
    end process; 	 
	 
	 --发声模块1 用于回放
	 process(clk,rst)
    begin
        if rst='0' then--如果复位
            beep2<='1';
				cnt2<=0;	
        elsif clk'event and clk='1' then--时钟上升沿
            if musical_piano_mode=1 and fre_cnt/=0 then
					if cnt2 < fre_cnt then
						cnt2 <= cnt2+1;
					else cnt2 <= 0;
					end if;
					if cnt2 <= (fre_cnt/2-1) then
						beep2<='1';
					else 
						beep2<='0';
					end if;
				else
					beep2<='1';
					cnt2<=0;	
				end if;
        end if;
    end process; 
	 
	 --选择控制器模块
	 beep_o<=beep1 when musical_piano_mode=0 else beep2;
	 current_fre<=current_fre1 when musical_piano_mode=0 else current_fre2;
	 
	 --led控制电路
	 process(musical_piano_mode,Freq_flag)
    begin
        if musical_piano_mode=0 then led(0)<='0';
		  else led(0)<='1';
		  end if;
		   if Freq_flag=2 then
				led(3 downto 1)<="001";
		   elsif Freq_flag=1 then
				led(3 downto 1)<="010";
		   elsif Freq_flag=0 then
				led(3 downto 1)<="100";
			end if;
    end process; 
	 
	 --数码管控制电路
	 process(clk)
	 
	 begin
	 
		  if (clk'event and clk='1') then
				if cp=100000 then
				   cp<=0;
					count<=count+1;
				else cp<=cp+1;
				end if;
		  end if;
		  sel<=sel_1;
	 end process;
	 
	 process(count)
	 begin
		  case count is
				 when"000"=>sel_1<="111110";
				 when"001"=>sel_1<="111101";
				 when"010"=>sel_1<="111011";
				 when"011"=>sel_1<="110111";
				 when"100"=>sel_1<="101111";
				 when"101"=>sel_1<="011111";
				 when others=>null;
		  end case;
	 end process;
	 
	 --数码管点亮
	 process(musical_piano_mode,fre_mode)
	 begin
		  if musical_piano_mode=1 then 
		     if sel_1(5 downto 0)="110111" then
			     ledag<="10001100";
			  elsif sel_1(5 downto 0)="111011" then
			     ledag<="11000111";
			  elsif sel_1(5 downto 0)="111101" then
			     ledag<="10001000";
           elsif sel_1(5 downto 0)="111110" then
			     ledag<="10011001";
			  else ledag<="11111111";
			  end if;
		  elsif fre_mode=2 then
			  if sel_1(5 downto 0)="110111" then
			     ledag<="10001001";
			  elsif sel_1(5 downto 0)="111011" then
			     ledag<="11111001";
			  elsif sel_1(5 downto 0)="111101" then
			     ledag<="11000010";
           elsif sel_1(5 downto 0)="111110" then
			     ledag<="10001001";
			  else ledag<="11111111";
			  end if;
		   elsif fre_mode=1 then
			  if sel_1(5 downto 0)="110111" then
			     ledag<="11001000";
			  elsif sel_1(5 downto 0)="111011" then
			     ledag<="11111001";
			  elsif sel_1(5 downto 0)="111101" then
			     ledag<="10100001";
           elsif sel_1(5 downto 0)="111110" then
			     ledag<="10000110";
			  else ledag<="11111111";
			  end if;
		   elsif fre_mode=0 then
			  if sel_1(5 downto 0)="111011" then
			     ledag<="11000111";
			  elsif sel_1(5 downto 0)="111101" then
			     ledag<="10100011";
           elsif sel_1(5 downto 0)="111110" then
			     ledag<="10000001";
			  else ledag<="11111111";
			  end if;
			end if;
    end process; 
	 
	 --低音音符对应的频率
	 fretab(0) <= 262;
	 fretab(1) <= 277;
	 fretab(2) <= 294;
	 fretab(3) <= 311;
	 fretab(4) <= 330;
	 fretab(5) <= 349;
	 fretab(6) <= 369;
	 fretab(7) <= 392;
	 fretab(8) <= 415;
	 fretab(9) <= 440;
	 fretab(10)<= 466;
	 fretab(11)<= 494;
	 fretab(12)<= 524;
	 
	 --频率表位置
    signtab(0)<= 0;
    signtab(1)<= 2;
	 signtab(2)<= 4;
	 signtab(3)<= 5;
	 signtab(4)<= 7;
	 signtab(5)<= 9;
	 signtab(6)<= 11;
	 signtab(7)<= 12;
	 
	 --频率计数器
    process(current_fre)--频率表
    begin
        case current_fre is
				when 262 =>fre_cnt<=190839;
				when 277 =>fre_cnt<=180505;
				when 294 =>fre_cnt<=170068;
				when 311 =>fre_cnt<=160771;
				when 330 =>fre_cnt<=151515;
				when 349 =>fre_cnt<=143266;
				when 369 =>fre_cnt<=135501;
				when 392 =>fre_cnt<=127551;
				when 415 =>fre_cnt<=120481;
				when 440 =>fre_cnt<=113636;
				when 466 =>fre_cnt<=107296;
				when 494 =>fre_cnt<=101214;

				when 524 =>fre_cnt<=095419;
				when 554 =>fre_cnt<=090252;
				when 588 =>fre_cnt<=085034;
				when 622 =>fre_cnt<=080385;
				when 660 =>fre_cnt<=075757;
				when 698 =>fre_cnt<=071633;
				when 738 =>fre_cnt<=067567;
				when 784 =>fre_cnt<=063775;
				when 830 =>fre_cnt<=060240;
				when 880 =>fre_cnt<=056818;
				when 932 =>fre_cnt<=053648;
				when 988 =>fre_cnt<=050607;


				when 1048=>fre_cnt<=47709;
				when 1108=>fre_cnt<=45126;
				when 1176=>fre_cnt<=42517;
				when 1244=>fre_cnt<=40192;
				when 1320=>fre_cnt<=37878;
				when 1396=>fre_cnt<=35816;
				when 1476=>fre_cnt<=33875;
				when 1568=>fre_cnt<=31887;
				when 1660=>fre_cnt<=30120;
				when 1760=>fre_cnt<=28409;
				when 1864=>fre_cnt<=26824;
				when 1976=>fre_cnt<=25303;	
	
				when 2096=>fre_cnt<=23854;
            when others=>fre_cnt<=0;
        end case;
    end process;
end an;