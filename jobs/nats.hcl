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
            config {
                image = "nats:latest"
                ports = ["client", "monitor"]
                args  = ["--http_port", "8222", "-js"]
            }
            resources {
                cpu    = 500 # MHz
                memory = 128 # MB
            }
        }
    }
}
