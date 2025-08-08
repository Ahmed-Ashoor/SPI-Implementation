`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 05:58:43 PM
// Design Name: 
// Module Name: spi_master
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


module spi_master(
    input clk, // syestem clock 
    input reset,
    input start,
    input [1:0] slave_select, 
    input [7:0] data_in,     // loads data to be sent to the slaves via mosi
    input miso,
    output [3:0] cs  ,
    output reg mosi,
    output reg sclk,
    output reg [7:0] recieved_data,
    output  done_flag
    );
    
    reg [7:0] shift_reg ;
    reg [2:0] bit_counter;
    reg [1:0] current_state, next_state  ;
    
    localparam idle = 2'b00,transfer = 2'b01,done = 2'b10; 
    

  
   assign cs = (slave_select == 2'b00)? 4'b1110 : //selecting which slave to communicate with
               (slave_select == 2'b01)? 4'b1101 :
               (slave_select == 2'b10)? 4'b1011 :
               (slave_select == 2'b11)? 4'b0111 : 4'b1111 ;
   
   
    // state transition
    always@(posedge clk , posedge reset)
    begin
       if (reset)
             current_state = idle; 
       else
            current_state = next_state;
    end
    
    
    // next state logic
    always @(clk)
    begin 
            case (current_state)
            idle : 
            begin
            sclk = 1'b0;
            
                if (start)
                begin
                shift_reg = data_in;
                bit_counter <= 3'd7; // to count the 8 bits 
                next_state <= transfer;
                mosi = shift_reg[0]; 
                end
            end
            transfer : 
            begin
            sclk <= ~sclk;  
            
            if (sclk)                                           
            if (bit_counter == 0) 
                      next_state <= done;
            else
                      bit_counter <= bit_counter - 1;                                                             
            end          
            done : 
            begin
            recieved_data <= shift_reg;
            
            next_state <= idle ;
            mosi <= 1'b0; 
            
            end 
            default : next_state = idle;
            endcase 
        end
        
    
        assign done_flag = (current_state == done)?     1'b1: 1'b0    ; 
        always@(negedge sclk)             
        mosi = shift_reg[0]; // falling edge (master loads the data into the mosi line) mode 0
        
        always@(posedge sclk)           
        shift_reg = {miso,shift_reg[7:1]}; // rising edge (master reads from the miso line) mode 0  
         
 endmodule


