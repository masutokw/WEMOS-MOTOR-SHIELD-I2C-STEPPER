#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/cm3/nvic.h>
#include "usart.h"
#include <stdio.h>
#include <errno.h>
#include "usart.h"
//--- Set up USART1 with 9600bps 8N1 ---/
#define BUFFER_LEN  10
uint8_t buffer[BUFFER_LEN]  ;
uint8_t bidx=0;
void (*parser )(uint8_t*)=NULL;

void uartwrite(char chars[])
{
    for(uint8_t c = 0; chars[c] != 0; c++)
    {
        usart_send_blocking(USART1, chars[c]);
    }
}

int _write(int file, char *ptr, int len)
{
    int i;

    if (file == 1)
    {
        for (i = 0; i < len; i++)
            usart_send_blocking(USART1, ptr[i]);
        return i;
    }

    errno = EIO;
    return -1;
}
/*static void usart_get_string( uint8_t *out_string, uint16_t str_max_size)
{
    uint8_t sign = 0;
    uint16_t iter = 0;

    while(iter < str_max_size)
    {
        sign = usart_recv_blocking(USART1);



        if(sign != '\n' && sign != '\r')
            out_string[iter++] = sign;
        else
        {
            out_string[iter] = 0;
            //usart_send_string(USART1, (uint8_t*)"\r\n", 3);
            break;
        }
    }
}*/
void usart1_isr(void)
{
    static uint8_t data = 'A';

    /* Check if we were called because of RXNE. */
    if (((USART_CR1(USART1) & USART_CR1_RXNEIE) != 0) &&
            ((USART_ISR(USART1) & USART_ISR_RXNE) != 0))
    {
        /* Retrieve the data from the peripheral. */
        data = usart_recv(USART1);
        buffer[bidx++]=data;
        buffer[bidx]=0;

        if (data==0xd )
        {
            (*parser)(buffer);
            bidx=0;
        }

        /* Enable transmit interrupt so it sends back the data. */
        USART_CR1(USART1) |= USART_CR1_TXEIE;
    }

    /* Check if we were called because of TXE. */
    if (((USART_CR1(USART1) & USART_CR1_TXEIE) != 0) &&
            ((USART_ISR(USART1) & USART_ISR_TXE) != 0))
    {

        /* Indicate that we are sending out data. */
        // gpio_toggle(GPIOA, GPIO7);

        /* Put data into the transmit register. */
        //   usart_send(USART1, data);

        /* Disable the TXE interrupt as we don't need it anymore. */
        USART_CR1(USART1) &= ~USART_CR1_TXEIE;
    }
}

void u32tostr(uint32_t dat,char *str)
{
    char temp[20];
    uint8_t i=0,j=0;
    i=0;
    while(dat)
    {
        temp[i]=dat%10+0x30;
        i++;
        dat/=10;
    }
    j=i;
    for(i=0; i<j; i++)
    {
        str[i]=temp[j-i-1];
    }
    if(!i)
    {
        str[i++]='0';
    }
    str[i]=0;
}
void USART_Put_Num(uint32_t dat)
{
    char temp[20];
    u32tostr(dat,temp);
    uartwrite(temp);
}

