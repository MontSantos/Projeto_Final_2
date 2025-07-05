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
        red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
        green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
        blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 2 bits
    );
END MAIN;

ARCHITECTURE Behavioral OF MAIN IS

    SIGNAL pixel_clk : STD_LOGIC := '0';
    SIGNAL image_on : STD_LOGIC;
    SIGNAL pixel_x : NATURAL RANGE 0 TO 1023;
    SIGNAL pixel_y : NATURAL RANGE 0 TO 767;
	 
	 SIGNAL teclado : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	 
	 SIGNAL new_tec : STD_LOGIC := '0';
	 
	 SIGNAL ps2_CLK_SYNC : STD_LOGIC := '0';
	 
	 SIGNAL go_signal: STD_LOGIC;
	 
	 SIGNAL out_data : NATURAL RANGE 0 TO 9 := 0; 
	 SIGNAL color_data : NATURAL RANGE 0 TO 9 := 0;
	 SIGNAL tmp_data : NATURAL RANGE 0 TO 9 := 0;
	 SIGNAL w_col_addr : NATURAL RANGE 0 TO n_blocks - 1 := 0;
	 SIGNAL w_lin_addr : NATURAL RANGE 0 TO n_LIN - 1 := 0;
	 SIGNAL r_col_addr : NATURAL RANGE 0 TO n_blocks - 1 := 0;
	 SIGNAL r_lin_addr : NATURAL RANGE 0 TO n_LIN - 1 := 0;
	 SIGNAL rw_en : STD_LOGIC := '0';
    
    SIGNAL red_i, green_i : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	 SIGNAL blue_i : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL h_sync_i, v_sync_i : STD_LOGIC := '0';
	 
	 SIGNAL hit : STD_LOGIC;
	 
	 SIGNAL reg_w, reg_s, reg_a, reg_d, reg_enter, reg_space : STD_LOGIC := '0';
	 SIGNAL reg_cor : NATURAL RANGE 0 TO 9 := 0;

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
		  
	u_sync: ENTITY work.SYNC(Behavioral)
		  PORT MAP(
				pixel_clk => pixel_clk,
				ps2_CLK => ps2_CLK,
				ps2_CLK_SYNC => ps2_CLK_SYNC
		  );
		  
	 -- Teclado	 
	 u_teclado: ENTITY work.TECLADO(Behavioral)
		  PORT MAP(
				clk	  => pixel_clk,
				ps2_CLK => ps2_CLK_SYNC,
				ps2_DATA=> ps2_DATA,
				new_tec => new_tec,
				saida	  => teclado
		  );
	
	u_tecff: ENTITY work.TEC_FF(Behavioral)
		  PORT MAP (
				pixel_clock => pixel_clk,
				ps2_CLK => ps2_CLK,
				new_tec => new_tec,
				teclado => teclado,
				state_cor => reg_cor,
				state_enter => reg_enter,
				state_space => reg_space,
				state_w => reg_w,
				state_s => reg_s,
				state_a => reg_a,
				state_d => reg_d
			);
		  
	-- Gera a RAM responsavel por guardar os dados da tela
	 u_grid: ENTITY work.GRID(Behavioral)
		  PORT MAP(
				pixel_clock => pixel_clk,
				state_space => reg_space,
				w_col_addr => w_col_addr,
				w_lin_addr => w_lin_addr,
				r_col_addr => r_col_addr,
				r_lin_addr => r_lin_addr,
				color_data => color_data,
				rw_en => rw_en,
				out_data => out_data
		  );
		  
		  
		
	-- Cores: Faz a traduçao da tecla para o codigo
	 u_colorctrl: ENTITY work.COLOR_CTRL(Behavioral)
		  PORT MAP(
				pixel_clock => pixel_clk,
				go_signal => go_signal,
				state_cor => reg_cor,
				state_enter => reg_enter,
				state_w => reg_w,
				state_s => reg_s,
				state_a => reg_a,
				state_d => reg_d,
				w_col_addr => w_col_addr,
				w_lin_addr => w_lin_addr,
				color_data => color_data,
				rw_en => rw_en,
				tmp_data => tmp_data
		  );

    -- Controle de pixels
    u_imagectrl: ENTITY work.IMAGE_CTRL(Behavioral)
        PORT MAP(
            pixel_clock => pixel_clk,
            image_on => image_on,
            pixel_x => pixel_x,
            pixel_y => pixel_y,
				out_data => out_data,
				tmp_data => tmp_data,
				w_col_addr => w_col_addr,
				w_lin_addr => w_lin_addr,
				r_col_addr => r_col_addr,
				r_lin_addr => r_lin_addr,
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

		-- Cores:
	red <= red_i WHEN image_on = '1' ELSE "000";
	green <= green_i WHEN image_on = '1' ELSE "000";
	blue <= blue_i WHEN image_on = '1' ELSE "00";


END Behavioral;
