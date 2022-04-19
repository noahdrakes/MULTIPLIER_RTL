library ieee;
use ieee.std_logic_1164.all;
package util_package is
	type std_logic_2d is
    	array (integer range <>, integer range <>) of std_logic;
	type std_aoa_type is
    	array (1 downto 0) of std_logic;
	function log2c (n: integer) return integer;
end util_package;

package body util_package is

	function log2c(n: integer) return integer is
    	variable m, p: integer;
	begin

 	m := 0;
 	p := 1;
  	while p< n loop
     	m := m + 1;
     	p := p + 2;
  	end loop;
  	return m;
	end log2c;
end util_package;
