
`include "../define/noc.svh"

module nocr_controller (
    input   logic   clk,reset,
    // Inputs from the package generaator
    input   logic   pack_valid,
    input   logic   pack_gen_ready,

    //Inputs from datapath to controller
    input   logic   invalid_pack,
    input   logic   nocr1,
    input   logic   nocr2,
    input   logic   nocr3,
    input   logic   nocr4,
    input   logic   valid_resp,

    // Outputs from Controller  to datapath
    output  logic   nocr1_en,
    output  logic   nocr2_en,
    output  logic   nocr3_en,
    output  logic   nocr4_en,

    // Outputs from NOCR to Packet Generator
    output  logic   nocr_ready,
    output  logic   nocr_valid
    
);

nocr_states_e        c_state,n_state;

//Controller Register
always_ff @(posedge clk or negedge reset)begin
    
    if (!reset)begin
        c_state <= IDLE;
        
    end
    else begin
        c_state <= n_state;
    end 

end

// Next state always_comb block
always_comb begin
    // Default state transition
    n_state = c_state;
    
    case (c_state)
        IDLE: begin
            if (pack_valid) begin
                n_state = DECODE;
            end
            else n_state = IDLE;
        end

        DECODE: begin
            if (invalid_pack) begin
                if (pack_gen_ready) n_state = IDLE;
                else n_state = WAIT_READY;
            end 
            else begin
                if (nocr1) n_state = NOCR1;
                else if (nocr2) n_state = NOCR2;
                else if (nocr3) n_state = NOCR3;
                else if (nocr4) n_state = NOCR4;
        
            end
        end

        NOCR1 : begin
            if (valid_resp)begin
                if (pack_gen_ready) n_state = IDLE;
                else n_state = WAIT_READY;
            end
            else n_state = NOCR1;
        end

        NOCR2 : begin
            if (valid_resp)begin
                if (pack_gen_ready) n_state = IDLE;
                else n_state = WAIT_READY;
            end
            else n_state = NOCR2;
        end

        NOCR3 : begin
            if (valid_resp)begin
                if (pack_gen_ready) n_state = IDLE;
                else n_state = WAIT_READY;
            end
            else n_state = NOCR3;
        end

        NOCR4 : begin
            if (valid_resp)begin
                if (pack_gen_ready) n_state = IDLE;
                else n_state = WAIT_READY;
            end
            else n_state = NOCR4;
        end


        WAIT_READY: begin
            if (pack_gen_ready) n_state = IDLE;
        end

        default: n_state = IDLE;
    endcase
end


always_comb begin 
    // Default values for outputs
    nocr1_en    = 1'b0;
    nocr2_en    = 1'b0;
    nocr3_en    = 1'b0;
    nocr4_en    = 1'b0;
    nocr_ready  = 1'b0;
    nocr_valid  = 1'b0;

    
    case (c_state)
        IDLE: begin
            nocr_ready = 1'b1;
        end

        DECODE: begin
            if (invalid_pack) begin
                nocr_valid = 1'b1;
            end 
            else begin
                if (nocr1) nocr1_en = 1'b1;
                else if (nocr2) nocr2_en = 1'b1;
                else if (nocr3) nocr3_en = 1'b1;
                else if (nocr4) nocr4_en = 1'b1;
        
            end
        end

        NOCR1 : begin
            if (valid_resp)begin
                nocr_valid = 1'b1;
            end
            
        end

        NOCR2 : begin
            if (valid_resp)begin
                nocr_valid = 1'b1;
            end
        end

        NOCR3 : begin
            if (valid_resp)begin
                nocr_valid = 1'b1;
            end
        end

        NOCR4 : begin
            if (valid_resp)begin
                nocr_valid = 1'b1;
            end
        end


        WAIT_READY: begin
            nocr_valid = 1'b1;
        end

        default: ;
    endcase
end






    
endmodule