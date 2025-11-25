![](https://img.shields.io/badge/Built%20With-Bash-1f425f.svg)

`30 June 2020`

A simple Bash script and helper to accept incoming SSH traffic using port forwarding on a router, with a dynamic DNS through DigitalOcean.

Following: [DigitalOcean DDNS Guide](https://surdu.me/2019/07/28/digital-ocean-ddns.html)

---

- [Requirements](#requirements)
- [Setup Instructions](#setup-instructions)
  - [Get a DigitalOcean API Token](#1-get-a-digitalocean-api-token)
  - [Set Up a Project](#2-set-up-a-project)
  - [Add DNS Record (A)](#3-add-dns-record-a)
  - [Get DNS Record ID](#4-get-id-of-the-dns-record)
  - [Update DNS](#5-update-dns)
  - [Set Up a Cron Job](#6-set-up-a-cron-job)
  - [Configure Port Forwarding](#7-configure-port-forwarding-on-router-airport-base-station)
  - [Connect via SSH](#8-connect-via-ssh)
  - [Install update-dns.sh to /usr/local/bin](#9-install-update-dns.sh-to-usrlocalbin)
  - [Keep Local Machine Awake](#10-set-local-computer-to-stay-awake)

---

## Requirements

- DigitalOcean account
- API token for DNS updates
- A local machine with SSH server enabled ("Remote Login")
- Router capable of port forwarding (example: Apple Airport Base Station)

---

## Setup Instructions

### 1. Get a DigitalOcean API Token
[Create a Personal Access Token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/)

### 2. Set Up a Project
Example: Use `O-R-G` as your project name.

### 3. Add DNS Record (A)
Point `basement.o-r-g.net` to your IP.
This DNS record will be updated by a local Bash script.

### 4. Get ID of the DNS Record
Use the `get-dns-id.sh` script:
```bash
./get-dns-id.sh
```

### 5. Update DNS
Add the DNS record ID and API token to .zshrc as enviroment variables then run `update-dns.sh`:
```bash
nano ~/.zshrc
./update-dns.sh
```

### 6. Set Up a Cron Job
Keep the DigitalOcean DNS record updated every 5 minutes:
```bash
crontab -e
```
Add the following line:
```bash
*/5 * * * * /usr/local/bin/update-do-ddns >> /Users/me/log.txt
```

### 7. Configure Port Forwarding on Router (Airport Base Station)
Following [Apple Discussions: Port Mapping](https://discussions.apple.com/docs/DOC-3415)

#### Steps:
- Reserve a DHCP static IP for the local computer.
- Forward external port **22** to this static IP.

#### Requirements:
- **MAC address** (System Preferences → Network).
- **Static local IP**.

List all local IPs and MAC addresses:
```bash
arp -a
```

Example output:
```
xx:xx:xx:xx:xx:xx
10.0.1.x
```

Set up port forwarding:
- Choose **"Remote Login - SSH"** (public TCP, port 22 points to local static IP).
- Restart the Base Station.

### 7. Set static ip
Set static ip for local computer with MAC address specified in Step 7: `System Settings : Network : Wifi : Details : TCP/IP : Configure IPv4 : Using DHCP with Manual Address`

### 8. Connect via SSH
Ensure `sshd` is running locally ("Remote Login" enabled in Sharing).

Connect using:
```bash
ssh someone@somewhere.com
```

### 9. Install `update-dns.sh` to `/usr/local/bin`
```bash
cp update-do-ddns.sh /usr/local/bin/update-do-ddns
```

### 10. Set Local Computer to Stay Awake
Run on startup:
```bash
caffeinate -d
```

---

✅ Your system should now accept incoming SSH traffic dynamically using DDNS and port forwarding.
