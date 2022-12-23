/*

COPYRIGHT 2020 University of Illinois at Urbana-Champaign

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

*/

#define TARGET_EWS 1
#define TARGET_RISCV 2
#define TARGET TARGET_RISCV

#if TARGET == TARGET_EWS
#include <stdio.h>
#endif

#define PASS    0x600d600d
#define FAIL    0x0badc0de

#define N       12
#define M       7
#define INC     29
#define MOD     41
//#define EXPECTED 10403194620
#define EXPECTED 77385916320

int gcd(int a, int b);

long long lcm(int a, int b);

long long iter(int * arr, int n);

#if TARGET == TARGET_EWS
int main() {
#else
int _start() {
#endif

#if TARGET == TARGET_RISCV
    volatile register unsigned status asm ("s10")  = 0xDEFFDEFF; // default value
#else
    register unsigned status = 0xDEFFDEFF; // default value
#endif

    unsigned i;
    int nums[N][N];
    nums[0][0] = 60;
    for (i = 1; i < N * N; i++) {
        nums[i / N][i % N] = (M * nums[(i-1) / N][(i-1) % N] + INC) % MOD;
    }

    unsigned long long lcms[N];
    for (i = 0; i < N; i++) {
        lcms[i] = iter(nums[i], N);
    }

    unsigned long long sum = 0;
    for (i = 0; i < N; i++) {
        sum += (i+1) * lcms[i];
    }

    status = (sum == EXPECTED) ? PASS : FAIL;

#if TARGET == TARGET_EWS
    printf("\n%llu\n", sum);
    printf("%x\n", status);
    return 0;
#else
    while(1);
#endif
}

int gcd(int a, int b) {
    if (a == 0 && b == 0) {
        return 1;
    }
    int rem;
    if (a < b) {
        rem = a;
        a = b;
        b = rem;
    }
    while (a != 0 && b != 0) {
        rem = a % b;
        a = b;
        b = rem;
    }
    return a ? a : b;
}

long long lcm(int a, int b) {
    return (long long)a * (b / gcd(a, b));
}

long long iter(int * arr, int n) {
    if (n == 0) {
        return -1;
    }
    int i;
    long long curr = arr[0];
    for (i = 1; i < n; i++) {
        curr = lcm(curr, arr[i]);
    }
    return curr;
}

unsigned long
__udivmodsi4(unsigned long num, unsigned long den, int modwanted)
{
  unsigned long bit = 1;
  unsigned long res = 0;

  while (den < num && bit && !(den & (1L<<31)))
    {
      den <<=1;
      bit <<=1;
    }
  while (bit)
    {
      if (num >= den)
	{
	  num -= den;
	  res |= bit;
	}
      bit >>=1;
      den >>=1;
    }
  if (modwanted) return num;
  return res;
}

long
__divsi3 (long a, long b)
{
  int neg = 0;
  long res;

  if (a < 0)
    {
      a = -a;
      neg = !neg;
    }

  if (b < 0)
    {
      b = -b;
      neg = !neg;
    }

  res = __udivmodsi4 (a, b, 0);

  if (neg)
    res = -res;

  return res;
}

long
__modsi3 (long a, long b)
{
  int neg = 0;
  long res;

  if (a < 0)
    {
      a = -a;
      neg = 1;
    }

  if (b < 0)
    b = -b;

  res = __udivmodsi4 (a, b, 1);

  if (neg)
    res = -res;

  return res;
}

long
__udivsi3 (long a, long b)
{
  return __udivmodsi4 (a, b, 0);
}

long
__umodsi3 (long a, long b)
{
  return __udivmodsi4 (a, b, 1);
}

unsigned long long
__muldi3 (unsigned long long a, unsigned long long b)
{
  unsigned long long r = 0;

  while (a)
    {
      if (a & 1)
    r += b;
      a >>= 1;
      b <<= 1;
    }
  return r;
}
