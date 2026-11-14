# InfraSync: Automated Infrastructure Provisioning & Monitoring Pipeline with Load Balancing and Auto-Remediation

**Course**: INT333 - DevOps Advance Configuration Management  
**Author**: Ansh Mishra  
**Target Environment**: Ubuntu 24.04 LTS (VMware Workstation Pro / Player)  
**Core Technologies**: Terraform (IaC), Ansible (Config Mgmt), Nagios Core 4 (Monitoring), HAProxy (Load Balancing), Docker (Containers)

---

## 1. Executive Summary & Architecture

Modern applications demand high availability, declarative infrastructure, automated configuration management, and self-healing incident response. This project establishes an automated pipeline that:
1. **Provisions** a custom Docker bridge network (`lab-net`), three independent Nginx web application containers (`web1`, `web2`, `web3`), and an HAProxy load balancer using **Terraform**.
2. **Configures & Deploys** Nagios Core 4, monitoring plugins, Apache HTTP digest authentication, and host/service check definitions using **Ansible**.
3. **Load Balances** HTTP traffic in round-robin mode across the backend web servers through HAProxy on port `8080`, with active health probes (`inter 2s fall 2 rise 2`) and live statistics on port `8404`.
4. **Auto-Remediates** failed container instances: when Nagios detects a backend service outage transitioning into a confirmed `HARD CRITICAL` state, a dedicated event handler (`restart_container.sh`) automatically issues a restricted, passwordless `sudo docker start <container>` command to restore the container without human intervention.

```
+---------------------------------------------------------------------------------------+
|                                    Ubuntu 24.04 VM                                    |
|                                                                                       |
|  [Client / Browser]                                                                   |
|          |                                                                            |
|          v (HTTP Port 8080)                                                           |
|    +-------------+          Docker Network: lab-net                                   |
|    |   HAProxy   |---------------------+---------------------+                        |
|    |  Container  |                     |                     |                        |
|    +-------------+                     v                     v                        |
|           | (Stats: 8404)       +-------------+       +-------------+                 |
|           |                     | web1 (8081) |       | web2 (8082) | ... web3 (8083) |
|           v                     +-------------+       +-------------+                 |
|  +------------------+                  ^                     ^                        |
|  | Nagios Core 4    |-- (HTTP checks) -+---------------------+                        |
|  | (Port 80/nagios4)|                                                                 |
|  +------------------+                                                                 |
|           |                                                                           |
|    (Event Handler on HARD CRITICAL)                                                   |
|           v                                                                           |
|   /usr/local/bin/restart_container.sh                                                 |
|           |                                                                           |
|           +--> sudo /usr/bin/docker start <container>                                 |
+---------------------------------------------------------------------------------------+
```

---

## 2. Repository Layout

```
InfraSync/
├── terraform/
│   ├── main.tf              # Docker network, images, containers & volume uploads
│   ├── variables.tf         # Port mappings & accent branding for web backends
│   ├── haproxy.cfg          # Round-robin balancing, health checks & stats config
│   └── web.html.tpl         # Modern, high-performance web dashboard template
├── ansible/
│   ├── inventory.ini        # Local connection target
│   ├── playbook.yml         # Nagios installation, config templating, sudo rule
│   └── templates/
│       └── lab.cfg.j2       # Jinja2 template for Nagios commands & service checks
├── scripts/
│   └── restart_container.sh # Self-healing event handler script with safety checks
├── index.html               # Interactive Project Hub, topology visualizer & test runner
├── README.md                # Full technical specification & project guide
└── .gitignore               # State files, caches and ephemeral locks exclusion
```

---

## 3. Step-by-Step Installation & Deployment Guide

### Phase 1: Virtual Machine & Toolchain Setup

1. **Update Ubuntu packages**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ip a   # Note down your VM IP address (e.g. 192.168.x.x)
   ```

2. **Install Docker Engine**:
   ```bash
   sudo apt install -y docker.io
   sudo systemctl enable --now docker
   sudo usermod -aG docker $USER
   ```
   *Note: Log out and log back in, then verify with `docker run --rm hello-world`.*

3. **Install HashiCorp Terraform**:
   ```bash
   sudo apt install -y gnupg software-properties-common curl wget
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install -y terraform
   terraform -version
   ```

4. **Install Ansible Core**:
   ```bash
   sudo apt install -y ansible git
   ansible --version
   ```

---

### Phase 2: Terraform Infrastructure Provisioning

1. Navigate to the `terraform/` directory:
   ```bash
   cd terraform
   ```

2. Initialize and deploy:
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

3. **Verify running containers**:
   ```bash
   docker ps
   ```
   You should see 4 active containers: `web1`, `web2`, `web3`, and `haproxy`.

4. **Verify Direct Backends & Load Balancing**:
   ```bash
   # Direct backends
   curl -s localhost:8081 | grep "<h1>"
   curl -s localhost:8082 | grep "<h1>"
   curl -s localhost:8083 | grep "<h1>"

   # HAProxy Load Balancer (round-robin verification)
   for i in {1..6}; do curl -s localhost:8080 | grep "<h1>"; done
   ```
   *Browser access:*
   - Application URL: `http://<VM-IP>:8080` (refresh to observe round-robin rotation)
   - HAProxy Live Statistics: `http://<VM-IP>:8404/stats`

---

