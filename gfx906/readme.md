# ROCm Gfx906 rocBLAS Library Patch

## Overview

This patch restores or supplements missing Tensile library files and matrix operation code objects for AMD gfx906 architecture GPUs (such as Radeon VII, MI50, and MI60) in ROCm installations where gfx906 kernels are omitted or incomplete.

It automatically scans the host machine to locate active rocBLAS library installation paths across both standard FHS deployments (such as Ubuntu under /opt/rocm/lib/rocblas/library) and Debian distribution packaging layouts (such as /usr/lib/x86_64-linux-gnu/rocblas/X.Y.Z/library).

## File Source Origin

The patch binaries in the patch/ directory originate from official AMD ROCm 5.7.3 release packages fetched from the upstream Radeon APT repository:

Source Repository: https://repo.radeon.com/rocm/apt/5.7.3/pool/main/r/rocblas/

The files were extracted from the rocblas package and filtered to isolate only the target gfx906 assembly code objects (.co), HIP source code objects (.hsaco), and Tensile manifest catalog files (.dat).

## Directory Structure

gfx906/
├── README.md
├── patch.sh
└── patch/
    ├── TensileLibrary_lazy_gfx906.dat
    ├── Kernels.so-000-gfx906-xnack-.hsaco
    └── (approx 150 total gfx906 library files)

## How to Use

1. Ensure all gfx906 binary files are placed inside the patch/ directory.

2. Make the patch script executable:
   chmod +x patch.sh

3. Execute the script:
   ./patch.sh

4. The script will request sudo privileges to write the payload into the system library directory, sync filesystem changes, and report the completion status.

