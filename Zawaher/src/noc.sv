module noc (
    input   logic   clk,reset,
    input   logic   [12:0]packet,
    input   logic   pack_valid,
    input   logic   pack_gen_ready,
    output  logic   nocr_ready,
    output  logic   nocr_valid,
    output  logic   [7:0]data_buffer,reserve_buffer,response_buffer,control_buffer

);


logic   nocr1_en;
logic   nocr2_en;
logic   nocr3_en;
logic   nocr4_en;
logic   invalid_pack;
logic   nocr1;
logic   nocr2;
logic   nocr3;
logic   nocr4;
logic   valid_resp;


nocr_datapath DP(
    .clk(clk),.reset(reset),
    // Input from the packet genertaor      
    .packet(packet),
    .nocr1_en(nocr1_en),
    .nocr2_en(nocr2_en),
    .nocr3_en(nocr3_en),
    .nocr4_en(nocr4_en),
    // Output from  datapath to controller
    .invalid_pack(invalid_pack),
    .nocr1(nocr1),
    .nocr2(nocr2),
    .nocr3(nocr3),
    .nocr4(nocr4),
    .valid_resp(valid_resp),
    .reserve_buffer(reserve_buffer),
    .data_buffer(data_buffer),
    .control_buffer(control_buffer),
    .response_buffer(response_buffer)
);

nocr_controller CT(
    .clk(clk),.reset(reset),
    // Inputs from the package generaator
    .pack_valid(pack_valid),
    .pack_gen_ready(pack_gen_ready),

    //Inputs from datapath to controller
    .invalid_pack(invalid_pack),
    .nocr1(nocr1),
    .nocr2(nocr2),
    .nocr3(nocr3),
    .nocr4(nocr4),
    .valid_resp(valid_resp),

    // Outputs from Controller  to datapath
    .nocr1_en(nocr1_en),
    .nocr2_en(nocr2_en),
    .nocr3_en(nocr3_en),
    .nocr4_en(nocr4_en),

    // Outputs from NOCR to Packet Generator
    .nocr_ready(nocr_ready),
    .nocr_valid(nocr_valid)
    
);

    
endmodule