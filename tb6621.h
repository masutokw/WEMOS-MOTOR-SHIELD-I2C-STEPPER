#define OWN_ADDRESS_1 0x32
// Commands
#define MOTOR_GET_COUNT 0x02
#define MOTOR_SET_COUNT 0x03
#define MOTOR_SET_TARGET 0x04
#define MOTOR_GET_TARGET 0x05
#define MOTOR_SET_TICKS 0x06
#define MOTOR_SET_DIR_RES 0x07
#define MOTOR_SET_PRESCALER 0x08
#define MOTOR_SET_WAVE_SCALE 0x09
#define MOTOR_SET_SPEED 0x0A
#define MOTOR_SET_TARGET_SPEED 0x0B
#define MOTOR_GET_TARGET_SPEED 0x0C
#define MOTOR_GET_SPEED 0x0D
#define MOTOR_GET_DIR_RES 0x0e
#define PRINT_WAVE 0x44
//MACROS TB6612 HBRIDGE INPUTS
#define WA_P   gpio_set(GPIOA,GPIO0); gpio_clear(GPIOA,GPIO1);//set  V+ for A winding
#define WA_N   gpio_clear(GPIOA,GPIO0); gpio_set(GPIOA,GPIO1); //set  V- for A winding
#define WB_P   gpio_set(GPIOA,GPIO3); gpio_clear(GPIOA,GPIO4); //set  V+ for B winding
#define WB_N   gpio_clear(GPIOA,GPIO3); gpio_set(GPIOA,GPIO4); //set  V- for B winding
#define MAIN_CLOCK 48000000
void set_period(int32_t period);
