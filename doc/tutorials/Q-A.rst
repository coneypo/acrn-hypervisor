ACRN Q&A
########
Feature
########

Q1. Does ACRN can run on ARM  except the Intel platform ?

.. code-block:: none

   Not yet, but support ARM is on our ACRN roadmap

Q2. Is there any map application on the ACRN project ? 

.. code-block:: none

   No map application so far from ACRN open source.
   ACRN just provides reference hypervisor and work with other projects.Like clearlinux, Android and support them to make sure they are able to run on the ACRN.

Q3. Which version of windows is expected to be supported by ACRN?

.. code-block:: none

   Plan 2019

Q4. If ACRN support the Windows, whether includes WinCE ?(Industry HMI still has a lot of devices using WinCE)

.. code-block:: none

   Plan Windows 10

Q5. How to run Celadon as a Guest OS on ACRN on NUC ?

.. code-block:: none

   We¡¯re still working on a setup guide now because Celadon and ACRN's kernel has updated to 4.19

Q6. Does SOS and UOS communicate with RPMSG in Intel ? if has RPMSG, which one has higher efficiency ? Does intel has plan to add RPMSG?

.. code-block:: none

   Not yet, but once add, it  will support in principle;
   Theoretically RPMSG has higher efficiency, RPMSG protol is more simple, RPMSG¡¯s master and slave communicates via RPMSG¡¯s backend as the switch;

   Not yet about add RPMSG.

Q7. Which hardware platform already support CAT in Intel?

.. code-block:: none

   APL(Apollo Lake);some server platforms and CORE platforms also support

Boot up
####################
Q1. How to fix "Fail to install Image on the APL NUC when use the USB storage"?

.. code-block:: none

    Change the Config ¡°Secure Boot -> no check¡±. 

    Details: How to modify this  parameter:

    a: Press ¡°F2¡± to enter the interface when bootup the NUC

    b: No check ¡°Secure Boot¡± on the ¡°Boot¡± option

Q2. What¡¯s about ACRN Android guest partition? Whether can use fastboot to flash Android some system or data?

.. code-block:: none

   It¡¯s one big image file, Android guest has a lot of partition on this Image file;

   Yes

Q3. How to enter vfastboot? 

.. code-block:: none

   Use the vsbl debug image, choose enter mode by vfastboot on the cmd console, it can flash Android different partition

Q4. For ACRN instrument panel OS, will it use Yocto or Clearlinux ?

.. code-block:: none

   Now focus on Clearlinux as SOS in our ACRN release and test, but customer can choose some one as their SOS, such as Yocto or Clearlinux.

Q5. User-Android  fail to boot up with the status: physical storage is 4G, Aaag use 3000M, but Debug-Android success to boot up

.. code-block:: none

   The storage firstly distribute all to SOS, then dm will distribute from hugetlb, so if make sure SOS can be run with 1G, Android can get 3G

Q6. Does it must need signature when generate sos_boot using iasImage ? And where can get public key ?

.. code-block:: none

   YES
   Please refer below link:
   _`<https://download.clearlinux.org/secureboot/DefaultIASSigningPrivateKey.pem>`_ 

Q7. How does the UEFI BIOS deal with the acrn.efi and loader config file ?

.. code-block:: none

   UEFI -> ACRN.EFI ->OS Bootloader -> SOS Kernel -> ACRN Device Model -> v-bootloader

   More info please refer  https://projectacrn.github.io/latest/introduction/index.html 

Q8. ACRN boot up time is long at the KBL NUC(i7&i5), also console prints : ¡°VMX ctrl 0x48b not fully enabled: request 0x18b but get 0x8b¡±

.. code-block:: none

    Remove CONFIG_SERIAL_8250_PNP=y from kernel_config_uefi_sos

Q9. How to pass through off-chip USB controller ?

