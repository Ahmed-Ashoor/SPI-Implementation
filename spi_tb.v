`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 06:26:11 PM
// Design Name: 
// Module Name: spi_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_tb();
    
    wire mosi_tb,miso_tb,sclk_tb,done_tb ;
    wire [3:0] cs_tb;
    wire [7:0] mreceived_tb;
    wire [7:0] sreceived_tb [3:0];
    reg clk_tb,reset_tb,start_tb ;
    reg [1:0]slave_sel_tb;
    reg [7:0] mdata_tb;
    reg [7:0] sdata_tb [3:0];
    
spi_master m1 (clk_tb,reset_tb,start_tb,slave_sel_tb,mdata_tb,miso_tb,cs_tb,mosi_tb,sclk_tb,mreceived_tb,done_tb);
spi_slave s0 (sclk_tb,cs_tb[0],mosi_tb,sdata_tb[0],miso_tb,sreceived_tb[0]);    
spi_slave s1 (sclk_tb,cs_tb[1],mosi_tb,sdata_tb[1],miso_tb,sreceived_tb[1]);  
spi_slave s2 (sclk_tb,cs_tb[2],mosi_tb,sdata_tb[2],miso_tb,sreceived_tb[2]);  
spi_slave s3 (sclk_tb,cs_tb[3],mosi_tb,sdata_tb[3],miso_tb,sreceived_tb[3]);  

initial
  fork 
    clk_tb = 1'b0;
    
    mdata_tb = 8'ha2;      // random data for the master to send 
    sdata_tb[0] = 8'hb1;   // random data for the slaves to send back
    sdata_tb[1] = 8'hc3;
    sdata_tb[2] = 8'hd4;
    sdata_tb[3] = 8'he5;
    reset_tb = 1'b1;      // reset signal  
    #20 reset_tb = 1'b0;
    
    #20 slave_sel_tb = 2'b00 ; // testing a data exchange with the first slave
    #20 start_tb = 1'b1;       // start signal
    #40 start_tb = 1'b0;
    
    #200 slave_sel_tb = 2'b01 ; // testing a data exchange with the second slave 
    #200 start_tb = 1'b1;       // start signal
    #220 start_tb = 1'b0;
    
    #400 slave_sel_tb = 2'b10 ; // testing a data exchange with the third slave 
    #400 start_tb = 1'b1;       // start signal
    #420 start_tb = 1'b0;
    
    #600 slave_sel_tb = 2'b11 ; // testing a data exchange with the fourth slave 
    #600 start_tb = 1'b1;       // start signal
    #620 start_tb = 1'b0;
    
    
    #1000 $finish;              // finishing the testbench

  join

 always
 #10 clk_tb = ~clk_tb ;      // generating a clock signal with period 10ns
 
endmodule

