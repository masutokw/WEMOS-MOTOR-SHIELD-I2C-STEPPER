

#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/timer.h>
#include <libopencm3/stm32/i2c.h>
#include <libopencm3/cm3/nvic.h>
#include <libopencm3/stm32/exti.h>
#include <string.h>
#include <stdlib.h>
#include "usart.h"
#include "wave.h"
#define WA_P   gpio_set(GPIOA,GPIO0); gpio_clear(GPIOA,GPIO1);//set  V+ for A winding
#define WA_N   gpio_clear(GPIOA,GPIO0); gpio_set(GPIOA,GPIO1); //set  V- for A winding
#define WB_P   gpio_set(GPIOA,GPIO3); gpio_clear(GPIOA,GPIO4) //set  V+ for B winding
#define WB_N   gpio_clear(GPIOA,GPIO3); gpio_set(GPIOA,GPIO4); //set  V- for B winding
long int max_steps;
long int backslash;
double step_size;
unsigned int speed;
uint32_t position;
long int delayt=500;
long int target;
long int backcounter;
uint16_t compare_time2;
uint16_t new_time2;
unsigned int ticks_x;
//enum motor_state state;
int pcounter;

short resolution;
#define OWN_ADDRESS_1 0x32
//Set Commands
#define MYSLAVE_SET_REG 0x01
//GET commands
#define MOTOR_GET_COUNT 0x02
#define MOTOR_SET_COUNT 0x03
#define MOTOR_SET_TARGET 0x04
#define MOTOR_GET_TARGET 0x05
#define MOTOR_SET_SPEED 0x06

volatile uint8_t reading;
//volatile uint8_t *read_p;
volatile uint8_t cmd;
volatile uint8_t *write_p;
volatile uint32_t *lpointer;
volatile uint8_t writing;
volatile bool i2cread;
uint8_t n;

uint8_t buf[10];

volatile uint32_t val;
void move_mstep(void);

static void gpio_setup(void)
{

    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO0 |GPIO1|GPIO2 | GPIO3 | GPIO4);

    /* Setup GPIO pins for USART2 transmit. */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO9 | GPIO7| GPIO6|GPIO10|GPIO2);

    /* Setup USART1 TX pin as alternate function. */
    gpio_set_af(GPIOA, GPIO_AF1,GPIO2);
    gpio_set_af(GPIOA, GPIO_AF1,GPIO6|GPIO7);
    /* Setup I2C  pin as alternate function. */
    gpio_set_af(GPIOA, GPIO_AF4,GPIO9|GPIO10);

}

static void usart_setup(void)
{
    /* Setup USART2 parameters. */
    //  nvic_enable_irq(NVIC_USART1_IRQ);
    usart_set_baudrate(USART1, 9600);
    usart_set_databits(USART1, 8);
    usart_set_parity(USART1, USART_PARITY_NONE);
    //usart_set_stopbits(USART1, USART_CR2_STOP_1_0BIT);
    usart_set_stopbits(USART1, USART_CR2_STOPBITS_1);
    usart_set_mode(USART1, USART_MODE_TX);
    usart_set_flow_control(USART1, USART_FLOWCONTROL_NONE);
//   USART_CR1(USART1) |= USART_CR1_RXNEIE;

    /* Finally enable the USART. */
    usart_enable(USART1);
}

static void clock_setup(void)
{
    rcc_clock_setup_in_hsi_out_48mhz();
    /* Enable GPIOC clock for LED & USARTs. */
    rcc_periph_clock_enable(RCC_TIM3);

    /* Enable GPIOC, Alternate Function clocks. */
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOB);
    //rcc_periph_clock_enable(RCC_GPIOC);

    /* Enable clocks for USART2. */
    rcc_periph_clock_enable(RCC_USART1);

}


