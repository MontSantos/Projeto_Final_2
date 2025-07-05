LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY OSCILADOR IS
    PORT (
        clk       : IN  STD_LOGIC;         -- clock de 50 MHz
        audio_out : OUT STD_LOGIC;
		  audio_out2 : OUT STD_LOGIC		  -- saída de audio
    );
END OSCILADOR;

ARCHITECTURE Behavioral OF OSCILADOR IS

    CONSTANT clk_freq : NATURAL := 50000000;

    type rom is array (0 to 47) of natural;
	 constant escala : rom := (
		  65, 69, 73, 78, 82, 87, 93, 98, 104, 110, 117, 123,
		  131, 139, 147, 156, 165, 175, 185, 196, 208, 220, 233, 247,
		  262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494,
		  523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988
	 );


    SIGNAL cnt_i     : NATURAL RANGE 0 TO 47 := 1;
    SIGNAL cnt_freq  : NATURAL := clk_freq / (65 * 2);
    SIGNAL cnt_onda  : NATURAL := 0;
    SIGNAL cnt_tempo : NATURAL := 0;
    SIGNAL audio_reg  : STD_LOGIC := '0';

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN

            IF cnt_tempo >= clk_freq THEN
                cnt_tempo <= 0;

                IF cnt_i < 47 THEN
                    cnt_i <= cnt_i + 1;
                ELSE
                    cnt_i <= 0;
                END IF;

                cnt_freq <= clk_freq / (escala(cnt_i) * 2);
            ELSE
                cnt_tempo <= cnt_tempo + 1;
            END IF;
				
				IF cnt_onda >= cnt_freq THEN
                cnt_onda  <= 0;
                audio_reg  <= NOT audio_reg;
            ELSE
                cnt_onda <= cnt_onda + 1;
            END IF;

        END IF;
    END PROCESS;

    audio_out <= audio_reg;
	 audio_out2 <= audio_reg;

END Behavioral;
