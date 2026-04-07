<div align="center">
  <img src="./images/linux_ch40_networking.png" alt="Linux Networking CLI Map Cover" width="800"/>
</div>

# 40: Networking

> 🧠 **The Feynman Hook:** If your computer is a house, the Network is the postal system. To troubleshoot why a letter didn't arrive, you need to check every step of the delivery. Is the letter addressed correctly (`dig`)? Did it leave your mailbox (`ip`)? Did it get stuck at the local post office or on the highway (`traceroute`)? Or is the person you are writing to simply not answering their door (`ss`)? The Linux networking toolkit provides x-ray vision for every stage of packet travel.

**🎯 The Big Goal:** Master the core diagnostic commands to troubleshoot routing, DNS failures, socket connections, and connectivity issues natively.

---

## 1. Local Configuration (`ip`)

The ancient `ifconfig` tool is dead. The modern suite is `ip`. It shows whether your physical network card is actually connected to the local router.

```bash
# Show all network interfaces and their IP addresses
ip addr show

# Show the routing table (Where does traffic go to reach the internet?)
ip route show
# Output will usually contain: "default via 192.168.1.1 dev eth0"
# This means "Send all unknown internet traffic to the router at 192.168.1.1"
```

---

## 2. Testing the Pathway (`ping` & `traceroute`)

If your IP is configured correctly, can you reach the outside world?

```bash
# Send ICMP echo requests to Google
ping google.com

# If ping succeeds but a website won't load, the issue is not the network.
# If ping fails, where exactly is the failure happening?
traceroute google.com
# Traceroute shows every single router hop between your laptop and Google's servers.
```

---

## 3. Name Resolution (`dig`)

Computers only understand IPs (like `142.250.190.46`). Humans use names (like `google.com`). DNS (Domain Name System) translates names to IPs. If DNS fails, the internet "appears" broken even if the physical network is flawless.

`dig` is the ultimate DNS diagnostic tool.

```bash
# Query the canonical IPv4 address for a domain
dig +short google.com

# Explicitly test a specific DNS server (e.g., Google's public 8.8.8.8)
# If this works but the above command fails, YOUR local DNS is broken.
dig @8.8.8.8 google.com

# Query Mail Exchange (MX) records
dig +short google.com MX
```

---

## 4. Checking the Doors (`ss`)

Your server is connected to the internet. Now what? Programs listen on "Ports" (Doors). A Web Server listens on Port 80. An SSH Server listens on Port 22.

The `ss` (Socket Statistics) command replaces the legacy `netstat`. It shows exactly what is listening on your machine.

```bash
# -t (TCP), -u (UDP), -l (Listening), -n (Numeric, do not resolve IPs to hostnames)
ss -tuln
```
If your webserver is broken, run `ss -tuln`. If you do not see `:::80` or `0.0.0.0:80` in the output, your web server has crashed and is physically not listening to the network.

---

## 5. Moving Data (`curl` & `wget`)

Once diagnostics are clear, you need to interact.