static void tim_setup(void)
{

    rcc_periph_clock_enable(RCC_TIM2);


    nvic_enable_irq(NVIC_TIM2_IRQ);
    timer_set_mode(TIM2, TIM_CR1_CKD_CK_INT,
                   TIM_CR1_CMS_EDGE, TIM_CR1_DIR_UP);

    /* Reset prescaler value. */
    timer_set_prescaler(TIM2, 24);
    timer_disable_preload(TIM2);
    timer_continuous_mode(TIM2);
    timer_set_period(TIM2, 65535);
    timer_disable_oc_output(TIM2, TIM_OC1);
    timer_disable_oc_output(TIM2, TIM_OC2);
    timer_disable_oc_output(TIM2, TIM_OC3);
    timer_disable_oc_output(TIM2, TIM_OC4);

    /* -- OC1 configuration -- */

    /* Configure global mode of line 1. */
    timer_disable_oc_clear(TIM2, TIM_OC1);
    timer_disable_oc_preload(TIM2, TIM_OC1);
    timer_set_oc_slow_mode(TIM2, TIM_OC1);
    timer_set_oc_mode(TIM2, TIM_OC1, TIM_OCM_FROZEN);

    /* Set the capture compare value for OC1. */
    timer_set_oc_value(TIM2, TIM_OC1, 1000);
    timer_disable_preload(TIM2);
    timer_enable_counter(TIM2);
    timer_enable_irq(TIM2, TIM_DIER_CC1IE);
}
static void i2c_setup(void)
{
    rcc_periph_clock_enable(RCC_I2C1);
    rcc_periph_clock_enable(RCC_GPIOA);
    nvic_enable_irq(NVIC_I2C1_IRQ);
    rcc_set_i2c_clock_hsi(I2C1);

    // Setup GPIO Alternate function  /GPIO9 /GPIO10 on GPIO SDA SCL */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO9| GPIO10);
    gpio_set_af(GPIOA, GPIO_AF4, GPIO9 | GPIO10);

    i2c_reset(I2C1);
    i2c_peripheral_disable(I2C1);
    i2c_enable_analog_filter(I2C1);
    i2c_set_digital_filter(I2C1, 0);
    // HSI is at 48Mhz
    i2c_set_speed(I2C1, i2c_speed_sm_100k,8);
    i2c_enable_stretching(I2C1);
    i2c_set_7bit_addr_mode(I2C1);
    i2c_set_own_7bit_slave_address(I2C1, OWN_ADDRESS_1);
    //enable first slave addres by setting register, there is not enable function in libopencm3 .
    I2C1_OAR1|=I2C_OAR1_OA1EN_ENABLE;
    // I2C1_CR1|=I2C_CR1_SBC;
    i2c_enable_interrupt(I2C1, I2C_CR1_ADDRIE|I2C_CR1_RXIE|I2C_CR1_TXIE|I2C_CR1_STOPIE|I2C_CR1_NACKIE);
    i2c_peripheral_enable(I2C1);

}

void tim2_isr(void)
{
    if (timer_get_flag(TIM2, TIM_SR_CC1IF))
    {
        timer_clear_flag(TIM2, TIM_SR_CC1IF);
        compare_time2 = timer_get_counter(TIM2);
        /* Calculate and set the next compare value. */
        new_time2 = compare_time2 + ticks_x;
        timer_set_oc_value(TIM2, TIM_OC1, new_time2);
        move_mstep();
    }
}
static void tim3_setup(void)
{
    TIM3_CR1 = TIM_CR1_CKD_CK_INT | TIM_CR1_CMS_EDGE;

    //TIM3_ARR = 65535;
    TIM3_ARR = 512;
    /* Prescaler */
    TIM3_PSC = 0;
    TIM3_EGR = TIM_EGR_UG;

    /* ---- */
    /* Output compare 1 mode and preload */
    TIM3_CCMR1 |= TIM_CCMR1_OC1M_PWM1 | TIM_CCMR1_OC1PE;
    TIM3_CCER |= TIM_CCER_CC1E;
    TIM3_CCR1 = 0;
    TIM3_CCMR1 |= TIM_CCMR1_OC2M_PWM1 | TIM_CCMR1_OC2PE;
    TIM3_CCER |= TIM_CCER_CC2E;
    TIM3_CCR2 = 0;
    TIM3_CCMR2 |= TIM_CCMR2_OC3M_PWM1 | TIM_CCMR2_OC3PE;
    TIM3_CCER |= TIM_CCER_CC4E;
    TIM3_CCR4 = 0;
    TIM3_CR1 |= TIM_CR1_ARPE;
    TIM3_CR1 |= TIM_CR1_CEN;
}


