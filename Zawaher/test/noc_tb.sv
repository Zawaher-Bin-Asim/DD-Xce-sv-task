module noc_tb();

    reg clk, reset;
    logic [12:0] packet;
    logic pack_gen_ready;
    logic nocr_ready;
    logic pack_valid;
    logic nocr_valid;
    logic [7:0]reserve_buffer,response_buffer,data_buffer,control_buffer;
    noc NOC(
        .clk(clk),
        .reset(reset),
        .packet(packet),
        .pack_valid(pack_valid),
        .pack_gen_ready(pack_gen_ready),
        .nocr_ready(nocr_ready),
        .nocr_valid(nocr_valid),
        .reserve_buffer(reserve_buffer),
        .response_buffer(response_buffer),
        .data_buffer(data_buffer),
        .control_buffer(control_buffer)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset_sequence();
        @(posedge clk);
        fork
            driver();
            monitor();
        join
    end

    task reset_sequence();
        begin
            reset = 1;
            @(posedge clk);
            reset <= 0;
            @(posedge clk);
            reset <= 1;
        end
    endtask

    task driver();
        begin
            apply_packet();
            pack_valid = 1'b1; // Assert pack_valid
            while (!nocr_ready) begin
                @(posedge clk); // Wait for NoC to be ready
            end
            @(posedge clk); // Allow the packet to be captured by NoC
            pack_valid = 1'b0; // Deassert pack_valid
        end    
    endtask

    task monitor();
        @(posedge clk);
        pack_gen_ready = 1'b1;
        while (!nocr_valid) begin
            @(posedge clk); 
        end
        if (packet[4:3] == 2'b00)begin
            if (packet[11:4] == data_buffer)begin
                $display("Test Passed");
            end
            else begin 
                $display("Test Failed");
            end
        end
        else if (packet[4:3] == 2'b01)begin
            if (packet[11:4] == control_buffer)begin
                $display("Test Passed");
            end
            else begin 
                $display("Test Failed");
            end
        end
        else if (packet[4:3] == 2'b11)begin
            if (packet[11:4] == reserve_buffer)begin
                $display("Test Passed");
            end
            else begin 
                $display("Test Failed");
            end
        end
        else if (packet[4:3] == 2'b10)begin
            if (packet[11:4] == response_buffer)begin
                $display("Test Passed");
            end
            else begin 
                $display("Test Failed");
            end
        end
        
        pack_gen_ready = 1'b0;
    endtask 

    task apply_packet();
        logic [1:0] addr, pack_type;
        logic [7:0] payload;

        addr = $random;
        pack_type = $random;
        payload = $random;

        // Blocking assignment for immediate update
        packet = {1'b1, payload, pack_type, addr};
    endtask

endmodule
