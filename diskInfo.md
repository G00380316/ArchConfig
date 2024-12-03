# Disk and Partitioning Utilities Cheatsheet

## Viewing Disk Information

- **`lsblk`**: List block devices (disks, partitions)
  ```bash
  lsblk

    fdisk -l: List all partitions and disks (works with MBR partitions)

sudo fdisk -l

parted -l: List all partitions (supports GPT)

sudo parted -l

blkid: Show block device attributes (filesystem types, UUIDs, etc.)

    sudo blkid

Partitioning with gdisk (GPT)

    gdisk /dev/sda: Open gdisk for partitioning a disk (use /dev/sda or your disk name)

sudo gdisk /dev/sda

p: Print partition table

p

d: Delete a partition

d

n: Create a new partition

n

w: Write changes to disk

w

q: Quit without saving changes

    q

Partitioning with fdisk (MBR)

    fdisk /dev/sda: Open fdisk for partitioning a disk (use /dev/sda or your disk name)

sudo fdisk /dev/sda

m: Display help

m

p: Print the partition table

p

d: Delete a partition

d

n: Create a new partition

n

t: Change partition type

t

w: Write changes to disk

w

q: Quit without saving changes

    q

Formatting Partitions

    mkfs.ext4: Format partition with ext4 (Linux)

sudo mkfs.ext4 /dev/sda1

mkfs.ntfs: Format partition with NTFS (Windows)

sudo mkfs.ntfs /dev/sda1

mkfs.vfat: Format partition with FAT32 (for cross-platform compatibility)

    sudo mkfs.vfat -F 32 /dev/sda1

Mounting and Unmounting Partitions

    mount: Mount a partition to a directory

sudo mount /dev/sda1 /mnt/mydrive

umount: Unmount a partition

sudo umount /dev/sda1

mount -t ext4 /dev/sda1 /mnt/mydrive: Mount a specific filesystem type (ext4 in this case)

sudo mount -t ext4 /dev/sda1 /mnt/mydrive

lsblk -f: Show partitions and their filesystem types

    lsblk -f

Filesystem Repair

    fsck: Check and repair a Linux filesystem (ext4)

sudo fsck /dev/sda1

ntfsfix: Attempt to fix an NTFS filesystem

    sudo ntfsfix /dev/sda1

Resize Partitions

    resize2fs: Resize ext2/ext3/ext4 filesystems (after resizing the partition)

sudo resize2fs /dev/sda1

parted: Resize partitions (use resize command inside parted)

    sudo parted /dev/sda

Partition Backup and Restore

    dd: Clone a disk or partition (dangerous, make sure to double-check source and target)

sudo dd if=/dev/sda1 of=/path/to/backup.img bs=64K status=progress

Restore using dd: Restore a partition from an image

    sudo dd if=/path/to/backup.img of=/dev/sda1 bs=64K


