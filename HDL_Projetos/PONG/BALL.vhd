LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY BALL IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		go_signal : IN STD_LOGIC;
		p1y : IN NATURAL;
		p2y : IN NATURAL;
		state_space : IN STD_LOGIC;
		bx : OUT INTEGER;
		by : OUT INTEGER;
		audio_val : OUT NATURAL;
		score1 : OUT NATURAL;
		score2 : OUT NATURAL
	);
END BALL;
ARCHITECTURE Behavioral OF BALL IS

	SIGNAL bx_reg : INTEGER := 512 - b_size/2; --h_pixels / 2;
	SIGNAL by_reg : INTEGER := 384 - b_size/2; --(v_pixels / 2);
	SIGNAL score1_reg : NATURAL RANGE 0 TO 9 := 0;
	SIGNAL score2_reg : NATURAL RANGE 0 TO 9 := 0;
	
	SIGNAL audio_reg : NATURAL RANGE 0 TO 3 := 0;
 
	SIGNAL ini : STD_LOGIC := '1';

	SIGNAL multiplier : INTEGER RANGE 2 TO 12 := 2;
	SIGNAL dir : INTEGER := - 1;
	SIGNAL dir_y : INTEGER := 1;
 
BEGIN
	PROCESS (pixel_clock)
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF go_signal = '1' THEN
				IF (score1_reg = 9 OR score2_reg = 9) THEN
					ini <= '1';
				END IF;
	 
				IF (state_space = '1') THEN
					bx_reg <= 512 - b_size/2;
					by_reg <= 384 - b_size/2;
					score1_reg <= 0;
					score2_reg <= 0;
					ini <= '0';
					audio_reg <= 0;
	 
				ELSE
					IF (ini = '0') THEN
						IF (by_reg + dir_y * multiplier_y <= border) AND  (by_reg >= border) THEN
							audio_reg <= 2;
							by_reg <= border;
							dir_y <= 1;
							
						ELSIF ((by_reg + b_size + dir_y * multiplier_y) >= v_pixels - border) AND ((by_reg + b_size ) <= v_pixels - border) THEN
							audio_reg <= 2;
							by_reg <= v_pixels - border - b_size;
							dir_y <= - 1;
						-- Colisão com as bordas
						
						ELSIF (bx_reg >= h_pixels - border - b_size) OR (bx_reg <= border) THEN
							audio_reg <= 3;
							bx_reg <= 512 - b_size/2;
							multiplier <= 2;
							IF (dir = 1) THEN -- INCREMENTA O PLACAR
								score1_reg <= score1_reg + 1;
							ELSE
								score2_reg <= score2_reg + 1;

							END IF;

							-- Colisão com raquete da esquerda
						ELSIF ((bx_reg + (multiplier * dir) <= p1x) AND (bx_reg >= p1x) AND-- cruzou a borda da raquete
								(by_reg + b_size >= p1y) AND (by_reg <= p1y + paddle_height)) THEN
								audio_reg <= 1;
								bx_reg <= p1x + paddle_width;
								dir <= - dir;
								IF multiplier <= 12 THEN
									multiplier <= multiplier + 1;
								END IF;
								
							-- Colisão com raquete da direita
						ELSIF ((bx_reg + (multiplier * dir) + b_size >= p2x) AND (bx_reg + b_size <= p2x) AND
								(by_reg + b_size >= p2y) AND (by_reg <= p2y + paddle_height)) THEN
									audio_reg <= 1;
									bx_reg <= p2x - b_size;
									dir <= - dir;
									IF multiplier <= 12 THEN
										multiplier <= multiplier + 1;
									END IF;
							-- Nenhuma colisão: libera novo movimento
						ELSE
							audio_reg <= 0;
							bx_reg <= bx_reg + (multiplier * dir);
							by_reg <= by_reg + dir_y * multiplier_y;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	audio_val <= audio_reg;
	bx <= bx_reg;
	by <= by_reg;
	score1 <= score1_reg;
	score2 <= score2_reg;

END Behavioral;