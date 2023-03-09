-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "02/05/2023 22:24:43"
                                                            
-- Vhdl Test Bench template for design  :  music_piano
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY music_piano_vhd_tst IS
END music_piano_vhd_tst;
ARCHITECTURE music_piano_arch OF music_piano_vhd_tst IS
-- constants  
constant clk_period :time   :=20 ns; --时钟的定义                                              
-- signals                                                   
SIGNAL beep_o : STD_LOGIC;
SIGNAL c : STD_LOGIC_VECTOR(4 DOWNTO 1);
SIGNAL clk : STD_LOGIC;
SIGNAL led : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL r : STD_LOGIC_VECTOR(4 DOWNTO 1);
SIGNAL rst : STD_LOGIC;
SIGNAL key : STD_LOGIC_VECTOR(4 DOWNTO 0);
COMPONENT music_piano
	PORT (
	beep_o : OUT STD_LOGIC;
	c : IN STD_LOGIC_VECTOR(4 DOWNTO 1);
	clk : IN STD_LOGIC;
	led : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	r : BUFFER STD_LOGIC_VECTOR(4 DOWNTO 1);
	rst : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : music_piano
	PORT MAP (
-- list connections between master ports and signals
	beep_o => beep_o,
	c => c,
	clk => clk,
	led => led,
	r => r,
	rst => rst
	);
	 clk_gen:process --时钟信号 
    begin
        clk<='1';
        wait for clk_period/2;
        clk<='0';
        wait for clk_period/2;  
    end process;    
    rst_gen:process --复位信号
    begin  
        rst<='0';
        wait for 20 us;
        rst<='1';  
        wait;       --will wait forever; 
    end process;   
process 
    begin 
       key<="10000";
       wait for 100 ms;--等待稳定
       
       
       wait for 50 ms;
       
       key<="01000";--选择音调
       wait for 50 ms;
       key<="10000";  
    
       wait for 50 ms;
        
       key<="01001";--选择音调
       wait for 50 ms;
       key<="10000"; 
       
       wait for 50 ms;

       key<="00000";--确定
       wait for 50 ms;
       key<="10000";  
       
       wait for 50 ms;
       
       key<="00101";
       wait for 50 ms;
       key<="10000"; 
       
       wait for 50 ms;
       
       key<="00111";
       wait for 50 ms;
       key<="10000";
       
       wait for 50 ms;
       
       key<="01011";--回放
       wait for 50 ms;
       key<="10000";        
       
		 wait for 1000 ms;
		 
		 key<="01100";--回放
       wait for 50 ms;
       key<="10000"; 
    wait;       --will wait forever; 
    
    end process;  
	 process(key,r)--时序电路,用来给keyvalue寄存器赋值
    begin
        case key is
			when "00000"=>c<= "111"&r(1);
			when "00001"=>c<= "11"&r(1)&'1';
			when "00010"=>c<= '1'&r(1)&"11";
			when "00011"=>c<= r(1)&"111";
			when "00100"=>c<= "111"&r(2);
			when "00101"=>c<= "11"&r(2)&'1';
			when "00110"=>c<= '1'&r(2)&"11";
			when "00111"=>c<= r(2)&"111";
			when "01000"=>c<= "111"&r(3);
			when "01001"=>c<= "11"&r(3)&'1';
			when "01010"=>c<= '1'&r(3)&"11";
			when "01011"=>c<= r(3)&"111";
			when "01100"=>c<= "111"&r(4);
			when "01101"=>c<= "11"&r(4)&'1';
			when "01110"=>c<= '1'&r(4)&"11";
			when "01111"=>c<= r(4)&"111";
            when others=>c<="1111";--全灭
        end case;
    end process;  
END music_piano_arch;
