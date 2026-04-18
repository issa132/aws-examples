Introduction to EBS
What is IOPS?
IOPS stands for Input/Output Per Second. It is the speed at which non-contiguous reads and writes can be performed on a storage medium. High I/O = lots of small, fast reads and writes.
What is Throughput?
The data transfer rate to and from the storage medium in megabytes per second.
What is Bandwidth?
Bandwidth is the measurement of the total possible speed of data movement along the network.

Think of Bandwidth = Pipe and Throughput = Water


Quick comparison:
Concept                 Definition                                      Unit
IOPS                    Speed of non-contiguous reads/writes            Operations/second
Throughput              Actual data transfer rate                       MB/s
Bandwidth               Maximum possible data movement speed            MB/s or Gbps

Key distinction: Bandwidth is the capacity of the pipe, Throughput is how much water is actually flowing through it, and IOPS measures how frequently you can read/write small chunks of data.

# Elastic Block Store (EBS) is a highly available and durable solution for attaching persistent block storage volumes to an EC2 instance.
Volumes are automatically replicated within their Availability Zone (AZ) to protect from component failure.
The types of volumes you can deploy:

General Purpose SSD (gp2) — for general usage without specific requirements
General Purpose SSD (gp3) — up to 20% lower cost per GB than gp2
Provisioned IOPS SSD (io1) — when you require really fast input & output
Provisioned IOPS SSD (io2) — more durable than io1
io2 Block Express — higher throughput and IOPS and support larger storage capacity
Cold HDD (sc1) — Lowest cost HDD volume for infrequently accessed workloads
Throughput Optimized HDD (st1) — magnetic drive optimized for quick throughput
Magnetic (standard) — previous generation HDD


Quick reference:
Type                    Category                Best For
gp2 / gp3                 SSD                   General purpose
io1 / io2                 SSD                   High-performance, low latency
io2 Block Express         SSD                   Highest IOPS & throughput
st1                       HDD                   Frequent, sequential access
sc1                       HDD                   Infrequent access, lowest cost
standard                  HDD                   Legacy / previous gen


# 04:20
Storage Volumes – HDD

Hard Disk Drive (HDD) is magnetic storage that uses rotating platters, an actuator arm, and a magnetic head (similar to a record player). HDD is very good at writing a continuous amount of data. HDD is not great for writing many small reads and writes (think of the arm of the record player having to lift up and down and move around).

Better for Throughput
Physical Moving Part
RPMs (Revolutions Per Minute) — the speed at which the drive's platters spin. Faster RPMs means faster access times. Slower RPMs means better cost-savings.

7200 RPM Drives: These are standard for desktops and high-performance external drives, offering a good balance of performance, cost, and power consumption.

5400 RPM Drives: Often used in laptops, external hard drives, and applications where lower power consumption and heat are priorities over top performance.

10000 RPM Drives: Mostly found in enterprise environments or high-end workstations where performance is critical, though these are less common today due to the rise of solid-state drives (SSDs).

RPM	        Use Case
5400	Laptops, low-power devices
7200	Desktops, standard performance
10000	Enterprise, high performance


# Storage Volumes – HDD RAID
RAID (redundant array of independent disks) is a data storage virtual technology for magnetic disks (not magnetic tape) to improve fault tolerance. RAID combines multiple physical volumes into one logical group, storing redundant data across disks. Since HDD has mechanical parts and will result in wear, HDD is more prone to failure than SSD.

RAID 0 (Striping = rayure)

No redundancy; data is split across disks for high performance
Increases speed and capacity but offers no fault tolerance
Minimum of 2 disks required

RAID 1 (Mirroring)

Data is duplicated on two or more disks, offering high redundancy
If one disk fails, data is still accessible from another
Requires at least 2 disks

RAID 5 (Striping with Parity)

Combines striping and parity for both speed and data protection
Can withstand the failure of one drive without data loss
Requires at least 3 disks

RAID 6 (Striping with Double Parity)

Similar to RAID 5 but with double parity, allowing it to survive the failure of two disks
Requires at least 4 disks

RAID 10 (1+0)

A combination of RAID 1 and RAID 0, offering redundancy and increased performance
Requires a minimum of 4 disks


RAID        Min Disks       Redundancy              Performance
02              ❌              None                ⚡Highest
1               2               ✅High              Moderate
5               3               ✅ 1 disk failure   Good
6               4               ✅ 2 disk failures  Moderate
10              4               ✅ High             ⚡High

Solid State Drive (SSD)
Uses integrated circuit (IC) assemblies as memory to store data persistently, typically using flash memory (NAND Flash Memory).
SSDs are more resistant to physical shock, run silently, and have quicker access time and lower latency.

Very good at frequently reads and writes (I/O)
No physical moving parts


SSD Types:
SATA SSDs: Widely used, compatible with most computers, offering good performance but slower than NVMe due to SATA interface limitations.
NVMe SSDs: Use the PCIe interface for higher performance. Ideal for intensive data tasks and gaming, available in M.2 or PCIe card form factors.
M.2 SSDs: Compact, suitable for laptops and compact PCs, can use SATA or NVMe interfaces. They are installed directly on the motherboard.
U.2 SSDs: Similar in performance to M.2 NVMe SSDs but designed for 2.5-inch drive bays, mainly used in enterprise and server environments.
Portable SSDs: External drives for easy portability, connecting via USB or Thunderbolt. Offer SSD speed and durability on the go.
PCIe SSDs: Add-on cards that provide high performance for older systems or specialized tasks, fitting into the motherboard's PCIe slots.

Type        Best For                    Speed
SATA        General use                 Moderate
NVMe        High performance, gaming    ⚡ Very fast
M.2         Laptops, compact builds     Fast
U.2         Enterprise servers          ⚡ Very fast
Portable    On-the-go storage           Moderate
PCIe        Specialized/legacy systems  ⚡ Fast

# Serial Advanced Technology Attachment (SATA) SSDs:
These are the most common and are compatible with the Serial ATA interface, used by most desktop and laptop computers. They are relatively easy to install and offer good performance, though they are typically slower than their NVMe counterparts due to the limitations of the SATA interface.

# (Peripheral Component Interconnect Express) PCIe SSDs: These SSDs are add-on cards that fit into the PCIe slots on a motherboard. They can offer very high performance, especially in configurations that support NVMe. They are a good option for users looking to upgrade older systems or for specialized high-performance tasks. PCIe slots on a motherboard come in different sizes, referred to as "lanes"

# (Non-Volatile Memory Express) NVMe SSDs
NVMe SSDs use the PCIe interface, offering significantly higher performance compared to SATA SSDs. They are designed to take full advantage of the high speeds of flash-based storage technologies. NVMe drives are found in the form of M.2 SSDs but can also be added to a computer using a PCIe expansion slot.

M.2 SSDs
Compact, suitable for laptops and compact PCs, can use SATA or NVMe interfaces. They are installed directly on the motherboard.
U.2 SSDs
Similar in performance to M.2 NVMe SSDs but designed for 2.5-inch drive bays, mainly used in enterprise and server environments. They generally connect via a U.2 port.

                        M.2                             U.2
                        
Form factor         Compact, motherboard-mounted        2.5-inch drive bay
Interface           SATA or NVMe                        NVMe via U.2 port
Best for            Laptops, compact PCs                Enterprise, servers


# Magnetic Tape
A large reel of magnetic tape. A tape drive is used to write data to the tape. Medium and large-sized data centers deployed both tape and disk formats. They normally come in the form of a cassette. Magnetic tape is very cheap to produce and can store a considerable amount of data.

Durable for decades (good for at least up to 30 years)
Cheap to produce


