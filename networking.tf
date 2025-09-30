module "core_network" {
  source = "./modules/vpn_ha" 
  
  # --- 1. BASIC CONFIGURATION ---
  project_id = var.project_id
  region     = var.region

  # --- 2. VPC AND SUBNETS ---
  create_network        = true
  network_name          = "vpc-vpn-ha"
  main_subnet_cidr      = "10.200.0.0/24"
  connector_subnet_cidr = "10.200.1.0/28"

  # --- 3. VPN GATEWAY ---
  create_vpn_gateway               = true
  vpn_gateway_self_link            = null
  router_name                      = ""
  router_asn                       = 64515
  external_vpn_gateway_description = "My VPN peering gateway"

  # --- 4. PEER EXTERNAL VPN GATEWAY ---
  peer_external_gateway = {
    name            = "vpn-peering-gw"
    redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT" 
    interfaces = [
      {
        id         = 0
        ip_address = "8.8.8.8" # Public IP Router On-Premise
      },
    ]
  }

  # --- 5. Tunnels
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1" # Peer BGP IP on-premises (Tunnel 0)
        asn     = 64513         # ASN of the On-Premise network
      }
      bgp_session_range               = "169.254.1.2/30"  # GCP Router Interface IP (Tunnel 0)
      ike_version                     = 2
      peer_external_gateway_interface = 0
      vpn_gateway_interface           = 0
      shared_secret                   = "mySecret"
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1" # Peer BGP IP on-premises (Tunnel 1)
        asn     = 64513
      }
      bgp_session_range               = "169.254.2.2/30"  # GCP Router Interface IP (Tunnel 1)
      ike_version                     = 2
      peer_external_gateway_interface = 0
      vpn_gateway_interface           = 1
      shared_secret                   = "mySecret"
    }
  }
  # --- 6. Peering
  host_networks = {
    dev = {
      project_id   = "conversational-agent-dev"
      network_name = "vpc-conversational-agent-dev"
    }
    itg = {
      project_id   = "conversational-agent-itg"
      network_name = "vpc-conversational-agent-itg"
    }
  }
}
