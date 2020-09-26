// 0.5um D-FlipFlop Timing Data Estimates:
// Data Propagation delay (clk->Q): 670ps
// Setup time for data relative to clock: 190ps
// Hold time for data relative to clock: 10ps

`timescale 1ns / 10ps

module tb_flex_counter();

  // Define local parameters used by the test bench
  localparam  CLK_PERIOD    = 1;
  localparam  FF_SETUP_TIME = 0.190;
  localparam  FF_HOLD_TIME  = 0.100;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); 
  
  localparam  INACTIVE_VALUE     = 1'b0;
  localparam  RESET_OUTPUT_VALUE = INACTIVE_VALUE;
  localparam  NUM_CNT_BITS = 4; 
 
  // Declare DUT portmap signals
  reg tb_clk;
  reg tb_n_rst;
  reg tb_clear;
  reg tb_count_enable;
  reg [NUM_CNT_BITS-1:0] tb_rollover_val;
  wire [NUM_CNT_BITS-1:0] tb_count_out;
  wire tb_rollover_flag;  

  // Declare test bench signals
  integer tb_test_num;
  string tb_test_case;
  integer tb_stream_test_num;
  string tb_stream_check_tag;
  integer z;
  integer q;
  // Task for standard DUT reset procedure
  task reset_dut;
  begin

    tb_n_rst = 1'b0;

    @(posedge tb_clk);
    @(posedge tb_clk);


    @(negedge tb_clk);
    tb_n_rst = 1'b1;


    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask


  task check_output;
    input logic  expected_value;
    input logic  expected_flag;
    input string check_tag;
  begin
    if(expected_value == tb_count_out && expected_flag == tb_rollover_flag) begin // Check passed
      $info("Correct counter output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect counter output %s during %s test case", check_tag, tb_test_case);
    end
  end
  endtask

  task clear_dut;
  begin
    tb_clear = 1'b0;
    #(CLK_PERIOD/2.0);
    tb_clear = 1'b1;
    #(CLK_PERIOD);
    tb_clear = 1'b0;
    #(CLK_PERIOD/2.0);	
  end
  endtask

  // Clock generation block
  always
  begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end
  
  // DUT Port map
  flex_counter DUT(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val),
 .count_out(tb_count_out), .rollover_flag(tb_rollover_flag) );
  
  // Test bench main process
  initial
  begin
    // Initialize all of the test inputs
    tb_n_rst  = 1'b1;              // Initialize to be inactive
    tb_count_enable = 1'b0;
    tb_clear = 1'b0;
    tb_rollover_val  = 0; // Initialize input to inactive  value
    tb_test_num = 0;               // Initialize test case counter
    tb_test_case = "Test bench initializaton";
    tb_stream_test_num = 0;
    tb_stream_check_tag = "N/A";
    // Wait some time before starting first test case
    #(0.1);
    
    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    tb_rollover_val  = 0; // Set to be the the non-reset value
    tb_n_rst  = 1'b0;    // Activate reset
    
    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    check_output( RESET_OUTPUT_VALUE,0, 
                  "after reset applied");
    
    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output( RESET_OUTPUT_VALUE,0, 
                  "after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(posedge tb_clk);
    #(2 * FF_HOLD_TIME);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    #0.1;
    // Check that internal state was correctly keep after reset release
    check_output( RESET_OUTPUT_VALUE, 0,
                  "after reset was released");

    // ************************************************************************
    // Test Case 2: Rollover for a rollover value that is not a power of two 
    // ************************************************************************    
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 0;
    reset_dut();
	clear_dut(); 
   tb_rollover_val = 4'b1001;
   tb_count_enable=1;
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover for a rollover value that is not a power of two";

    for(z=0;z<tb_rollover_val;z+=1)	
	@(posedge tb_clk);

   #(CHECK_DELAY);
   	// Check results
    check_output( tb_rollover_val,1,
                  "after processing delay");
 		
	clear_dut();

    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 0;
    reset_dut();
	clear_dut(); 
   tb_rollover_val = 4'b1011;
   tb_count_enable=1;
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover for a rollover value that is not a power of two";

    for(z=0;z<tb_rollover_val;z+=1)	
	@(posedge tb_clk);

   #(CHECK_DELAY);
   	// Check results
    check_output( tb_rollover_val,1,
                  "after processing delay");
 		
	clear_dut();
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 0;
    reset_dut();
	clear_dut(); 
   tb_rollover_val = 4'b1101;
   tb_count_enable=1;
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover for a rollover value that is not a power of two";

    for(z=0;z<tb_rollover_val;z+=1)	
	@(posedge tb_clk);

   #(CHECK_DELAY);
   	// Check results
    check_output( tb_rollover_val,1,
                  "after processing delay");
 		
	clear_dut();
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 0;
    reset_dut();
	clear_dut(); 
   tb_rollover_val = 4'b1111;
   tb_count_enable=1;
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover for a rollover value that is not a power of two";

    for(z=0;z<tb_rollover_val;z+=1)	
	@(posedge tb_clk);

   #(CHECK_DELAY);
   	// Check results
    check_output( tb_rollover_val,1,
                  "after processing delay");
 		
	clear_dut();
    // Wait for DUT to process stimulus before checking results


    
    // ************************************************************************    
    // Test Case 3: Continous counting
    // ************************************************************************
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-2;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-2;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-2,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-3;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-3;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-3,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-4;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-4;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-4,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-5;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-5;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-5,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
    // ************************************************************************
    // Test Case 4: Discontinous counting
    // ************************************************************************
      @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-2;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(z=1;z<2**NUM_CNT_BITS-2;z+=2)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( z,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-2,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
      @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-3;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(z=1;z<2**NUM_CNT_BITS-3;z+=2)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( z,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-3,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
      @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-4;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(z=1;z<2**NUM_CNT_BITS-4;z+=2)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( z,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-4,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
      @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-5;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(z=1;z<2**NUM_CNT_BITS-5;z+=2)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( z,0,
                  "after processing delay");		
	
    end
	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( 2**NUM_CNT_BITS-5,1,
                  "after processing delay");		
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();

    // ************************************************************************
    // Last Test Case: Clearing while counting to check clear vs. count enable priority
    // ************************************************************************
    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-2;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-2;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	if(q==2**NUM_CNT_BITS-4)begin
		clear_dut();
	end
    end
    	check_output( 1'b1,0,
                  "after processing delay");
    clear_dut();

    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-2;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-2;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	if(q==2**NUM_CNT_BITS-5)begin
		clear_dut();
	end
    end
    	check_output( 1'b1,0,
                  "after processing delay");
    clear_dut();

    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-2;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-2;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	if(q==2**NUM_CNT_BITS-6)begin
		clear_dut();
	end
    end
    	check_output( 1'b1,0,
                  "after processing delay");
    clear_dut();

    @(negedge tb_clk); 
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 2**NUM_CNT_BITS-2;
    reset_dut();
    tb_count_enable=1;

    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continous counting";
    for(q=1;q<2**NUM_CNT_BITS-2;q+=1)begin


	@(posedge tb_clk);

   	#(CHECK_DELAY);
    	// Check results
    	check_output( q,0,
                  "after processing delay");		
	if(q==2**NUM_CNT_BITS-7)begin
		clear_dut();
	end
    end
    	check_output( 1'b1,0,
                  "after processing delay");
    clear_dut();

	
	
    // Wait for DUT to process stimulus before checking results

    clear_dut();
    
  end
endmodule
