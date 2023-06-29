`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/26 10:17:06
// Design Name: 
// Module Name: dm
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

`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100
module dm_controller(
    input mem_w,
    input [31:0]Addr_in,
    input [31:0]Data_write,
    input [2:0]dm_ctrl,
    input [31:0]Data_read_from_dm,
    output reg [31:0]Data_read,
    output reg [31:0]Data_write_to_dm,
    output reg [3:0]wea_mem
    );
    always @(*)
    if(mem_w)begin
    //Data_write_to_dm<=Data_write;
    case(dm_ctrl)
        `dm_word: 
            begin
            wea_mem<=4'b1111;
            Data_write_to_dm<=Data_write;
            end
        `dm_halfword:
            if(Addr_in[1]==1'b0)
             begin wea_mem<=4'b0011; Data_write_to_dm<={2{Data_write[15:0]}}; end
            else if 
            (Addr_in[1]==1'b1) begin wea_mem<=4'b1100;Data_write_to_dm<={2{Data_write[15:0]}}; end
        `dm_halfword_unsigned:
            if(Addr_in[1]==1'b0)
             begin wea_mem<=4'b0011; Data_write_to_dm<={2{Data_write[15:0]}}; end
            else if (Addr_in[1]==1'b1) 
            begin wea_mem<=4'b1100;Data_write_to_dm<={2{Data_write[15:0]}}; end
        `dm_byte:
            if(Addr_in[1:0]==2'b00) 
            begin wea_mem<=4'b0001;Data_write_to_dm<={4{Data_write[7:0]}}; end
            else if(Addr_in[1:0]==2'b01)
             begin wea_mem<=4'b0010; Data_write_to_dm<={4{Data_write[7:0]}}; end 
            else if (Addr_in[1:0]==2'b10)
             begin wea_mem<=4'b0100; Data_write_to_dm<={4{Data_write[7:0]}}; end
            else if (Addr_in[1:0]==2'b11)
             begin wea_mem<=4'b1000; Data_write_to_dm<={4{Data_write[7:0]}}; end    
        `dm_byte_unsigned:
             if(Addr_in[1:0]==2'b00) 
             begin wea_mem<=4'b0001;Data_write_to_dm<={4{Data_write[7:0]}}; end
             else if(Addr_in[1:0]==2'b01) 
             begin wea_mem<=4'b0010;Data_write_to_dm<={4{Data_write[7:0]}}; end 
             else if (Addr_in[1:0]==2'b10)
              begin wea_mem<=4'b0100;Data_write_to_dm<={4{Data_write[7:0]}}; end
             else if (Addr_in[1:0]==2'b11)
              begin wea_mem<=4'b1000; Data_write_to_dm<={4{Data_write[7:0]}};end         
    endcase    
    end
    else begin
    wea_mem<=4'b0000;
    case(dm_ctrl)
            `dm_word:
                Data_read<=Data_read_from_dm;
            `dm_halfword:
                if(Addr_in[1]==1'b0)
                 begin Data_read<={{16{Data_read_from_dm[15]}},Data_read_from_dm[15:0]}; end
                else if(Addr_in[1]==1'b1)
                 begin Data_read<={{16{Data_read_from_dm[31]}},Data_read_from_dm[31:16]}; end
            `dm_halfword_unsigned:
                if(Addr_in[1]==1'b0) 
                begin Data_read<={16'b0,Data_read_from_dm[15:0]}; end
                else if(Addr_in[1]==1'b1)
                 begin Data_read<={16'b0,Data_read_from_dm[31:16]}; end
            `dm_byte:
                if(Addr_in[1:0]==2'b00) 
                begin Data_read<={{24{Data_read_from_dm[7]}},Data_read_from_dm[7:0]}; end
                else if (Addr_in[1:0]==2'b01) 
                begin Data_read<={{24{Data_read_from_dm[15]}},Data_read_from_dm[15:8]}; end
                else if (Addr_in[1:0]==2'b10) 
                begin Data_read<={{24{Data_read_from_dm[23]}},Data_read_from_dm[23:16]}; end
                else if (Addr_in[1:0]==2'b11)
                 begin Data_read<={{24{Data_read_from_dm[31]}},Data_read_from_dm[31:24]}; end
            `dm_byte_unsigned:
                if(Addr_in[1:0]==2'b00) 
                begin Data_read<={24'b0,Data_read_from_dm[7:0]}; end
                else if (Addr_in[1:0]==2'b01) 
                begin Data_read<={24'b0,Data_read_from_dm[15:8]}; end
                else if (Addr_in[1:0]==2'b10)
                 begin Data_read<={24'b0,Data_read_from_dm[23:16]}; end
                else if (Addr_in[1:0]==2'b11) 
                begin Data_read<={24'b0,Data_read_from_dm[31:24]}; end
    endcase
    end
endmodule

