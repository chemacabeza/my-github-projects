<div align="center">
  <img src="./images/linux_ch54_web_servers.png" alt="Linux Web Servers Cover" width="800"/>
</div>

# 54: Web Servers

> 🧠 **The Feynman Hook:** If a database is a kitchen cooking the food, a Web Server is the Waiter (`Nginx` or `Apache`). The waiter's only job is to stand at the front door (Port 80/443), receive orders from customers (HTTP Requests), walk to the kitchen to grab the assembled plate, and carry it back to the customer. A great waiter can seamlessly balance 10,000 customers simultaneously without breaking a sweat or dropping a dish.

**🎯 The Big Goal:** Understand the architecture of HTTP daemons, structure virtual hosts, and contrast the event-driven performance of Nginx against the process-driven legacy of Apache.

---

## 1. The Legacy Powerhouse (`Apache`)

Apache ruled the early internet. Its core architecture is **Process-Driven**. 

Whenever a new customer connects to the website, Apache spins up a completely new, dedicated process (or thread) strictly for that one customer.
- **The Pro:** It is incredibly stable. If one customer's connection crashes, it only kills that one isolated thread.
- **The Con:** Creating a new process for 10,000 simultaneous users requires massive amounts of RAM. Under extreme load, Apache chokes and drops connections.

### Configuring Apache
Apache's superpower is the `.htaccess` file. This allows developers to instantly modify web routing rules on a per-directory basis without ever needing to restart the primary Apache server. 

---

## 2. The Modern Asynchronous Champion (`Nginx`)

Nginx (pronounced "Engine-X") was built to solve the C10K problem (handling 10,000 concurrent connections). Its architecture is **Event-Driven**.

Instead of assigning one waiter per customer, Nginx uses a single, highly caffeinated waiter running in an infinite asynchronous loop. It takes an order, instantly passes it to the kitchen, and instead of standing there waiting, immediately turns around to take the next customer's order.
- **The Pro:** It can handle hundreds of thousands of connections while burning almost zero RAM.
- **The Con:** It does not support `.htaccess`. All rules must be defined centrally by the system administrator.

---

## 3. Reverse Proxying

Because Nginx is so fast, developers rarely let users connect directly to backend applications (like Python or Node.js). 

Instead, Nginx sits at the edge of the network as a **Reverse Proxy**. It absorbs the initial HTTPS encryption burden, filters out malicious traffic, and then securely forwards the pure request via local HTTP strictly to the vulnerable internal Python application running on Port 8000.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why serving Static Files (Images, CSS) is vastly different than serving Dynamic content (PHP) for a Web Server.</summary>
When a user requests an image, the Web Server just grabs the literal file from the hard drive and streams it instantly back to the user. This takes virtually zero CPU. When a user requests a PHP page (like verifying a password), the Web Server cannot answer. It must freeze, hand the request entirely off to the backend PHP engine (the kitchen) to calculate the password hash, wait for the HTML response, and then pass it back. Serving static files is instantaneous; dynamic content requires a backend engine hand-off.
</details>

---
[<< Previous: DNS and DHCP](./53_DNS_and_DHCP.md) | [Home: Curriculum Map](./README.md) | [Next: SSH Deep Dive >>](./55_SSH_Deep_Dive.md)
