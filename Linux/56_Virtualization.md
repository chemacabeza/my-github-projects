# 56: Virtualization (KVM/QEMU)

<p align="center">
  <img src="images/linux_virtualization.png" alt="Linux Virtualization" width="800"/>
</p>

Linux is the world's most popular hypervisor platform. KVM (Kernel-based Virtual Machine) turns your Linux kernel into a Type-1 hypervisor, while QEMU provides hardware emulation — together they power everything from local dev VMs to massive cloud infrastructure.

---

## 1. Virtualization Types

| Type | Description | Examples |
| :--- | :--- | :--- |
| **Type 1** (Bare-metal) | Hypervisor runs directly on hardware | KVM, VMware ESXi, Xen |
| **Type 2** (Hosted) | Hypervisor runs on an OS | VirtualBox, VMware Workstation |
| **Containers** | OS-level virtualization (shared kernel) | Docker, LXC, Podman |

KVM is technically **Type 1** — the Linux kernel itself is the hypervisor.

---

## 2. Checking Hardware Virtualization Support

```bash
# Check for VT-x (Intel) or AMD-V (AMD)
grep -E "vmx|svm" /proc/cpuinfo | head -1

# Check if KVM module is loaded
lsmod | grep kvm

# Verify with kvm-ok
sudo apt install cpu-checker
kvm-ok
```

---

## 3. The KVM/QEMU/libvirt Stack

| Component | Role |
| :--- | :--- |
| **KVM** | Kernel module for hardware-accelerated virtualization |
| **QEMU** | Machine emulator (CPU, disk, network virtual hardware) |
| **libvirt** | Management API and daemon (`libvirtd`) |
| **virsh** | Command-line tool to manage VMs |
| **virt-manager** | GUI for VM management |
| **virt-install** | CLI to create new VMs |

### Installation:
```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo usermod -aG libvirt $USER
sudo systemctl enable libvirtd
```

---

## 4. Managing VMs with `virsh`

```bash
# List all VMs
virsh list --all

# Start/stop/reboot
virsh start myvm
virsh shutdown myvm
virsh reboot myvm
virsh destroy myvm                 # Force stop (like pulling the power cord)

# Create a snapshot
virsh snapshot-create-as myvm snap1 "Before upgrade"
virsh snapshot-list myvm
virsh snapshot-revert myvm snap1

# View VM info
virsh dominfo myvm
virsh domblklist myvm              # Disk devices
virsh domiflist myvm               # Network interfaces
```

---

## 5. Creating a VM with `virt-install`

```bash
virt-install \
  --name ubuntu-server \
  --ram 2048 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/ubuntu.qcow2,size=20 \
  --os-variant ubuntu22.04 \
  --cdrom /path/to/ubuntu-22.04-server.iso \
  --network bridge=virbr0 \
  --graphics vnc
```

---

## 6. Cloud-Init (Automated VM Setup)

Cloud-init makes VMs self-configuring at first boot:

```yaml
# user-data.yaml
#cloud-config
hostname: webserver-01
users:
  - name: deploy
    ssh_authorized_keys:
      - ssh-ed25519 AAAA... user@workstation
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
packages:
  - nginx
  - htop
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
```

### Exercise 1: Check Virtualization Support
> **Goal:** Determine if the host supports hardware virtualization.
```bash
grep -cE "vmx|svm" /proc/cpuinfo
cat /proc/cpuinfo | grep -m1 "model name"
```
✅ **Expected:** A count > 0 means VT-x/AMD-V is available. You will also see the host CPU model.

### Exercise 2: Explore libvirt XML Structure
> **Goal:** Understand how VMs are defined.
```bash
apt-get update > /dev/null 2>&1 && apt-get install -y libvirt-clients > /dev/null 2>&1
cat << 'XML'
<domain type='kvm'>
  <name>testvm</name>
  <memory unit='MiB'>2048</memory>
  <vcpu>2</vcpu>
  <os><type arch='x86_64'>hvm</type></os>
  <devices>
    <disk type='file' device='disk'>
      <source file='/var/lib/libvirt/images/disk.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
  </devices>
</domain>
XML
```
✅ **Expected:** Understanding the XML format that defines VM resources (RAM, CPU, disk, network).

### Exercise 3: QEMU Disk Images
> **Goal:** Create and inspect a virtual disk.
```bash
apt-get install -y qemu-utils > /dev/null 2>&1
qemu-img create -f qcow2 /tmp/test-disk.qcow2 1G
qemu-img info /tmp/test-disk.qcow2
```
✅ **Expected:** A 1GB qcow2 virtual disk is created. `info` shows the actual (small) and virtual (1GB) size.

---

[<< Previous: SSH Deep Dive](./55_SSH_Deep_Dive.md) | [Home: Curriculum Map](./README.md) | [Next: Git Version Control >>](./57_Git_Version_Control.md)
