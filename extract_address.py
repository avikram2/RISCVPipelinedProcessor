from collections import Counter
import sys

TAG_BITS = 24
INDEX_BITS = 3

ZERO = "000000000000000000000000000"

VERBOSE = True

def parse_data(filename):
    with open(filename) as fp:
        lines = fp.readlines()	
    filtered_lines = [line[line.rfind("=")+1:].strip() for line in lines if line.strip().startswith("a_pmem_address")]
    filtered_lines = [addr for addr in filtered_lines if 'x' not in addr]
    #careful, python indexing doesn't include the end index (unlike sys verilog) and is the other way!

    address_counter = Counter(filtered_lines)

    #address_set = set(filtered_lines)

    distinct_addresses = [key for key in address_counter.keys() if key != ZERO]  

    print("Number of distinct non-zero and non-x addresses, which resolve to the same cache line, is {}".format(len(distinct_addresses)
))
    if (VERBOSE):
        with open(filename + '_addr_set.txt', 'w') as fp:
            fp.writelines(map(lambda x: x + '\n', distinct_addresses))

if __name__ == "__main__":
    parse_data(sys.argv[1])
