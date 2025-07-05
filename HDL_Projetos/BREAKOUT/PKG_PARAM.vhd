LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE PKG_PARAM IS
	CONSTANT h_pixels : NATURAL := 1024; 
	CONSTANT v_pixels : NATURAL := 768; 
	CONSTANT border : NATURAL := 8; --h_pixels / 128;

	CONSTANT paddle_height : NATURAL := 10;
	CONSTANT paddle_width : NATURAL := 100;
	CONSTANT p1y : NATURAL := 700;
	
	CONSTANT b_size : NATURAL := 8;
	
	CONSTANT score1x : NATURAL := 200;
	CONSTANT score2x : NATURAL := 210;
	CONSTANT life1x : NATURAL := 820;
	CONSTANT life2x : NATURAL := 830;
	CONSTANT scorey : NATURAL := 30;
	CONSTANT score_width: NATURAL := 8;
	CONSTANT score_height: NATURAL := 16;
	
	CONSTANT n_blocks : NATURAL := 16;
	CONSTANT n_lin : NATURAL := 6;
	CONSTANT block_height : NATURAL := 20;
	CONSTANT block_width : NATURAL := 63;
	CONSTANT block_x : NATURAL := border;
	CONSTANT block_y : NATURAL := 82;
	
	TYPE block_mat IS ARRAY(0 TO n_lin - 1) OF STD_LOGIC_VECTOR(0 TO n_blocks - 1);
END PACKAGE PKG_PARAM;