`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/21 14:56:49
// Design Name: 
// Module Name: TOP_SCPU
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


module TOP(
input [4:0]  btn_i,
input [15:0] sw_i,
input clk,
input rstn,
output [7:0] disp_an_o,
output [7:0]disp_seg_o,
output [15:0]led_o 
    );
wire [4:0] BTN_out;
wire [15:0] SW_out;
wire Clk_CPU;
wire [31:0]clkdiv;
wire IO_clk_i;
wire [15:0] LED_out;
wire [1:0] counter_set;
wire [15:0]led;
wire counter0_OUT, counter1_OUT, counter2_OUT;
wire [31:0] counter_out;
wire [31:0] spo;
wire [31:0]Data_write_to_dm;
wire [31:0]Data_read;
wire [3:0]wea_mem;
wire clka0_i;
wire [31:0] douta;
wire MIO0;
wire [31:0] Data_out,PC_out,Addr_out;
wire [2:0]dm_ctrl;
wire mem_w;
wire [31:0]Cpu_data4bus,ram_data_in,Peripheral_in;
wire [9:0]ram_addr;
wire [7:0]point_out,LE_out;
wire [31:0]Disp_num;
wire data_ram_we,GPIOf0000000_we,GPIOe0000000_we,counter_we;
wire [7:0]seg_an,seg_sout;
wire rst_i;
assign rst_i=~rstn;
assign IO_clk_i =~clk;
assign clka0_i=~clk;
Enter U10_Enter(.BTN(btn_i), .SW(sw_i), .clk(clk), .BTN_out(BTN_out), .SW_out(SW_out));

clk_div U8_clk_div(.SW2(SW_out[2]),.clk(clk),.rst(rst_i), .Clk_CPU(Clk_CPU),.clkdiv(clkdiv));

SPIO U7_SPIO(.EN(GPIOf0000000_we),.P_Data(Peripheral_in),.clk(IO_clk_i),.rst(rst_i),.LED_out(LED_out), .counter_set(counter_set), .led(led));

Counter_x U9_Counter_x(.clk(IO_clk_i),.clk0(clkdiv[6]),.clk1(clkdiv[9]),.clk2(clkdiv[11]),.counter_ch(counter_set),.counter_val(Peripheral_in), .counter_we(counter_we), .rst(rst_i),
                         .counter0_OUT(counter0_OUT),.counter1_OUT(counter1_OUT),.counter2_OUT(counter2_OUT), .counter_out(counter_out));

ROM_D U2_ROMD(.a(PC_out[11:2]),.spo(spo));

dm_controller U3_dm_controller(.Addr_in(Addr_out),.Data_read_from_dm(Cpu_data4bus),.Data_write(ram_data_in),.dm_ctrl(dm_ctrl),.mem_w(mem_w),.Data_read(Data_read),.Data_write_to_dm(Data_write_to_dm),.wea_mem(wea_mem));

RAM_B U4_RAM_B(.addra(ram_addr),.clka(clka0_i),.dina(Data_write_to_dm),.wea(wea_mem),.douta(douta));

SCPU U1_SCPU (.Data_in(Data_read),.INT(counter0_OUT),.MIO_ready(MIO0),.clk(Clk_CPU),.inst_in(spo),.reset(rst_i),
               .Addr_out(Addr_out),.CPU_MIO(MIO0),.Data_out(Data_out),.PC_out(PC_out),.DMType(dm_ctrl),.mem_w(mem_w));

MIO_BUS U4_MIO_BUS(.BTN(BTN_out),.Cpu_data2bus(Data_out),.SW(SW_out),.addr_bus(Addr_out),.clk(Clk_CPU),.counter_out(counter_out),.counter0_out(counter0_OUT),.counter1_out(counter1_OUT),
                   .counter2_out(counter2_OUT),.led_out(LED_out),.mem_w(mem_w),.ram_data_out(douta),
                   .rst(rst_i),.Cpu_data4bus(Cpu_data4bus), .ram_data_in(ram_data_in),.ram_addr(ram_addr),.data_ram_we(data_ram_we),.GPIOf0000000_we(GPIOf0000000_we),
                   .GPIOe0000000_we(GPIOe0000000_we),.counter_we(counter_we),.Peripheral_in(Peripheral_in));


Multi_8CH32 U5_Multi_8CH32(.EN(GPIOe0000000_we),.LES(~(64'b0)),.Switch(SW_out[7:5]),.clk(IO_clk_i),.data0(Peripheral_in),.data1({2'b00,PC_out[29:0]}),.data2(spo),.data3(counter_out),.data4(Addr_out),.data5(Data_out),.data6(Cpu_data4bus),.data7(PC_out),
                            .rst(rst_i),.point_in({clkdiv,clkdiv}),.Disp_num(Disp_num),.point_out(point_out),.LE_out(LE_out));

SSeg7 U6_SSeg7(.Hexs(Disp_num),.point(point_out),.LES(LE_out),.SW0(SW_out[0]),.flash(clkdiv[10]),.clk(clk),.rst(rst_i),.seg_an(seg_an),.seg_sout(seg_sout));
assign led_o=led;
assign disp_an_o=seg_an;
assign disp_seg_o=seg_sout;
endmodule