void move_mstep(void)
{
    uint8_t p, s, j;
    uint8_t  pwma, pwmb;
    /*  if ((focus_aux.state == slew) && (focus_aux.position == focus_aux.target))
      {
          focus_aux.state = sync;
          focus_aux.resolution = 0;
          //  get_counter(&focus_aux);
          trigg=&focus_aux;
      }


    #ifdef BACKSLASH_COMP
      if (resolution<0)
      {
          if (backcounter==0) position += resolution;
          else backcounter+= resolution ;
      }
      else
      {
          if (backcounter==backslash)position += resolution;
          else backcounter+= resolution ;
      }


    #else

      focus_aux.position += focus_aux.resolution;
    #endif // BACKSLASH_COMP
    */
    position += resolution;
    pcounter += resolution;

    /*   if (bit_is_clear(PINF, PF0) &&  (focus_aux.resolution<0))
       {

           focus_aux.backcounter;
           focus_aux.position=focus_aux.resolution = 0;
           focus_aux.state = sync;
       }
       */
    if (pcounter < 0)   pcounter += MSTEPS4;
    else if (pcounter >= MSTEPS4) pcounter -= MSTEPS4;
    s = pcounter / MSTEPS;
    j = MSTEPS - (p = pcounter % (MSTEPS));
    if (s & 1) //check odd even step
    {
        pwma = wave[p];
        pwmb = wave[j];
        if (s == 1)
        {
            WA_P;
            WB_N ;
        }
        else
        {
            WA_N;
            WB_P;
        }
    }
    else
    {
        pwma = wave[j];
        pwmb = wave[p];

        if (s == 0)
        {
            WA_P;
            WB_P;
        }
        else
        {
            WA_N;
            WB_N;
        }
    }
    TIM3_CCR1=(pwmb);
    TIM3_CCR2=(pwma);



}


void serialParse(uint8_t* cad)
{
    uint8_t len,cmd;
    len=strlen((char*) cad);
    cmd =cad[len-2];
    cad[len-2]=0;


    switch(cmd)
    {
    case 'i':
        resolution=atol((char*)cad);

        break;
    case 'd':
        ticks_x=atol((char*)cad);

        break;


    case 'p':

        USART_Put_Num(position);
        uartwrite("\r\n");
        break;
    default:
        break;


    }


}


void i2c1_isr(void)
{
    uint32_t isr;
    isr = I2C1_ISR;
    // Address matched (Slave)
    if (isr & I2C_ISR_ADDR)
    {
        // uartwrite("int");

        if (isr & I2C_ISR_DIR_READ)
        {
            i2cread=false;
            write_p = ((volatile uint8_t *)(&val) );
            writing = 0;
        }
        //  read_p = buf;
        else
        {
            i2cread=true;
            reading = 0;
            lpointer=(volatile uint32_t *)(buf);
            I2C1_ISR|=I2C_ISR_TXE;
        }

        I2C1_ICR |= I2C_ICR_ADDRCF;
    }
    // Receive buffer not empty
    else if (isr& I2C_ISR_RXNE)
    {
        uint8_t rx;
        if (reading > 9) return; //Place limit on receive
        rx=i2c_get_data(I2C1);
        /*   USART_Put_Num(rx);uartwrite("-");USART_Put_Num(reading);uartwrite("\r\n");*/
        //read bytes from slave

        if (reading==0)
            cmd=rx;
        else
            buf[reading-1]=rx;
        reading++;
//uartwrite("rxne");
    }
    // Transmit buffer empty & Data byte transfer not finished
    else if ((isr & I2C_ISR_TXIS)) //&& !(isr & I2C_ISR_TC))

    {
        uint8_t tx= *write_p++;
        I2C1_TXDR=tx;
    }
    // done by master by sending STOP
    //this event happens when slave is in Recv mode at the end of communication
    else if (isr & I2C_ISR_STOPF)
    {
        i2c_peripheral_enable(I2C1);

        I2C1_ICR |= I2C_ICR_STOPCF;
        //   uartwrite("stopf\r\n");
        if (i2cread)
        {
            switch (cmd)
            {
            case MOTOR_GET_COUNT:
                val =position;
                break;
            case MOTOR_SET_COUNT:
                position =*lpointer;
                break;
            case MOTOR_SET_TARGET:
                target =*lpointer;
                break;
            case MOTOR_GET_TARGET:
                val=target ;
                break;
            case MOTOR_SET_SPEED:
                ticks_x=*lpointer;
                break;
            default:
                break;
            }
        }
    }

    else if (isr &I2C_ISR_NACKF)
    {
        I2C1_ICR |= I2C_ICR_NACKCF;
        // uartwrite("nack");
    }
}
int main(void)

{
    int i;
    clock_setup();
    gpio_setup();
    usart_setup();
    i2c_setup();
    tim_setup();
    tim3_setup();
    resolution=1;
    gpio_set(GPIOA,GPIO0);
    gpio_set(GPIOA,GPIO3);
    gpio_clear(GPIOA,GPIO1);
    gpio_clear(GPIOA,GPIO4);
    ticks_x=10000;
    while (1)
    {
        for (i = 0; i < delayt; i++)
        {
            __asm__("NOP");
        }
    }

    return 0;
}
