library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--library SAFEPOWER;
--use SAFEPOWER.TTEL.all;	-- parameters of the current TTEL (for PORTID_WIDTH)

--library SYSTEMS;
--use SYSTEMS.auxiliary.all;         	-- helper functions and helper procedures
--use SYSTEMS.system_parameter.all;	-- parameters of the current NoC instance


entity core is
	generic (
        MY_ID                   : integer := 0;
	
		-- -- The size of messages in words
		-- 	C_MESSAGE_SIZE				: integer := 1024;
		-- Base address of targeted slave
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		-- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		C_M_AXI_BURST_LEN	: integer	:= 16;
		-- Thread ID Width
		C_M_AXI_ID_WIDTH	: integer	:= 6;
		-- Width of Address Bus
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		-- Width of Data Bus
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of User Write Address Bus
		C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
		-- Width of User Read Address Bus
		C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
		-- Width of User Write Data Bus
		C_M_AXI_WUSER_WIDTH	: integer	:= 0;
		-- Width of User Read Data Bus
		C_M_AXI_RUSER_WIDTH	: integer	:= 0;
		-- Width of User Response Bus
		C_M_AXI_BUSER_WIDTH	: integer	:= 0; 
		PORTID_WIDTH          : integer := 8; 
		C_PORT_STATUS_BIT     : integer := 2; 
		C_PORTID_LOW          : integer := 16;
		C_LAST_BURST_BIT      : integer := 31
	);
	port (
		INIT_AXI_TXN			: in std_logic;
		PORT_ID_WR				: in std_logic_vector (PORTID_WIDTH - 1 downto 0);
		MSG_LENGTH_WR			: in integer;
		
        INPUT_WDATA          : in std_logic_vector (C_M_AXI_DATA_WIDTH-1 downto 0); ------new signal defined by nahar
        INPUT_WADDR          : in std_logic_vector (C_M_AXI_ADDR_WIDTH-1 downto 0); ------new signal defined by nahar

		INIT_AXI_RXN			: in std_logic;
		PORT_ID_RD				: in std_logic_vector (PORTID_WIDTH - 1 downto 0);
		MSG_LENGTH_RD			: in integer;
		
		
		READ_ADDR : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		
        -- AXI Master ports
		M_AXI_ACLK				: in std_logic;
		M_AXI_ARESETN			: in std_logic;
		M_AXI_AWID				: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_AWADDR			: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWLEN				: out std_logic_vector(7 downto 0);
		M_AXI_AWSIZE			: out std_logic_vector(2 downto 0);
		M_AXI_AWBURST			: out std_logic_vector(1 downto 0);
		M_AXI_AWLOCK			: out std_logic;
		M_AXI_AWCACHE			: out std_logic_vector(3 downto 0);
		M_AXI_AWPROT			: out std_logic_vector(2 downto 0);
		M_AXI_AWQOS				: out std_logic_vector(3 downto 0);
		M_AXI_AWUSER			: out std_logic_vector(C_M_AXI_AWUSER_WIDTH downto 0);
		M_AXI_AWVALID			: out std_logic;
		M_AXI_AWREADY			: in std_logic;
		M_AXI_WDATA				: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB				: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WLAST				: out std_logic;
		M_AXI_WUSER				: out std_logic_vector(C_M_AXI_WUSER_WIDTH downto 0);
		M_AXI_WVALID			: out std_logic;
		M_AXI_WREADY			: in std_logic;
		M_AXI_BID				: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_BRESP				: in std_logic_vector(1 downto 0);
		M_AXI_BUSER				: in std_logic_vector(C_M_AXI_BUSER_WIDTH downto 0);
		M_AXI_BVALID			: in std_logic;
		M_AXI_BREADY			: out std_logic;
		M_AXI_ARID				: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_ARADDR			: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARLEN				: out std_logic_vector(7 downto 0);
		M_AXI_ARSIZE			: out std_logic_vector(2 downto 0);
		M_AXI_ARBURST			: out std_logic_vector(1 downto 0);
		M_AXI_ARLOCK			: out std_logic;
		M_AXI_ARCACHE			: out std_logic_vector(3 downto 0);
		M_AXI_ARPROT			: out std_logic_vector(2 downto 0);
		M_AXI_ARQOS				: out std_logic_vector(3 downto 0);
		M_AXI_ARUSER			: out std_logic_vector(C_M_AXI_ARUSER_WIDTH downto 0);
		M_AXI_ARVALID			: out std_logic;
		M_AXI_ARREADY			: in std_logic;
		M_AXI_RID			    : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_RDATA				: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP				: in std_logic_vector(1 downto 0);
		M_AXI_RLAST				: in std_logic;
		M_AXI_RUSER				: in std_logic_vector(C_M_AXI_RUSER_WIDTH downto 0);
		M_AXI_RVALID			: in std_logic;
		M_AXI_RREADY			: out std_logic
	    
	);
end core;

