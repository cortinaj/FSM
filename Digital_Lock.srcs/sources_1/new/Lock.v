`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 05:49:24 PM
// Design Name: 
// Module Name: Lock
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


module Lock(
    input wire clk,
    input wire [3:0] btn,
    output wire [7:0] led
    );
    
    //wire rst;
    // Debounced and synchronized button pulses
    wire btn_N_p, btn_E_p, btn_S_p, btn_W_p;
    
    debounce North(.clk(clk),
                   .rst(1'b0),
                   .button_in(btn[3]),
                   .pulse_out(btn_N_p)
                  );
   
    debounce East(.clk(clk),
                   .rst(1'b0),
                   .button_in(btn[2]),
                   .pulse_out(btn_E_p)
                  );
    
    debounce South(.clk(clk),
                   .rst(1'b0),
                   .button_in(btn[1]),
                   .pulse_out(btn_S_p)
                  );
    
    debounce West(.clk(clk),
                   .rst(1'b0),
                   .button_in(btn[0]),
                   .pulse_out(btn_W_p)
                  );
                  
    //FSM output
    
    digital_lock_fsm FSM(.clk(clk),
                         .rst(btn_N_p),
                         .btn_N(btn_N_p),
                         .btn_E(btn_E_p),
                         .btn_S(btn_S_p),
                         .btn_W(btn_W_p),
                         .unlock(unlock),
                         .alarm(alarm),
                         .state_led(state_led)
                        );
                        
   assign led = state_led;
                    
endmodule
