LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MAIN IS
    PORT (
        clock : IN STD_LOGIC; -- FPGA clock
		  ps2_CLK    : IN  STD_LOGIC; -- Clock do teclado PS/2
        ps2_DATA   : IN  STD_LOGIC; -- Dados do teclado PS/2
        h_sync : OUT STD_LOGIC; -- horizontal sync pulse
        v_sync : OUT STD_LOGIC; -- vertical sync pulse
        red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
        green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
        blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 2 bits
    );
END MAIN;

ARCHITECTURE Behavioral OF MAIN IS

    SIGNAL pixel_clk : STD_LOGIC := '0';
	 SIGNAL ps2_CLK_SYNC : STD_LOGIC := '0';
    SIGNAL image_on : STD_LOGIC;
    SIGNAL pixel_x : NATURAL;
    SIGNAL pixel_y : NATURAL;
	 
	 SIGNAL teclado : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	 
	 SIGNAL new_tec : STD_LOGIC := '0';
    
    SIGNAL red_i, green_i : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	 SIGNAL blue_i : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; 
    SIGNAL h_sync_i, v_sync_i : STD_LOGIC := '0';
	 
	 SIGNAL reg_a, reg_x, reg_p, reg_3 : STD_LOGIC := '0';

BEGIN

    -- PLL para gerar clock para VGA
    u_pllvga: ENTITY work.PLL_VGA(SYN)
        PORT MAP(
            inclk0 => clock,
            c0 => pixel_clk,
            locked => open
        );
		  
	 u_sync: ENTITY work.SYNC(Behavioral)
		  PORT MAP(
				pixel_clk => pixel_clk,
				ps2_CLK => ps2_CLK,
				ps2_CLK_SYNC => ps2_CLK_SYNC
		  );

    -- Controle de pixels
    u_imagectrl: ENTITY work.IMAGE_CTRL(Behavioral)
        PORT MAP(
            pixel_clock => pixel_clk,
            image_on => image_on,
            pixel_x => pixel_x,
            pixel_y => pixel_y,
				state_a => reg_a,
				state_x => reg_x,
				state_p => reg_p,
				state_3 => reg_3,
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
				ps2_CLK => ps2_CLK_SYNC,
				new_tec => new_tec,
				teclado => teclado,
				state_a => reg_a,
				state_x => reg_x,
				state_p => reg_p,
				state_3 => reg_3
			);

	-- Atribuições finais
	h_sync <= h_sync_i;
	v_sync <= v_sync_i;

		-- Cores:
	red <= red_i WHEN image_on = '1' ELSE "000";
	green <= green_i WHEN image_on = '1' ELSE "000";
	blue <= blue_i WHEN image_on = '1' ELSE "00";


END Behavioral;
