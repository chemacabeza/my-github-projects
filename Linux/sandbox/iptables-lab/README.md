# IPTables Practice Sandbox

This environment allows you to test Netfilter rules safely.

## 🚀 Getting Started

1.  **Launch the lab:**
    ```bash
    docker compose up -d
    ```

2.  **Enter the Firewall Node:**
    ```bash
    docker exec -it iptables-sandbox sh
    ```

## 🧪 Experiments to Try

### 1. The Ping Test
From inside `iptables-sandbox`, try to ping the target:
```bash
ping -c 3 target-server
```
Now, block ICMP and try again:
```bash
iptables -A OUTPUT -p icmp -j DROP
ping -c 3 target-server
```

### 2. Blocking Web Traffic
Try to reach the target's web server:
```bash
curl target-server
```
Now, block Port 80:
```bash
iptables -A OUTPUT -p tcp --dport 80 -j DROP
curl target-server
```

### 3. Connection Tracking
Allow established traffic and then block all new output:
```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P OUTPUT DROP
```
*(Warning: This is how you build a real-world secure outgoing policy!)*

## 🧹 Cleanup
```bash
docker compose down
```
