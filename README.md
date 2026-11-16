# Ubuntu 26.04 (Resolute) Lockdep Kernel Builder

Compiles Ubuntu 26.04 LTS (`resolute`, Linux 7.0) kernel source with `CONFIG_PROVE_LOCKING` (`lockdep`) enabled and packages it into `.deb` files via GitHub Actions.

## Build Instructions
1. Open the **Actions** tab in this GitHub repository.
2. Select **Build Ubuntu 26.04 (Resolute) Lockdep Kernel**.
3. Click **Run workflow** (choose `generic` or `lowlatency`).
4. Once finished, download `linux-image-*-lockdep_*.deb` and `linux-headers-*-lockdep_*.deb` from **Releases**.

## Install on Ubuntu 26.04
```bash
sudo apt install ./linux-image-*-lockdep_*.deb ./linux-headers-*-lockdep_*.deb
sudo reboot
```

## Verify Lockdep
```bash
uname -r
cat /proc/lockdep_stats
```
