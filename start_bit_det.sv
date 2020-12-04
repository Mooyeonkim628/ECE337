// $Id: $
// File name:   start_bit_det.sv
// Created:     2/5/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: start bit detector for UART RX Design

`timescale 1ns / 10ps

module start_bit
(
  input  wire clk,
  input  wire n_rst,
  input  wire dp_s,
  output wire s_bit
);

  reg old_sample;
  reg new_sample;
  reg sync_phase;
  
  always @ (negedge n_rst, posedge clk)
  begin : REG_LOGIC
    if(1'b0 == n_rst)
    begin
      old_sample  <= 1'b1; // Reset value to idle line value
      new_sample  <= 1'b1; // Reset value to idle line value
      sync_phase  <= 1'b1; // Reset value to idle line value
    end
    else
    begin
      old_sample  <= new_sample;
      new_sample  <= sync_phase;
      sync_phase  <= d_ps;
    end
  end
  
  // Output logic
  assign s_bit = old_sample & (~new_sample); // Detect a falling edge -> new sample must be '0' and old sample must be '1'

  // Input checking assertions
  always @ (clk, n_rst, serial_in)
  begin
    #(0.2ns);
  
    assert((1'b0 == clk) || (1'b1 == clk))
    else
      $warning("Start bit detector input clk is not a logic '1' or '0'");
    
    assert((1'b0 == n_rst) || (1'b1 == n_rst))
    else
      $warning("Start bit detector input n_rst is not a logic '1' or '0'");
    
    assert((1'b0 == d_ps) || (1'b1 == d_ps))
    else
      $warning("Start bit detector input serial_in is not a logic '1' or '0'");
  end
  
endmodule
