`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 06:14:07 PM
// Design Name: 
// Module Name: spi_slave
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


 module spi_slave(
    input sclk,cs,mosi,
    input [7:0] data_to_send,
    output reg miso,
    output reg [7:0] received_data
    );
    reg [2:0] bit_counter  ;
    reg [7:0] shift_reg   ;
    always@(negedge cs) // when selected by the master 
      begin
        shift_reg <= data_to_send; // loads the data to be sent
        miso <= data_to_send[0];  
        bit_counter <= 3'd7;      // intialises the counter
      end
    
    always@(posedge sclk) // at sclk's positve edge the slave samples data from the mosi (mode 0)
     begin 
        if (cs == 0)
        shift_reg <= {mosi,shift_reg[7:1]}; //loads data from the mosi into the shift register
        else 
        shift_reg <= shift_reg;
     end
     
    always@(negedge sclk)
    begin
       if (cs == 0)
        begin 
         miso  <= shift_reg[0]; // loads LSB to the miso line
            if (bit_counter !=0) 
              bit_counter <= bit_counter -1 ;
            else if (bit_counter == 0)
              begin
              received_data <= shift_reg;
              miso <= 1'bz ;
              end
        end
       else
        miso <= 1'bz ; // so that it doesn't drive the mosi line when it's not selected 
    end
 endmodule
 
 