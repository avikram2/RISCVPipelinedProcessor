/*

COPYRIGHT 2020 University of Illinois at Urbana-Champaign
All rights reserved.

*/

#include <stdint.h>
#include "target.h"

#if TARGET == RISCV
#include <stdio.h>
#endif

int uncorrelated_branches_kernel(unsigned char test);
int correlated_branches_kernel(unsigned char test);
int test_uncorrelated_branches();
int test_correlated_branches();
int test_mixed();
int fib(int n);
int test_function_call ();

#if TARGET == EWS
int main()
#else
int _start()
#endif
{
#if TARGET == TARGET_RISCV
    volatile register unsigned status asm ("s10")  = 0xDEFFDEFF; // default value
#else
    register unsigned status = 0xDEFFDEFF; // default value
#endif

    int error = 0;
    error |= test_uncorrelated_branches();
    error |= test_correlated_branches();
    error |= test_mixed();
    error |= test_function_call();

    if (error) {
        #if TARGET == EWS
            printf("something went wrong\n");
        #endif
        status = 0x00BADBAD;
        goto done;
    }

    status = 0x600D600D;
done:
    #if TARGET == EWS
        return 0;
    #else
        while(1);
        return status;
    #endif
}

int uncorrelated_branches_kernel(unsigned char test) {
    unsigned char out = 0;
    // here we have 8 branches at 8 distinc PC addresses
    if (test & 0x1) {
        out |= 0x1;
    } else {
        out = out;
    }
    if (test & 0x02) {
        out |= 0x02;
    } else {
        out = out;
    }
    if (test & 0x04) {
        out |= 0x04;
    } else {
        out = out;
    }
    if (test & 0x08) {
        out |= 0x08;
    } else {
        out = out;
    }
    if (test & 0x10) {
        out |= 0x10;
    } else {
        out = out;
    }
    if (test & 0x20) {
        out |= 0x20;
    } else {
        out = out;
    }
    if (test & 0x40) {
        out |= 0x40;
    } else {
        out = out;
    }
    if (test & 0x80) {
        out |= 0x80;
    } else {
        out = out;
    }
    return out;
}

int correlated_branches_kernel(unsigned char test) {
    unsigned char out = 0;
    if (test & 0x01) {
        out |= 0x01;
    } else {
        out = out;
    }
    if ((test & 0x03) == 0x03) {
        out |= 0x03;
    } else {
        out = out;
    }
    if ((test & 0x07) == 0x07) {
        out |= 0x07;
    } else {
        out = out;
    }
    if ((test & 0x0F) == 0x0F) {
        out |= 0x0F;
    } else {
        out = out;
    }
    if ((test & 0x1F) == 0x1F) {
        out |= 0x1F;
    } else {
        out = out;
    }
    if ((test & 0x3F) == 0x3F) {
        out |= 0x3F;
    } else {
        out = out;
    }
    if ((test & 0x7F) == 0x7F) {
        out |= 0x7F;
    } else {
        out = out;
    }
    if ((test & 0xFF) == 0xFF) {
        out |= 0xFF;
    } else {
        out = out;
    }
    return out;
}

int test_uncorrelated_branches() {
    unsigned char test = 0;
    unsigned char out = 0;
    // test local branch histroy table
    for (test = 0; test < 255; test ++) {
        out = uncorrelated_branches_kernel(test);
        //sanity check
        if (out != test) {
            return 1;
        }
    }
    return 0;
}

int test_correlated_branches() {
    unsigned char test = 0;
    unsigned char out = 0;
    unsigned char golden = 0;
    // test local branch histroy table
    for (test = 0; test < 255; test ++) {
        out = correlated_branches_kernel(test);
        //sanity check
        golden = ~test & (test + 1);
        golden --;
        //printf("0x%x 0x%x 0x%x\n", test, out, golden);
        if (out != golden) {
            return 1;
        }
    }
    return 0;
}

int test_mixed() {
    unsigned char test = 0;
    unsigned char out1 = 0, out2 = 0;
    unsigned char golden = 0;
    // test local branch histroy table
    for (test = 0; test < 255; test ++) {
        out1 = uncorrelated_branches_kernel(test);
        out2 = correlated_branches_kernel(test);
        //sanity check
        golden = ~test & (test + 1);
        golden --;
        //printf("0x%x 0x%x 0x%x\n", test, out, golden);
        if (out1 != test || out2 != golden) {
            return 1;
        }
    }
    return 0;
}

int fib(int n) {
    if (n <= 1)
        return n;
    return fib(n-1) + fib(n-2);
}



int test_function_call ()
{
    int n = 12;
    #if TARGET == EWS
        printf("fib(%d) = %d\n", n, fib(n));
    #else
        fib(n);
    #endif
    return 0;
}
