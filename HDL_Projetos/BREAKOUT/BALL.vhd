LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY BALL IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		go_signal : IN STD_LOGIC;
		hit : IN STD_LOGIC;
		game : IN STD_LOGIC;
		p1x : IN NATURAL;
		state_space : IN STD_LOGIC;
		audio_val : OUT  NATURAL;
		bx : OUT INTEGER;
		by : OUT INTEGER;
		dir_y_O : OUT INTEGER;
		life : OUT NATURAL
	);
END BALL;
ARCHITECTURE Behavioral OF BALL IS

	SIGNAL bx_reg : NATURAL := h_pixels / 2 - b_size/2; --h_pixels / 2;
	SIGNAL by_reg : NATURAL := (v_pixels / 2) - b_size / 2;
	
	SIGNAL ini : STD_LOGIC := '1';
	
	SIGNAL audio_reg : NATURAL RANGE 0 TO 4 := 0;
 
	SIGNAL multiplier : INTEGER RANGE 2 TO 6 := 2;
	SIGNAL multiplier_Y : INTEGER RANGE 1 TO 4 := 1;
	SIGNAL dir : INTEGER := - 1;
	SIGNAL dir_y : INTEGER := 1;
	
	SIGNAL life_reg : NATURAL RANGE 0 TO 3 := 3;

BEGIN
	PROCESS (pixel_clock)
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF go_signal = '1' THEN						
				IF(state_space = '1') THEN 
						bx_reg <= h_pixels / 2 - b_size / 2;
						by_reg <= (v_pixels / 2) - b_size / 2;
						ini <= '0';
						audio_reg <= 0;
						life_reg <= 3;
						multiplier <= 2;
						multiplier_y <= 1;
						dir <= - 1;
						dir_y <= 1;
						
				ELSE
					IF (ini = '0') THEN	
						IF (by_reg >= v_pixels - border - b_size) THEN
							life_reg <= life_reg - 1;
							audio_reg <= 4;
							
							IF (life_reg > 1) AND (game = '0') THEN
								bx_reg <= h_pixels / 2 - b_size / 2;
								by_reg <= (v_pixels / 2) - b_size / 2;
								multiplier <= 2;
								multiplier_y <= 1;
							ELSE 
								ini <= '1';
							END IF;
						
						ELSIF (by_reg >= border) AND (by_reg + (multiplier_y * dir_y) <= border)THEN -- colisao superior
							by_reg <= border;
							dir_y <= 1;
							audio_reg <= 2;
							
						ELSIF (bx_reg + b_size <= h_pixels - border) AND (bx_reg + b_size + (multiplier * dir) >= h_pixels - border) THEN -- colisao direita
							bx_reg <= h_pixels - border - b_size;
							dir <= - 1;
							audio_reg <= 2;
							
						ELSIF (bx_reg >= border) AND (bx_reg + (multiplier * dir) <= border) THEN -- colisao esquerda
							bx_reg <= border;
							dir <= + 1;
							audio_reg <= 2;
						
						ELSIF (hit = '1') THEN -- colisao com bloco
							dir_Y <= -dir_y;
							audio_reg <= 3;
							IF multiplier_y <= 4 THEN
								multiplier_y <= multiplier_y + 1;
							END IF;

							-- Colisão com raquete
						ELSIF ((by_reg + b_size + (multiplier_y * dir_y) >= p1y) AND (by_reg + b_size <= p1y) AND -- cruzou a borda da raquete
								(bx_reg >= p1x - b_size) AND (bx_reg <= p1x + paddle_width)) THEN
							IF (dir = -1) AND (bx_reg >= p1x + paddle_width/2) THEN
								dir <= - dir;
							ELSIF (dir = 1) AND (bx_reg < p1x + paddle_width/2) THEN
								dir <= - dir;
							END IF;
							audio_reg <= 1;
							dir_y <= - dir_y;
							by_reg <= p1y - b_size; -- Reposiciona fora da raquete
							IF multiplier <= 6 THEN
								multiplier <= multiplier + 1;
							END IF;

							-- Nenhuma colisão: libera movimento
						ELSE
							audio_reg <= 0;
							bx_reg <= bx_reg + (multiplier * dir);
							by_reg <= by_reg + dir_y * multiplier_y;
						END IF;
					ELSE
						audio_reg <= 0;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	bx <= bx_reg;
	by <= by_reg;
	audio_val <= audio_reg;
	dir_y_O <= dir_y;
	life <= life_reg;

END Behavioral;