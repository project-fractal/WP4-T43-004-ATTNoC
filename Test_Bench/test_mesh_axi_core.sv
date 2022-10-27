`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2021 09:19:12 PM
// Design Name: 
// Module Name: test_mesh_axi_core
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
module test_mesh_axi_core;

parameter FLIT_DATA_WIDTH = 32;
parameter FLIT_TYPE_WIDTH = 2;
parameter FLIT_WIDTH = FLIT_DATA_WIDTH + FLIT_TYPE_WIDTH;
     
parameter integer C_S00_AXI_ID_WIDTH = 1;
parameter integer C_S00_AXI_DATA_WIDTH= 32;
parameter integer C_S00_AXI_ADDR_WIDTH= 32;
parameter integer C_S00_AXI_AWUSER_WIDTH = 1;
parameter integer C_S00_AXI_ARUSER_WIDTH = 1;
parameter integer C_S00_AXI_WUSER_WIDTH= 1;
parameter integer C_S00_AXI_RUSER_WIDTH= 1;
parameter integer C_S00_AXI_BUSER_WIDTH= 1;
reg sel1;
reg sel2;
reg sel3;
reg sel4;
reg INIT_AXI_TXN;
reg [7:0]PORT_ID_WR;
integer MSG_LENGTH_WR = 32;         
reg INIT_AXI_RXN;
reg [7:0]PORT_ID_RD;
integer MSG_LENGTH_RD = 32;
reg [31:0] INPUT_WDATA;
reg [31:0] INPUT_WADDR;  
reg [31:0]READ_ADDR;
reg tx_adaptiveRMI2;
reg rst_n;
reg clk,mt_clk;

//wire  s00_axi_aresetn;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid_0;
wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr_0;
wire [7 : 0] s00_axi_awlen_0;
wire [2 : 0] s00_axi_awsize_0;
wire [1 : 0] s00_axi_awburst_0;
wire  s00_axi_awlock_0;
wire [3 : 0] s00_axi_awcache_0;
wire [2 : 0] s00_axi_awprot_0;
wire [3 : 0] s00_axi_awqos_0;
wire [3 : 0] s00_axi_awregion_0;
wire [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser_0;
wire  s00_axi_awvalid_0;
wire  s00_axi_awready_0;
wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata_0;
wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb_0;
wire  s00_axi_wlast_0;
wire [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser_0;
wire  s00_axi_wvalid_0;
wire  s00_axi_wready_0;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid_0;
wire [1 : 0] s00_axi_bresp_0;
wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser_0;
wire  s00_axi_bvalid_0;
wire  s00_axi_bready_0;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid_0;
wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr_0;
wire [7 : 0] s00_axi_arlen_0;
wire [2 : 0] s00_axi_arsize_0;
wire [1 : 0] s00_axi_arburst_0;
wire  s00_axi_arlock_0;
wire [3 : 0] s00_axi_arcache_0;
wire [2 : 0] s00_axi_arprot_0;
wire [3 : 0] s00_axi_arqos_0;
wire [3 : 0] s00_axi_arregion_0;
wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser_0;
wire  s00_axi_arvalid_0;
wire  s00_axi_arready_0;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid_0;
wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata_0;
wire [1 : 0] s00_axi_rresp_0;
wire  s00_axi_rlast_0;
wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser_0;
wire  s00_axi_rvalid_0;
wire  s00_axi_rready_0;   
   
  
  
  
  
  
 
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid_1;
wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr_1;
wire [7 : 0] s00_axi_awlen_1;
wire [2 : 0] s00_axi_awsize_1;
wire [1 : 0] s00_axi_awburst_1;
wire  s00_axi_awlock_1;
wire [3 : 0] s00_axi_awcache_1;
wire [2 : 0] s00_axi_awprot_1;
wire [3 : 0] s00_axi_awqos_1;
wire [3 : 0] s00_axi_awregion_1;
wire [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser_1;
wire  s00_axi_awvalid_1;
wire  s00_axi_awready_1;
wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata_1;
wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb_1;
wire  s00_axi_wlast_1;
wire [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser_1;
wire  s00_axi_wvalid_1;
wire  s00_axi_wready_1;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid_1;
wire [1 : 0] s00_axi_bresp_1;
wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser_1;
wire  s00_axi_bvalid_1;
wire  s00_axi_bready_1;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid_1;
wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr_1;
wire [7 : 0] s00_axi_arlen_1;
wire [2 : 0] s00_axi_arsize_1;
wire [1 : 0] s00_axi_arburst_1;
wire  s00_axi_arlock_1;
wire [3 : 0] s00_axi_arcache_1;
wire [2 : 0] s00_axi_arprot_1;
wire [3 : 0] s00_axi_arqos_1;
wire [3 : 0] s00_axi_arregion_1;
wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser_1;
wire  s00_axi_arvalid_1;
wire  s00_axi_arready_1;
wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid_1;
wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata_1;
wire [1 : 0] s00_axi_rresp_1;
wire  s00_axi_rlast_1;
wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser_1;
wire  s00_axi_rvalid_1;
wire  s00_axi_rready_1;   
wire  [8:0]period_id_BD;
wire period_En_BD;
    
reg[63:0] GTB;

wire [31:0]source_datain_2;
wire trigger_2;
reg out_rd_en;

wire  portid_valid_3;
wire  [7:0] sink_portid_3;
wire  write_en_3;
wire  [31:0] sink_dataout_3;
wire  sink_terminate_3;
  
core #(.C_LAST_BURST_BIT(15),.C_PORT_STATUS_BIT(14))cdxm(              
                        .INIT_AXI_TXN         (INIT_AXI_TXN),
                        .PORT_ID_WR     (PORT_ID_WR),
                        .MSG_LENGTH_WR     (MSG_LENGTH_WR),
                        
                        .INIT_AXI_RXN        (INIT_AXI_RXN),
                        .PORT_ID_RD    (PORT_ID_RD),
                        .MSG_LENGTH_RD        (MSG_LENGTH_RD),
                        .INPUT_WDATA            (INPUT_WDATA),
                        .INPUT_WADDR            (INPUT_WADDR),
                        .READ_ADDR                 (READ_ADDR),
                      
                          // -- AXI M 
                        .M_AXI_ACLK     (clk),
                        .M_AXI_ARESETN     (rst_n),   
                        .M_AXI_AWID     (s00_axi_awid_0),    
                        .M_AXI_AWADDR (s00_axi_awaddr_0),  
                        .M_AXI_AWLEN     (s00_axi_awlen_0),   
                        .M_AXI_AWSIZE     (s00_axi_awsize_0),  
                        .M_AXI_AWBURST     (s00_axi_awburst_0), 
                        .M_AXI_AWLOCK (s00_axi_awlock_0),  
                        .M_AXI_AWCACHE     (s00_axi_awcache_0), 
                        .M_AXI_AWPROT (s00_axi_awprot_0),  
                        .M_AXI_AWQOS     (s00_axi_awqos_0),   
                        .M_AXI_AWUSER (s00_axi_awuser_0),    
                        .M_AXI_AWVALID     (s00_axi_awvalid_0),   
                        .M_AXI_AWREADY     (s00_axi_awready_0),   
                        .M_AXI_WDATA     (s00_axi_wdata_0),     
                        .M_AXI_WSTRB     (s00_axi_wstrb_0),     
                        .M_AXI_WLAST     (s00_axi_wlast_0),     
                        .M_AXI_WUSER     (s00_axi_wuser_0),     
                        .M_AXI_WVALID     (s00_axi_wvalid_0),    
                        .M_AXI_WREADY (s00_axi_wready_0),    
                        .M_AXI_BID          (s00_axi_bid_0 ),       
                        .M_AXI_BRESP     (s00_axi_bresp_0),     
                        .M_AXI_BUSER     (s00_axi_buser_0),     
                        .M_AXI_BVALID     (s00_axi_bvalid_0),    
                        .M_AXI_BREADY     (s00_axi_bready_0),
                        
                        .M_AXI_ARID         (s00_axi_arid_1),      
                        .M_AXI_ARADDR   (s00_axi_araddr_1),    
                        .M_AXI_ARLEN     (s00_axi_arlen_1),     
                        .M_AXI_ARSIZE     (s00_axi_arsize_1),    
                        .M_AXI_ARBURST     (s00_axi_arburst_1),   
                        .M_AXI_ARLOCK   (s00_axi_arlock_1),    
                        .M_AXI_ARCACHE     (s00_axi_arcache_1),   
                        .M_AXI_ARPROT       (s00_axi_arprot_1),    
                        .M_AXI_ARQOS         (s00_axi_arqos_1),     
                        .M_AXI_ARUSER        (s00_axi_aruser_1),    
                        .M_AXI_ARVALID        (s00_axi_arvalid_1),  
                        .M_AXI_ARREADY     (s00_axi_arready_1),  
                        .M_AXI_RID          (s00_axi_rid_1 ),      
                        .M_AXI_RDATA     (s00_axi_rdata_1),    
                        .M_AXI_RRESP     (s00_axi_rresp_1),    
                        .M_AXI_RLAST     (s00_axi_rlast_1),    
                        .M_AXI_RUSER     (s00_axi_ruser_1),    
                        .M_AXI_RVALID     (s00_axi_rvalid_1),   
                        .M_AXI_RREADY (s00_axi_rready_1)   
                                           
                        );                                          



		
	torus_mesh mm(
                   .rst_n (rst_n),
                   .tx_adaptiveRMI2 (tx_adaptiveRMI2),
                   .clk (clk),
                   .GTB(GTB),
                   .sel1 (sel1),
                   .sel2 (sel2),
                   .sel3 (sel3),
                   .sel4 (sel4),
                  
                  .s_axi_core_awid_2       (s00_axi_awid_0),              
                  .s_axi_core_awaddr_2          (s00_axi_awaddr_0),        
                  .s_axi_core_awlen_2     (s00_axi_awlen_0),        
                  .s_axi_core_awsize_2        (s00_axi_awsize_0),      
                  .s_axi_core_awburst_2         (s00_axi_awburst_0),      
                  .s_axi_core_awlock_2     (s00_axi_awlock_0),      
                  .s_axi_core_awcache_2         (s00_axi_awcache_0),        
                  .s_axi_core_awprot_2        (s00_axi_awprot_0),      
                  .s_axi_core_awqos_2   (s00_axi_awqos_0),        
                  .s_axi_core_awregion_2         (s00_axi_awregion_0),      
                  .s_axi_core_awuser_2   (s00_axi_awuser_0),      
                  .s_axi_core_awvalid_2          (s00_axi_awvalid_0),    
                  .s_axi_core_awready_2          (s00_axi_awready_0),      
                  .s_axi_core_wdata_2      (s00_axi_wdata_0),      
                  .s_axi_core_wstrb_2            (s00_axi_wstrb_0),      
                  .s_axi_core_wlast_2            (s00_axi_wlast_0),      
                  .s_axi_core_wuser_2          (s00_axi_wuser_0),      
                  .s_axi_core_wvalid_2           (s00_axi_wvalid_0),    
                  .s_axi_core_wready_2            (s00_axi_wready_0),      
                  .s_axi_core_bid_2    (s00_axi_bid_0 ),    
                  .s_axi_core_bresp_2               (s00_axi_bresp_0),      
                  .s_axi_core_buser_2        (s00_axi_buser_0),      
                  .s_axi_core_bvalid_2               (s00_axi_bvalid_0),    
                  .s_axi_core_bready_2             (s00_axi_bready_0),      
                  .s_axi_core_arid_2  (s00_axi_arid_0),    
                  .s_axi_core_araddr_2             (s00_axi_araddr_0),    
                  .s_axi_core_arlen_2      (s00_axi_arlen_0),    
                  .s_axi_core_arsize_2         (s00_axi_arsize_0),    
                  .s_axi_core_arburst_2             (s00_axi_arburst_0),    
                  .s_axi_core_arlock_2       (s00_axi_arlock_0),    
                  .s_axi_core_arcache_2           (s00_axi_arcache_0),      
                  .s_axi_core_arprot_2          (s00_axi_arprot_0),    
                  .s_axi_core_arqos_2        (s00_axi_arqos_0),      
                  .s_axi_core_arregion_2           (s00_axi_arregion_0),    
                  .s_axi_core_aruser_2 (s00_axi_aruser_0),    
                  .s_axi_core_arvalid_2              (s00_axi_arvalid_0),  
                  .s_axi_core_arready_2            (s00_axi_arready_0),    
                  .s_axi_core_rid_2 (s00_axi_rid_0 ),    
                  .s_axi_core_rdata_2                (s00_axi_rdata_0),    
                  .s_axi_core_rresp_2               (s00_axi_rresp_0),    
                  .s_axi_core_rlast_2                 (s00_axi_rlast_0),    
                  .s_axi_core_ruser_2          (s00_axi_ruser_0),    
                  .s_axi_core_rvalid_2                (s00_axi_rvalid_0),  
                  .s_axi_core_rready_2         (s00_axi_rready_0)      
                   
                   
                   
                   
                   
              );
		
		
		
		
		
		
		
		
		
		

Clock   Global(

    .clk(clk),          
    .reset_n(rst_n),      
    //macro tick input
    .mtclk(mt_clk),
    //-- state-set of the counter vector
    .SetTimeVal(0),   
    .NewTimeVal(0),   
    //-- reconfiguration instant to issue switch to new value
    .ReconfInst(0),   
    //-- the outgoing counter vector
	.TimeCnt(GTB)		
);






 
//reg flag_config=0;
initial
begin


clk=0;
rst_n=0;
INPUT_WDATA = 0;
INPUT_WADDR= 0 ;
READ_ADDR=0;
tx_adaptiveRMI2 =0;



#50
rst_n=1;
//tx_adaptiveRMI2 =1;
INIT_AXI_TXN=0;
//PORT_ID_WR =1;
MSG_LENGTH_WR=5;
INIT_AXI_RXN=0;
//PORT_ID_RD=1;
MSG_LENGTH_RD=5;
//status register Tx_busy on location 12


               #99;
         tx_adaptiveRMI2 =1;
         #10
         tx_adaptiveRMI2 =0;

               
          INIT_AXI_TXN=1; 
          PORT_ID_WR =2;
          INPUT_WDATA=0;
          
            #48
                     

             INIT_AXI_TXN=0; 
        for(integer j=0;j<16;j=j+1)//f
            begin 
            #8;
            INPUT_WDATA =j; 
  
            
            
            end  
            #500
         
          PORT_ID_WR =2;
          #8
            INIT_AXI_TXN=1; 
            
          INPUT_WDATA=0;
            #40
             tx_adaptiveRMI2 = 1;
             INIT_AXI_TXN=0; 
             #7
             tx_adaptiveRMI2=0; 

        for(integer j=0;j<16;j=j+1)//f
            begin 
            #8;
            INPUT_WDATA =j*2; 
  
            
            
            end  
               
      
          INIT_AXI_TXN=1; 
          PORT_ID_WR =2;
          INPUT_WDATA=0;
            #48
             INIT_AXI_TXN=0; 
        for(integer j=0;j<16;j=j+1)//f
            begin 
            #8;
            INPUT_WDATA =j; 
  
            
            
            end  
       
          
         #10
         tx_adaptiveRMI2 =0;
          INIT_AXI_TXN=1; 
          PORT_ID_WR =2;
          INPUT_WDATA=0;
            #48
           
             INIT_AXI_TXN=0; 
        for(integer j=0;j<16;j=j+1)//f
            begin 
            #8;
            INPUT_WDATA =j; 
  
            
            
            end  
            
             INIT_AXI_TXN=1; 
          PORT_ID_WR =2;
          INPUT_WDATA=0;
            #48
             INIT_AXI_TXN=0; 
        for(integer j=0;j<16;j=j+1)//f
            begin 
            #8;
            INPUT_WDATA =j; 
  
            
            
            end  
            #5

         
            PORT_ID_RD=8;	
            #8
            INIT_AXI_RXN=1;
             #40
             	INIT_AXI_RXN=0;
           			
end 
              // INIT_AXI_TXN=1;
  //         end   
  


always
begin
    clk = 1'b1;
    #4; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #4; // low for 20 * timescale = 20 ns
end

always
begin
    mt_clk = 1'b1;
     #14.90; // high for 20 * timescale = 20 ns
    // #40;
    mt_clk = 1'b0;
     #14.90; // low for 20 * timescale = 20 ns
   // #40;
end 


     
  
 
endmodule
