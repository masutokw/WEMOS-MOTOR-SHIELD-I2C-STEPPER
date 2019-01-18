#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/timer.h>
#include <libopencm3/cm3/systick.h>
#include <libopencm3/stm32/i2c.h>
#include <libopencm3/cm3/nvic.h>
#include <string.h>
#include <stdlib.h>
#include "tb6621.h"
#include "usart.h"
#include "wave.h"
int32_t max_steps;
volatile int32_t dir;
uint32_t backslash=0;
int32_t  backcounter=0;
volatile int32_t speed,speedt;
volatile int32_t position;
volatile int32_t target=0x00FFFFFF;
uint16_t delayt=50;
uint8_t rep_counter;
uint32_t next_time2,overticks_time2;;
unsigned int ticks_x;
float fspeed,fspeedt;
//enum motor_state state;
int ustep_index;
int32_t resolution;
volatile uint8_t reading;
volatile uint8_t cmd;
volatile uint8_t *write_p;
volatile int32_t *lpointer;
volatile float *fpointer;
volatile uint32_t tim2_prescaler=1000;
volatile uint32_t freq=MAIN_CLOCK/1000;
volatile bool i2cread;
uint8_t slave= OWN_ADDRESS_1;
uint8_t buf[10];
bool bprint =false;
volatile int32_t val;
void move_mstep(void);
inline int32_t sign(int32_t x)
{
    return (x > 0) - (x < 0);
}
inline int32_t signf(float x)
{
    return (x > 0.0) - (x < 0.0);
}
static void gpio_setup(void)
{
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO0 |GPIO1|GPIO2 | GPIO3 | GPIO4);
    /* Setup GPIO pins for USART transmit and I2c */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO9 | GPIO7| GPIO6|GPIO10|GPIO2);
    /* Setup USART1 TX pin as alternate function. */
    gpio_set_af(GPIOA, GPIO_AF1,GPIO2);
    gpio_set_af(GPIOA, GPIO_AF1,GPIO6|GPIO7);
}

static void usart_setup(void)
{
// nvic_enable_irq(NVIC_USART1_IRQ);
    usart_set_baudrate(USART1, 9600);
    usart_set_databits(USART1, 8);
    usart_set_parity(USART1, USART_PARITY_NONE);
    usart_set_stopbits(USART1, USART_CR2_STOPBITS_1);
    usart_set_mode(USART1, USART_MODE_TX);
    usart_set_flow_control(USART1, USART_FLOWCONTROL_NONE);
    usart_enable(USART1);
}

static void clock_setup(void)
{
    rcc_clock_setup_in_hsi_out_48mhz();
    rcc_periph_clock_enable(RCC_TIM3);
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOB);
    rcc_periph_clock_enable(RCC_USART1);

}
//Timer 2 doesn´t exist  officialy in STM32F030F4 but it is really there. OO
/*static void systick_setup(int xms)
{
    systick_set_clocksource(STK_CSR_CLKSOURCE_EXT);
    STK_CVR = 0;//set to 0
    systick_set_reload(rcc_ahb_frequency / 8 / 1000 * xms);
    systick_counter_enable();
    systick_interrupt_enable();
}
void sys_tick_handler(void)
{
    __asm__("NOP");	;
}
 static void tim2_setup(void)
{
    rcc_periph_clock_enable(RCC_TIM2);
    nvic_enable_irq(NVIC_TIM2_IRQ);
    rcc_periph_reset_pulse(RST_TIM2);
    timer_set_prescaler(TIM2,  tim2_prescaler);
    timer_disable_preload(TIM2);
    timer_continuous_mode(TIM2);
    timer_set_period(TIM2, 65535);
    timer_set_oc_value(TIM2, TIM_OC1, 1000);
    timer_enable_counter(TIM2);
    timer_enable_irq(TIM2, TIM_DIER_CC1IE);
}

void tim2_isr(void)
{
    if (timer_get_flag(TIM2, TIM_SR_CC1IF))
    {
        timer_clear_flag(TIM2, TIM_SR_CC1IF);
        overticks_time2 = timer_get_counter(TIM2);
        next_time2 = overticks_time2 + ticks_x;
        timer_set_oc_value(TIM2, TIM_OC1, next_time2);
        if (dir) move_mstep();
    }
}*/
static void tim16_setup(void)
{
    rcc_periph_clock_enable(RCC_TIM16);
    nvic_enable_irq(NVIC_TIM16_IRQ);
    rcc_periph_reset_pulse(RST_TIM16);
    timer_set_prescaler(TIM16,  tim2_prescaler);
    TIM16_ARR = 0xFFFF;
    timer_set_repetition_counter(TIM16, 0);
    //timer_enable_preload(TIM16);
    //timer_continuous_mode(TIM16);
    timer_enable_update_event(TIM16);
    timer_enable_counter(TIM16);
    timer_enable_irq(TIM16,TIM_DIER_UIE);

}

