

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

signal s_alu: std_logic_vector(OUTPUT-1 downto 0);

begin

s_alu <= (alu_in1+alu_in2) when alu_sel = "00" else
	(alu_in1 and alu_in2) when alu_sel ="01" else
	alu_in1 when alu_sel = "10" else
	not alu_in1; 

 
alu_out <= s_alu;
end alu_arch;




-- SHIFT LEFT LOGIC --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_LEFT_128BIT is 
generic( width: NATURAL);
port(	
		CLK: IN STD_LOGIC;
		RST: IN STD_LOGIC;
		EN: IN STD_LOGIC;
		OP_Q: out std_logic_vector(width-1 downto 0)
	);
end shift_LEFT_128BIT;

architecture behavorial of shift_LEFT_128BIT is
	
	signal TEMP_Q: std_logic_vector(width-1 downto 0);

begin 

			REG_CLK:PROCESS(CLK)
			BEGIN
			  IF(CLK='1' AND CLK'EVENT)THEN
				 IF(RST='1')THEN
				 -- INITIAL MCAND VALUE IS 32
				TEMP_Q<="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000";
				 ELSIF(EN='1')THEN
				TEMP_Q <= 	std_logic_vector(shift_left(signed(TEMP_Q),1));
				 ELSE
				TEMP_Q<=TEMP_Q;
				 END IF;
			  ELSE
				TEMP_Q<=TEMP_Q;
			  END IF;
			END PROCESS REG_CLK;
		OP_Q<=TEMP_Q;
end behavorial;




-- SHIFT RIGHT LOGIC

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_RIGHT_64BIT is 
generic( width: NATURAL);
port(	
		CLK: IN STD_LOGIC;
		RST: IN STD_LOGIC;
		EN: IN STD_LOGIC;
		OP_Q: out std_logic_vector(width-1 downto 0)
	);
end shift_RIGHT_64BIT;

architecture behavorial of shift_RIGHT_64BIT is
	
	signal TEMP_Q: std_logic_vector(width-1 downto 0);

begin 

			REG_CLK:PROCESS(CLK)
			BEGIN
			  IF(CLK='1' AND CLK'EVENT)THEN
				 IF(RST='1')THEN
				 -- INITIAL MCAND VALUE IS 32
				TEMP_Q<="0000000000000000000000000000000000000000000000000000000000000110";
				 ELSIF(EN='1')THEN
				TEMP_Q <= 	std_logic_vector(shift_right(signed(TEMP_Q),1));
				 ELSE
				TEMP_Q<=TEMP_Q;
				 END IF;
			  ELSE
				TEMP_Q<=TEMP_Q;
			  END IF;
			END PROCESS REG_CLK;
		OP_Q<=TEMP_Q;
end behavorial;




-- PRODUCT REGISTER
library ieee;
use ieee.std_logic_1164.all;

entity Drakes_PRODUCT_Reg is

GENERIC(
	P :integer:= 128
	);

 PORT(	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	OP_Q: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END Drakes_PRODUCT_Reg;

ARCHITECTURE BEHAVIORAL OF Drakes_PRODUCT_Reg IS
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