### Phase 3: Ansible Configuration & Nagios Monitoring

1. **Create Nagios Admin Web Credentials**:
   ```bash
   sudo htdigest -c /etc/nagios4/htdigest.users Nagios4 nagiosadmin
   # Enter your chosen password
   ```

2. **Run Ansible Playbook**:
   ```bash
   cd ../ansible
   ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
   ```

3. **Validate Nagios Configuration**:
   ```bash
   sudo /usr/sbin/nagios4 -v /etc/nagios4/nagios.cfg
   # Ensure "Total Warnings: 0" and "Total Errors: 0"
   ```

4. **Access Nagios Web Interface**:
   - URL: `http://<VM-IP>/nagios4`
   - User: `nagiosadmin`
   - Password: `<your-password>`
   - Navigate to **Current Status -> Services**: You will see all 4 services green (OK).

---

## 4. Test Cases Matrix (TC01 - TC08)

| Test ID | Objective | Procedure | Expected Outcome | Evidence |
|---|---|---|---|---|
| **TC01** | Infrastructure Provisioning | `terraform apply` | 3 Nginx containers + HAProxy running on `lab-net` | `docker ps` |
| **TC02** | Direct Backend Access | `curl localhost:8081/8082/8083` | Each container returns 200 OK with custom UI | Terminal curl |
| **TC03** | Round-Robin Balancing | `for i in {1..6}; do curl localhost:8080; done` | Responses rotate between web1, web2, web3 | Terminal curl loop |
| **TC04** | Monitoring Automation | `ansible-playbook playbook.yml` | Nagios 4 installed, configs deployed, service running | Ansible output |
| **TC05** | Normal Status Monitoring | Open `http://<VM-IP>/nagios4` | 3 backends + HAProxy show **OK (Green)** | GUI screenshot |
| **TC06** | Passive Failover (Remediation OFF) | Disable flag & run `docker stop web1` | Traffic uninterrupted on 8080; Nagios marks web1 CRITICAL | Nagios alert + HAProxy stats |
| **TC07** | Auto-Remediation (Remediation ON) | Enable flag & run `docker stop web2` | Nagios event handler triggers `docker start web2` | `journalctl` log + Nagios recovery |
| **TC08** | Idempotency Verification | Re-run `terraform plan` & `ansible-playbook` | Terraform reports 0 changes; Ansible reports `changed=0` | Terminal outputs |

---

## 5. Auto-Remediation Deep Dive

### Killswitch Flag
- File: `/etc/nagios4/remediation.enabled`
- Turn ON: `sudo touch /etc/nagios4/remediation.enabled`
- Turn OFF: `sudo rm -f /etc/nagios4/remediation.enabled`

### State Transitions (SOFT vs HARD)
1. When `web1` fails, Nagios triggers a check every `retry_interval` (1 minute).
2. Attempts 1 and 2 are in **SOFT CRITICAL** state (no remediation triggered to prevent false positives).
3. On reaching `max_check_attempts` (attempt 3), the service enters **HARD CRITICAL**.
4. The event handler command executes:
   ```bash
   /usr/local/bin/restart_container.sh CRITICAL HARD web1
   ```
5. The script verifies the flag file, checks container whitelist (`web1|web2|web3`), and executes:
   ```bash
   sudo /usr/bin/docker start web1
   ```
6. Verify remediation logs:
   ```bash
   journalctl -t nagios-remediation -f
   ```

### Least-Privilege Sudo Security
The `nagios` system user has strictly scoped permissions defined in `/etc/sudoers.d/nagios-docker`:
```
nagios ALL=(root) NOPASSWD: /usr/bin/docker start web1, /usr/bin/docker start web2, /usr/bin/docker start web3
```
This prevents unauthorized execution of arbitrary root commands or Docker containers.

---

## 6. Troubleshooting & Diagnostics

| Symptom | Probable Cause | Fix / Remediation |
|---|---|---|
| `docker permission denied` | User not in docker group | Run `sudo usermod -aG docker $USER` and re-login |
| `HAProxy container exits` | Syntax error in `haproxy.cfg` | Run `docker logs haproxy` to pinpoint line error |
| `Nagios 404 / 401 Unauthorized` | Apache digest auth realm mismatch | Ensure realm in `htdigest` is `Nagios4`, run `sudo a2enmod auth_digest cgi && sudo systemctl restart apache2` |
| `Nagios config check fails` | Syntax error in `lab.cfg` | Run `sudo /usr/sbin/nagios4 -v /etc/nagios4/nagios.cfg` |
| `Auto-remediation not firing` | Flag file missing or state still SOFT | Check `/etc/nagios4/remediation.enabled` and test via `sudo -u nagios sudo -n /usr/bin/docker start web1` |

---

## 7. Viva & Oral Examination Highlights

- **Declarative vs Imperative**: Terraform specifies *what* the target state should look like (declarative), whereas scripts specify *how* to execute step-by-step (imperative).
- **Idempotency**: Ensuring repeated executions produce the exact same outcome without unnecessary modifications.
- **Docker DNS Resolution in HAProxy**: HAProxy uses `resolvers docker` with DNS `127.0.0.11:53` so dynamic container IP reassignments on reboot are resolved automatically.
- **Why Nagios for this project?**: Demonstrates active polling check plugins, service thresholds, state-change hooks, and automated incident recovery required by the INT333 syllabus.