.. code-block:: none
 
   (a). Find out the physical BDF (bus:device.function) for USB Host

   $lspci

   <output>...
   *00:15.0*  USB controller: Intel Corporation Celeron N3350/Pentium N4200/Atom E3900 Series USB xHCI (rev 0b) ...

   (b). Find out the numeric PCI ID for USB Host
   $lspci -n

   <output>...
   *00:15.0*  0c03:*8086:5aa8*  (rev 0b)
   ...

   (c). Hide the PCI device in SOS via stub driver

   Execute the following commands to hide the PCI device "00:15.0" in SOS

   echo "8086 5aa8" > /sys/bus/pci/drivers/pci-stub/new_id

   echo "0000:00:15.0" > /sys/bus/pci/devices/0000:00:15.0/driver/unbind

   echo "0000:00:15.0" > /sys/bus/pci/drivers/pci-stub/bind

   You could double-check whether the PCI device is hidden successfully via the following command.

   $cat /sys/bus/pci/devices/0000:00:15.0/uevent

   If it is done successfully, the driver will be shown as 'pci-stub'. 

   If lspci is not found in your clearlinux sos, you can install the tool by/

   /swupd bundle-add sysadmin-basic

Q10. If rpmb key has issue, will it affect vsbl load Android ?

.. code-block:: none

   NO

   Because virtual rpmb hasn¡¯t realize on the ACRN, after realize ,it doesn¡¯t affect the vsbl, but affect Android Disk Encryption

Q11. Which system does the SOS support ?

.. code-block:: none

   clear linux, ubuntu, using the ubuntu as SOS please refer: https://projectacrn.github.io/latest/tutorials/using_ubuntu_as_sos.html 

Q12. How does the  Android bootup on the ACRN?

.. code-block:: none

   Android can be the guest on the ACRN now. The process is  Download Hypervisor from ACRN project, and download SOS from clearlinux, then get Android from Celadon(Will update related doc next).

Q13. ABL Version 1804 fail to load iasimage(but 1820 can load iasimage)

.. code-block:: none

   ABL 1804 format is raw. ABL support raw/fs boot format, but 1820 default adopt s raw format.

Q14. Does the ACRN support real-time?

.. code-block:: none

   Plan vxworks, Zephyr,preempt-RT Linux 

Q15. APL NUC/KBL NUC/UP2 fail to boot up when allocate memory > 16G

.. code-block:: none

    You must modify hypervisor/arch/x86/Kconfig:
If memory is 32G, setup PLATFORM_RAM_SIZE = 32G

.. code-block:: none

  config PLATFORM_RAM_SIZE
        hex "Size of the physical platform RAM"
        default 0x200000000 if PLATFORM_SBL
        default 0x800000000 if PLATFORM_UEFI

setup SOS_RAM_SIZE =32G too (The SOS will have the whole resource)

.. code-block:: none

  config SOS_RAM_SIZE
        hex "Size of the vm0 (SOS) RAM"
        default 0x200000000 if PLATFORM_SBL
        default 0x800000000 if PLATFORM_UEFI

setup UOS_RAM_SIZE to what you need, here setup 16G

.. code-block:: none

  config UOS_RAM_SIZE
        hex "Size of the User OS (UOS) RAM"
        default 0x100000000 if PLATFORM_SBL
        default 0x400000000 if PLATFORM_UEFI

setup HV_RAM_SIZE(We will reserve memory for guest EPT paging table), if you setup 32G(default 16G),you must enlarge it with (32G-16G)/2M pages which size is 4K, below is after changed to 240M

.. code-block:: none

  config HV_RAM_SIZE
    hex "Size of the RAM region used by the hypervisor"
    default 0x07800000 if PLATFORM_SBL
    default 0x0f000000 if PLATFORM_UEFI


Q16. There is no code about setting ¡°tty ldisc¡± in the dm ioc code part, how does the cbc data send to the ioc ?

.. code-block:: none

   dm send the cbc header¡¯s uart packet, UOS kernel uses the cbc ldisc to analysis data. when systemd bootup cbc_attch, will set SOS cbc ldisc, and other SOS process  reveice/send cbc service data via directly open cbc char device.

Q17. Intel processor access the peripherals devices through IN/OUT instruction?

.. code-block:: none

   PCIE use IO and MMIO

Resource
########
Q1. Where can get vt-x vt-d detail spec?

.. code-block:: none

  VT-X: _`<https://software.intel.com/en-us/articles/intel-sdm>`_ 

  VT-D: _`<https://software.intel.com/sites/default/files/managed/c5/15/vt-directed-io-spec.pdf>`_

Q2. Whether Intel GPU spec is open?

.. code-block:: none

  _`<https://01.org/linuxgraphics/documentation/hardware-specification-prms>`_. 
