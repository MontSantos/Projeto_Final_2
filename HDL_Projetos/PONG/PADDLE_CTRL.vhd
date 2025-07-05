LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY PADDLE_CTRL IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		v_sync : IN STD_LOGIC;
		go_signal : IN STD_LOGIC;
		state_space : IN STD_LOGIC;
		state_w : IN STD_LOGIC;
		state_s : IN STD_LOGIC;
		state_i : IN STD_LOGIC;
		state_k : IN STD_LOGIC;
		p1y : OUT NATURAL;
		p2y : OUT NATURAL
	);
END PADDLE_CTRL;
ARCHITECTURE Behavioral OF PADDLE_CTRL IS

	SIGNAL multiplier : NATURAL := 8; 

	SIGNAL p1y_reg : NATURAL := (v_pixels / 2) - (paddle_height / 2);
	SIGNAL p2y_reg : NATURAL := (v_pixels / 2) - (paddle_height / 2);

BEGIN
	PROCESS (pixel_clock)
		BEGIN
			IF rising_edge(pixel_clock) THEN
				IF go_signal = '1' THEN
					IF (state_space = '1') THEN
						p1y_reg <= (v_pixels / 2) - (paddle_height / 2);
						p2y_reg <= (v_pixels / 2) - (paddle_height / 2);
					ELSE 
						IF state_w = '1' THEN
							IF p1y_reg > border THEN
								p1y_reg <= p1y_reg - (1 * multiplier);
							END IF;
						END IF;
						
						IF state_s = '1' THEN
							IF p1y_reg < (95 * border - paddle_height) THEN
								p1y_reg <= p1y_reg + (1 * multiplier);
							END IF;
						END IF;
						
						IF state_i = '1' THEN
							IF p2y_reg > border THEN
								p2y_reg <= p2y_reg - (1 * multiplier);
							END IF;
						END IF;
						
						IF state_k = '1' THEN
							IF p2y_reg < (95 * border - paddle_height) THEN
								p2y_reg <= p2y_reg + (1 * multiplier);
							END IF;
						END IF;
						
					END IF;
				END IF;
			END IF;
		END PROCESS;

		p1y <= p1y_reg;
		p2y <= p2y_reg;

END Behavioral;