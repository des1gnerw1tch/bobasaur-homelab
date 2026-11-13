# https://developer.hashicorp.com/nomad/docs/job-specification
job "nats" {
    datacenters = ["bobasaur-homelab"]
    type = "service"

    group "app" {
        count = 1
        network {
            port "client" {
                # Port on the host that clients connect to
                static = 4222
                # Port inside the container that host traffic is forwarded to
                to     = 4222
            }
            port "monitor" {
                # Port on the host that clients connect to
                static = 8222
                # Port inside the container that host traffic is forwarded to
                to     = 8222
            }
            port "mqtt" {
                # Port on the host that MQTT clients connect to
                static = 1883
                # Port inside the container that host traffic is forwarded to
                to     = 1883
            }
            # I was having the issue where without mode "bridge", it was only mapping host ports on the wlan0 
            # interface to docker container ports,  not 0.0.0.0 like a normal docker run -p ...
            # Source to this same issue https://github.com/hashicorp/nomad/issues/12106#issuecomment-1126907699,
            # with the recommendation of using "bridge" as the mode to have a similar effect as 0.0.0.0. Not completely
            # sure what "bridge" does yet, but would be a good investigation in the future. 
            mode = "bridge"
        }
        service {
            port = "monitor"
            check {
                type     = "http"
                # NATS monitor endpoints, healthz is a health check that just returns 200 OK when healthy 503 when not
                # https://docs.nats.io/learn/monitoring/monitoring-endpoints#a-note-on-healthz
                path     = "/healthz"
                interval = "10s"
                timeout  = "2s"
            }
        }
        task "run-nats" {
            driver = "docker"
            # Renders the NATS config into the task's local/ dir, which the docker driver mounts at /local
            # https://developer.hashicorp.com/nomad/docs/job-specification/template
            template {
                destination = "local/nats.conf"
                # Restart NATS when the config changes
                change_mode = "restart"
                data        = <<EOF
# MQTT requires JetStream and an explicit server_name
server_name: "bobasaur-nats"

port: 4222
http_port: 8222

jetstream {
  # Note: this is inside the container, so JetStream/MQTT state is lost on restart
  store_dir: "/data/jetstream"
}

mqtt {
  port: 1883
}
EOF
            }
            config {
                image = "nats:latest"
                ports = ["client", "monitor", "mqtt"]
                args  = ["-c", "/local/nats.conf"]
            }
            resources {
                cpu    = 500 # MHz
                memory = 128 # MB
            }
        }
    }
}