architecture simulation of core is

	-- C_TRANSACTIONS_NUM is the width of the index counter for
	-- number of beats in a burst write or burst read transaction.
	constant  C_TRANSACTIONS_NUM : integer := 4; --clogb2(C_M_AXI_BURST_LEN-1);
	-- Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
	-- Non-2^n lengths will eventually cause bursts across 4K address boundaries.
	constant  C_MASTER_LENGTH  : integer := 12;
	-- total number of burst transfers is master length divided by burst length and burst size
	constant  C_NO_BURSTS_REQ  : integer := 8; -- (C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1));

	-- This constant represents the address range of each port.
	constant C_PORT_ADDR_RANGE	: integer := 16; -- clogb2 (MESSAGE_SIZE - 1);
	-- constant C_PORT_BASE_ADDR		: std_logic_vector (C_M_AXI_ADDR_WIDTH-1 downto 0) := (C_PORT_ADDR_WIDTH => '1', others => '0');

	-- constant C_LAST_BURST_BIT		: integer := C_PORT_ADDR_RANGE + PORTID_WIDTH; -- defined in system_parameter.vhd

	-- Example State machine to initialize counter, initialize write transactions,
	 -- initialize read transactions and comparison of read data with the
	 -- written data words.
	type state is ( IDLE, -- This state initiates AXI4Lite transaction
					-- after the state machine changes state to INIT_WRITE
							-- when there is 0 to 1 transition on INIT_AXI_TXN
					INIT_WRITE,   -- This state initializes write transaction,
							-- once writes are done, the state machine
								-- changes state to READING
--					READING,    -- This state initializes read transaction
								-- once reads are done, the state machine
								-- changes state to INIT_COMPARE
					INIT_COMPARE);-- This state issues the status of comparison
								-- of the written data with the read data
	signal write_state  : state ;


	-- State machine to initialize counter, initialize read transactions
	type rd_state is ( IDLE,
					READ_MSGL,
					CHECK_MSGL,
					READING,
					READ_DECLINED,
					READ_DONE
					);

	signal read_state  			: rd_state;
	signal read_nextstate  	: rd_state;

	-- AXI4FULL signals
	--AXI4 internal temp signals
	signal axi_awaddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awvalid	: std_logic;
	signal axi_wdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
	signal axi_wlast	: std_logic;
	signal axi_wvalid	: std_logic;
	signal axi_bready	: std_logic;
	signal axi_araddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arvalid	: std_logic;
	signal axi_rready	: std_logic;
	--write beat count in a burst
	signal write_index	: std_logic_vector(C_TRANSACTIONS_NUM downto 0);
	--read beat count in a burst
	signal read_index	: std_logic_vector(C_TRANSACTIONS_NUM downto 0);
	--size of C_M_AXI_BURST_LEN length burst in bytes
	signal burst_size_bytes	: std_logic_vector(C_TRANSACTIONS_NUM+2 downto 0);
	--size of C_M_AXI_BURST_LEN length burst in bytes
	signal burst_size_words	: std_logic_vector(C_TRANSACTIONS_NUM downto 0);

	--The burst counters are used to track the number of burst transfers of C_M_AXI_BURST_LEN burst length needed to transfer 2^C_MASTER_LENGTH bytes of data.
	signal write_burst_counter	: std_logic_vector(C_NO_BURSTS_REQ downto 0);
	signal read_burst_counter	: std_logic_vector(C_NO_BURSTS_REQ downto 0);
	signal start_single_burst_write	: std_logic;
	signal start_single_burst_read	: std_logic;
	signal writes_done	: std_logic;
	signal reads_done	: std_logic;
	signal error_reg	: std_logic;
	signal msg_wr_done	: std_logic;
	signal msg_rd_done	: std_logic;
	signal read_mismatch	: std_logic;
	signal burst_write_active	: std_logic;
	signal burst_read_active	: std_logic;
	signal axi_module_busy 		: std_logic := '0';
	--Interface response error flags
	signal write_resp_error	: std_logic;
	signal read_resp_error	: std_logic;
	signal wnext	: std_logic;
	signal rnext	: std_logic;
	signal init_txn_ff	: std_logic;
	signal init_txn_ff2	: std_logic;
	signal init_txn_pulse	: std_logic;

	signal init_rxn_ff						: std_logic;
	signal init_rxn_ff2						: std_logic;
	signal init_rxn_pulse					: std_logic;

	-- signal data_txn			: integer;
	signal sig_one 						: integer := 1;
	-- this signal includes the base address for the port
	signal rWrPortBaseAddr 			: std_logic_vector (C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal rRdPortBaseAddr 				: std_logic_vector (C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal rLastBurstAddr 				: std_logic_vector (C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal rPortStatusRdAddr			: std_logic_vector (C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal wr_msgl          			        : integer;
	signal rd_msgl          			        : integer;
	signal rem_wr_msgl      			: integer := 0;
	signal rem_rd_msgl  			    : integer := 0;
	signal axi_awlen					: std_logic_vector(7 downto 0);
	signal axi_arlen					: std_logic_vector(7 downto 0);
	-- this signal shows whether we need any furhter burst
	signal termination_burst			: std_logic;
	signal numOfRdBurst					: integer := 2;
	signal numOfRdBeat					: integer := 2;
	signal msgl_available				: std_logic;
	signal port_status_read_bit		    : std_logic;
	-- signal port_stat_rd_en				: std_logic;


begin
	-- I/O Connections assignments

	--I/O Connections. Write Address (AW)
	M_AXI_AWID	<= (others => '0');
	--The AXI address is a concatenation of the target base address + active offset range
	M_AXI_AWADDR	<= std_logic_vector( unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_awaddr) + unsigned (rWrPortBaseAddr) + unsigned (rLastBurstAddr));
--M_AXI_AWADDR <= INPUT_WADDR ;     ------new signal defined by nahar
	--Burst LENgth is number of transaction beats, minus 1
	--M_AXI_AWLEN	<= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) ); -- commented by HA
	M_AXI_AWLEN	<= axi_awlen;
	--Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	M_AXI_AWSIZE	<= std_logic_vector( to_unsigned(3, 3) );
	--INCR burst type is usually used, except for keyhole bursts
	M_AXI_AWBURST	<= "01";
	M_AXI_AWLOCK	<= '0';
	--Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache.
	M_AXI_AWCACHE	<= "0010";
	M_AXI_AWPROT	<= "000";
	M_AXI_AWQOS	<= x"0";
	M_AXI_AWUSER	<= (others => '1');
	M_AXI_AWVALID	<= axi_awvalid;
	--Write Data(W)
	-- M_AXI_WDATA	<= axi_wdata when termination_burst = '0' else std_logic_vector (to_unsigned (MSG_LENGTH_WR/16, C_M_AXI_DATA_WIDTH));
M_AXI_WDATA	<= INPUT_WDATA; ------new signal defined by nahar

	--All bursts are complete and aligned in this example
	M_AXI_WSTRB	<= (others => '1');
	M_AXI_WLAST	<= axi_wlast;
	M_AXI_WUSER	<= (others => '0');
	M_AXI_WVALID	<= axi_wvalid;

	--Write Response (B)
	M_AXI_BREADY	<= axi_bready;
	--Read Address (AR)
	M_AXI_ARID	<= (others => '0');
	-- M_AXI_ARADDR	<= axi_araddr;
	M_AXI_ARADDR	<= std_logic_vector (unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_araddr) + unsigned (rRdPortBaseAddr) + unsigned (rPortStatusRdAddr));
 --M_AXI_ARADDR	<= READ_ADDR;------new signal defined by nahar
	--Burst LENgth is number of transaction beats, minus 1
	-- M_AXI_ARLEN	<= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
	M_AXI_ARLEN	<= axi_arlen;
	--Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
	M_AXI_ARSIZE	<= std_logic_vector( to_unsigned( 3,3 ));
	--INCR burst type is usually used, except for keyhole bursts
	M_AXI_ARBURST	<= "01";
	M_AXI_ARLOCK	<= '0';
	--Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache.
	M_AXI_ARCACHE	<= "0010";
	M_AXI_ARPROT	<= "000";
	M_AXI_ARQOS	<= x"0";
	M_AXI_ARUSER	<= (others => '1');
	M_AXI_ARVALID	<= axi_arvalid;
	--Read and Read Response (R)
	M_AXI_RREADY	<= axi_rready;
	--Burst size in bytes
	burst_size_bytes	<= std_logic_vector( to_unsigned((C_M_AXI_BURST_LEN * (C_M_AXI_DATA_WIDTH/8)),C_TRANSACTIONS_NUM+3) );
	-- burst_size_words	<= x"10";


	init_txn_pulse	<= ( not init_txn_ff2)  and  init_txn_ff;
	init_rxn_pulse	<= ( not init_rxn_ff2)  and  init_rxn_ff;

	-- indicates if the axi module is busy with write or read
	axi_module_busy <= burst_write_active OR	burst_read_active;
	-- AXI_BUSY <= burst_write_active OR	burst_read_active;

	rPortStatusRdAddr <= (C_PORT_STATUS_BIT => port_status_read_bit, others => '0');

	port_status_read_bit <= '1' when read_state = READ_MSGL else '0';

	process (M_AXI_ARESETN, M_AXI_ACLK)
	begin
		if M_AXI_ARESETN = '0' then
			numOfRdBeat <= 0;
	  elsif rising_edge (M_AXI_ACLK) then
			if read_state = READ_MSGL and M_AXI_RLAST = '1' then
				numOfRdBeat <= to_integer (unsigned (M_AXI_RDATA (C_M_AXI_DATA_WIDTH - 1 downto 0))); 
			elsif read_state = READING and rnext = '1' then
                    numOfRdBeat <= numOfRdBeat - 1;
			end if;
	  end if;
	end process;


	process (M_AXI_ARESETN, M_AXI_ACLK)
	begin
		if M_AXI_ARESETN = '0' then
			numOfRdBurst <= 0;
	  elsif rising_edge (M_AXI_ACLK) then
			if read_state = READ_MSGL and M_AXI_RLAST = '1' then
				numOfRdBurst <= to_integer (unsigned (M_AXI_RDATA (C_M_AXI_DATA_WIDTH - 1 downto 4))); 
			elsif read_state = READING and M_AXI_RLAST = '1' then
                    numOfRdBurst <= numOfRdBurst - 1;
			end if;
	  end if;
	end process;


	--Generate a pulse to initiate AXI write transaction.
	process(M_AXI_ACLK)
	begin
	  if (rising_edge (M_AXI_ACLK)) then
	      -- Initiates AXI transaction delay
	    if (M_AXI_ARESETN = '0' ) then
	      init_txn_ff <= '0';
	      init_txn_ff2 <= '0';
	    else
	      init_txn_ff <= INIT_AXI_TXN;
	      init_txn_ff2 <= init_txn_ff;
	    end if;
	  end if;
	end process;


	--Generate a pulse to initiate AXI read transaction.
	process(M_AXI_ACLK)
	begin
	  if (rising_edge (M_AXI_ACLK)) then
	      -- Initiates AXI transaction delay
	    if (M_AXI_ARESETN = '0' ) then
	      init_rxn_ff <= '0';
	      init_rxn_ff2 <= '0';
	    else
	      init_rxn_ff <= INIT_AXI_RXN;
	      init_rxn_ff2 <= init_rxn_ff;
	    end if;
	  end if;
	end process;


	----------------------
	--Write Address Channel
	----------------------

	-- The purpose of the write address channel is to request the address and
	-- command information for the entire transaction.  It is a single beat
	-- of information.

	-- The AXI4 Write address channel in this example will continue to initiate
	-- write commands as fast as it is allowed by the slave/interconnect.
	-- The address will be incremented on each accepted address transaction,
	-- by burst_size_byte to point to the next address.

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_awvalid <= '0';
      else
        -- If previously not valid , start next transaction
        if (axi_awvalid = '0' and start_single_burst_write = '1') then
          axi_awvalid <= '1';
          -- Once asserted, VALIDs cannot be deasserted, so axi_awvalid
          -- must wait until transaction is accepted
        elsif (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
          axi_awvalid <= '0';
        else
          axi_awvalid <= axi_awvalid;
        end if;
      end if;
    end if;
  end process;

	-- Next address after AWREADY indicates previous address acceptance
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_awaddr <= (others => '0');
      else
        if (M_AXI_AWREADY= '1' and axi_awvalid = '1') then
					axi_awaddr <= std_logic_vector(unsigned(axi_awaddr) + unsigned(burst_size_bytes)); -- byte alighned addressing
					--axi_awaddr <= std_logic_vector(unsigned(axi_awaddr) + unsigned(burst_size_words));   -- word alighned addressing
        end if;
      end if;
    end if;
  end process;

	-- process for generation of the rWrPortBaseAddr
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if M_AXI_ARESETN = '0' then
        rWrPortBaseAddr <= (others => '0');
      else
        if (init_txn_pulse = '1') then
					rWrPortBaseAddr (PORTID_WIDTH + C_PORTID_LOW - 1 downto C_PORTID_LOW) <= PORT_ID_WR (PORTID_WIDTH - 1 downto 0);
        elsif  writes_done = '1' then
					rWrPortBaseAddr <= (others => '0');
				end if;
      end if;
    end if;
  end process;

	-- process for generation of the rRdPortBaseAddr
  process(M_AXI_ACLK)
  begin
    if rising_edge (M_AXI_ACLK) then
      if M_AXI_ARESETN = '0' then
        rRdPortBaseAddr <= (others => '0');
      else
        if start_single_burst_read = '1' then
					-- if read_state = READ_MSGL then
					-- 	rRdPortBaseAddr (PORTID_WIDTH + C_PORTID_LOW - 1 downto C_PORTID_LOW) <= x"C";
					-- else
						rRdPortBaseAddr (PORTID_WIDTH + C_PORTID_LOW - 1 downto C_PORTID_LOW) <= PORT_ID_RD (PORTID_WIDTH - 1 downto 0);
						-- rRdPortBaseAddr (PORTID_WIDTH + C_PORT_ADDR_RANGE - 1 downto C_PORT_ADDR_RANGE) <= PORT_ID_RD (PORTID_WIDTH - 1 downto 0);
					-- end if;
        elsif  M_AXI_AWREADY= '1' and axi_awvalid = '1' then
					rRdPortBaseAddr <= (others => '0');
				end if;
      end if;
    end if;
  end process;


	-- process for generation of the rLastBurstAddr
  process(M_AXI_ARESETN, termination_burst)
  begin
    -- if (rising_edge (M_AXI_ACLK)) then
    if M_AXI_ARESETN = '0' or  termination_burst = '0' then
      rLastBurstAddr <= (others => '0');
    else
				rLastBurstAddr <= (C_LAST_BURST_BIT => '1', others => '0');
    end if;
  end process;


	----------------------
	--Write Data Channel
	----------------------

	--The write data will continually try to push write data across the interface.

	--The amount of data accepted will depend on the AXI slave and the AXI
	--Interconnect settings, such as if there are FIFOs enabled in interconnect.

	--Note that there is no explicit timing relationship to the write address channel.
	--The write channel has its own throttling flag, separate from the AW channel.

	--Synchronization between the channels must be determined by the user.

	--The simpliest but lowest performance would be to only issue one address write
	--and write data burst at a time.

	--In this example they are kept in sync by using the same address increment
	--and burst sizes. Then the AW and W channels have their transactions measured
	--with threshold counters as part of the user logic, to make sure neither
	--channel gets too far ahead of each other.

	--Forward movement occurs when the write channel is valid and ready

	  wnext <= M_AXI_WREADY and axi_wvalid;

	-- WVALID logic, similar to the axi_awvalid always block above
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
	        axi_wvalid <= '0';
	      else
	        if (axi_wvalid = '0' and axi_awvalid = '1' and M_AXI_AWREADY = '1') then
	          -- If previously not valid, start next transaction
	          axi_wvalid <= '1';
	          --     /* If WREADY and too many writes, throttle WVALID
	          --      Once asserted, VALIDs cannot be deasserted, so WVALID
	          --      must wait until burst is complete with WLAST */
	        elsif (wnext = '1' and axi_wlast = '1') then
	          axi_wvalid <= '0';
	        else
	          axi_wvalid <= axi_wvalid;
	        end if;
	      end if;
	    end if;
	  end process;

	--WLAST generation on the MSB of a counter underflow
	-- WVALID logic, similar to the axi_awvalid always block above

	-- process(M_AXI_ACLK)
	-- begin
	-- 	if (rising_edge (M_AXI_ACLK)) then
	-- 		if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
	-- 			axi_wlast <= '0';
	-- 			-- axi_wlast is asserted when the write index
	-- 			-- count reaches the penultimate count to synchronize
	-- 			-- with the last write data when write_index is b1111
	-- 			-- elsif (&(write_index[C_TRANSACTIONS_NUM-1:1])&& ~write_index[0] && wnext)
	-- 		else
	-- 			if ((((write_index = std_logic_vector(unsigned(axi_awlen (C_TRANSACTIONS_NUM downto 0)) - 1)) and C_M_AXI_BURST_LEN >= 1) and wnext = '1') or (unsigned(axi_awlen (C_TRANSACTIONS_NUM downto 0)) = 0)) then
	-- 				axi_wlast <= '1';
	-- 				-- Deassrt axi_wlast when the last write data has been
	-- 				-- accepted by the slave with a valid response
	-- 			elsif (wnext = '1') then
	-- 				axi_wlast <= '0';
	-- 			elsif (axi_wlast = '1' and unsigned(axi_awlen (C_TRANSACTIONS_NUM downto 0)) = 0) then
	-- 				axi_wlast <= '0';
	-- 			end if;
	-- 		end if;
	-- 	end if;
	-- end process;


	  process(M_AXI_ARESETN, init_txn_pulse, axi_awlen, wnext, M_AXI_ACLK)
	  begin
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_wlast <= '0';
			elsif unsigned(axi_awlen) = 0 then
				axi_wlast <= wnext;
	    elsif rising_edge (M_AXI_ACLK) and wnext = '1' then
	        -- axi_wlast is asserted when the write index
	        -- count reaches the penultimate count to synchronize
	        -- with the last write data when write_index is b1111
	        -- elsif (&(write_index[C_TRANSACTIONS_NUM-1:1])&& ~write_index[0] && wnext)
				if write_index = std_logic_vector(unsigned(axi_awlen (C_TRANSACTIONS_NUM downto 0)) - 1) then
          axi_wlast <= '1';
        -- Deassrt axi_wlast when the last write data has been
        -- accepted by the slave with a valid response
        else
          axi_wlast <= '0';
	      end if;
	    end if;
	  end process;

	-- Burst length counter. Uses extra counter register bit to indicate terminal
	-- count to reduce decode logic */
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or start_single_burst_write = '1' or init_txn_pulse = '1') then
	        write_index <= (others => '0');
	      else
	        if (wnext = '1' and (write_index /= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-1,C_TRANSACTIONS_NUM+1)))) then
	          write_index <= std_logic_vector(unsigned(write_index) + 1);
	        end if;
	      end if;
	    end if;
	  end process;


	-- Write Data Generator
	-- Data pattern is only a simple incrementing count from 0 for each burst  */
  process(M_AXI_ARESETN, M_AXI_ACLK)
  begin
    if M_AXI_ARESETN = '0' then
			sig_one <= 110;
			msg_wr_done <= '0';
    elsif rising_edge (M_AXI_ACLK) then
			if init_txn_pulse = '1' then
				axi_wdata <= std_logic_vector (to_unsigned(sig_one, C_M_AXI_DATA_WIDTH));
				sig_one <= sig_one + 16;
				wr_msgl <= MSG_LENGTH_WR;
				msg_wr_done <= '0';
      else
				if msg_wr_done = '0' then
        	if (wnext = '1') then
          	axi_wdata <= std_logic_vector(unsigned(axi_wdata) + 1);
						wr_msgl <= wr_msgl - 1;
						if wr_msgl = 1 then
							msg_wr_done <= '1';
						end if;
					end if;
				elsif termination_burst = '1' then
					msg_wr_done <= '0';
        end if;
      end if;
    end if;
  end process;


	-- process for generation of termination_burst
	process (M_AXI_ARESETN, M_AXI_ACLK, burst_write_active, msg_wr_done, axi_bready, M_AXI_BVALID)
	begin
		if M_AXI_ARESETN = '0' then
			termination_burst <= '0';
		elsif rising_edge (M_AXI_ACLK) then
			if termination_burst = '0' and burst_write_active /= '1' and msg_wr_done = '1' then
				termination_burst <= '1';
			elsif termination_burst = '1' and M_AXI_BVALID = '1' and axi_bready = '1' then
					termination_burst <= '0';
			end if;
		end if;
	end process;

	-- process for generation of axi_awlen
	process(M_AXI_ARESETN, M_AXI_ACLK, termination_burst)
	begin
		if M_AXI_ARESETN = '0' then
			axi_awlen <= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
			rem_wr_msgl <= 0;
		elsif rising_edge (M_AXI_ACLK) then
			if init_txn_pulse = '1' then
				rem_wr_msgl <= MSG_LENGTH_WR;
			elsif start_single_burst_write = '1' then
				if rem_wr_msgl > 16 then
					axi_awlen <= x"0F";
					rem_wr_msgl <= rem_wr_msgl - 16;
				elsif rem_wr_msgl > 0 and rem_wr_msgl <= 16 then
					axi_awlen <= std_logic_vector(to_unsigned(rem_wr_msgl - 1, 8));
					rem_wr_msgl <= 0;
				elsif rem_wr_msgl = 0 then
					axi_awlen <= x"00";
          -- axi_awlen <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN - 1, 8));
          rem_wr_msgl <= -1;
				elsif rem_wr_msgl = -1 then
					axi_awlen <= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
				end if;
			end if;
		end if;
	end process;

	------------------------------
	--Write Response (B) Channel
	------------------------------

	--The write response channel provides feedback that the write has committed
	--to memory. BREADY will occur when all of the data and the write address
	--has arrived and been accepted by the slave.

	--The write issuance (number of outstanding write addresses) is started by
	--the Address Write transfer, and is completed by a BREADY/BRESP.

	--While negating BREADY will eventually throttle the AWREADY signal,
	--it is best not to throttle the whole data channel this way.

	--The BRESP bit [1] is used indicate any errors from the interconnect or
	--slave for the entire write burst. This example will capture the error
	--into the ERROR output.

  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        axi_bready <= '0';
        -- accept/acknowledge bresp with axi_bready by the master
        -- when M_AXI_BVALID is asserted by slave
      else
        if (M_AXI_BVALID = '1' and axi_bready = '0') then
          axi_bready <= '1';
          -- deassert after one clock cycle
        elsif (axi_bready = '1') then
          axi_bready <= '0';
        end if;
      end if;
    end if;
  end process;


	--Flag any write response errors
  write_resp_error <= axi_bready and M_AXI_BVALID and M_AXI_BRESP(1);

	-- write_burst_counter counter keeps track with the number of burst transaction initiated
	-- against the number of burst transactions the master needs to initiate
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
        write_burst_counter <= (others => '0');
      else
        if (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
          if (write_burst_counter(C_NO_BURSTS_REQ) = '0')then
            write_burst_counter <= std_logic_vector(unsigned(write_burst_counter) + 1);
          end if;
        end if;
      end if;
    end if;
  end process;



	------------------------------
	--Read Address Channel
	------------------------------

	--The Read Address Channel (AW) provides a similar function to the
	--Write Address channel- to provide the tranfer qualifiers for the burst.

	--In this example, the read address increments in the same
	--manner as the write address channel.

	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_rxn_pulse = '1') then
	        axi_arvalid <= '0';
	     -- If previously not valid , start next transaction
	      else
	        if (axi_arvalid = '0' and start_single_burst_read = '1') then
	          axi_arvalid <= '1';
	        elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
	          axi_arvalid <= '0';
	        end if;
	      end if;
	    end if;
	  end process;

	-- Next address after ARREADY indicates previous address acceptance
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_rxn_pulse = '1' ) then
	        axi_araddr <= (others => '0');
	      else
	        if (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
	          axi_araddr <= std_logic_vector(unsigned(axi_araddr) + unsigned(burst_size_bytes)); -- byte alighned addressing
						-- axi_araddr <= std_logic_vector(unsigned(axi_araddr) + unsigned(burst_size_words)); -- word alighned addressing

	        end if;
	      end if;
	    end if;
	  end process;

		-- process(M_AXI_ARESETN, init_rxn_pulse)
		-- begin
		-- 	if M_AXI_ARESETN = '0' then
		-- 		numOfRdBurst <= -1;
		-- 	elsif init_rxn_pulse = '1' then



		-- -- process for generation of axi_arlen
		-- process(M_AXI_ARESETN, M_AXI_ACLK, init_rxn_pulse, numOfRdBurst)
		-- begin
		-- 	if M_AXI_ARESETN = '0' then
		-- 		axi_arlen <= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
		-- 		rem_rd_msgl <= 0;
		-- 	elsif rising_edge (M_AXI_ACLK) then
		-- 		if init_rxn_pulse = '1' then
		-- 			rem_rd_msgl <= MSG_LENGTH_RD;
		-- 		elsif start_single_burst_read = '1' then
		-- 			if rem_rd_msgl > 16 then
		-- 				axi_arlen <= x"0F";
		-- 				rem_rd_msgl <= rem_rd_msgl - 16;
		-- 			elsif rem_rd_msgl > 0 and rem_rd_msgl <= 16 then
		-- 				axi_arlen <= std_logic_vector(to_unsigned(rem_rd_msgl - 1, 8));
		-- 				rem_rd_msgl <= 0;
		-- 			elsif rem_rd_msgl = 0 then
		-- 				axi_arlen <= x"01";
	  --         -- axi_arlen <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN - 1, 8));
	  --         rem_rd_msgl <= -1;
		-- 			elsif rem_rd_msgl = -1 then
		-- 				axi_arlen <= std_logic_vector( to_unsigned(C_M_AXI_BURST_LEN - 1, 8) );
		-- 			end if;
		-- 		end if;
		-- 	end if;
		-- end process;



	----------------------------------
	--Read Data (and Response) Channel
	----------------------------------
	-- Forward movement occurs when the channel is valid and ready
	  rnext <= M_AXI_RVALID and axi_rready;


	-- Burst length counter. Uses extra counter register bit to indicate
	-- terminal count to reduce decode logic
	  process(M_AXI_ACLK)
	  begin
	    if rising_edge (M_AXI_ACLK) then
	      if M_AXI_ARESETN = '0' or start_single_burst_read = '1' or init_rxn_pulse = '1' then
	        read_index <= (others => '0');
	      else
	        if (rnext = '1' and (read_index <= std_logic_vector(to_unsigned(C_M_AXI_BURST_LEN-1,C_TRANSACTIONS_NUM+1)))) then
	          read_index <= std_logic_vector(unsigned(read_index) + 1);
	        end if;
	      end if;
	    end if;
	  end process;

	--/*
	-- The Read Data channel returns the results of the read request
	--
	-- In this example the data checker is always able to accept
	-- more data, so no need to throttle the RREADY signal
	-- */
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_rxn_pulse = '1') then
	        axi_rready <= '0';
	     -- accept/acknowledge rdata/rresp with axi_rready by the master
	      -- when M_AXI_RVALID is asserted by slave
	      else
	        if (M_AXI_RVALID = '1') then
	          if (M_AXI_RLAST = '1' and axi_rready = '1') then
	            axi_rready <= '0';
	           else
	             axi_rready <= '1';
	          end if;
	        end if;
	      end if;
	    end if;
	  end process;

	--Check received read data against data generator
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_rxn_pulse = '1') then
	        read_mismatch <= '0';
	      --Only check data when RVALID is active
	      else
	        if (rnext = '1') then
	          read_mismatch <= '1';
	        else
	          read_mismatch <= '0';
	        end if;
	      end if;
	    end if;
	  end process;

