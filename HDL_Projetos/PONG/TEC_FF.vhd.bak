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
		state_a : OUT STD_LOGIC;
		state_x : OUT STD_LOGIC;
		state_p : OUT STD_LOGIC; 
		state_3 : OUT STD_LOGIC
	);
END ENTITY TEC_FF;

ARCHITECTURE behavioral OF TEC_FF IS

	SIGNAL reg_read, reg_new, tic_reg : STD_LOGIC := '0';
	SIGNAL tec_r0, tec_r1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL reg_a, reg_x, reg_p, reg_3 : STD_LOGIC := '0';
	
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
					WHEN x"1C" => reg_a <= '0';
					WHEN x"22" => reg_x <= '0';
					WHEN x"4D" => reg_p <= '0';
					WHEN x"26" => reg_3 <= '0';
					WHEN OTHERS => NULL;
				END CASE;
			ELSE
				CASE tec_r0 IS
					WHEN x"1C" => reg_a <= '1';
					WHEN x"22" => reg_x <= '1';
					WHEN x"4D" => reg_p <= '1';
					WHEN x"26" => reg_3 <= '1';
					WHEN OTHERS => NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	tic_reg <= reg_read AND NOT reg_new;
	
	state_a <= reg_a;
	state_x <= reg_x;
	state_p <= reg_p;
	state_3 <= reg_3;

END behavioral;