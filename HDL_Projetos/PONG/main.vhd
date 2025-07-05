LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.PKG_PARAM.ALL;

ENTITY MAIN IS
    PORT (
        clock : IN STD_LOGIC; -- FPGA clock
		  ps2_CLK    : in  STD_LOGIC; -- Clock do teclado PS/2
        ps2_DATA   : in  STD_LOGIC; -- Dados do teclado PS/2
        h_sync : OUT STD_LOGIC; -- horizontal sync pulse
        v_sync : OUT STD_LOGIC; -- vertical sync pulse
		  audio_L_out : OUT STD_LOGIC; -- audio left
        audio_R_out : OUT STD_LOGIC; -- audio right
        red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
        green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
        blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 2 bits
    );
END MAIN;

ARCHITECTURE Behavioral OF MAIN IS

    SIGNAL pixel_clk : STD_LOGIC := '0';
    SIGNAL image_on : STD_LOGIC;
    SIGNAL pixel_x : NATURAL;
    SIGNAL pixel_y : NATURAL;
	 
	 SIGNAL p1y, p2y: NATURAL;
	 SIGNAL bx, by: INTEGER;
	 SIGNAL score1, score2: NATURAL;
	 
	 SIGNAL teclado : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	 
	 SIGNAL new_tec : STD_LOGIC := '0';
	 
	 SIGNAL audio_L : STD_LOGIC := '0';
	 SIGNAL audio_R : STD_LOGIC := '0';
	 SIGNAL audio_val: NATURAL;
	 
	 SIGNAL dir: INTEGER;
	 SIGNAL go_signal: STD_LOGIC;
	 
	 SIGNAL ps2_CLK_SYNC : STD_LOGIC;
    
    SIGNAL red_i, green_i : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	 SIGNAL blue_i : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; 
    SIGNAL h_sync_i, v_sync_i : STD_LOGIC := '0';
	 
	 SIGNAL reg_w, reg_s, reg_i, reg_k, reg_space : STD_LOGIC := '0';

BEGIN

    -- PLL para gerar clock para VGA
    u_pllvga: ENTITY work.PLL_VGA(SYN)
        PORT MAP(
            inclk0 => clock,
            c0 => pixel_clk,
            locked => open
        );
		  
		  -- sincroniza vsync e pixel clock
	 u_COUNTER: ENTITY work.COUNTER(Behavioral)
		  PORT MAP(
				pixel_clock => pixel_clk,
				v_sync => v_sync_i,
				go_signal => go_signal
		  );
		  
	u_SYNC: ENTITY work.SYNC(Behavioral)
		  PORT MAP(
				pixel_clk => pixel_clk,
				ps2_CLK => ps2_CLK,
				ps2_CLK_SYNC => ps2_CLK_SYNC
		  );
		  
	 -- Teclado	 
	 u_teclado: ENTITY work.TECLADO(Behavioral)
		  PORT MAP(
				ps2_CLK => ps2_CLK_SYNC,
				ps2_DATA=> ps2_DATA,
				new_tec => new_tec,
				saida	  => teclado
		  );
		  
	 u_audio: ENTITY work.AUDIO(Behavioral)
    	  PORT MAP(
				pixel_clK => pixel_clk,
				audio_val => audio_val,
				audio_out_L  => audio_L,
				audio_out_R	 => audio_R
		  );
		  
		--FF de teclas
	 u_tecff: ENTITY work.TEC_FF(Behavioral)
		  PORT MAP (
				pixel_clock => pixel_clk,
				new_tec => new_tec,
				teclado => teclado,
				state_space => reg_space,
				state_w => reg_w,
				state_s => reg_s,
				state_i => reg_i,
				state_k => reg_k
			);

	 	      -- Controle de paddles
    u_paddlectrl: ENTITY work.PADDLE_CTRL(Behavioral)
        PORT MAP(
            pixel_clock => pixel_clk,
				v_sync => v_sync_i,
				go_signal => go_signal,
				state_space => reg_space,
            state_w => reg_w,
				state_s => reg_s,
				state_i => reg_i,
				state_k => reg_k,
				p1Y => p1y,
				p2y => p2y
        );
		  
	 	  -- Calcula Bola
	 u_BALL: ENTITY work.BALL(Behavioral)
		  PORT MAP(
				pixel_clock => pixel_clk,
				go_signal => go_signal,
				p1Y => p1y,
				p2y => p2y,
				state_space => reg_space,
				bx => bx,
				by => by,
				audio_val => audio_val,
				score1 => score1,
				score2 => score2
		  );

    -- Controle de pixels
    u_imagectrl: ENTITY work.IMAGE_CTRL(Behavioral)
        PORT MAP(
            pixel_clock => pixel_clk,
            image_on => image_on,
            pixel_x => pixel_x,
            pixel_y => pixel_y,
				p1Y => p1y,
				p2y => p2y,
				bx => bx,
				by => by,
				score1 => score1,
				score2 => score2,
            red => red_i,
            green => green_i,
            blue => blue_i
        );

    -- Controle de sincronismo VGA
    u_timingctrl: ENTITY work.TIMING_CTRL(Behavioral)
        PORT MAP(
            pixel_clock => pixel_clk,
            h_sync => h_sync_i,
            v_sync => v_sync_i,
            image_on => image_on,
            pixel_x => pixel_x,
            pixel_y => pixel_y
        );

	-- Atribuições finais
	h_sync <= h_sync_i;
	v_sync <= v_sync_i;
	
	audio_L_out <= audio_L;
	audio_R_out <= audio_R;


		-- Cores:
	red <= red_i WHEN image_on = '1' ELSE "000";
	green <= green_i WHEN image_on = '1' ELSE "000";
	blue <= blue_i WHEN image_on = '1' ELSE "00";


END Behavioral;
