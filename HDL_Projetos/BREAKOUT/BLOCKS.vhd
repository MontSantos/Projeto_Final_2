LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY BLOCKS IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		go_signal : IN STD_LOGIC;
		dir_y_O : IN INTEGER;
		bx : IN INTEGER;
		by : IN INTEGER;
		state_space : IN STD_LOGIC;
		parede : OUT block_mat;
		hit : OUT STD_LOGIC;
		game : OUT STD_LOGIC;
		score1 : OUT NATURAL;
		score2 : OUT NATURAL
	);
END BLOCKS;
ARCHITECTURE Behavioral OF BLOCKS IS
	
	SIGNAL parede_reg : block_mat := (OTHERS => (OTHERS => '1'));
	SIGNAL hit_reg, game_reg : STD_LOGIC := '0';
	SIGNAL score1_reg : NATURAL RANGE 0 TO 9 := 0;
	SIGNAL score2_reg : NATURAL RANGE 0 TO 9 := 0;

BEGIN
	PROCESS (pixel_clock)
		VARIABLE x_ind, y_ind : INTEGER;
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF go_signal = '1' THEN
				IF (state_space = '1') THEN
					parede_reg <= (OTHERS => (OTHERS => '1'));
					score1_reg <= 9;
					score2_reg <= 5;
					hit_reg <= '0';
					game_reg <= '0';
				
				ELSIF (score1_reg = 9 AND score2_reg = 6) THEN
					game_reg <= '1';

				ELSE 
					hit_reg <= '0';
					IF (bx >= block_x AND bx + b_size < block_x + n_blocks * block_width) AND
					(by >= block_y - b_size AND by < block_y + n_lin * block_height) THEN
						x_ind := (bx - block_x) / (block_width);
						
						IF (dir_y_O = -1) THEN
							y_ind := ((by) - block_y) / (block_height);
						ELSE
							y_ind := ((by) + b_size - block_y) / (block_height);
						END IF;
						
						IF x_ind >= 0 AND x_ind < n_blocks AND
                     y_ind >= 0 AND y_ind < n_lin THEN
							
							IF (parede_reg(y_ind)(x_ind) = '1') THEN
								parede_reg(y_ind)(x_ind) <= '0';
								hit_reg <= '1';
								IF (score2_reg < 9) THEN
									score2_reg <= score2_reg + 1;
								ELSE 
									score2_reg <= 0;
									score1_reg <= score1_reg + 1;
									
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	
	game <= game_reg;
	parede <= parede_reg;
	hit <= hit_reg;
	score1 <= score1_reg;
	score2 <= score2_reg;
END Behavioral;