static void i2c_setup(void)
{
    rcc_periph_clock_enable(RCC_I2C1);
    nvic_enable_irq(NVIC_I2C1_IRQ);
    rcc_set_i2c_clock_hsi(I2C1);
    // Setup GPIO Alternate function  /GPIO9 /GPIO10 on GPIO SDA SCL */
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO9| GPIO10);
    gpio_set_af(GPIOA, GPIO_AF4, GPIO9 | GPIO10);
    i2c_reset(I2C1);
    i2c_peripheral_disable(I2C1);
    i2c_enable_analog_filter(I2C1);
    i2c_set_digital_filter(I2C1, 0);
    // HSI is at 8Mhz
    i2c_set_speed(I2C1, i2c_speed_sm_100k,8);
    i2c_enable_stretching(I2C1);
    i2c_set_7bit_addr_mode(I2C1);
    i2c_set_own_7bit_slave_address(I2C1,slave);
    //enable first slave addres by setting register, there is not enable function in libopencm3 .
    I2C1_OAR1|=I2C_OAR1_OA1EN_ENABLE;
    i2c_enable_interrupt(I2C1, I2C_CR1_ADDRIE|I2C_CR1_RXIE|I2C_CR1_TXIE|I2C_CR1_STOPIE|I2C_CR1_NACKIE);
    i2c_peripheral_enable(I2C1);
}

void tim16_isr(void)
{
    if (timer_get_flag(TIM16, TIM_SR_UIF))
    {
        timer_clear_flag(TIM16,  TIM_SR_UIF);
        if (dir) move_mstep();
    }
}

