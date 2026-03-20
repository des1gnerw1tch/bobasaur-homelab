# https://developer.hashicorp.com/nomad/docs/job-specification
job "nas-filebrowser" {
    datacenters = ["bobasaur-homelab"]
    type = "service"
    constraint {
        attribute = "${attr.unique.hostname}"
        value     = "raspberrypi4dot2"
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
                static = 8080
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
                args = ["-c", "echo 'hello from nomad'; whoami; sudo mount /dev/sda1 /mnt/myssd/; sudo docker run --rm --user root -v /mnt/myssd:/srv -p 8080:80 filebrowser/filebrowser:v2.62.0"]
            }
            env {
            }
            # Specify the maximum resources required to run the task,
            # include CPU and memory.
            resources {
                cpu    = 500 # MHz
                memory = 256 # MB
            }
        }
    }
}

