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

#include "target.h"
#include "comp3_data.h"
#include <stdint.h>

#if TARGET == TARGET_EWS
#include <stdio.h>
#endif

#define EXECUTION_TYPE 'N'
#define EXECUTION_SUBTYPE 'E'
#define TRADE_PUT 'P'
#define TRADE_CALL 'C'
#define SIDE_BUY 'B'
#define SIDE_SELL 'S'

#define LIQUIDITY_MAKER 1
#define LIQUIDITY_TAKER 2

#define RISK_THRESHOLD 100

struct exec_notification
{
    char     type;
    char     subtype;
    char     trade_type;
    char     side;
    uint32_t timestamp;
    uint32_t price;
    char     symbol [5];
    uint16_t contracts;
    uint8_t  liquidity;
    uint16_t strike;
    uint16_t expiration;
    uint64_t message_id;
} __attribute__ ((__packed__));

_Static_assert (sizeof(struct exec_notification) == 32, "Cacheline size mismatch");

unsigned long long old_message_id = 0;
unsigned int contracts_processed = 0;
int puts_count = 0;
int calls_count = 0;

unsigned int process_execution(struct exec_notification*);

#define CHECK_EVERY 200
#define STRIDE 3
#define CHECK_STRIDE 80
#define MESSAGE_STRIDE sizeof(struct exec_notification) * STRIDE

#if TARGET == TARGET_EWS
int main()
#else
int _start()
#endif
{
    //printf("%d\n", sizeof(struct exec_notification));
    unsigned char* message_start = raw_data;
    struct exec_notification* trade;
    int ret_val;
    #if TARGET == TARGET_RISCV
        volatile register unsigned status asm ("s10") = 0xFEFEFEFE;
    #else
        register unsigned status = 0xFEFEFEFE;
    #endif

    for (int i = 0; i < CHECK_EVERY; i++)
    {
        trade = (struct exec_notification*) message_start;
        ret_val = process_execution(trade);
        if (ret_val) status = 0x00BADBAD;
        message_start += sizeof(struct exec_notification);
    }

    for (int i = 0; i < CHECK_STRIDE; i++)
    {
        trade = (struct exec_notification*) message_start;
        ret_val = process_execution(trade);
        if (ret_val) status = 0x00BADBAD;
        message_start += MESSAGE_STRIDE;
    }

    if (status == 0xFEFEFEFE)
    {
        status = 0x600D600D;
    }
    #if TARGET == TARGET_EWS
        return 0;
    #else
        while(1);
    #endif
}

unsigned int process_execution(struct exec_notification* trade)
{
    if (trade->type != EXECUTION_TYPE && trade->subtype != EXECUTION_SUBTYPE)
    {
        // Not a notification we are interested in
        return 0;
    }

    uint32_t price = __builtin_bswap32(trade->price);
    uint16_t contracts = __builtin_bswap16(trade->contracts);
    uint16_t strike = __builtin_bswap16(trade->strike);
    uint16_t expiration = __builtin_bswap16(trade->expiration);
    uint64_t message_id = __builtin_bswap64(trade->message_id);

    #if TARGET == TARGET_EWS
        printf("Processing a trade involving %.5s side %c amount %d price %d\n", trade->symbol, trade->side, contracts, price);
    #endif

    if (message_id <= old_message_id)
    {
        // Out of order message, ignore
        return 0;
    }
    old_message_id = message_id;
    contracts_processed += contracts;
    if (trade->trade_type == TRADE_PUT)
    {
        puts_count += (trade->side == SIDE_BUY) ? contracts : -(contracts);
    }
    else if (trade->trade_type == TRADE_CALL)
    {
        calls_count += (trade->side == SIDE_SELL) ? -(contracts) : contracts;
    }

    int vol = price - strike;
    if (vol < 0) vol = -vol;

    int risk = vol << 2;
    if (expiration > 10) 
    {
        // Long ways out means riskier
        risk += risk;
    }

    if (trade->liquidity == LIQUIDITY_MAKER) 
    {
        //exchange gives us rebate on liquidity making, reflect that in risk
        risk -= 2;
    }

    if (risk > RISK_THRESHOLD)
    {
        //uhoh
        #if TARGET == TARGET_EWS
            printf("Trade breached risk threshold!!!\n");
        #endif
        return 1;
    }
    return 0;
}

uint32_t __bswapsi2(uint32_t u)
{
    return ((((u) & 0xff000000) >> 24)
      | (((u) & 0x00ff0000) >>  8)
      | (((u) & 0x0000ff00) <<  8)
      | (((u) & 0x000000ff) << 24));
}

uint64_t __bswapdi2(uint64_t u)
{
    return ((((u) & 0xff00000000000000ull) >> 56)
      | (((u) & 0x00ff000000000000ull) >> 40)
      | (((u) & 0x0000ff0000000000ull) >> 24)
      | (((u) & 0x000000ff00000000ull) >>  8)
      | (((u) & 0x00000000ff000000ull) <<  8)
      | (((u) & 0x0000000000ff0000ull) << 24)
      | (((u) & 0x000000000000ff00ull) << 40)
      | (((u) & 0x00000000000000ffull) << 56));
}
