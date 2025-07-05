LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY COLOR_CTRL IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		go_signal : IN STD_LOGIC;
		state_cor : IN NATURAL RANGE 0 TO 9;
		state_enter : IN STD_LOGIC;
		state_w : IN STD_LOGIC;
		state_s : IN STD_LOGIC;
		state_a : IN STD_LOGIC; 
		state_d : IN STD_LOGIC;
		w_col_addr : OUT NATURAL RANGE 0 TO n_blocks - 1;
		w_lin_addr : OUT NATURAL RANGE 0 TO n_lin - 1;
		color_data : OUT NATURAL RANGE 0 TO 9;
		tmp_data : OUT NATURAL RANGE 0 TO 9;
		rw_en : OUT STD_LOGIC
	);
END COLOR_CTRL;
ARCHITECTURE Behavioral OF COLOR_CTRL IS

	SIGNAL col_reg : NATURAL RANGE 0 TO n_blocks - 1:= 0;
	SIGNAL lin_reg : NATURAL RANGE 0 TO n_lin - 1:= 0;
	SIGNAL rw_reg : STD_LOGIC := '0';
	
	SIGNAL data_reg : NATURAL RANGE 0 TO 9 := 0;
	SIGNAL data_tmp : NATURAL RANGE 0 TO 9 := 0;

BEGIN
	PROCESS (pixel_clock)
	VARIABLE CNT : NATURAL RANGE 0 TO 6500000:= 0;
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF CNT = 6500000 THEN
				CNT := 0;
				rw_reg <= '0';
				
				data_tmp <= state_cor; -- passa a cor
				
				IF state_w = '1' THEN
					IF lin_reg > 0 THEN
						lin_reg <= lin_reg - 1; --W
					END IF;
				END IF;
				IF state_s = '1' THEN
					IF lin_reg < n_lin - 1 THEN
						lin_reg <= lin_reg + 1; --S
					END IF;
				END IF;
				IF state_a = '1' THEN
					IF col_reg > 0 THEN
						col_reg <= col_reg - 1; --A
					END IF;
				END IF;
				IF state_d = '1' THEN
					IF col_reg < n_blocks - 1 THEN
						col_reg <= col_reg + 1; --D
					END IF;
				END IF;
				
				IF state_enter = '1' THEN
					rw_reg <= '1'; -- pinta o quadrado
					data_reg <= data_tmp;
				END IF;
			END IF;
			CNT := CNT + 1;
		END IF;
	END PROCESS;
	
	rw_en <= rw_reg AND go_signal;
	w_col_addr <= col_reg;
	w_lin_addr <= lin_reg;
	color_data <= data_reg;
	tmp_data <= data_tmp;

END Behavioral;