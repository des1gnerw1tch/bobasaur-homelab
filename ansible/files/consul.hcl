datacenter = "bobasaur-homelab" # define datacenter ID
data_dir = "/opt/consul/data"
retry_join = ["raspberrypi4dot1", "raspberrypi4dot2", "raspberrypi5"] # the list of all nodes IP addresses
bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}"
# Loopback is required here: Nomad talks to Consul at 127.0.0.1:8500 by default,
# and uses it to discover its server peers. Loopback is not a network exposure --
# it is unreachable from wlan0/eth0. bind_addr and advertise_addr below keep all
# gossip, raft, and peer traffic on tailscale0 only.
client_addr = "127.0.0.1 {{ GetInterfaceIP \"tailscale0\" }}"
advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}"

domain = "bobasaur" # Define the top level DNS domain for service discovery

ui_config {
  enabled = true
}

# I added this down below, I'm not sure why this wasn't included in the blog..
server = true
bootstrap_expect = 3