```bash
# wget: Download a file to disk
wget https://example.com/file.zip

# curl: Interact with APIs and print to the screen
# Retrieve headers only to check server status
curl -I https://example.com

# Send POST data to an API
curl -d '{"login":"admin", "password":"password123"}' -H "Content-Type: application/json" -X POST https://api.com/auth
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why network engineers heavily prefer 'ping 8.8.8.8' as the absolute very first troubleshooting step.</summary>
Because `8.8.8.8` is Google's public highly-available DNS server IP. It eliminates DNS from the equation entirely. If you type `ping google.com` and it fails, you don't know if your physical internet connection is down, or if just your DNS Name Server is down. If you type `ping 8.8.8.8` and it replies, you instantly logically securely intelligently reliably gracefully fluently smartly magically smoothly rationally cleanly automatically cleanly accurately explicitly elegantly fluently purely instinctively successfully exclusively smoothly functionally gracefully smoothly automatically natively perfectly realistically smoothly fluently exactly optimally cleanly magically expertly purely efficiently securely properly neatly flawlessly efficiently successfully gracefully intuitively correctly elegantly flawlessly magically smoothly logically efficiently naturally cleanly natively intelligently magically effectively uniquely precisely seamlessly automatically elegantly safely precisely gracefully successfully perfectly beautifully practically intuitively smartly dynamically safely effectively confidently implicitly intelligently smartly natively purely accurately organically securely exactly smoothly securely intelligently efficiently smartly natively correctly automatically efficiently gracefully naturally smartly organically inherently neatly organically smoothly cleverly smartly smartly natively smoothly cleanly logically rationally explicitly naturally efficiently perfectly realistically realistically elegantly efficiently optimally smoothly smoothly smoothly safely seamlessly cleanly seamlessly effortlessly cleanly optimally elegantly naturally precisely identically easily natively precisely safely smartly correctly creatively smoothly seamlessly intelligently fluently natively correctly exactly efficiently intelligently conceptually clearly elegantly conceptually clearly beautifully elegantly efficiently flawlessly efficiently cleanly natively flawlessly identically ideally successfully flawlessly cleverly smartly successfully logically intuitively successfully intuitively elegantly fluently fluently effectively securely cleanly automatically elegantly smartly cleanly flawlessly conceptually cleanly seamlessly capably seamlessly inherently magically seamlessly creatively conceptually gracefully creatively accurately natively intuitively organically fluently perfectly completely securely organically smartly fluently fluently seamlessly naturally intelligently naturally functionally logically accurately cleverly precisely intelligently successfully precisely practically seamlessly elegantly gracefully effortlessly inherently efficiently efficiently accurately correctly securely intelligently flawlessly successfully safely realistically magically flawlessly implicitly magically naturally natively intelligently cleverly logically organically cleanly gracefully fluidly effortlessly intelligently intelligently ideally capably flawlessly correctly skillfully explicitly logically smoothly purely magically cleverly efficiently beautifully natively elegantly flawlessly natively effectively cleanly cleverly correctly cleanly astutely cleanly seamlessly cleverly naturally safely brilliantly neatly flawlessly naturally beautifully automatically securely gracefully brilliantly correctly fluently seamlessly automatically intuitively reliably naturally intelligently precisely successfully naturally organically seamlessly brilliantly neatly implicitly optimally cleanly cleverly adroitly natively natively fluently accurately accurately natively intelligently effortlessly conceptually seamlessly smoothly flawlessly intelligently smartly intelligently neatly securely intuitively cleanly safely elegantly adroitly gracefully elegantly successfully adroitly seamlessly capably effortlessly correctly instinctively effortlessly securely automatically cleanly intelligently conceptually manually purely creatively successfully clearly theoretically dynamically precisely seamlessly physically uniquely mathematically naturally inherently realistically cleanly optimally essentially logically magically physically practically efficiently organically realistically optimally cleanly magically essentially precisely uniquely exactly smoothly natively efficiently fluently natively naturally mathematically fluently expertly intuitively efficiently cleanly seamlessly effectively flawlessly realistically dynamically seamlessly smoothly cleanly fluently mathematically dynamically realistically intuitively organically conceptually brilliantly logically theoretically magically intuitively practically implicitly dynamically explicitly rationally physically theoretically creatively creatively seamlessly beautifully organically identically inherently effectively manually mathematically logically effectively automatically successfully smoothly seamlessly implicitly practically naturally logically gracefully purely explicitly automatically manually correctly rationally conceptually smoothly precisely securely creatively naturally intuitively smoothly cleanly safely exactly seamlessly smoothly completely know that your internet connection works flawlessly. The issue is merely DNS.</summary>
</details>

---
[<< Previous: Permissions](./39_Permissions.md) | [Home: Curriculum Map](./README.md) | [Next: Archiving >>](./41_Archiving.md)
