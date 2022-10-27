/* Copyright (c) 2015 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =================================================================================================================================================================================================================
 *
 * Author(s):
 *   Andreas Lankes <andreas.lankes@tum.de
 */
 
 
     
     `define NORTH 5'b00001
     `define EAST  5'b00010
     `define SOUTH 5'b00100
     `define WEST  5'b01000
     `define LOCAL 5'b10000
    
 
 module torus_mesh#(/*AUTOARG*/
   // parameter ph_prio_offset=0,
    parameter flit_type_width = 2,
    parameter flit_data_width = 32,
    parameter vchannels = 1,
 
    parameter xdim = 3,
    parameter ydim = 3,
     parameter ph_prio_offset=0,
    parameter ph_prio_width = 4,    //Defines the lenght of the priority field in the header flit if priority unicast routing is selected
    parameter payload_length = 6,   //Maximum packet lenght if recursive partitioning is selected
    parameter select_router = 0,
      
    parameter  nodes = xdim*ydim,
    parameter dest_width = $clog2(nodes),
 
    parameter flit_width = flit_data_width + flit_type_width,
    parameter msg_length=1024,
    parameter  contral_status_reg_memory_length=40,
    
    
      ////////////   AXI4_Full Slave Interface Signals  ///////////////////////////////////////////////////
       // Parameters of Axi Slave Bus Interface S00_AXI
 parameter integer C_S00_AXI_ID_WIDTH = 1,
 parameter integer C_S00_AXI_DATA_WIDTH = 32,
 parameter integer C_S00_AXI_ADDR_WIDTH = 32,
 parameter integer C_S00_AXI_AWUSER_WIDTH = 0,
 parameter integer C_S00_AXI_ARUSER_WIDTH = 0,
 parameter integer C_S00_AXI_WUSER_WIDTH = 0,
 parameter integer C_S00_AXI_RUSER_WIDTH = 0,
 parameter integer C_S00_AXI_BUSER_WIDTH = 0   
            
             )
    
    
    
    (
         input tx_adaptiveRMI2,
         input rst_n,
         input clk,
         input [63:0]GTB,
         input wire  sel1 ,
         input wire sel2,
         input wire sel3,
         input wire sel4,
//         input trigger_2,
//         input wire [(flit_data_width - 1):0] source_datain_2,
//         output out_rd_en_2,
         //d
         
//         output  portid_valid_3,
//         output  [7:0] sink_portid_3,
//         output  write_en_3,
//         output  [31:0] sink_dataout_3,
//         output  sink_terminate_3,
         
         output pIntToCore0,
         output pIntToCore1,
         output pIntToCore2,
         output pIntToCore3,
         //input wire  s00_axi_aclk,                                      
         //input wire  s00_axi_aresetn,           
         
         //AXI connection to NI_0     
//         input wire  s00_axi_aclk,
//		 input wire  s00_axi_aresetn,                             
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_awid_0        ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]s_axi_core_awaddr_0      ,
         input wire [7 : 0] s_axi_core_awlen_0                           ,
         input wire [2 : 0] s_axi_core_awsize_0                          ,
         input wire [1 : 0] s_axi_core_awburst_0                         ,
         input wire s_axi_core_awlock_0                                  ,
         input wire s_axi_core_awcache_0                                 ,
         input wire s_axi_core_awprot_0                                  ,
         input wire s_axi_core_awqos_0                                   ,
         input wire s_axi_core_awregion_0                                ,
         input wire s_axi_core_awuser_0                                  ,
         input wire s_axi_core_awvalid_0                                 ,
         output wire s_axi_core_awready_0                                ,
         input wire [C_S00_AXI_DATA_WIDTH-1 : 0]s_axi_core_wdata_0       ,
         input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s_axi_core_wstrb_0  ,     
         input wire  s_axi_core_wlast_0                                  ,
         input wire [C_S00_AXI_WUSER_WIDTH-1 : 0]s_axi_core_wuser_0      , 
         input wire  s_axi_core_wvalid_0                                 ,
         output wire  s_axi_core_wready_0                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_bid_0         ,
         output wire [1 : 0]s_axi_core_bresp_0                           ,
         output wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s_axi_core_buser_0    ,   
         output wire  s_axi_core_bvalid_0                                ,
         input wire  s_axi_core_bready_0                                 ,
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_arid_0         ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s_axi_core_araddr_0     , 
         input wire [7 : 0] s_axi_core_arlen_0                           ,
         input wire [2 : 0] s_axi_core_arsize_0                          ,
         input wire [1 : 0] s_axi_core_arburst_0                         ,
         input wire  s_axi_core_arlock_0                                 ,
         input wire [3 : 0] s_axi_core_arcache_0                         ,
         input wire [2 : 0] s_axi_core_arprot_0                          ,
         input wire [3 : 0] s_axi_core_arqos_0                           ,
         input wire [3 : 0] s_axi_core_arregion_0                        ,
         input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s_axi_core_aruser_0   ,   
         input wire  s_axi_core_arvalid_0                                ,
         output wire s_axi_core_arready_0                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_rid_0         ,
         output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s_axi_core_rdata_0     ,  
         output wire [1 : 0] s_axi_core_rresp_0                          ,
         output wire  s_axi_core_rlast_0                                 ,
         output wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s_axi_core_ruser_0    ,   
         output wire  s_axi_core_rvalid_0                                ,
         input wire  s_axi_core_rready_0,    
         
         
         
         
         //AXI connection to NI_1    
//         input wire  s01_axi_aclk,
//		 input wire  s01_axi_aresetn,                                         
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_awid_1        ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]s_axi_core_awaddr_1      ,
         input wire [7 : 0] s_axi_core_awlen_1                           ,
         input wire [2 : 0] s_axi_core_awsize_1                          ,
         input wire [1 : 0] s_axi_core_awburst_1                         ,
         input wire s_axi_core_awlock_1                                  ,
         input wire s_axi_core_awcache_1                                 ,
         input wire s_axi_core_awprot_1                                  ,
         input wire s_axi_core_awqos_1                                   ,
         input wire s_axi_core_awregion_1                                ,
         input wire s_axi_core_awuser_1                                  ,
         input wire s_axi_core_awvalid_1                                 ,
         output wire s_axi_core_awready_1                                ,
         input wire [C_S00_AXI_DATA_WIDTH-1 : 0]s_axi_core_wdata_1       ,
         input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s_axi_core_wstrb_1  ,     
         input wire  s_axi_core_wlast_1                                  ,
         input wire [C_S00_AXI_WUSER_WIDTH-1 : 0]s_axi_core_wuser_1      , 
         input wire  s_axi_core_wvalid_1                                 ,
         output wire  s_axi_core_wready_1                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_bid_1         ,
         output wire [1 : 0]s_axi_core_bresp_1                           ,
         output wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s_axi_core_buser_1    ,   
         output wire  s_axi_core_bvalid_1                                ,
         input wire  s_axi_core_bready_1                                 ,
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_arid_1         ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s_axi_core_araddr_1     , 
         input wire [7 : 0] s_axi_core_arlen_1                           ,
         input wire [2 : 0] s_axi_core_arsize_1                          ,
         input wire [1 : 0] s_axi_core_arburst_1                         ,
         input wire  s_axi_core_arlock_1                                 ,
         input wire [3 : 0] s_axi_core_arcache_1                         ,
         input wire [2 : 0] s_axi_core_arprot_1                          ,
         input wire [3 : 0] s_axi_core_arqos_1                           ,
         input wire [3 : 0] s_axi_core_arregion_1                        ,
         input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s_axi_core_aruser_1   ,   
         input wire  s_axi_core_arvalid_1                                ,
         output wire s_axi_core_arready_1                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_rid_1         ,
         output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s_axi_core_rdata_1     ,  
         output wire [1 : 0] s_axi_core_rresp_1                          ,
         output wire  s_axi_core_rlast_1                                 ,
         output wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s_axi_core_ruser_1    ,   
         output wire  s_axi_core_rvalid_1                                ,
         input wire  s_axi_core_rready_1,      
           
         //AXI connection to NI_2
//         input wire  s02_axi_aclk,
//		input wire  s02_axi_aresetn,
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_awid_2        ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]s_axi_core_awaddr_2     ,
         input wire [7 : 0] s_axi_core_awlen_2                           ,
         input wire [2 : 0] s_axi_core_awsize_2                          ,
         input wire [1 : 0] s_axi_core_awburst_2                         ,
         input wire s_axi_core_awlock_2                                  ,
         input wire s_axi_core_awcache_2                                 ,
         input wire s_axi_core_awprot_2                                  ,
         input wire s_axi_core_awqos_2                                   ,
         input wire s_axi_core_awregion_2                                ,
         input wire s_axi_core_awuser_2                                  ,
         input wire s_axi_core_awvalid_2                                 ,
         output wire s_axi_core_awready_2                                ,
         input wire [C_S00_AXI_DATA_WIDTH-1 : 0]s_axi_core_wdata_2       ,
         input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s_axi_core_wstrb_2  ,    
         input wire  s_axi_core_wlast_2                                  ,
         input wire [C_S00_AXI_WUSER_WIDTH-1 : 0]s_axi_core_wuser_2      ,
         input wire  s_axi_core_wvalid_2                                 ,
         output wire  s_axi_core_wready_2                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_bid_2         ,
         output wire [1 : 0]s_axi_core_bresp_2                           ,
         output wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s_axi_core_buser_2    ,  
         output wire  s_axi_core_bvalid_2                                ,
         input wire  s_axi_core_bready_2                                 ,
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_arid_2         ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s_axi_core_araddr_2     ,
         input wire [7 : 0] s_axi_core_arlen_2                           ,
         input wire [2 : 0] s_axi_core_arsize_2                          ,
         input wire [1 : 0] s_axi_core_arburst_2                         ,
         input wire  s_axi_core_arlock_2                                 ,
         input wire [3 : 0] s_axi_core_arcache_2                         ,
         input wire [2 : 0] s_axi_core_arprot_2                          ,
         input wire [3 : 0] s_axi_core_arqos_2                           ,
         input wire [3 : 0] s_axi_core_arregion_2                        ,
         input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s_axi_core_aruser_2   ,  
         input wire  s_axi_core_arvalid_2                                ,
         output wire s_axi_core_arready_2                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_rid_2         ,
         output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s_axi_core_rdata_2     ,  
         output wire [1 : 0] s_axi_core_rresp_2                          ,
         output wire  s_axi_core_rlast_2                                 ,
         output wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s_axi_core_ruser_2    ,  
         output wire  s_axi_core_rvalid_2                                ,
         input wire  s_axi_core_rready_2                                 ,      
         
         
         //AXI connection to NI_3    
//         input wire  s03_axi_aclk,
//		input wire  s03_axi_aresetn,
          input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_awid_3        ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]s_axi_core_awaddr_3      ,
         input wire [7 : 0] s_axi_core_awlen_3                           ,
         input wire [2 : 0] s_axi_core_awsize_3                          ,
         input wire [1 : 0] s_axi_core_awburst_3                         ,
         input wire s_axi_core_awlock_3                                  ,
         input wire s_axi_core_awcache_3                                 ,
         input wire s_axi_core_awprot_3                                  ,
         input wire s_axi_core_awqos_3                                   ,
         input wire s_axi_core_awregion_3                                ,
         input wire s_axi_core_awuser_3                                  ,
         input wire s_axi_core_awvalid_3                                 ,
         output wire s_axi_core_awready_3                                ,
         input wire [C_S00_AXI_DATA_WIDTH-1 : 0]s_axi_core_wdata_3       ,
         input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s_axi_core_wstrb_3  ,    
         input wire  s_axi_core_wlast_3                                  ,
         input wire [C_S00_AXI_WUSER_WIDTH-1 : 0]s_axi_core_wuser_3      ,
         input wire  s_axi_core_wvalid_3                                 ,
         output wire  s_axi_core_wready_3                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_bid_3         ,
         output wire [1 : 0]s_axi_core_bresp_3                           ,
         output wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s_axi_core_buser_3    ,  
         output wire  s_axi_core_bvalid_3                                ,
         input wire  s_axi_core_bready_3                                 ,
         input wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_arid_3         ,
         input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s_axi_core_araddr_3     ,
         input wire [7 : 0] s_axi_core_arlen_3                           ,
         input wire [2 : 0] s_axi_core_arsize_3                          ,
         input wire [1 : 0] s_axi_core_arburst_3                         ,
         input wire  s_axi_core_arlock_3                                 ,
         input wire [3 : 0] s_axi_core_arcache_3                         ,
         input wire [2 : 0] s_axi_core_arprot_3                          ,
         input wire [3 : 0] s_axi_core_arqos_3                           ,
         input wire [3 : 0] s_axi_core_arregion_3                        ,
         input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s_axi_core_aruser_3   ,  
         input wire  s_axi_core_arvalid_3                                ,
         output wire s_axi_core_arready_3                                ,
         output wire [C_S00_AXI_ID_WIDTH-1 : 0] s_axi_core_rid_3         ,
         output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s_axi_core_rdata_3     ,  
         output wire [1 : 0] s_axi_core_rresp_3                          ,
         output wire  s_axi_core_rlast_3                                 ,
         output wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s_axi_core_ruser_3    ,  
         output wire  s_axi_core_rvalid_3                                ,
         input wire  s_axi_core_rready_3                                  
         
         
         
         
         
         
         
         
         
     
    );
    
    
    wire [flit_width-1:0] local_in_flit[0:nodes-1]  ;
    wire [vchannels-1:0]  local_in_valid[0:nodes-1] ;
    wire [vchannels-1:0]  local_in_ready[0:nodes-1] ;
    wire [flit_width-1:0] local_out_flit[0:nodes-1] ;
    wire [vchannels-1:0]  local_out_valid[0:nodes-1];
    wire [vchannels-1:0]  local_out_ready[0:nodes-1];
                                                    
                                                    
    wire [flit_width-1:0] north_in_flit[0:nodes-1]  ;
    wire [vchannels-1:0]  north_in_valid[0:nodes-1] ;
    wire [vchannels-1:0]  north_in_ready[0:nodes-1] ;
    wire [flit_width-1:0] north_out_flit[0:nodes-1] ;
    wire [vchannels-1:0]  north_out_valid[0:nodes-1];
    wire [vchannels-1:0]  north_out_ready[0:nodes-1];
                                                    
    wire [flit_width-1:0] east_in_flit[0:nodes-1]   ;
    wire [vchannels-1:0]  east_in_valid[0:nodes-1]  ;
    wire [vchannels-1:0]  east_in_ready[0:nodes-1]  ;
    wire [flit_width-1:0] east_out_flit[0:nodes-1]  ;
    wire [vchannels-1:0]  east_out_valid[0:nodes-1] ;
    wire [vchannels-1:0]  east_out_ready[0:nodes-1] ;
                                                    
    wire [flit_width-1:0] south_in_flit[0:nodes-1]  ;
    wire [vchannels-1:0]  south_in_valid[0:nodes-1] ;
    wire [vchannels-1:0]  south_in_ready[0:nodes-1] ;
    wire [flit_width-1:0] south_out_flit[0:nodes-1] ;
    wire [vchannels-1:0]  south_out_valid[0:nodes-1];
    wire [vchannels-1:0]  south_out_ready[0:nodes-1];
                                                    
    wire [flit_width-1:0] west_in_flit[0:nodes-1]   ;
    wire [vchannels-1:0]  west_in_valid[0:nodes-1]  ;
    wire [vchannels-1:0]  west_in_ready[0:nodes-1]  ;
    wire [flit_width-1:0] west_out_flit[0:nodes-1]  ;
    wire [vchannels-1:0]  west_out_valid[0:nodes-1] ;
    wire [vchannels-1:0]  west_out_ready[0:nodes-1] ;
    wire reset_globle;
 
    reset rs( .clk(clk),
            .rst_n(rst_n),
           .reset_globle(reset_globle)
             );                              
 
   TT_NetworkInterface_nr #(.nodes(nodes),.my_id(0)) u_NI_0(  // Outputs     
              .clk      (clk),
              .sel (sel1),
              .reset_globle(reset_globle),
              //.source_id(0),
              .GTB(GTB),
              .pIntToCore (pIntToCore0),
              // connection to NOC
              // source 
              .flit_source                     (local_in_flit[7]),   // (local_in_flit[0]),  
              .valid_source                    (local_in_valid[7]),   //(local_in_valid[0]), 
              .ready_source                    (local_in_ready[7]),   //(local_in_ready[0]), 
              //sink                                                  //
              .ready_sink                      (local_out_ready[7]),  //(local_out_ready[0]),
              .flit_sink                       (local_out_flit[7]),   //(local_out_flit[0]), 
              .valid_sink                      (local_out_valid[7]),  //(local_out_valid[0]),
              // redundant source                                     //
              
             
              
              // core AXI connection 
//              .s00_axi_aclk(s00_axi_aclk),   
//              .s00_axi_aresetn(s00_axi_aresetn),
              .s_axi_core_awid        (s_axi_core_awid_0   ),        
              .s_axi_core_awaddr      (s_axi_core_awaddr_0  ), 
              .s_axi_core_awlen       (s_axi_core_awlen_0  ), 
              .s_axi_core_awsize      (s_axi_core_awsize_0  ), 
              .s_axi_core_awburst     (s_axi_core_awburst_0 ), 
              .s_axi_core_awlock      (s_axi_core_awlock_0  ), 
              .s_axi_core_awcache     (s_axi_core_awcache_0 ), 
              .s_axi_core_awprot      (s_axi_core_awprot_0  ), 
              .s_axi_core_awqos       (s_axi_core_awqos_0   ), 
              .s_axi_core_awregion    (s_axi_core_awregion_0), 
              .s_axi_core_awuser      (s_axi_core_awuser_0  ), 
              .s_axi_core_awvalid     (s_axi_core_awvalid_0 ), 
              .s_axi_core_awready     (s_axi_core_awready_0 ), 
              .s_axi_core_wdata       (s_axi_core_wdata_0   ), 
              .s_axi_core_wstrb       (s_axi_core_wstrb_0   ), 
              .s_axi_core_wlast       (s_axi_core_wlast_0   ), 
              .s_axi_core_wuser       (s_axi_core_wuser_0   ), 
              .s_axi_core_wvalid      (s_axi_core_wvalid_0  ), 
              .s_axi_core_wready      (s_axi_core_wready_0  ), 
              .s_axi_core_bid         (s_axi_core_bid_0     ), 
              .s_axi_core_bresp       (s_axi_core_bresp_0   ), 
              .s_axi_core_buser       (s_axi_core_buser_0   ), 
              .s_axi_core_bvalid      (s_axi_core_bvalid_0  ), 
              .s_axi_core_bready      (s_axi_core_bready_0  ), 
              .s_axi_core_arid        (s_axi_core_arid_0    ), 
              .s_axi_core_araddr      (s_axi_core_araddr_0  ), 
              .s_axi_core_arlen       (s_axi_core_arlen_0   ), 
              .s_axi_core_arsize      (s_axi_core_arsize_0  ), 
              .s_axi_core_arburst     (s_axi_core_arburst_0 ), 
              .s_axi_core_arlock      (s_axi_core_arlock_0  ), 
              .s_axi_core_arcache     (s_axi_core_arcache_0 ), 
              .s_axi_core_arprot      (s_axi_core_arprot_0  ), 
              .s_axi_core_arqos       (s_axi_core_arqos_0   ), 
              .s_axi_core_arregion    (s_axi_core_arregion_0), 
              .s_axi_core_aruser      (s_axi_core_aruser_0  ), 
              .s_axi_core_arvalid     (s_axi_core_arvalid_0 ), 
              .s_axi_core_arready     (s_axi_core_arready_0 ), 
              .s_axi_core_rid         (s_axi_core_rid_0     ), 
              .s_axi_core_rdata       (s_axi_core_rdata_0   ), 
              .s_axi_core_rresp       (s_axi_core_rresp_0   ), 
              .s_axi_core_rlast       (s_axi_core_rlast_0   ), 
              .s_axi_core_ruser       (s_axi_core_ruser_0   ), 
              .s_axi_core_rvalid      (s_axi_core_rvalid_0  ), 
              .s_axi_core_rready      (s_axi_core_rready_0  )  
            );
      
     
      
   TT_NetworkInterface_nr #(.nodes(nodes),.my_id(1)) u_NI_1(  // Outputs     
              .clk      (clk),
              .sel (sel2),
              .GTB(GTB),
              .reset_globle(reset_globle),
              //.source_id(1),
              
              .pIntToCore (pIntToCore1),
              // connection to NOC
              //source 
              .flit_source                     (local_in_flit[1]),
              .valid_source                    (local_in_valid[1]),
              .ready_source                    (local_in_ready[1]),
              //sink
              
              .ready_sink                      (local_out_ready[1]),
              .flit_sink                       (local_out_flit[1]),
              .valid_sink                      (local_out_valid[1]),
              
              // core AXI connection 
//                .s00_axi_aclk(s01_axi_aclk),   
//              .s00_axi_aresetn(s01_axi_aresetn),
              .s_axi_core_awid        (s_axi_core_awid_1   ),        
              .s_axi_core_awaddr      (s_axi_core_awaddr_1  ), 
              .s_axi_core_awlen       (s_axi_core_awlen_1  ), 
              .s_axi_core_awsize      (s_axi_core_awsize_1  ), 
              .s_axi_core_awburst     (s_axi_core_awburst_1 ), 
              .s_axi_core_awlock      (s_axi_core_awlock_1  ), 
              .s_axi_core_awcache     (s_axi_core_awcache_1 ), 
              .s_axi_core_awprot      (s_axi_core_awprot_1  ), 
              .s_axi_core_awqos       (s_axi_core_awqos_1   ), 
              .s_axi_core_awregion    (s_axi_core_awregion_1), 
              .s_axi_core_awuser      (s_axi_core_awuser_1  ), 
              .s_axi_core_awvalid     (s_axi_core_awvalid_1 ), 
              .s_axi_core_awready     (s_axi_core_awready_1 ), 
              .s_axi_core_wdata       (s_axi_core_wdata_1   ), 
              .s_axi_core_wstrb       (s_axi_core_wstrb_1   ), 
              .s_axi_core_wlast       (s_axi_core_wlast_1   ), 
              .s_axi_core_wuser       (s_axi_core_wuser_1   ), 
              .s_axi_core_wvalid      (s_axi_core_wvalid_1  ), 
              .s_axi_core_wready      (s_axi_core_wready_1  ), 
              .s_axi_core_bid         (s_axi_core_bid_1     ), 
              .s_axi_core_bresp       (s_axi_core_bresp_1   ), 
              .s_axi_core_buser       (s_axi_core_buser_1   ), 
              .s_axi_core_bvalid      (s_axi_core_bvalid_1  ), 
              .s_axi_core_bready      (s_axi_core_bready_1  ), 
              .s_axi_core_arid        (s_axi_core_arid_1    ), 
              .s_axi_core_araddr      (s_axi_core_araddr_1  ), 
              .s_axi_core_arlen       (s_axi_core_arlen_1   ), 
              .s_axi_core_arsize      (s_axi_core_arsize_1  ), 
              .s_axi_core_arburst     (s_axi_core_arburst_1 ), 
              .s_axi_core_arlock      (s_axi_core_arlock_1  ), 
              .s_axi_core_arcache     (s_axi_core_arcache_1 ), 
              .s_axi_core_arprot      (s_axi_core_arprot_1  ), 
              .s_axi_core_arqos       (s_axi_core_arqos_1   ), 
              .s_axi_core_arregion    (s_axi_core_arregion_1), 
              .s_axi_core_aruser      (s_axi_core_aruser_1  ), 
              .s_axi_core_arvalid     (s_axi_core_arvalid_1 ), 
              .s_axi_core_arready     (s_axi_core_arready_1 ), 
              .s_axi_core_rid         (s_axi_core_rid_1     ), 
              .s_axi_core_rdata       (s_axi_core_rdata_1   ), 
              .s_axi_core_rresp       (s_axi_core_rresp_1   ), 
              .s_axi_core_rlast       (s_axi_core_rlast_1   ), 
              .s_axi_core_ruser       (s_axi_core_ruser_1   ), 
              .s_axi_core_rvalid      (s_axi_core_rvalid_1  ), 
              .s_axi_core_rready      (s_axi_core_rready_1  )  
            );
            
 TT_NetworkInterface#(.nodes(nodes),.my_id(2)) u_NI_2(  // Outputs    
              .clk      (clk),
              .sel (sel3),
              .reset_globle(reset_globle),
              .GTB(GTB),
              //.source_id(2),
             .pIntToCore (pIntToCore2),
              // connection to NOC
              .flit_source                     (local_in_flit[6]),
              .valid_source                    (local_in_valid[6]),
              .ready_source                    (local_in_ready[6]),
              
              .ready_sink                      (local_out_ready[6]),
              .flit_sink                       (local_out_flit[6]),
              .valid_sink                      (local_out_valid[6]),
             // redundant source 
              .flit_source_r                   (local_in_flit[0]),
              .valid_source_r                  (local_in_valid[0]),
              .ready_source_r                  (local_in_ready[0]),
              // redundant sink
              .flit_sink_r                      (local_out_flit[0]),
              .valid_sink_r                     (local_out_valid[0]),
              .ready_sink_r                     (local_out_ready[0]),
              .tx_adaptiveRMI (tx_adaptiveRMI2),
              

              

              // core AXI connection
//               .s00_axi_aclk(s02_axi_aclk),   
//             .s00_axi_aresetn(s02_axi_aresetn),
              .s_axi_core_awid        (s_axi_core_awid_2   ),        
              .s_axi_core_awaddr      (s_axi_core_awaddr_2  ),
              .s_axi_core_awlen       (s_axi_core_awlen_2  ),
              .s_axi_core_awsize      (s_axi_core_awsize_2  ),
              .s_axi_core_awburst     (s_axi_core_awburst_2 ),
              .s_axi_core_awlock      (s_axi_core_awlock_2  ),
              .s_axi_core_awcache     (s_axi_core_awcache_2 ),
              .s_axi_core_awprot      (s_axi_core_awprot_2  ),
              .s_axi_core_awqos       (s_axi_core_awqos_2   ),
              .s_axi_core_awregion    (s_axi_core_awregion_2),
              .s_axi_core_awuser      (s_axi_core_awuser_2  ),
              .s_axi_core_awvalid     (s_axi_core_awvalid_2 ),
              .s_axi_core_awready     (s_axi_core_awready_2 ),
              .s_axi_core_wdata       (s_axi_core_wdata_2   ),
              .s_axi_core_wstrb       (s_axi_core_wstrb_2   ),
              .s_axi_core_wlast       (s_axi_core_wlast_2   ),
              .s_axi_core_wuser       (s_axi_core_wuser_2   ),
              .s_axi_core_wvalid      (s_axi_core_wvalid_2  ),
              .s_axi_core_wready      (s_axi_core_wready_2  ),
              .s_axi_core_bid         (s_axi_core_bid_2     ),
              .s_axi_core_bresp       (s_axi_core_bresp_2   ),
              .s_axi_core_buser       (s_axi_core_buser_2   ),
              .s_axi_core_bvalid      (s_axi_core_bvalid_2  ),
              .s_axi_core_bready      (s_axi_core_bready_2  ),
              .s_axi_core_arid        (s_axi_core_arid_2    ),
              .s_axi_core_araddr      (s_axi_core_araddr_2  ),
              .s_axi_core_arlen       (s_axi_core_arlen_2   ),
              .s_axi_core_arsize      (s_axi_core_arsize_2  ),
              .s_axi_core_arburst     (s_axi_core_arburst_2 ),
              .s_axi_core_arlock      (s_axi_core_arlock_2  ),
              .s_axi_core_arcache     (s_axi_core_arcache_2 ),
              .s_axi_core_arprot      (s_axi_core_arprot_2  ),
              .s_axi_core_arqos       (s_axi_core_arqos_2   ),
              .s_axi_core_arregion    (s_axi_core_arregion_2),
              .s_axi_core_aruser      (s_axi_core_aruser_2  ),
              .s_axi_core_arvalid     (s_axi_core_arvalid_2 ),
              .s_axi_core_arready     (s_axi_core_arready_2 ),
              .s_axi_core_rid         (s_axi_core_rid_2     ),
              .s_axi_core_rdata       (s_axi_core_rdata_2   ),
              .s_axi_core_rresp       (s_axi_core_rresp_2   ),
              .s_axi_core_rlast       (s_axi_core_rlast_2   ),
              .s_axi_core_ruser       (s_axi_core_ruser_2   ),
              .s_axi_core_rvalid      (s_axi_core_rvalid_2  ),
              .s_axi_core_rready      (s_axi_core_rready_2  )  
            );


 TT_NetworkInterface #(.nodes(nodes),.my_id(3)) u_NI_3(  // Outputs    
              .clk      (clk),
              .sel      (sel4),
              .reset_globle(reset_globle),
              .GTB(GTB),
              //.source_id(3),
             .pIntToCore (pIntToCore3),
              // connection to NOC
              //source
              .flit_source                     (local_in_flit[8]),
              .valid_source                    (local_in_valid[8]),
              .ready_source                    (local_in_ready[8]),
              //sink
              .ready_sink                      (local_out_ready[8]),
              .flit_sink                       (local_out_flit[8]),
              .valid_sink                      (local_out_valid[8]),
              
                   // redundant source 
              .flit_source_r                   (local_in_flit[2]),
              .valid_source_r                  (local_in_valid[2]),
              .ready_source_r                  (local_in_ready[2]),
              // redundant sink
              .flit_sink_r                      (local_out_flit[2]),
              .valid_sink_r                     (local_out_valid[2]),
              .ready_sink_r                     (local_out_ready[2]),
             
              // core AXI connection
//              .s00_axi_aclk(s03_axi_aclk),   
//              .s00_axi_aresetn(s03_axi_aresetn),
              .s_axi_core_awid        (s_axi_core_awid_3   ),        
              .s_axi_core_awaddr      (s_axi_core_awaddr_3  ),
              .s_axi_core_awlen       (s_axi_core_awlen_3  ),
              .s_axi_core_awsize      (s_axi_core_awsize_3  ),
              .s_axi_core_awburst     (s_axi_core_awburst_3 ),
              .s_axi_core_awlock      (s_axi_core_awlock_3  ),
              .s_axi_core_awcache     (s_axi_core_awcache_3 ),
              .s_axi_core_awprot      (s_axi_core_awprot_3  ),
              .s_axi_core_awqos       (s_axi_core_awqos_3   ),
              .s_axi_core_awregion    (s_axi_core_awregion_3),
              .s_axi_core_awuser      (s_axi_core_awuser_3  ),
              .s_axi_core_awvalid     (s_axi_core_awvalid_3 ),
              .s_axi_core_awready     (s_axi_core_awready_3 ),
              .s_axi_core_wdata       (s_axi_core_wdata_3   ),
              .s_axi_core_wstrb       (s_axi_core_wstrb_3   ),
              .s_axi_core_wlast       (s_axi_core_wlast_3   ),
              .s_axi_core_wuser       (s_axi_core_wuser_3   ),
              .s_axi_core_wvalid      (s_axi_core_wvalid_3  ),
              .s_axi_core_wready      (s_axi_core_wready_3  ),
              .s_axi_core_bid         (s_axi_core_bid_3     ),
              .s_axi_core_bresp       (s_axi_core_bresp_3   ),
              .s_axi_core_buser       (s_axi_core_buser_3   ),
              .s_axi_core_bvalid      (s_axi_core_bvalid_3  ),
              .s_axi_core_bready      (s_axi_core_bready_3  ),
              .s_axi_core_arid        (s_axi_core_arid_3    ),
              .s_axi_core_araddr      (s_axi_core_araddr_3  ),
              .s_axi_core_arlen       (s_axi_core_arlen_3   ),
              .s_axi_core_arsize      (s_axi_core_arsize_3  ),
              .s_axi_core_arburst     (s_axi_core_arburst_3 ),
              .s_axi_core_arlock      (s_axi_core_arlock_3  ),
              .s_axi_core_arcache     (s_axi_core_arcache_3 ),
              .s_axi_core_arprot      (s_axi_core_arprot_3  ),
              .s_axi_core_arqos       (s_axi_core_arqos_3   ),
              .s_axi_core_arregion    (s_axi_core_arregion_3),
              .s_axi_core_aruser      (s_axi_core_aruser_3  ),
              .s_axi_core_arvalid     (s_axi_core_arvalid_3 ),
              .s_axi_core_arready     (s_axi_core_arready_3 ),
              .s_axi_core_rid         (s_axi_core_rid_3     ),
              .s_axi_core_rdata       (s_axi_core_rdata_3   ),
              .s_axi_core_rresp       (s_axi_core_rresp_3   ),
              .s_axi_core_rlast       (s_axi_core_rlast_3   ),
              .s_axi_core_ruser       (s_axi_core_ruser_3   ),
              .s_axi_core_rvalid      (s_axi_core_rvalid_3  ),
              .s_axi_core_rready      (s_axi_core_rready_3  )  
            );

            
            
            
            
            
       
       
      
   genvar x;
   genvar y;

   generate
      for (y=0;y<ydim;y=y+1) begin
         for (x=0;x<xdim;x=x+1) begin
              lisnoc_router_2dgrid #(.vchannels(vchannels),.num_dests(nodes),.lookup(genlookup(x,y)),
                 .flit_data_width(flit_data_width),.flit_type_width(flit_type_width),
                 .ph_prio_width(ph_prio_width),.ph_prio_offset(ph_prio_offset))
                  u_router(
                           .clk (clk),
                           .rst (reset_globle),
                           .local_in_valid_i  (local_in_valid[nodenum(x,y)]),
                           .local_in_flit_i   (local_in_flit[nodenum(x,y)]),
                           .local_in_ready_o  (local_in_ready[nodenum(x,y)]),
                           .local_out_valid_o (local_out_valid[nodenum(x,y)]),
                           .local_out_flit_o  (local_out_flit[nodenum(x,y)]),
                           .local_out_ready_i (local_out_ready[nodenum(x,y)]),
                           .north_in_valid_i  (north_in_valid[nodenum(x,y)]),
                           .north_in_flit_i   (north_in_flit[nodenum(x,y)]),
                           .north_in_ready_o  (north_in_ready[nodenum(x,y)]),
                           .north_out_valid_o (north_out_valid[nodenum(x,y)]),
                           .north_out_flit_o  (north_out_flit[nodenum(x,y)]),
                           .north_out_ready_i (north_out_ready[nodenum(x,y)]),
                           .east_in_valid_i   (east_in_valid[nodenum(x,y)]),
                           .east_in_flit_i    (east_in_flit[nodenum(x,y)]),
                           .east_in_ready_o   (east_in_ready[nodenum(x,y)]),
                           .east_out_valid_o  (east_out_valid[nodenum(x,y)]),
                           .east_out_flit_o   (east_out_flit[nodenum(x,y)]),
                           .east_out_ready_i  (east_out_ready[nodenum(x,y)]),
                           .south_in_valid_i  (south_in_valid[nodenum(x,y)]),
                           .south_in_flit_i   (south_in_flit[nodenum(x,y)]),
                           .south_in_ready_o  (south_in_ready[nodenum(x,y)]),
                           .south_out_valid_o (south_out_valid[nodenum(x,y)]),
                           .south_out_flit_o  (south_out_flit[nodenum(x,y)]),
                           .south_out_ready_i (south_out_ready[nodenum(x,y)]),
                           .west_in_valid_i   (west_in_valid[nodenum(x,y)]),
                           .west_in_flit_i    (west_in_flit[nodenum(x,y)]),
                           .west_in_ready_o   (west_in_ready[nodenum(x,y)]),
                           .west_out_valid_o  (west_out_valid[nodenum(x,y)]),
                           .west_out_flit_o   (west_out_flit[nodenum(x,y)]),
                           .west_out_ready_i  (west_out_ready[nodenum(x,y)])
                           );

            // Generate connection in north-south direction
            if (y>0 && y<ydim-1) begin
               // North port connection
               assign north_in_valid[nodenum(x,y)]  = south_out_valid[northof(x,y)];
               assign north_in_flit[nodenum(x,y)]   = south_out_flit[northof(x,y)];
               assign north_out_ready[nodenum(x,y)] = south_in_ready[northof(x,y)];
               assign south_in_valid[northof(x,y)]  = north_out_valid[nodenum(x,y)];
               assign south_in_flit[northof(x,y)]   = north_out_flit[nodenum(x,y)];
               assign south_out_ready[northof(x,y)] = north_in_ready[nodenum(x,y)];

               // South port connection
               assign south_in_valid[nodenum(x,y)]  = north_out_valid[southof(x,y)];
               assign south_in_flit[nodenum(x,y)]   = north_out_flit[southof(x,y)];
               assign south_out_ready[nodenum(x,y)] = north_in_ready[southof(x,y)];
               assign north_out_ready[southof(x,y)] = south_in_ready[nodenum(x,y)];
               assign north_in_valid[southof(x,y)]  = south_out_valid[nodenum(x,y)];
               assign north_in_flit[southof(x,y)]   = south_out_flit[nodenum(x,y)];
            end

            if (y==0) begin
               // North port connection
               assign north_in_valid[nodenum(x,y)]  = south_out_valid[northof(x,y)];
               assign north_in_flit[nodenum(x,y)]   = south_out_flit[northof(x,y)];
               assign north_out_ready[nodenum(x,y)] = south_in_ready[northof(x,y)];
               assign south_in_valid[northof(x,y)]  = north_out_valid[nodenum(x,y)];
               assign south_in_flit[northof(x,y)]   = north_out_flit[nodenum(x,y)];
               assign south_out_ready[northof(x,y)] = north_in_ready[nodenum(x,y)];

               // South border of the mesh
               assign south_in_valid[nodenum(x,y)]  = {vchannels{1'b0}};
               assign south_out_ready[nodenum(x,y)] = {vchannels{1'b0}};
            end

            if (y==ydim-1) begin
               // South port connection
               assign south_in_valid[nodenum(x,y)]  = north_out_valid[southof(x,y)];
               assign south_in_flit[nodenum(x,y)]   = north_out_flit[southof(x,y)];
               assign south_out_ready[nodenum(x,y)] = north_in_ready[southof(x,y)];
               assign north_out_ready[southof(x,y)] = south_in_ready[nodenum(x,y)];
               assign north_in_valid[southof(x,y)]  = south_out_valid[nodenum(x,y)];
               assign north_in_flit[southof(x,y)]   = south_out_flit[nodenum(x,y)];

               // North border of the mesh
               assign north_in_valid[nodenum(x,y)]  = {vchannels{1'b0}};
               assign north_out_ready[nodenum(x,y)] = {vchannels{1'b0}};
            end

            // Generate connection in east-west direction
            if (x>0 && x<xdim-1) begin
               // West port connection
               assign west_in_valid[nodenum(x,y)]  = east_out_valid[westof(x,y)];
               assign west_in_flit[nodenum(x,y)]   = east_out_flit[westof(x,y)];
               assign west_out_ready[nodenum(x,y)] = east_in_ready[westof(x,y)];
               assign east_out_ready[westof(x,y)]  = west_in_ready[nodenum(x,y)];
               assign east_in_valid[westof(x,y)]   = west_out_valid[nodenum(x,y)];
               assign east_in_flit[westof(x,y)]    = west_out_flit[nodenum(x,y)];

               // East port connection
               assign east_in_valid[nodenum(x,y)]  = west_out_valid[eastof(x,y)];
               assign east_in_flit[nodenum(x,y)]   = west_out_flit[eastof(x,y)];
               assign west_out_ready[eastof(x,y)]  = east_in_ready[nodenum(x,y)];
               assign west_in_valid[eastof(x,y)]   = east_out_valid[nodenum(x,y)];
               assign west_in_flit[eastof(x,y)]    = east_out_flit[nodenum(x,y)];
               assign east_out_ready[nodenum(x,y)] = west_in_ready[eastof(x,y)];
            end

            if (x==0) begin
              // East port connection
              assign east_in_valid[nodenum(x,y)]  = west_out_valid[eastof(x,y)];
              assign east_in_flit[nodenum(x,y)]   = west_out_flit[eastof(x,y)];
              assign west_out_ready[eastof(x,y)]  = east_in_ready[nodenum(x,y)];
              assign west_in_valid[eastof(x,y)]   = east_out_valid[nodenum(x,y)];
              assign west_in_flit[eastof(x,y)]    = east_out_flit[nodenum(x,y)];
              assign east_out_ready[nodenum(x,y)] = west_in_ready[eastof(x,y)];

              // West border of the mesh
              assign west_in_valid[nodenum(x,y)]  = {vchannels{1'b0}};
              assign west_out_ready[nodenum(x,y)] = {vchannels{1'b0}};
            end

            if (x==xdim-1) begin
              // West port connection
              assign west_in_valid[nodenum(x,y)]  = east_out_valid[westof(x,y)];
              assign west_in_flit[nodenum(x,y)]   = east_out_flit[westof(x,y)];
              assign west_out_ready[nodenum(x,y)] = east_in_ready[westof(x,y)];
              assign east_out_ready[westof(x,y)]  = west_in_ready[nodenum(x,y)];
              assign east_in_valid[westof(x,y)]   = west_out_valid[nodenum(x,y)];
              assign east_in_flit[westof(x,y)]    = west_out_flit[nodenum(x,y)];

              // East border of the mesh
              assign east_in_valid[nodenum(x,y)]  = {vchannels{1'b0}};
              assign east_out_ready[nodenum(x,y)] = {vchannels{1'b0}};
            end
         end
      end

   endgenerate

   function integer nodenum(input integer x,input integer y);
      nodenum = x+y*xdim;
   endfunction // nodenum

   function integer northof(input integer x,input integer y);
      northof = x+(y+1)*xdim;
   endfunction // northof
   function integer eastof(input integer x,input integer y);
      eastof  = (x+1)+y*xdim;
   endfunction // eastof
   function integer southof(input integer x,input integer y);
      southof = x+(y-1)*xdim;
   endfunction // southof
   function integer westof(input integer x,input integer y);
      westof = (x-1)+y*xdim;
   endfunction // westof

   // This generates the lookup table for each single node
   function [nodes*5-1:0] genlookup(input integer x,input integer y);
      integer yd,xd;
      integer nd;
      reg [4:0] d;

      genlookup = {nodes{5'b00000}};

      for (yd=0;yd<xdim;yd=yd+1) begin
         for (xd=0;xd<xdim;xd=xd+1) begin : inner_loop


            nd = nodenum(xd,yd);
            d = 5'b00000;
            if ((xd==x) && (yd==y)) begin
               d = `LOCAL;
            end else if (xd==x) begin
               if (yd<y) begin
                  d = `SOUTH;
               end else begin
                  d = `NORTH;
               end
            end else begin
               if (xd<x) begin
                  d = `WEST;
               end else begin
                  d = `EAST;
               end
            end // else: !if(xd==x)
            genlookup = genlookup | (d<<((nodes-nd-1)*5));
         end
      end
   endfunction

endmodule // mesh
