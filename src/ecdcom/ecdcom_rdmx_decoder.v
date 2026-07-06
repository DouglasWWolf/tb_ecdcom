
//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 21-Mar-25  DWW     1  Initial creation
//====================================================================================

/*
    This decodes an RDMX header into its constituent fields.  It outputs:
    
    (1) The PCI address where the packet payload should be written
    (2) The payload length in bytes
    (3) The payload length in 64-byte data-cycles
*/

module ecdcom_rdmx_decoder
(
    // Little endian version of the RDMX header
    input[511:0] le_rdmx_header,
    
    // Is this an RDMX packet?
    output       is_rdmx,

    // PCI address where payload should be written
    output[63:0] rdmx_address,

    // The "flags" field from the RDMX header
    output[7:0]  rdmx_flags,

    // The "user-defined" field from the RDMX header
    output[31:0] rdmx_user_field,

    // The length of the payload in bytes
    output[15:0] payload_bytes,

    // The length of the payload, in 64-byte cycles
    output[7:0]  payload_cycles

);

genvar i;

// The "udp_length" field includes 8 bytes for the UDP header
localparam UDP_HDR_LEN  = 8;

// 22 bytes of the UDP packet data in an RDMX packet are RDMX header bytes
localparam RDMX_HDR_LEN = 22;


// These are the fields that comprise an RDMX packet header
wire[ 6 *8-1:0] eth_dst_mac, eth_src_mac;
wire[ 2 *8-1:0] eth_frame_type;
wire[ 2 *8-1:0] ip4_ver_dsf, ip4_length, ip4_id, ip4_flags, ip4_ttl_prot, ip4_checksum;
wire[ 2 *8-1:0] ip4_srcip_h, ip4_srcip_l, ip4_dstip_h, ip4_dstip_l;
wire[ 2 *8-1:0] udp_src_port, udp_dst_port, udp_length, udp_checksum;
wire[ 2 *8-1:0] rdmx_magic;
wire[ 8 *8-1:0] rdmx_target_addr;
wire[ 2 *8-1:0] rdmx_seq;
wire[ 5 *8-1:0] rdmx_reserved;

// Big-endian RDMX header
wire[511:0] be_rdmx_header =
{
    // Ethernet header fields - 14 bytes
    eth_dst_mac,
    eth_src_mac,
    eth_frame_type,

    // IPv4 header fields - 20 bytes
    ip4_ver_dsf,
    ip4_length, 
    ip4_id,
    ip4_flags,
    ip4_ttl_prot,
    ip4_checksum,
    ip4_srcip_h,
    ip4_srcip_l,
    ip4_dstip_h,
    ip4_dstip_l,

    // UDP header fields - 8 bytes
    udp_src_port,
    udp_dst_port,
    udp_length,
    udp_checksum,

    // RDMX header fields - 22 bytes
    rdmx_magic,
    rdmx_target_addr,
    rdmx_seq,
    rdmx_user_field,
    rdmx_flags,
    rdmx_reserved
};

localparam PROT_UDP   = 8'h11;
localparam PROT_IPV4  = 8'h45;
localparam RDMX_MAGIC = 16'h0122;

// Byte-swap the little-endian RDMX header to obtain a big-endian version
for (i=0; i<64; i=i+1) begin
    assign be_rdmx_header[i*8 +:8] = le_rdmx_header[(63-i)*8 +:8];
end

// This is the PCI address where the payload should be written
assign rdmx_address = rdmx_target_addr;

// Determine whether this is an RDMX packet
assign is_rdmx =
(
    (ip4_ver_dsf [15:8] == PROT_IPV4 ) &&
    (ip4_ttl_prot[ 7:0] == PROT_UDP  ) &&
    (rdmx_magic         == RDMX_MAGIC)
);

//=============================================================================
// Compute the length of the packet payload in bytes, and in data-cycles.
//=============================================================================
assign     payload_bytes      = udp_length - UDP_HDR_LEN - RDMX_HDR_LEN;
wire[7:0]  dbip_div_64        = (payload_bytes >> 6);
wire       dbip_has_remainder = (payload_bytes & 6'b111111) ? 1 : 0;
assign     payload_cycles     = (dbip_div_64 + dbip_has_remainder);
//=============================================================================

endmodule