--Flag any read response errors
  read_resp_error <= axi_rready and M_AXI_RVALID and M_AXI_RRESP(1);


 -- read_burst_counter counter keeps track with the number of burst transaction initiated
 -- against the number of burst transactions the master needs to initiate
  process(M_AXI_ACLK)
  begin
    if (rising_edge (M_AXI_ACLK)) then
      if (M_AXI_ARESETN = '0' or init_rxn_pulse = '1') then
        read_burst_counter <= (others => '0');
      else
        if (M_AXI_ARREADY = '1' and axi_arvalid = '1') then
          if (read_burst_counter(C_NO_BURSTS_REQ) = '0')then
            read_burst_counter <= std_logic_vector(unsigned(read_burst_counter) + 1);
          end if;
        end if;
      end if;
    end if;
  end process;


	-- Read Data Generator
	-- Data pattern is only a simple incrementing count from 0 for each burst  */
  process(M_AXI_ARESETN, M_AXI_ACLK)
  begin
    if M_AXI_ARESETN = '0' then
			msg_rd_done <= '0';
			reads_done <= '0';
    elsif rising_edge (M_AXI_ACLK) then
			if init_rxn_pulse = '1' then
				rd_msgl <= MSG_LENGTH_RD;
				msg_rd_done <= '0';
				reads_done <= '0';
      else
				if msg_rd_done = '0' then
        	       if (rnext = '1') then
						rd_msgl <= rd_msgl - 1;
						if rd_msgl = 1 then
							msg_rd_done <= '1';
							reads_done <= '1';
						end if;
					end if;
				-- elsif termination_burst = '1' then
				-- 	msg_rd_done <= '0';
        end if;
      end if;
    end if;
  end process;

	----------------------------------
	--Example design throttling
	----------------------------------

	-- For maximum port throughput, this user example code will try to allow
	-- each channel to run as independently and as quickly as possible.

	-- However, there are times when the flow of data needs to be throtted by
	-- the user application. This example application requires that data is
	-- not read before it is written and that the write channels do not
	-- advance beyond an arbitrary threshold (say to prevent an
	-- overrun of the current read address by the write address).

	-- From AXI4 Specification, 13.13.1: "If a master requires ordering between
	-- read and write transactions, it must ensure that a response is received
	-- for the previous transaction before issuing the next transaction."

	-- This example accomplishes this user application throttling through:
	-- -Reads wait for writes to fully complete
	-- -Address writes wait when not read + issued transaction counts pass
	-- a parameterized threshold
	-- -Writes wait when a not read + active data burst count pass
	-- a parameterized threshold


	  MASTER_EXECUTION_PROC:process(M_AXI_ACLK) -- fsm number 2
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0') then
	        -- reset condition
	        -- All the signals are ed default values under reset condition
	        write_state     <= IDLE;
	        start_single_burst_write <= '0';
	        --ERROR <= '0';
	      else
	        -- state transition
	        case (write_state) is
        		when IDLE =>
	            -- This state is responsible to initiate
	            -- AXI transaction when init_txn_pulse is asserted
              if init_txn_pulse = '1' then
               write_state  <= INIT_WRITE;
               --ERROR <= '0';
              else
               write_state  <= IDLE;
              end if;
            when INIT_WRITE =>
              -- This state is responsible to issue start_single_write pulse to
              -- initiate a write transaction. Write transactions will be
              -- issued until burst_write_active signal is asserted.
              -- write controller
              if (writes_done = '1') then
                write_state <= IDLE;
              else
                write_state  <= INIT_WRITE;
	              if (axi_awvalid = '0' and start_single_burst_write = '0' and burst_write_active = '0' ) then
									-- if msg_wr_done = '0' then
	                	start_single_burst_write <= '1';
	                	
	              else
	                start_single_burst_write <= '0'; --Negate to generate a pulse
	              end if;
              end if;            
            when INIT_COMPARE =>
              -- This state is responsible to issue the state of comparison
              -- of written data with the read data. If no error flags are set,
              -- msg_wr_done signal will be asseted to indicate success.
