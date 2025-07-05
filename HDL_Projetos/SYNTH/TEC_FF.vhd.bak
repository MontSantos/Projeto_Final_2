LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

ENTITY TEC_FF IS
	PORT (
		pixel_clock : IN STD_LOGIC;
		ps2_CLK : IN STD_LOGIC;
		new_tec : IN STD_LOGIC;
		teclado : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		state_cor : OUT NATURAL RANGE 0 TO 9;
		state_enter : OUT STD_LOGIC;
		state_space : OUT STD_LOGIC;
		state_w : OUT STD_LOGIC;
		state_s : OUT STD_LOGIC;
		state_a : OUT STD_LOGIC; 
		state_d : OUT STD_LOGIC
	);
END ENTITY TEC_FF;

ARCHITECTURE behavioral OF TEC_FF IS

	SIGNAL reg_read, reg_new, tic_reg : STD_LOGIC := '0';
	SIGNAL tec_r0, tec_r1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL reg_w, reg_s, reg_a, reg_d, reg_enter, reg_space : STD_LOGIC := '0';
	SIGNAL reg_cor : NATURAL RANGE 0 TO 9 := 0;
	
BEGIN
	PROCESS (pixel_clock)
	BEGIN
		IF rising_edge(pixel_clock) THEN
			reg_read <= new_tec;
			reg_new <= reg_read;
			IF tic_reg = '1' THEN
				tec_r0 <= teclado;
				tec_r1 <= tec_r0;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS (pixel_clock)
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF tec_r1 = x"F0" THEN
				CASE tec_r0 IS
					WHEN x"1D" => reg_w <= '0';
					WHEN x"1B" => reg_s <= '0';
					WHEN x"1C" => reg_a <= '0';
					WHEN x"23" => reg_d <= '0';
					WHEN x"29" => reg_space <= '0';
					WHEN x"16" => reg_cor <= 1; --1
					WHEN x"1E" => reg_cor <= 2; --2
					WHEN x"26" => reg_cor <= 3; --3
					WHEN x"25" => reg_cor <= 4; --4
					WHEN x"2E" => reg_cor <= 5; --5
					WHEN x"36" => reg_cor <= 6; --6
					WHEN x"3D" => reg_cor <= 7; --7
					WHEN x"3E" => reg_cor <= 8; --8
					WHEN x"46" => reg_cor <= 9; --9
					WHEN x"45" => reg_cor <= 0; --0
					WHEN x"5A" => reg_enter <= '0';
					WHEN OTHERS => NULL;
				END CASE;
			ELSE
				CASE tec_r0 IS
					WHEN x"1D" => reg_w <= '1';
					WHEN x"1B" => reg_s <= '1';
					WHEN x"1C" => reg_a <= '1';
					WHEN x"23" => reg_d <= '1';
					WHEN x"29" => reg_space <= '1';
					WHEN x"16" => reg_cor <= 1; --1
					WHEN x"1E" => reg_cor <= 2; --2
					WHEN x"26" => reg_cor <= 3; --3
					WHEN x"25" => reg_cor <= 4; --4
					WHEN x"2E" => reg_cor <= 5; --5
					WHEN x"36" => reg_cor <= 6; --6
					WHEN x"3D" => reg_cor <= 7; --7
					WHEN x"3E" => reg_cor <= 8; --8
					WHEN x"46" => reg_cor <= 9; --9
					WHEN x"45" => reg_cor <= 0; --0
					WHEN x"5A" => reg_enter <= '1';
					WHEN OTHERS => NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	tic_reg <= reg_read AND NOT reg_new;
	
	state_cor <= reg_cor;
	state_w <= reg_w;
	state_s <= reg_s;
	state_a <= reg_a;
	state_d <= reg_d;
	state_enter <= reg_enter;
	state_space <= reg_space;
	
END behavioral;