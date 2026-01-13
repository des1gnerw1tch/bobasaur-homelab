datacenter = "bobasaur-homelab" # define datacenter ID
data_dir = "/opt/consul/data"
retry_join = ["raspberrypi4dot1", "raspberrypi4dot2", "raspberrypi5"] # the list of all nodes IP addresses
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "{{ GetInterfaceIP \"wlan0\" }}"
domain = "bobasaur" # Define the top level DNS domain for service discovery

ui_config {
  enabled = true
}

# I added this down below, I'm not sure why this wasn't included in the blog..
server = true
bootstrap_expect = 3
