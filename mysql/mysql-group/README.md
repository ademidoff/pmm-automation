# Provision MySQL 8.4 Cluster with Group Replication in Docker

This setup allows the user to provision a MySQL 8.4 cluster with group replication using Docker. The setup includes one primary and two replica nodes, all running MySQL 8.4.

## Prerequisites
- Docker
- Docker Compose
- python3
- ansible
- ansible-playbook

## Run the playbook

```bash
ansible-playbook mysql-84-group.yml
```

## Verify the replication

1. Connect to the primary (mysql-group1):

```bash
  docker exec -it mysql-async1 mysql -uroot -p{{ root_password }}
```

2. Insert data in the test database:

```sql
  USE testdb;
  INSERT INTO testdb VALUES (100, 'Test replication');
```

3. Connect to replicas and verify data is replicated:

```bash
  docker exec -it mysql-group2 mysql -uroot -p{{ root_password }}
  USE testdb;
  SELECT * FROM testdb;
```
