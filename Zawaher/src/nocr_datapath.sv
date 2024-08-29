module nocr_datapath (
    input   logic   clk,reset,
    // Input from the packet genertaor      
    input   logic   [12:0]packet,
    input   logic   nocr1_en,
    input   logic   nocr2_en,
    input   logic   nocr3_en,
    input   logic   nocr4_en,
    // Output from  datapath to controller
    output  logic   invalid_pack,
    output  logic   nocr1,
    output  logic   nocr2,
    output  logic   nocr3,
    output  logic   nocr4,
    output  logic   valid_resp,
    output  logic   [7:0]data_buffer,control_buffer,response_buffer,reserve_buffer
);

logic [1:0]pack_type;

// DATA BUFFER

decode DECODER(
    .packet(packet),

    .pack_type(pack_type),
    .invalid_pack(invalid_pack),
    .nocr1(nocr1),
    .nocr2(nocr2),
    .nocr3(nocr3),
    .nocr4(nocr4)
);


always_ff @( posedge clk or negedge reset ) begin 
    if (!reset)begin
        valid_resp <= 1'b0;
        data_buffer <= 'h0;
        reserve_buffer <= 'h0;
        response_buffer  <= 'h0;
        control_buffer  <= 'h0;

    end
    else begin
        if (nocr1_en)begin
            if (pack_type == 2'b00)begin
                data_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b01)begin
                control_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b11)begin
                reserve_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b10)begin
                response_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
        end
        
        else  if (nocr2_en)begin
            if (pack_type == 2'b00)begin
                data_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b01)begin
                control_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b11)begin
                reserve_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b10)begin
                response_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
        end

        else  if (nocr3_en)begin
            if (pack_type == 2'b00)begin
                data_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b01)begin
                control_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b11)begin
                reserve_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b10)begin
                response_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
        end

        else  if (nocr4_en)begin
            if (pack_type == 2'b00)begin
                data_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b01)begin
                control_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b11)begin
                reserve_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
            else if (pack_type == 2'b10)begin
                response_buffer <=  packet[11:4];
                valid_resp  <= 1'b1;
            end
        end



    end
    
end





    
endmodule

module decode (
    input   logic [12:0]packet,

    output  logic   [1:0]pack_type,
    output  logic   invalid_pack,
    output  logic   nocr1,
    output  logic   nocr2,
    output  logic   nocr3,
    output  logic   nocr4

);

always_comb begin 

    invalid_pack    = 1'b0;
    nocr1           = 1'b0;           
    nocr2           = 1'b0;
    nocr3           = 1'b0;
    nocr4           = 1'b0;

    if ( packet[12] == 0)begin
        invalid_pack = 1'b1;
    end
    else begin
        if (packet[1:0] == 00 )begin
            nocr1 = 1'b1;
        end
        else if (packet[1:0] == 01 )begin
            nocr2 = 1'b1;
        end
        else if (packet[1:0] == 11 )begin
            nocr3 = 1'b1;
        end
        else if (packet[1:0] == 10 )begin
            nocr4 = 1'b1;
        end
    end
    pack_type = packet[3:2];  

    
end

endmodule

