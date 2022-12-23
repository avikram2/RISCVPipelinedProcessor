#!/bin/bash

# Settings
ECE411DIR=$HOME/mp4
DEFAULT_TARGET=$ECE411DIR/mp4/sim/memory.lst
ASSEMBLER=/class/ece411/software/riscv-tools/bin/riscv32-unknown-elf-gcc
OBJCOPY=/class/ece411/software/riscv-tools/bin/riscv32-unknown-elf-objcopy
OBJDUMP=/class/ece411/software/riscv-tools/bin/riscv32-unknown-elf-objdump

# CHANGE FOR CP2
ADDRESSABILITY=32
# possible_error: change addressability.

# Command line parameters
ASM_FILE=$1
TARGET_FILE=${2:-$DEFAULT_TARGET}
ADDRESSABILITY=${3:-$ADDRESSABILITY}

# Print usage
if [[ "$#" -lt 1 ]]; then
    echo "Compile a RISC-V assembly file and write a memory file for simulation."
    echo "Usage: $0 <asm-file> [memory-file]"
    exit 0
fi

# Remove temporary directory on exit
cleanup()
{
    rm -rf -- "$WORK_DIR"
    # echo "$WORK_DIR"
}
trap cleanup exit

# Create temporary directory
WORK_DIR="$(mktemp -d)"

# Copy files to temporary directory
cp "$ASM_FILE" "$WORK_DIR"

# Fail if assembler cannot be found
if [ ! -x "$ASSEMBLER" ]; then
    echo "Cannot execute assembler at $ASSEMBLER." >&2
    echo "Make sure it exists and is executable." >&2
    exit 1
fi

OBJ_FILE="${WORK_DIR}/$(basename $ASM_FILE .asm).obj"

# Assemble code
"$ASSEMBLER" -ffreestanding -nostdlib -march=rv32i "${WORK_DIR}/$(basename $ASM_FILE)" -Wl,--no-relax -o "$OBJ_FILE"

# Fail if object file doesn't exist or has no memory content
if [[ ! -e "$OBJ_FILE" || "$(cat "$OBJ_FILE" | wc -c)" -le "1" ]]; then
    echo "Error assembling $ASM_FILE, not generating binary file" >&2
    exit 2
fi

# Fail if objcopy cannot be found
if [ ! -x "$OBJCOPY" ]; then
    echo "Cannot execute objcopy at $OBJCOPY" >&2
    echo "Make sure it exists and is executable." >&2
    exit 1
fi

BIN_FILE="${WORK_DIR}/$(basename $ASM_FILE .asm).bin"

"$OBJDUMP" -D "$OBJ_FILE" -Mnumeric
"$OBJCOPY" -O binary "$OBJ_FILE" "$BIN_FILE"
hexdump $BIN_FILE

# Fail if binary file doesn't exist or has no memory content
if [[ ! -e "$BIN_FILE" || "$(cat "$BIN_FILE" | wc -c)" -le "1" ]]; then
    echo "Error binarizing $OBJ_FILE, not generating memory file" >&2
    exit 3
fi

# Fail if the target directory doesn't exist
if [[ ! -d "$(dirname "$TARGET_FILE")" ]]; then
    echo "Directory $(dirname "$TARGET_FILE") does not exist." >&2
    echo "Did you specify the correct target path? Aborting." >&2
    exit 4
fi

# Ask if user wants to overwrite target
if [ -e "$TARGET_FILE" ]; then
    echo "Target file $TARGET_FILE exists."
    read -p "Overwrite? [y/N] " CONF
    shopt -s nocasematch
    if [[ "${CONF}" != "y" && "${CONF}" != "yes" ]]; then
        echo "Aborting." >&2
        exit 0
    fi
    shopt -u nocasematch
fi



# Write memory to file
function log2 {
    local x=0
    for (( y=$1-1 ; $y > 0; y >>= 1 )) ; do
        let x=$x+1
    done
    echo $x
}

z=$( log2 $ADDRESSABILITY )
hex="0x00000060"
result=$(( hex >> $z ))
mem_start=$(printf "@%08x\n" $result)

{
    echo $mem_start
    hexdump -ve $ADDRESSABILITY'/1 "%02X " "\n"' "$BIN_FILE" \
        | awk '{for (i = NF; i > 0; i--) printf "%s", $i; print ""}'
} > "$TARGET_FILE"

echo "Assembled $ASM_FILE and wrote memory contents to $TARGET_FILE"