--	              ERROR <= error_reg ;
              write_state <= IDLE;
              -- msg_wr_done <= '0';
            when others  =>
              write_state  <= IDLE;
	          end case  ;
	       end if;
	    end if;
	  end process;


	  -- burst_write_active signal is asserted when there is a burst write transaction
	  -- initiated by the assertion of start_single_burst_write. burst_write_active
	  -- signal remains asserted until the burst write is accepted by the slave
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
	        burst_write_active <= '0';
	       --The burst_write_active is asserted when a write burst transaction is initiated
	      else
	        if (start_single_burst_write = '1') then
	          burst_write_active <= '1';
	        elsif (M_AXI_BVALID = '1' and axi_bready = '1') then
	          burst_write_active <= '0';
	        end if;
	      end if;
	    end if;
	  end process;

	 -- Check for last write completion.

	 -- This logic is to qualify the last write count with the final write
	 -- response. This demonstrates how to confirm that a write has been
	 -- committed.
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
	       writes_done <= '0';
	      --The reads_done should be associated with a rready response
	      --elsif (M_AXI_RVALID && axi_rready && (read_burst_counter == {(C_NO_BURSTS_REQ-1){1}}) && axi_rlast)
	      else
--	        if (M_AXI_BVALID = '1' and (write_burst_counter(C_NO_BURSTS_REQ) = '1') and axi_bready = '1') then
					if (M_AXI_BVALID = '1'and termination_burst = '1' and axi_bready = '1') then --  and msg_wr_done = '1'
	          writes_done <= '1';
	        end if;
	      end if;
	    end if;
	  end process;

	  -- burst_read_active signal is asserted when there is a burst write transaction
	  -- is initiated by the assertion of start_single_burst_write. start_single_burst_read
	  -- signal remains asserted until the burst read is accepted by the master
	  process(M_AXI_ACLK)
	  begin
	    if (rising_edge (M_AXI_ACLK)) then
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then
	        burst_read_active <= '0';

	       --The burst_write_active is asserted when a write burst transaction is initiated
	      else
	        if (start_single_burst_read = '1')then
	          burst_read_active <= '1';
	        elsif (M_AXI_RVALID = '1' and axi_rready = '1' and M_AXI_RLAST = '1') then
	          burst_read_active <= '0';
	        end if;
	      end if;
	    end if;
	  end process;

		fsm_cmb : process (M_AXI_ACLK)  -- fsm number 1
		begin
			if rising_edge (M_AXI_ACLK) then
	      if M_AXI_ARESETN = '0' then
					start_single_burst_read  <= '0';
					read_state <= IDLE;
					axi_arlen <= x"00";
				else
	        -- state transition
					case read_state is
						when IDLE =>
							if init_rxn_pulse = '1' then
								axi_arlen <= x"00";
								read_state <= READ_MSGL;
							end if;
						when READ_MSGL =>
							if (M_AXI_RLAST = '1') then
								read_state <= CHECK_MSGL;
							else
								read_state  <= READ_MSGL;
								if (axi_arvalid = '0' and burst_read_active = '0' and start_single_burst_read = '0') then
									start_single_burst_read <= '1';
								else
									start_single_burst_read <= '0'; --Negate to generate a pulse
								end if;
							end if;
						when CHECK_MSGL =>
                                if numOfRdBeat = 0 then
                                    -- read_state <= READ_DECLINED;
                                    read_state <= READ_DONE;
                                elsif numOfRdBeat > 0 and numOfRdBeat <= 15 then
                                        axi_arlen <= std_logic_vector (to_unsigned (numOfRdBeat, 8) - 1);
                                        read_state <= READING;
                                    -- else error!
                                elsif numOfRdBeat > 15 then
                                    axi_arlen <= x"0F";
                                    read_state <= READING;
                                -- else error!
                                end if;
