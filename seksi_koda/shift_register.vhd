-------------------------------------------------------
--! @brief 
-------------------------------------------------------
--
--! @author Dominik Perusko, Cosylab, dominik.perusko@cosylab.com
--
--! @date 29.4.2013 created
--
--! @version 0.1
--
-------------------------------------------------------
--! @file
-------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--! @brief Shift register
--! @details Universal shift register with serial and parallel inputs and serial and parallel outputs
entity shift_register is
   generic (
      --! Number of bits in the shift register.
      g_LENGTH : positive range 1 to 64
   );
   port (
   
      -------------
      -- Inputs --
      -------------    
   
      --! Serial input, loaded into the shift register as MSB when enable_i is asserted. 
      serial_i : in std_logic;
      
      --! Parallel input, replaces content of shift register when load_i is asserted
      parallel_i : in std_logic_vector(g_LENGTH-1 downto 0);
      
      --! Enable input, shifts the contents of shift register one bit to the right when asserted.
      enable_i : in std_logic;
      
      --! Load input, parallel input is loaded into the register when asserted
      load_i : in std_logic;
      
      -------------
      -- Outputs --
      ------------- 
      
      --! Serial output, the LSB of the shift register.
      serial_o : out std_logic;
      
      --! Contents of the shift registe.
      parallel_o : out std_logic_vector(g_LENGTH-1 downto 0);

      --------------------
      -- General inputs --
      --------------------
      
      --! Global reset input.
      rst_i : in  std_logic;
      
      --! Global clock input.
      clk_i : in  std_logic
      
   );
end shift_register;

architecture RTL of shift_register is

   --! Contents of the shift register.
   signal s_srData : std_logic_vector(g_LENGTH-1 downto 0);

begin

   --! Shifting and loading of the shift register.
   p_sync_shiftRegister : process(clk_i)
   begin
      
      if rising_edge(clk_i) then
      
         if rst_i='0' then
            s_srData <= (others => '0');
            
         -- Parallel load.
         elsif load_i='1' then
            s_srData <= parallel_i;
         
         -- Shift 1 bit to the right
         elsif enable_i='1' then
            s_srData <= serial_i & s_srData(g_LENGTH-1 downto 1);
            
         else
            s_srData <= s_srData;
            
         end if;
      end if;
         
   end process p_sync_shiftRegister;
   
   -- Output LSB as serial out.
   serial_o <= s_srData(0);
   
   -- Output contents as parallel out   
   parallel_o <= s_srData;
   
end RTL;