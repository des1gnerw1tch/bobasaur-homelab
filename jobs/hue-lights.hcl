# https://developer.hashicorp.com/nomad/docs/job-specification
job "hue-lights" {
    datacenters = ["bobasaur-homelab"]
    type = "service"
    constraint {
        attribute = "${attr.unique.hostname}"
        value     = "raspberrypi5"
    }
    group "dash-app" {
        count=1
        network {
            # This requests a dynamic port named "http". This will
            # be something like "46283", but we refer to it via the
            # label "http".
            # port "http" {}

            # This requests a static port on 443 on the host. This
            # will restrict this task to running once per host, since
            # there is only one port 443 on each host.
            port "http" {
                static = 8050
            }
        }
        service{
            port = "http"
            check{
                type = "http"
                path = "/"
                interval = "10s"
                timeout = "2s"
            }
        }
        task "run-app" {
            driver = "raw_exec"
            config {
                command = "/bin/bash"
                args = ["-c", "whoami; echo 'Hello from nomad!'; mkdir -p /home/dino/hue-lights; cd /home/dino/hue-lights; rm -rf hue-lights-dash-controller; git clone https://github.com/des1gnerw1tch/hue-lights-dash-controller.git; cd hue-lights-dash-controller; git pull; uv sync; uv run main.py"]
            }
            env {
                HUE_BULB_MAC = "D5:3E:9F:CA:E5:77"
            }
            # Specify the maximum resources required to run the task,
            # include CPU and memory.
            resources {
                cpu    = 500 # MHz
                memory = 128 # MB
            }
        }
    }
}

