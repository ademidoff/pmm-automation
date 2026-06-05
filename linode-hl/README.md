# pmm-highload

End-to-end Terraform stack that provisions a PMM Server on Linode plus configurable numbers of MySQL, PostgreSQL, and MongoDB workload nodes — all monitored by PMM, all generating sustained load via `sysbench` (MySQL/PostgreSQL) or a custom JS load generator (MongoDB).

## Architecture

```
   ┌───────────────────────────┐
   │ module "pmm_server"       │  perconalab/pmm-server (UI on :443)
   └─────────────┬─────────────┘
                 │ public IP
   ┌─────────────┴─────────────┐
   │ module "mysql"    × N     │  ──┐
   │ module "postgres" × N     │  ──┼─► each runs a DB container + 10
   │ module "mongo"    × N     │  ──┘   pmm-client containers + sysbench
   └───────────────────────────┘
```

- Every VM is a single Linode running an AlmaLinux 9 image with Docker preinstalled.
- DB scripts wait for PMM Server's `/v1/server/readyz` before registering clients.
- 10 PMM client containers per DB node (each `perconalab/pmm-client:3.8.0-rc`) register the local DB as a distinct PMM service, simulating many monitored sources.

## Quick start

```sh
# 1. Configure secrets in terraform.tfvars (gitignored)
cat > terraform.tfvars <<EOF
ssh_public_key = "ssh-rsa AAAA... you@host"
linode_token   = "your-linode-pat"
mysql_count    = 1
postgres_count = 1
mongo_count    = 1
EOF

# 2. Apply
terraform init
terraform apply

# 3. Open PMM UI
echo "https://$(terraform output -raw pmm_server_ip)"
terraform output -raw pmm_admin_password
```

## Scaling DB instances

DB node counts are plain Terraform variables — bump them up or down and re-apply.

```sh
# Scale to 5 MySQL + 3 Postgres + 2 Mongo nodes
terraform apply -var mysql_count=5 -var postgres_count=3 -var mongo_count=2

# Or persist in terraform.tfvars
echo 'mysql_count = 5' >> terraform.tfvars
terraform apply

# Tear everything down
terraform apply -var mysql_count=0 -var postgres_count=0 -var mongo_count=0
```

Scaling down destroys the highest-indexed nodes first (e.g. going from 5 → 3 destroys `pmm-mysql-*-3` and `pmm-mysql-*-4`). PMM Server itself is unaffected by DB count changes.

## Variables

| Variable | Default | Notes |
|---|---|---|
| `ssh_public_key` | — | Required. Authorized on all VMs. |
| `linode_token` | — | Required. Linode API token. |
| `mysql_count` / `postgres_count` / `mongo_count` | `0` | Opt-in. Number of DB nodes per type. |
| `instance_type` | `g6-standard-4` | Same for PMM Server and DB nodes. |
| `region` | `fr-par` | Linode region. |
| `image` | `private/38885222` | Private AlmaLinux 9 image with Docker preinstalled. |
| `firewall_id` | `4112335` | Linode firewall (`pmm`) attached to all VMs. |
| `pmm_docker_image` | `perconalab/pmm-server:3-dev-latest` | PMM Server container image. |
| `pmm_client_image` | `perconalab/pmm-client:3.8.0-rc` | PMM Client container image. |
| `mysql_image` / `postgres_image` / `mongo_image` | Percona images | DB server container images. |
| `pmm_admin_password` / `mysql_password` / `postgres_password` / `mongo_password` | `null` (auto-generated) | All `sensitive`. Override via tfvars if you want a known value. |
| `metrics_mode` | `auto` | `pmm-admin add --metrics-mode` value. |

## Outputs

```sh
terraform output pmm_server_ip
terraform output mysql_ips      # list, one per mysql node
terraform output postgres_ips
terraform output mongo_ips

terraform output -raw pmm_admin_password
terraform output -raw mysql_password
terraform output -raw postgres_password
terraform output -raw mongo_password
```

## Layout

```
linode-hl/
  main.tf                # module calls + random_password resources
  variables.tf
  outputs.tf
  provider.tf            # linode + random providers, GCS state backend
  cloud-init/
    pmm-server.yml.tftpl # PMM Server bootstrap
    mysql.yml.tftpl      # MySQL + sysbench + pmm-clients
    postgres.yml.tftpl   # PostgreSQL + sysbench + pmm-clients
    mongo.yml.tftpl      # MongoDB + JS load gen + pmm-clients
  modules/
    linode-vm/           # reusable VM module (instance + random_password root)
```

## Troubleshooting

- Per-VM provisioning logs land at `/root/stackscript.log` on each VM (`ssh root@<ip>`).
- Cloud-init logs: `/var/log/cloud-init-output.log`.
- DB nodes block on PMM Server readiness; if a DB node hangs, check that PMM Server's `/v1/server/readyz` returns 200 from the DB node.
