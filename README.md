# How to setup and install Android x86 on VirtualBox

This guide details the necessary steps to get the virtual machine up and running with the Android x86 image on VirtualBox.

Note, that this guide will **not (yet)** detail the necessary cli commands to setup the machine.
Therefore, some steps have to performed via the GUI.

Attention: it is assumed, that the scripts are called from within the directory `platform-setup` (i.e. `$PWD
=platform-setup`)

The Android image and a prepared adeb rootfs can be downloaded from [here](https://uni-bonn.sciebo.de/s/s2z65Xs8eN4DHQc
).
## Virtual Machine Profile

Setting up the virtual machine:
- **Processor:** at least 2 cores

- **RAM:** at least 2 GB

- **Storage:** 10 - 15 GB should be enough for most scenarios

- **Video Memory:** don't be too thrifty here

- **!! IMPORTANT !!:** set graphics controller to `VBoxVGA`, otherwise the GUI will not be rendered!!!

- **Network:** Set it up the way you want, but keep in mind you should set it up so you can connect to it via `adb`
    - The `Bridged Network Adapter` is probably the easiest way to get the networking part working (for adb and internet access)
    - However, since we are dealing with potentially dangerous software here, **consider redirecting the traffic to protect your network from the assailant**


## Installation of Android x86 on the machine
- Download the iso image from [this](https://uni-bonn.sciebo.de/s/s2z65Xs8eN4DHQc/download?path=%2F&files=android_x86_64.7.1-r4-ikheaders.iso) link

- Now start the machine and VirtualBox usually asks to select an image to boot from. Chose the `android_x86_64.7.1-r4-ikheaders.iso` file here

- The installation itself is pretty straightforward. 
  Just try to:
    - **not install GPT**
    - **install grub**
    - and to **install system as read/writable**

- unmount the image from VirtualBox and reboot


## Setting up the rest (network, houdini, ebpf, etc.)
This section details the steps finalize the setup of the machine to get it ready for takeoff.

Also, it is assumed, that the machine has already been installed and is already booted up.

### Network Setup
In this section it is assumed, that the `Bridged Network Adapter` has been used in the machine setup. However, these steps/principles should, for the most part, also work with different setups.

- Use the drag-down menu on the GUI, as you would on a real smartphone, activate WiFi and select `VirtWifi`
- Wait until the system is connected
- To quickly check the assigned IP address:
    - get a `TTY` by pressing `Alt+F1`
    - execute `ifconfig` and note the ip address assigned to the machine
    - switch back to the GUI with `Alt+F7`

- Once you have the address you can connect to the machine with `adb`
    - precautiously execute `adb kill-server` 
    - execute `adb connect $IP`
    - now connect with `adb shell`
    - In case you did not get a shell, check if a firewall rule is preventing the connection
    - Maybe switch to `Host only network Adatper` if you cannot solve the issue


### Getting Houdini to work
In theory the Android x86 comes with a handy script installed, that should take care of the setup of houdini. However, the urls in that script and other functionalities (namely wget) do not work well together.

For this reason use the script `./install/setup_houdini.sh` instead.
- execute `setup_houdini.sh`
- Make sure to also activate houdini via the Settings GUI
    - `Settings -> App compatibility -> Enable native bridge`


### Installing ADEB and BCC

There are two ways to install ADEB and BCC:

#### Install from scratch
- execute `./install/install_adeb_and_bcc.sh`
- keep in mind, that this will take a long time, as the root fs and BCC have to be build and compiled from scratch

#### Download and install the already prepared rootfs
- The prepared rootfs file can be directly downloaded from [here](https://uni-bonn.sciebo.de/s/s2z65Xs8eN4DHQc/download?path=%2F&files=androdeb-fs-androidx86.tgz)
- execute `./install/install_already_prepared_rootfs.sh <path-to-file>`
- benefit of this install method is a noticably shorter prepare time

#### Test it
To check if bcc is up and running:
- execute `./launch_adeb_shell.sh` to spawn a shell into the chroot-environment
- then execute e.g. `opensnoop` or `execsnoop`
- if no error occurred and the first results come up, the platform is good to go



## Additional preparations when working with the platform
In this section steps are detailed, that may be required to be executed after every platform start


### Fix mountpoints in chroot environment
Adeb does not automatically mount every interesting path of the Android system into the chrooted environment. 
For example, the paths to the "`sdcard`" are missing and not accessible from within the adeb environment.
This can be detrimental to the analysis, since some apps might write to these locations.

To fix this:
- execute `./misc/prepare_mounts_androix86.sh`


### Push ebpf-programs to chrooted environment
To quickly push the current state of the `ebpf-programs` directory:
- execute `./misc/push_ebpf_programs.sh`



## Miscellaneous

### Fixing `build.prop` for hiding from a root detection method
This android image has been built with default test keys, which results in `test-keys` being set as build properties.
Some root detection mechanisms use this information to sniff out rooted environments.
To fix this, a script is included, that patches that file to eliminate this simple indicator.

- execute `./misc/fix_build_prop.sh`
- **IMPORTANT:** reboot to make the changes have an effect!


### Installing a root certificate and redirecting to a proxy server
For obvious reasons it can be useful to let the system communicate through a proxy server.
Especially, if the proxy server terminates TLS connections.

To do this on this platform:
- execute `./misc/install_custom_root_cert.sh <path-to-root-cert>`
- reboot the platform to let the system register the added root certificate
- execute `./misc/redirect_to_proxy.sh <proxy-ip>:<proxy-port>`
- Check if it worked by opening the Webview browser on the platform and connecting to websites


### Installing Google Services
Every now and then it is useful or even mandatory to have the Google services on an android platform. For example, when an app relies on GMS. In this project a script is included that swiftly integrates gms and vending onto the android-x86 machine.
This is done by using the OpenGApps project.

To do so:
- execute (for pico) `./misc/install_open_gapps_pico.sh` -> recommended
- execute (for stock) `./misc/install_open_gapps_stock.sh`
