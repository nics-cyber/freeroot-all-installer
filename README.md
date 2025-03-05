

---

# FreeRoot All Installer

FreeRoot All Installer is a powerful, open-source script that allows you to download and install **multiple operating systems** from a single interface. Whether you're setting up a new system, testing different OSes, or creating a multi-boot environment, FreeRoot All Installer simplifies the process.

## Features

- **Multi-OS Support**: Install over **50+ operating systems**, including Debian, Ubuntu, Arch Linux, Fedora, CentOS, Kali Linux, and more.
- **Easy to Use**: Simple, interactive menu for selecting and installing OSes.
- **Checksum Verification**: Ensures the integrity of downloaded OS images using SHA-256 checksums.
- **Modular Design**: Easily add or remove operating systems by editing the embedded JSON list.
- **Self-Contained**: No external dependencies other than `jq` and `wget`.

## Supported Operating Systems

FreeRoot All Installer supports the following operating systems (and more!):

- Debian
- Ubuntu
- Arch Linux
- Fedora
- CentOS
- openSUSE
- Kali Linux
- Alpine Linux
- Gentoo
- FreeBSD
- OpenBSD
- NetBSD
- Manjaro
- Slackware
- And many more!

---

## Installation

### Prerequisites

1. **Linux Environment**: The script is designed to run on Linux.
2. **Dependencies**:
   - `jq`: For parsing JSON data.
   - `wget`: For downloading OS images.
   - `sha256sum`: For checksum verification.

Install the dependencies using your package manager:

#### Debian/Ubuntu
```bash
sudo apt update
sudo apt install jq wget coreutils
```

#### Fedora/CentOS
```bash
sudo dnf install jq wget coreutils
```

#### Arch Linux
```bash
sudo pacman -S jq wget coreutils
```

### Download the Script

Clone the repository or download the script directly:

```bash
git clone https://github.com/nics-cyber/freeroot-all-installer.git
cd freeroot-all-installer
```

Alternatively, download the script directly:

```bash
wget https://raw.githubusercontent.com/nics-cyber/freeroot-all-installer/main/freeroot_multi_os.sh
chmod +x freeroot_multi_os.sh
```

---

## Usage

1. **Run the Script**:
   ```bash
   ./freeroot_multi_os.sh
   ```

2. **Select an OS**:
   - The script will display a list of available operating systems.
   - Enter the ID of the OS you want to install.

3. **Download and Install**:
   - The script will download the OS image, verify its checksum, and guide you through the installation process.

---

## Adding More Operating Systems

To add more operating systems, edit the `OS_LIST_JSON` variable in the script. Follow this format:

```json
{
  "id": 14,
  "name": "Slackware",
  "version": "15.0",
  "url": "http://mirrors.slackware.com/slackware/slackware-iso/slackware64-15.0-install-dvd.iso",
  "checksum": "sha256:slackware_checksum_here"
}
```

Add the new entry to the `operating_systems` array in the `OS_LIST_JSON` variable.

---

## Contributing

We welcome contributions! If you'd like to add support for more operating systems, improve the script, or fix bugs, follow these steps:

1. Fork the repository.
2. Create a new branch for your changes:
   ```bash
   git checkout -b feature/new-os-support
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add support for Slackware"
   ```
4. Push your changes:
   ```bash
   git push origin feature/new-os-support
   ```
5. Open a pull request on GitHub.

---

## License

FreeRoot All Installer is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## Support

If you encounter any issues or have questions, please open an issue on the [GitHub repository](https://github.com/nics-cyber/freeroot-all-installer/issues).

---

## Acknowledgments

- Thanks to the open-source community for providing the tools and resources that made this project possible.
- Special thanks to the developers of `jq`, `wget`, and all the operating systems supported by this script.

---

Enjoy using FreeRoot All Installer! 🚀
