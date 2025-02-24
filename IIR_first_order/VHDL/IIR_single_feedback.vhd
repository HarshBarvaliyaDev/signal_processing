library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IIR_Filter is
    Port ( clk    : in  STD_LOGIC;
           rst    : in  STD_LOGIC;
           x_in   : in  STD_LOGIC_VECTOR(15 downto 0);  -- 16-bit input
           y_out  : out STD_LOGIC_VECTOR(15 downto 0)   -- 16-bit output
         );
end IIR_Filter;

architecture Behavioral of IIR_Filter is

    -- Internal registers
    signal x_reg, y_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    -- Filter Coefficients (Fixed-Point Representation, Q15 format)
    constant a0 : STD_LOGIC_VECTOR(15 downto 0) := "0000110011001101";  -- 0.1 in Q15
    constant a1 : STD_LOGIC_VECTOR(15 downto 0) := "0111100110011001";  -- 0.95 in Q15

begin

    process (clk)
    variable mult_x, mult_y, sum : STD_LOGIC_VECTOR(31 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                y_reg <= (others => '0'); -- Reset output
            else
                -- Multiply input by a0
                mult_x := x_in * a0;
                
                -- Multiply previous output by a1
                mult_y := y_reg * a1;
                
                -- Sum the results
                sum := mult_x + mult_y;
                
                -- Assign new output (keeping the most significant 16 bits)
                y_reg <= sum(30 downto 15);
            end if;
        end if;
    end process;

    y_out <= y_reg;

end Behavioral;
