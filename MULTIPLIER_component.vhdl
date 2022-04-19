-- BUFFER

library IEEE;
use ieee.std_logic_1164.all;

entity DRAKES_TRI_STATE IS
GENERIC(P:INTEGER:=128);
PORT(CLK:IN STD_LOGIC;
     EN: IN STD_LOGIC;
     MDR_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
     GATE_MDR_OUT:OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
end DRAKES_TRI_STATE;

architecture sel_arch of DRAKES_TRI_STATE is
SIGNAL Sgate:std_logic_vector(P-1 downto 0);
begin
PROCESS(CLK)
BEGIN 
	IF(CLK='1' AND CLK'EVENT)THEN
		IF(EN='1')THEN
		  Sgate<= MDR_IN;
		ELSE
		 Sgate<=(OTHERS=>'Z');
		END IF;
	ELSE
	END IF;
END PROCESS;
GATE_MDR_OUT<=Sgate;
end sel_arch;




-- COMBINATIONAL ADDER --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;


entity DRAKES_COMBO_ADDER is
generic(
WIDTH: natural :=128;
OUTPUT: natural := 128
);
port (
	Op_A: in std_logic_vector(width-1 downto 0); 
	Op_B: in std_logic_vector(width-1 downto 0);
	OP_Q: out std_logic_vector(OUTPUT-1 downto 0)
);
end DRAKES_COMBO_ADDER;

architecture combo_add of DRAKES_COMBO_ADDER is
signal S_D: std_logic_vector(width-1 downto 0);
begin
S_D <=OP_A+OP_B;

OP_Q<=S_D;
end combo_add;




-- MUX 2 TO 1 --

library ieee ; 
use ieee. std_logic_1164. all ; 
entity MUX2_1 is 
port ( 
	OP_A,OP_B: in std_logic_vector(15 downto 0); 
	s: in std_logic_vector(1 downto 0); 
	OP_Q: out std_logic_vector (15 downto 0) 
); 
end MUX2_1; 
architecture cond_arch of MUX2_1 is 

begin 
OP_Q <= OP_A when (s="00") else 
     	OP_B ;
end cond_arch ; 




-- ARITHMETIC LOGIC UNIT (ALU) --

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY DRAKES_ALU is 
generic( width: natural := 64;
	output: natural	:= 128);
port(
	alu_in1: in std_logic_vector(output-1 downto 0);
	alu_in2: in std_logic_vector(output-1 downto 0);
	alu_sel: in std_logic_vector(1 downto 0);
	alu_out: out std_logic_vector(output-1 downto 0)
);
end DRAKES_ALU;

architecture alu_arch of DRAKES_ALU is

signal s_alu: std_logic_vector(15 downto 0);

begin

s_alu <= (alu_in1+alu_in2) when alu_sel = "00" else
	(alu_in1 and alu_in2) when alu_sel ="01" else
	alu_in1 when alu_sel = "10" else
	not alu_in1; 

 
alu_out <= s_alu;
end alu_arch;




-- SHIFT LEFT AND RIGHT LOGIC --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift is 
port(
		OP_A: in std_logic_vector(63 downto 0);
		direction: in std_logic;
		OP_Q: out std_logic_vector(63 downto 0)
	);
end shift;

architecture behavorial of shift is
	
	signal output: std_logic_vector(63 downto 0);

begin 
	
		with direction select
		
			output <= 	std_logic_vector(shift_left(signed(OP_A),1)) WHEN '0', 
						std_logic_vector(shift_right(signed(OP_A),1)) WHEN OTHERS;

			OP_Q <= output;
end behavorial;



-- 128 BIT SIGN EXTENDER

library ieee;
use ieee.std_logic_1164.all ; 
entity DRAKES_SIGN_EXTENDER64_128 is
GENERIC(
	P:INTEGER:=128); 
port ( 
	OP_A: in std_logic_vector (63 downto 0) ;  
	SEXT64: out std_logic_vector (P-1 downto 0) ); 
end DRAKES_SIGN_EXTENDER64_128;

architecture sel_arch of DRAKES_SIGN_EXTENDER64_128 is

SIGNAL sOnes :STD_LOGIC_VECTOR(63 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(63 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(P-1 downto 0);

begin 
	WITH OP_A(4) SELECT
	
	sQ <= sOnes (63 downto 0) &OP_A(63 downto 0) WHEN '1',
	      sZeros (63 downto 0) &OP_A(63 downto 0) WHEN OTHERS;
	SEXT64 <= sQ;

end sel_arch;


 -- 128 BIT REGISTER 
library ieee;
use ieee.std_logic_1164.all;

entity Drakes_128_Bit_Reg is

GENERIC(
	P :integer:= 128
	);

 PORT(	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	OP_Q: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END Drakes_128_Bit_Reg;

ARCHITECTURE BEHAVIORAL OF Drakes_128_Bit_Reg IS
	SIGNAL TEMP_Q:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
BEGIN
REG_CLK:PROCESS(CLK)
	BEGIN
	  IF(CLK='1' AND CLK'EVENT)THEN
	     IF(RST='1')THEN
		TEMP_Q<="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	     ELSIF(EN='1')THEN
		TEMP_Q<=OP_A;
	     ELSE
		TEMP_Q<=TEMP_Q;
	     END IF;
	  ELSE
		TEMP_Q<=TEMP_Q;
	  END IF;
	END PROCESS REG_CLK;
OP_Q<=TEMP_Q;
END BEHAVIORAL;



library ieee;
use ieee.std_logic_1164.all;

entity Drakes_64_Bit_Reg is

GENERIC(
	P :integer:= 64
	);

 PORT(	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	OP_Q: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END Drakes_64_Bit_Reg;

ARCHITECTURE BEHAVIORAL OF Drakes_64_Bit_Reg IS
	SIGNAL TEMP_Q:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
BEGIN
REG_CLK:PROCESS(CLK)
	BEGIN
	  IF(CLK='1' AND CLK'EVENT)THEN
	     IF(RST='1')THEN
		TEMP_Q<="0000000000000000000000000000000000000000000000000000000000000000";
	     ELSIF(EN='1')THEN
		TEMP_Q<=OP_A;
	     ELSE
		TEMP_Q<=TEMP_Q;
	     END IF;
	  ELSE
		TEMP_Q<=TEMP_Q;
	  END IF;
	END PROCESS REG_CLK;
OP_Q<=TEMP_Q;
END BEHAVIORAL;

-------------------------------------------------------
-- 			SIGN EXTENDERS THAT ARE NOT NEEDED		--
-------------------------------------------------------









library ieee;
use ieee.std_logic_1164.all;





library ieee;
use ieee.std_logic_1164.all ; 
entity DRAKES_SIGN_EXTENDER64_128 is
GENERIC(
	P:INTEGER:=128); 
port ( 
	OP_A: in std_logic_vector (63 downto 0) ;  
	SEXT5: out std_logic_vector (P-1 downto 0) ); 
end DRAKES_SIGN_EXTENDER64_128;

architecture sel_arch of DRAKES_SIGN_EXTENDER64_128 is

SIGNAL sOnes :STD_LOGIC_VECTOR(63 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(63 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(P-1 downto 0);

begin 
	WITH OP_A(4) SELECT
	
	sQ <= sOnes (63 downto 0) &OP_A(63 downto 0) WHEN '1',
	      sZeros (63 downto 0) &OP_A(63 downto 0) WHEN OTHERS;
	SEXT5 <= sQ;

end sel_arch;




library ieee;
use ieee.std_logic_1164.all ; 
entity DRAKES_SIGN_EXTENDER6 is 
GENERIC(
	P:INTEGER:=16); 
port ( 
	OP_A: in std_logic_vector (5 downto 0) ;  
	SEXT6: out std_logic_vector (P-1 downto 0) ); 
end DRAKES_SIGN_EXTENDER6;

architecture sel_arch of DRAKES_SIGN_EXTENDER6 is

SIGNAL sOnes :STD_LOGIC_VECTOR(9 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(9 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH OP_A(5) SELECT
	
	sQ <= sOnes (9 downto 0) &OP_A(5 downto 0) WHEN '1',
	      sZeros (9 downto 0) &OP_A(5 downto 0) WHEN OTHERS;
	SEXT6 <= sQ;

end sel_arch;



library ieee;
use ieee.std_logic_1164.all ; 
entity DRAKES_SIGN_EXTENDER9 is 
port ( 
	OP_A: in std_logic_vector (8 downto 0) ;  
	OP_Q: out std_logic_vector (15 downto 0) ); 
end DRAKES_SIGN_EXTENDER9;

architecture sel_arch of DRAKES_SIGN_EXTENDER9 is

SIGNAL sOnes :STD_LOGIC_VECTOR(6 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(6 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH OP_A(8) SELECT
	
	sQ <= sOnes (6 downto 0) &OP_A(8 downto 0) WHEN '1',
	      sZeros (6 downto 0) &OP_A(8 downto 0) WHEN OTHERS;
	OP_Q <= sQ;

end sel_arch;



library ieee;
use ieee.std_logic_1164.all ; 
entity DRAKES_SIGN_EXTENDER11 is 
port ( 
	OP_A: in std_logic_vector (10 downto 0) ;  
	OP_Q: out std_logic_vector (15 downto 0) ); 
end DRAKES_SIGN_EXTENDER11;

architecture sel_arch of DRAKES_SIGN_EXTENDER11 is

SIGNAL sOnes :STD_LOGIC_VECTOR(4 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(4 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH OP_A(10) SELECT
	
	sQ <= sOnes (4 downto 0) &OP_A(10 downto 0) WHEN '1',
	      sZeros (4 downto 0) &OP_A(10 downto 0) WHEN OTHERS;
	OP_Q <= sQ;

end sel_arch;


-- ZERO EXTENDER

library ieee;
use ieee.std_logic_1164.all ; 
entity DRAKES_ZERO_EXTENDER is 
port ( 
	OP_A: in std_logic_vector (7 downto 0) ;  
	OP_Q: out std_logic_vector (15 downto 0) ); 
end DRAKES_ZERO_EXTENDER;

architecture Z_arch of DRAKES_ZERO_EXTENDER is

SIGNAL sZeros :STD_LOGIC_VECTOR(7 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH OP_A(7) SELECT
	
	sQ <= sZeros (7 downto 0) &OP_A(7 downto 0) WHEN OTHERS;
	OP_Q <= sQ;

end z_arch;