//TIMER3 configured for PWM
static void tim3_setup(void)
{
    TIM3_CR1 = TIM_CR1_CKD_CK_INT | TIM_CR1_CMS_EDGE;
    TIM3_ARR = 512;
    // Prescaler
    TIM3_PSC = 0;
    TIM3_EGR = TIM_EGR_UG;
    // Output compare 1 mode and preload */
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
    uint16_t  pwma, pwmb;
    if ((position == target)&&(dir!=0))
    {
        dir = 0;
      //  set_speed(fspeedt);
        target=0xFFFFEEEE;
    }


#ifdef BACKSLASH_COMP
    if (dir<0)
    {
        if (backcounter==0) position += dir;
        else backcounter+= dir ;
    }
    else
    {
        if (backcounter==backslash)position += dir;
        else backcounter+= dir ;
    }

#else
    position += dir;
#endif // BACKSLASH_COMP
    ustep_index += dir;
    if ( ustep_index < 0) ustep_index += MSTEPS4;
    else if ( ustep_index >= MSTEPS4)  ustep_index -= MSTEPS4;
    s =  ustep_index >>MSTEPS_DIV;/// MSTEPS;
    j = MSTEPS - (p =  ustep_index % (MSTEPS));
    if (s & 1) //check odd even step
    {
        pwma = wave[p];
        pwmb = wave[j];
        if (s == 1)
        {
            WA_P;
            WB_N
        }
        else
        {
            WA_N
            WB_P
        }
    }
    else
    {
        pwma = wave[j];
        pwmb = wave[p];

        if (s == 0)
        {
            WA_P
            WB_P
        }
        else
        {
            WA_N
            WB_N
        }
    }
    TIM3_CCR1=(pwmb);
    TIM3_CCR2=(pwma);
}
void set_period(int32_t period)
{
    dir=sign(period)*resolution;
    ticks_x=abs(period);
    rep_counter=0;
    if (ticks_x>0xFFFF)
    {
        rep_counter=ticks_x>>16;
        ticks_x=ticks_x/(rep_counter+1);
    }
    TIM16_ARR =ticks_x;
    TIM16_RCR=rep_counter;

}
void set_speed(float speed)
{
    dir=signf(speed)*resolution;

    ticks_x=abs((int)(freq/(speed)));
    rep_counter=0;
    if (ticks_x>0xFFFF)
    {
        rep_counter=ticks_x>>16;
        ticks_x=ticks_x/(rep_counter+1);
    }
   if (dir==0) ticks_x=0xFFFE;
    TIM16_ARR = ticks_x;
    TIM16_RCR=rep_counter;
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

        }
        //  read_p = buf;
        else
        {
            i2cread=true;
            reading = 0;
            lpointer=(volatile int32_t *)(buf);
            fpointer=(volatile float *)(buf);
            I2C1_ISR|=I2C_ISR_TXE;
        }

        I2C1_ICR |= I2C_ICR_ADDRCF;
    }
    // Receive buffer not empty
    else if (isr& I2C_ISR_RXNE)
    {
        uint8_t rx;
        if (reading > 9) return; //Place limit on receive to avoid buffer overflow
        rx=i2c_get_data(I2C1);

        //read bytes from slave

        if (reading==0)
            cmd=rx;
        else
            buf[reading-1]=rx;
        reading++;

    }
    // Transmit buffer empty & Data byte transfer not finished
    else if ((isr & I2C_ISR_TXIS)) //&& !(isr & I2C_ISR_TC))

    {
        uint8_t tx= *write_p++;
        I2C1_TXDR=tx;
    }
    // done by master by sending STOP
    else if (isr & I2C_ISR_STOPF)
    {
        i2c_peripheral_enable(I2C1);

        I2C1_ICR |= I2C_ICR_STOPCF;

        if (i2cread)
        {
            switch (cmd)
            {
            case MOTOR_GET_COUNT:
                val=position;
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
            case MOTOR_SET_TICKS:
                set_period(speed=*lpointer);
                break;
            case MOTOR_SET_DIR_RES:
                resolution=abs(*lpointer);
                break;
            case MOTOR_SET_PRESCALER:
                timer_set_prescaler(TIM2,tim2_prescaler=*lpointer);
                freq=MAIN_CLOCK/tim2_prescaler;
                break;
            case MOTOR_SET_WAVE_SCALE:
                generate_wave(*lpointer);
                break;
            case MOTOR_SET_SPEED:
                set_speed( fspeed=*fpointer);
                break;
            case  MOTOR_SET_TARGET_SPEED:
                fspeedt=*fpointer;
                break;
            case PRINT_WAVE:
                bprint=true;
                break;
            default:
                break;
            }
        }
    }

    else if (isr &I2C_ISR_NACKF)
    {
        I2C1_ICR |= I2C_ICR_NACKCF;

    }
}
int main(void)

{
    int i;
    generate_wave(50);
    clock_setup();
    gpio_setup();
    usart_setup();
    i2c_setup();
    //systick_setup(125); // tim2_setup();
    tim16_setup();
    tim3_setup();
    resolution=1;
    gpio_set(GPIOA,GPIO0);
    gpio_set(GPIOA,GPIO3);
    gpio_clear(GPIOA,GPIO1);
    gpio_clear(GPIOA,GPIO4);
    ticks_x=65535;
    dir=01;

    while (1)
    {
        //debug table
        if (bprint)
        {
            for (i=0 ; i<=MSTEPS; i++)
            {

                USART_Put_Num(i);
                uartwrite("-");
                USART_Put_Num(wave[i]);
                uartwrite("\r\n");
            }
            bprint=false;
        }
        for (i = 0; i < delayt; i++)
        {
            __asm__("NOP");
        }
    }

    return 0;
}
