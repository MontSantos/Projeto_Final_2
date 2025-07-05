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
		game : IN STD_LOGIC;
		life : IN NATURAL;
		state_space : IN STD_LOGIC;
		state_a : IN STD_LOGIC;
		state_d : IN STD_LOGIC;
		p1x : OUT NATURAL
	);
END PADDLE_CTRL;
ARCHITECTURE Behavioral OF PADDLE_CTRL IS

	SIGNAL multiplier : NATURAL := 8; 

	SIGNAL p1x_reg : NATURAL := (h_pixels / 2) - (paddle_width / 2);

BEGIN
	PROCESS (pixel_clock)
		BEGIN
			IF rising_edge(pixel_clock) THEN
				IF go_signal = '1' THEN
					IF (state_space = '1') THEN
						p1x_reg <= (h_pixels / 2) - (paddle_width / 2);
					ELSIF (game = '1') OR (life < 1) THEN
						p1x_reg <= p1x_reg;
					ELSE 
						IF state_a = '1' THEN
							IF p1x_reg > border THEN
								p1x_reg <= p1x_reg - (1 * multiplier);
							END IF;
						END IF;
						IF state_d = '1' THEN
							IF p1x_reg < (127 * border - paddle_width) THEN
								p1x_reg <= p1x_reg + (1 * multiplier);
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END PROCESS;

		p1x <= p1x_reg;

END Behavioral;