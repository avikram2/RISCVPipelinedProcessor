make clean
make sim/simv
make run ASM=testcode/$1 > "$1_address_log.txt"
python3 extract_address.py "$1_address_log.txt"



