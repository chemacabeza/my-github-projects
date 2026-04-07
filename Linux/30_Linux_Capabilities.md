<div align="center">
  <img src="./images/linux_ch30_capabilities.png" alt="Capabilities Architecture Cover" width="800"/>
</div>

# 30: Linux Capabilities - Replacing Root

> 🧠 **The Feynman Hook:** In traditional Linux, security is binary. You are either a normal user or `root`. If a web server needs to open port 80, you historically had to give it `root`. But if the web server is hacked, the hacker now owns the entire server. **Linux Capabilities** break the `root` key into 40 tiny keys. You can now tell the web server: "Here is the exact key to unlock port 80, but you cannot open the server room or look at passwords."

**🎯 The Big Goal:** Understand how modern container architectures drop `root` using granular Linux Capabilities to achieve the Principle of Least Privilege.

---

## 1. Dissecting the Master Key

The Kernel defines about 40 Capabilities. If you grant a capability to a binary file, it gains that specific elevated permission without running as Root.

### Core Capabilities:

| Capability | Purpose |
| :--- | :--- |
| `CAP_NET_BIND_SERVICE` | Bind to privileged ports below 1024. |
| `CAP_NET_ADMIN` | Configure network interfaces and firewalls. |
| `CAP_SYS_PTRACE` | Trace and debug processes. |
| `CAP_SYS_TIME` | Change the host hardware clock. |
| `CAP_DAC_OVERRIDE` | Ignore file read, write, and execute permissions. |
| `CAP_SYS_ADMIN` | The master capability. Allows mounting hard drives. |

---

## 2. Hands-on: Nginx without Root

Traditionally, you run Nginx with `sudo` because it binds to Port 80.

```bash
# 1. Grant ONLY the specific capability to the Nginx binary
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx

# 2. Verify the Kernel stamped the binary
getcap /usr/sbin/nginx
# Output: /usr/sbin/nginx cap_net_bind_service=ep

# 3. Start the server as an unprivileged user
nginx
```

---

## 3. Docker and Capabilities (The Security Secret)

> **Feynman Insight:** When you run a process as `root` inside Docker, it is not the real `root`. Docker inherently drops 26 of the 40 capabilities before the container boots.

If you attempt to load a Kernel Module from inside Docker, the Kernel blocks you. Even though your username says `root`, your Capability Keyring is restricted.

**Best Practice:** Drop all capabilities and only add what is needed.

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: In 'setcap cap_net_bind_service=+ep', what do 'e' and 'p' mean?</summary>
Linux Capabilities use three logical flags. `e` stands for **Effective** (The capability is active and ready). `p` stands for **Permitted** (The process is allowed to utilize this capability). `i` stands for **Inheritable** (Child processes inherit the capability).
</details>

<details>
<summary>💡 View Answer: Why is 'CAP_SYS_ADMIN' considered dangerous?</summary>
`CAP_SYS_ADMIN` encompasses critical administrative functions. It allows mounting hard drives and bypassing namespaces, which can easily lead to a full container breakout.
</details>

---
[<< Previous: Seccomp-BPF](./29_Seccomp_BPF.md) | [Home: Curriculum Map](./README.md) | [Next: Traffic Control & QoS >>](./31_Traffic_Control_QoS.md)
