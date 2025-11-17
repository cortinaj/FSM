`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 05:34:22 PM
// Design Name: 
// Module Name: digital_lock_fsm
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


module digital_lock_fsm(
    input wire clk, rst,
    input wire btn_N, btn_E, btn_S, btn_W,
    output reg unlock,
    output reg alarm,
    output reg [7:0] state_led
    );
    
    //State encoding
    reg [3:0] state, next_state;
    
    localparam [3:0]
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        UNL = 4'd4,
        ALM = 4'd5;
        
    always @(posedge clk or posedge rst) begin
        if(rst || btn_N) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        unlock = 0;
        alarm = 0;
        next_state = state;
        
        case (state)
            S0: begin
                state_led = 8'h30;
                if(btn_S) next_state = S1;
            end
            
            S1: begin
                state_led = 8'h31;
                if(btn_W) begin 
                    next_state = S2;
                end else if 
                    (btn_E || btn_S) next_state = ALM;
            end

            S2: begin
                state_led = 8'h32;
                if(btn_E) next_state = S3;
                else next_state = ALM;
            end
            
            S3: begin
                state_led = 8'h33;
                if(btn_W) next_state = UNL;
                else next_state = ALM;
            end
            
            UNL: begin
                state_led = 8'h55;
                unlock = 1;
                if (btn_S || btn_E || btn_W) next_state = S0;
            end
            
            ALM: begin
                state_led = 8'h41;
                alarm = 1;
                if (btn_W && btn_E) next_state = S0;
            end
           
            default: begin
                next_state = S0;
            end
         endcase
         
         if (state != S0 && state != UNL && state != ALM) begin
            if (btn_E || btn_S || btn_W) begin
                // Go to ALM on any invalid key
                if (!((state == S1 && btn_W) ||
                      (state == S2 && btn_E) ||
                      (state == S3 && btn_W)))
                    next_state = ALM;
            end
        end
    end  
           
    
endmodule
