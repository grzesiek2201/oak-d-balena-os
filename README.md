### Docker container for BalenaOS that supports hotplugging USB (oakd camera)
In order to use oakd camera (usb) with BalenaOS, it's necessary to allow for device hotplugging inside the container.

Each time the camera is opened, it disconnects and reconnects to the pc. This makes it change it's bus address, and thus, it's necessary to enable hotplugging (without balena it's as simple as volume sharing the /dev/bus directory).

### This repository
This repository provides a simple example of creating a Docker image, that enables device hotplugging.
It should serve as a template or inspiration for creating customized docker images.

### Testing inside the container
Once deployed to the device, an easy test to see if the hotplugging works is to either connect the oakd camera and run this simple script:
```
python3
```
```
import depthai as dai

device = dai.Device()
print("Connected to:", device.getMxId(), device.getDeviceName())
```

#### or

Plug in the camera, check its bus address (e.g. lsusb), replug the camera and check the bus address again. If this address is available under /dev/bus/usb/00x/00y, then hotplugging works.
```
apt-get update
apt-get install usbutils
```
```
lsusb
>> Bus 001 Device 005: ID 03e7:2485 Intel Movidius MyriadX
```
```
ls /dev/bus/usb/001/005 
>> /dev/bus/usb/001/005
```
** replug the camera **

```
lsusb
>> Bus 001 Device 006: ID 03e7:2485 Intel Movidius MyriadX
```
```
ls /dev/bus/usb/001/006
>> /dev/bus/usb/001/006
```
### Credits
https://forums.balena.io/t/x11-hotplug-usb/7250/36