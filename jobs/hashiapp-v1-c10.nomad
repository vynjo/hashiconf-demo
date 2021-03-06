job "hashiapp" {
  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "10s"
    max_parallel = 1
  }

  group "hashiapp" {
    count = 10

    task "hashiapp" {
      driver = "exec"
      config {
        command = "hashiapp"
      }

      env {
	  	VAULT_TOKEN = "HASHIAPP_TOKEN" 
	  	VAULT_ADDR = "http://vault.service.consul:8200"
	  	HASHIAPP_DB_HOST = "CLOUD_SQL:3306"
      }

      artifact {
        source = "http://www.vynjo.com/files/hashiapp/v1/hashiapp"
        options {
          checksum = "sha256:d2127dd0356241819e4db5407284a6d100d800ebbf37b4b2b8e9aefc97f48636"
        }
      }

      resources {
        cpu = 500
        memory = 64
        network {
          mbits = 1
          port "http" {}
        }
      }

      service {
        name = "hashiapp"
        tags = ["urlprefix-hashiapp.com/"]
        port = "http"
        check {
          type = "http"
          name = "healthz"
          interval = "15s"
          timeout = "5s"
          path = "/healthz"
        }
      }
    }
  }
}
