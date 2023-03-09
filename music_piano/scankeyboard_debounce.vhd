library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity scankeyboard_debounce is
    port(
            clk:        in std_logic;                             --clock signal
            rst:        in std_logic;                             --reset signal 
            c:          in std_logic_vector(4 downto 1);          --column signal      
			   r:          buffer std_logic_vector(4 downto 1);      --row signal 
            keyvalue:   buffer std_logic_vector(4 downto 0);      --key value
            keyfinish:  out std_logic                             --key latch signal   
    
        );
end scankeyboard_debounce;

architecture an of scankeyboard_debounce is
	 constant         SET_TIME : integer:=250000;                  --timer:5ms
    signal           cnt : integer range 0 to 3:=0;               --scanning signal
    signal           time_cnt : integer range 0 to 500000:=0;
    signal           c1 : std_logic_vector(4 downto 1 );          --input of the first column
    signal           c2 : std_logic_vector(4 downto 1 );          --input of the second column
    signal           c3 : std_logic_vector(4 downto 1 );          --input of the third column
    signal           c4 : std_logic_vector(4 downto 1 );          --input of the fourth column
    signal           c1_n : std_logic_vector(4 downto 1 );        --the next state of c1
    signal           c2_n : std_logic_vector(4 downto 1 );        --the next state of c2
    signal           c3_n : std_logic_vector(4 downto 1 );        --the next state of c3
    signal           c4_n : std_logic_vector(4 downto 1 );        --the next state of c4
    signal           c1_tmp : std_logic_vector(4 downto 1 );      --input of c1 with eliminating jitter
    signal           c2_tmp : std_logic_vector(4 downto 1 );      --input of c2 with eliminating jitter
    signal           c3_tmp : std_logic_vector(4 downto 1 );      --input of c3 with eliminating jitter
    signal           c4_tmp : std_logic_vector(4 downto 1 );      --input of c4 with eliminating jitter
    
    signal           keyflag : std_logic_vector(3 downto 0 );     --whether to press the key for all columns
    signal           keyflag_n : std_logic_vector(3 downto 0 );   --the next state of keyflag
    signal           keyvalue_n : std_logic_vector(4 downto 0 );  --the next state of keyvalue

begin 
    
	 process(clk,rst)
    begin
        if rst = '0' then
            time_cnt <= 0;
		      cnt <= 0;
        elsif clk'event and clk= '1' then
            if time_cnt = SET_TIME then
					time_cnt <= 0;
				if cnt = 3 then
					cnt <= 0;
				else 
					cnt <= cnt+1;
				end if;
				else
				time_cnt <= time_cnt+1;
            end if;
        end if;
    end process; 
    
    process(cnt)
    begin
        case cnt is
		      when 0 => r <= "1110";
			   when 1 => r <= "1101";
			   when 2 => r <= "1011";
			   when 3 => r <= "0111";
            when others =>
        end case;
    end process;     
    
    process(r(1))
    begin
        if r(1)'event and r(1) = '1' then
            c1 <= c;					
            c1_n <= c1;	
	     end if;
    end process;  
    
	 c1_tmp <= c1 or c1_n;
    
	 process(r(2))
    begin
        if r(2)'event and r(2) = '1' then
            c2 <= c;					
            c2_n <= c2;	
        end if;
    end process;  
    
	 c2_tmp<=c2 or c2_n;
    
	 process(r(3))
    begin
        if r(3)'event and r(3) = '1' then
            c3 <= c;					
            c3_n <= c3;	
        end if;
    end process;  
    
	 c3_tmp<=c3 or c3_n;
    
	 process(r(4))
    begin
        if r(4)'event and r(4) = '1' then
            c4 <= c;					
            c4_n <= c4;	
        end if;
    end process;  
    
	 c4_tmp<=c4 or c4_n;
     
    process(clk,rst)   --set the value ofkeyflag
    begin
        if rst='0' then
            keyflag <= "1111";	
        elsif clk'event and clk = '1' then
            keyflag <= keyflag_n;
        end if;
    end process; 
    
    process(r,c1_tmp,c2_tmp,c3_tmp,c4_tmp)
    begin
        case r is
		      when "1110" => if c1_tmp="1111" then
                               keyflag_n <= keyflag(3 downto 1)&'1';
                           else
                               keyflag_n <= keyflag(3 downto 1)&'0';
                           end if;
			   when "1101" => if c2_tmp="1111" then
                               keyflag_n <= keyflag(3 downto 2)&'1'&keyflag(0);
                           else
                               keyflag_n <= keyflag(3 downto 2)&'0'&keyflag(0);
                           end if;
			   when "1011" => if c3_tmp="1111" then
                               keyflag_n <= keyflag(3)&'1'&keyflag(1 downto 0);
                           else
                               keyflag_n <= keyflag(3)&'0'&keyflag(1 downto 0);
                           end if;
			   when "0111" => if c4_tmp="1111" then
                               keyflag_n <= '1'&keyflag(2 downto 0);
                           else
                               keyflag_n <= '0'&keyflag(2 downto 0);
                           end if;
            when others => keyflag_n <= keyflag;
        end case;
    end process; 
    
    process(clk,rst)   --set the value of keyvalue
    begin
        if rst = '0' then
            keyvalue <= "10000";
        elsif clk'event and clk = '1' then
            keyvalue <= keyvalue_n;
        end if;
    end process;
    
    process(keyflag,c1_tmp,c2_tmp,c3_tmp,c4_tmp)
    begin
        case keyflag is
		      when "1110" => case c1_tmp is
                               when "1110" => keyvalue_n <= "00000";
                               when "1101" => keyvalue_n <= "00001";
                               when "1011" => keyvalue_n <= "00010";
                               when "0111" => keyvalue_n <= "00011";
                               when others => keyvalue_n <= keyvalue;
                           end case;
			   when "1101" => case c2_tmp is
                               when "1110" => keyvalue_n <= "00100";
                               when "1101" => keyvalue_n <= "00101";
                               when "1011" => keyvalue_n <= "00110";
                               when "0111" => keyvalue_n <= "00111";
                               when others => keyvalue_n <= keyvalue;
                           end case;
			   when "1011" => case c3_tmp is
                               when "1110" => keyvalue_n <= "01000";
                               when "1101" => keyvalue_n <= "01001";
                               when "1011" => keyvalue_n <= "01010";
                               when "0111" => keyvalue_n <= "01011";
                               when others => keyvalue_n <= keyvalue;
                           end case;
			   when "0111" => case c4_tmp is
                               when "1110" => keyvalue_n <= "01100";
                               when "1101" => keyvalue_n <= "01101";
                               when "1011" => keyvalue_n <= "01110";
                               when "0111" => keyvalue_n <= "01111";
                               when others => keyvalue_n <= keyvalue;
                           end case;
            when "1111" => keyvalue_n <= "10000";
            when others => keyvalue_n <= keyvalue;
        end case;
    end process;   
    
    process(keyflag)   --set the value of keyflag 
    begin
        if keyflag = "1111" then
            keyfinish <= '1';
        else
            keyfinish <= '0';
        end if;
    end process;

end an;