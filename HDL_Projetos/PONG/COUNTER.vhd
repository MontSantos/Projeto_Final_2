LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

ENTITY COUNTER IS
    PORT (
        pixel_clock : IN STD_LOGIC; -- pixel clock real
        v_sync : IN STD_LOGIC;
        go_signal : OUT STD_LOGIC
    );
END COUNTER;

ARCHITECTURE Behavioral OF COUNTER IS

    SIGNAL v_sync_prev : STD_LOGIC := '0';
    SIGNAL flag : STD_LOGIC := '0';

BEGIN
    PROCESS (pixel_clock)
    BEGIN
        IF rising_edge(pixel_clock) THEN
            IF (v_sync_prev = '0' AND v_sync = '1') THEN -- borda de subida de v_sync
                flag <= '1';
            ELSE
                flag <= '0';
            END IF;
            v_sync_prev <= v_sync;
        END IF;
    END PROCESS;

    go_signal <= flag;

END Behavioral;