--						when CHECK_MSGL =>
--							if numOfRdBurst = 0 then
--								-- read_state <= READ_DECLINED;
--								read_state <= READ_DONE;
--							elsif numOfRdBurst > 0 and numOfRdBurst <= 255 then
--								axi_arlen <= x"0F";
--								read_state <= READING;
--							-- else error!
--							end if;
						when READING =>
						-- This state is responsible to issue start_single_read pulse to
						-- initiate a read transaction. Read transactions will be
						-- issued until burst_read_active signal is asserted.
						-- read controller
							if (M_AXI_RLAST = '1') then
								read_state <= CHECK_MSGL;
							else
								if (axi_arvalid = '0' and burst_read_active = '0' and start_single_burst_read = '0') then
									start_single_burst_read <= '1';
								else
									start_single_burst_read <= '0'; --Negate to generate a pulse
								end if;
								read_state  <= READING;
							end if;
						when READ_DONE =>
							read_state <= IDLE; -- READ_DONE;
						when others  =>
		          read_state  <= IDLE;
					end case;
				end if;
			end if;
		end process;

	 -- Check for last read completion.

	 -- This logic is to qualify the last read count with the final read
	 -- response. This demonstrates how to confirm that a read has been
	 -- committed.

	  -- process(M_AXI_ACLK)
	  -- begin
	  --   if (rising_edge (M_AXI_ACLK)) then
	  --     if (M_AXI_ARESETN = '0' or init_rxn_pulse = '1') then
	  --       reads_done <= '0';
	  --       --The reads_done should be associated with a rready response
	  --       --elsif (M_AXI_RVALID && axi_rready && (read_burst_counter == {(C_NO_BURSTS_REQ-1){1}}) && axi_rlast)
	  --     else
	  --       if (M_AXI_RVALID = '1' and axi_rready = '1' and (read_index = std_logic_vector (to_unsigned(C_M_AXI_BURST_LEN-1,C_TRANSACTIONS_NUM+1))) and (read_burst_counter(C_NO_BURSTS_REQ) = '1')) then
	  --         reads_done <= '1';
	  --       end if;
	  --     end if;
	  --   end if;
	  -- end process;

	-- Add user logic here

	-- User logic ends

end simulation;
