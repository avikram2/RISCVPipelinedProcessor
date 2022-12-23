# Author: ECE 411 Staff, Umur Darbaz
# This script is provided to you as a compilation wrapper. The flags are needed to properly
# compile the RISCV assembly for Spike (RISCV-ISA-SIMULATOR) Baremetal mode.

RISCV_GCC=riscv32-unknown-elf-gcc
LINK_FILE=./baremetal_link.ld
FLAGS="-march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -T$LINK_FILE -Wl,--no-relax"
BINARY_NAME=riscv_test_bin

if [ -z "$1" ]; then
  echo "ERROR: An assembly source file must be provided."
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "ERROR: The specified source file $1 does not exit."
  exit 2
fi

$RISCV_GCC $FLAGS -o $BINARY_NAME $1
