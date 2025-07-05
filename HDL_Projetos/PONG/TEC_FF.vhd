LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

ENTITY TEC_FF IS
	PORT (
		pixel_clock : IN STD_LOGIC;
		new_tec : IN STD_LOGIC;
		teclado : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		state_space : OUT STD_LOGIC;
		state_w : OUT STD_LOGIC;
		state_s : OUT STD_LOGIC;
		state_i : OUT STD_LOGIC; 
		state_k : OUT STD_LOGIC
	);
END ENTITY TEC_FF;

ARCHITECTURE behavioral OF TEC_FF IS

	SIGNAL reg_read, reg_new, tic_reg : STD_LOGIC := '0';
	SIGNAL tec_r0, tec_r1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL reg_w, reg_s, reg_i, reg_k, reg_space : STD_LOGIC := '0';
	
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
					WHEN x"43" => reg_i <= '0';
					WHEN x"42" => reg_k <= '0';
					WHEN x"29" => reg_space <= '0';
					WHEN OTHERS => NULL;
				END CASE;
			ELSE
				CASE tec_r0 IS
					WHEN x"1D" => reg_w <= '1';
					WHEN x"1B" => reg_s <= '1';
					WHEN x"43" => reg_i <= '1';
					WHEN x"42" => reg_k <= '1';
					WHEN x"29" => reg_space <= '1';
					WHEN OTHERS => NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	tic_reg <= reg_read AND NOT reg_new;
	
	state_w <= reg_w;
	state_s <= reg_s;
	state_i <= reg_i;
	state_k <= reg_k;
	state_space <= reg_space;
	
END behavioral;