`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2021 10:12:54 AM
// Design Name: 
// Module Name: reset
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


module reset( input clk,
               input rst_n,
              output reg reset_globle
             );
             integer                         clkcount;
            
             always @(posedge clk or negedge rst_n) 
             begin   
             if(!rst_n)
              begin
              clkcount=0;
              reset_globle=1;
              end           
                      // During reset: Set initial state and counter
//              if (clkcount<3) 
//                  begin
//                     reset_globle<=1;
//                     clkcount <= clkcount + 1;
//                  end 
              else
                  begin
                    reset_globle<=0;
                    clkcount <= clkcount;
                  end    
              end
         
             
             
             
             
             
endmodule
