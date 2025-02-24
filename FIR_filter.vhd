library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FIR_Filter is
    generic (
        N : integer := 4  -- Number of Taps
    );
    port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        x_in   : in  STD_LOGIC_VECTOR(15 downto 0);
        y_out  : out STD_LOGIC_VECTOR(15 downto 0)
    );
end FIR_Filter;

architecture Behavioral of FIR_Filter is
    -- Filter Coefficients
    constant h : array(0 to 3) of integer := (1, 2, 3, 4);

    -- Shift Registers for Input Samples
    signal x : array(0 to 3) of STD_LOGIC_VECTOR(15 downto 0) := (others => (others => '0'));
    
    signal y_temp : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin
    process (clk)
        variable sum : integer := 0;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                x <= (others => (others => '0'));
                y_temp <= (others => '0');
            else
                -- Shift input samples
                x(3) <= x(2);
                x(2) <= x(1);
                x(1) <= x(0);
                x(0) <= x_in;

                -- Compute FIR output
                sum := h(0) * CONV_INTEGER(x(0)) +
                       h(1) * CONV_INTEGER(x(1)) +
                       h(2) * CONV_INTEGER(x(2)) +
                       h(3) * CONV_INTEGER(x(3));

                y_temp <= CONV_STD_LOGIC_VECTOR(sum, 16);
            end if;
        end if;
    end process;

    y_out <= y_temp;

end Behavioral;
