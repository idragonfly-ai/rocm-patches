# ROCm Architecture Binary Patches

This repository contains targeted binary patches, Tensile library additions, and deployment scripts for AMD ROCm installations across specific GPU architectures.

## Supported Architectures

* gfx906: Contains rocBLAS Tensile library patches and automated installation scripts for Radeon VII, MI50, and MI60 GPUs on Debian and Ubuntu.
* gfx1030: Patches and configuration overrides for RX 6800, RX 6800 XT, and RX 6900 XT series GPUs.

## Usage

Navigate into the specific architecture directory for detailed installation instructions and execution scripts:

cd gfx906 ./patch.sh
