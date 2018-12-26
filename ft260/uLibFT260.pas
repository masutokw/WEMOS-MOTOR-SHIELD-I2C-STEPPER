unit uLibFT260;

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion > 13}
    {$DEFINE DELPHI6_UP} // > D5
  {$IFEND}
{$ENDIF}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

type
  PDWORD = ^DWORD;
  {$EXTERNALSYM PDWORD}
  DWORD = LongWord;
  {$EXTERNALSYM DWORD}
  PFT260_HANDLE = ^FT260_HANDLE;
  FT260_HANDLE = THandle;

type
  {$IFDEF DELPHI6_UP} // > D5
  FT260_STATUS = (
    FT260_OK = 0,
    FT260_INVALID_HANDLE,
    FT260_DEVICE_NOT_FOUND,
    FT260_DEVICE_NOT_OPENED,
    FT260_DEVICE_OPEN_FAIL,
    FT260_DEVICE_CLOSE_FAIL,
    FT260_INCORRECT_INTERFACE,
    FT260_INCORRECT_CHIP_MODE,
    FT260_DEVICE_MANAGER_ERROR,
    FT260_IO_ERROR,
    FT260_INVALID_PARAMETER,
    FT260_NULL_BUFFER_POINTER,
    FT260_BUFFER_SIZE_ERROR,
    FT260_UART_SET_FAIL,
    FT260_RX_NO_DATA,
    FT260_GPIO_WRONG_DIRECTION,
    FT260_INVALID_DEVICE,
    FT260_OTHER_ERROR
  );
  {$ELSE}
  FT260_STATUS = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_GPIO2_Pin = (
    FT260_GPIO2_GPIO    = 0,
    FT260_GPIO2_SUSPOUT = 1,
    FT260_GPIO2_PWREN   = 2,
    FT260_GPIO2_TX_LED  = 4
  );
  {$ELSE}
  FT260_GPIO2_Pin = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_GPIOA_Pin = (
    FT260_GPIOA_GPIO      = 0,
    FT260_GPIOA_TX_ACTIVE = 3,
    FT260_GPIOA_TX_LED    = 4
  );
  {$ELSE}
  FT260_GPIOA_Pin = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_GPIOG_Pin = (
    FT260_GPIOG_GPIO    = 0,
    FT260_GPIOG_PWREN   = 2,
    FT260_GPIOG_RX_LED  = 5,
    FT260_GPIOG_BCD_DET = 6
  );
  {$ELSE}
  FT260_GPIOG_Pin = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Clock_Rate = (
    FT260_SYS_CLK_12M = 0,
    FT260_SYS_CLK_24M,
    FT260_SYS_CLK_48M
  );
  {$ELSE}
  FT260_Clock_Rate = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Interrupt_Trigger_Type = (
    FT260_INTR_RISING_EDGE = 0,
    FT260_INTR_LEVEL_HIGH,
    FT260_INTR_FALLING_EDGE,
    FT260_INTR_LEVEL_LOW
  );
  {$ELSE}
  FT260_Interrupt_Trigger_Type = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Interrupt_Level_Time_Delay = (
    FT260_INTR_DELY_1MS = 1,
    FT260_INTR_DELY_5MS,
    FT260_INTR_DELY_30MS
  );
  {$ELSE}
  FT260_Interrupt_Level_Time_Delay = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Suspend_Out_Polarity = (
    FT260_SUSPEND_OUT_LEVEL_HIGH = 0,
    FT260_SUSPEND_OUT_LEVEL_LOW
  );
  {$ELSE}
  FT260_Suspend_Out_Polarity = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_UART_Mode = (
    FT260_UART_OFF = 0,
    FT260_UART_RTS_CTS_MODE,      // hardware flow control RTS, CTS mode
    FT260_UART_DTR_DSR_MODE,      // hardware flow control DTR, DSR mode
    FT260_UART_XON_XOFF_MODE,     // software flow control mode
    FT260_UART_NO_FLOW_CTRL_MODE  // no flow control mode
  );
  {$ELSE}
  FT260_UART_Mode = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Data_Bit = (
    FT260_DATA_BIT_7 = 7,
    FT260_DATA_BIT_8 = 8
  );
  {$ELSE}
  FT260_Data_Bit = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Stop_Bit = (
    FT260_STOP_BITS_1 = 0,
    FT260_STOP_BITS_2 = 2
  );
  {$ELSE}
  FT260_Stop_Bit = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_Parity = (
    FT260_PARITY_NONE = 0,
    FT260_PARITY_ODD,
    FT260_PARITY_EVEN,
    FT260_PARITY_MARK,
    FT260_PARITY_SPACE
  );
  {$ELSE}
  FT260_Parity = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_RI_Wakeup_Type = (
    FT260_RI_WAKEUP_RISING_EDGE = 0,
    FT260_RI_WAKEUP_FALLING_EDGE
  );
  {$ELSE}
  FT260_RI_Wakeup_Type = Byte;
  {$ENDIF}

  PFT260_GPIO_Report = ^FT260_GPIO_Report;
  FT260_GPIO_Report = record
    value: Word;       // GPIO0~5 values
    dir: Word;         // GPIO0~5 directions
    gpioN_value: Word; // GPIOA~H values
    gpioN_dir: Word;   // GPIOA~H directions
  end;

  {$IFDEF DELPHI6_UP} // > D5
  FT260_GPIO_DIR = (
    FT260_GPIO_IN = 0,
    FT260_GPIO_OUT
  );
  {$ELSE}
  FT260_GPIO_DIR = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_GPIO = (
    FT260_GPIO_0 = $0001,
    FT260_GPIO_1 = $0002,
    FT260_GPIO_2 = $0004,
    FT260_GPIO_3 = $0008,
    FT260_GPIO_4 = $0010,
    FT260_GPIO_5 = $0020,
    FT260_GPIO_A = $0040,
    FT260_GPIO_B = $0080,
    FT260_GPIO_C = $0100,
    FT260_GPIO_D = $0200,
    FT260_GPIO_E = $0400,
    FT260_GPIO_F = $0800,
    FT260_GPIO_G = $1000,
    FT260_GPIO_H = $2000
  );
  {$ELSE}
  FT260_GPIO = Word;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_I2C_FLAG = (
    FT260_I2C_NONE  = 0,
    FT260_I2C_START = 2,
    FT260_I2C_REPEATED_START = 3,
    FT260_I2C_STOP  = 4,
    FT260_I2C_START_AND_STOP = 6
  );
  {$ELSE}
  FT260_I2C_FLAG = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_PARAM_1 = (
    FT260_DS_CTL0 = $50,
    FT260_DS_CTL3 = $51,
    FT260_DS_CTL4 = $52,
    FT260_SR_CTL0 = $53,
    FT260_GPIO_PULL_UP    = $61,
    FT260_GPIO_OPEN_DRAIN = $62,
    FT260_GPIO_PULL_DOWN  = $63,
    FT260_GPIO_GPIO_SLEW_RATE = $65
  );
  {$ELSE}
  FT260_PARAM_1 = Byte;
  {$ENDIF}

  {$IFDEF DELPHI6_UP} // > D5
  FT260_PARAM_2 = (
    FT260_GPIO_GROUP_SUSPEND_0 = $10,  // for gpio 0 ~ gpio 5
    FT260_GPIO_GROUP_SUSPEND_A = $11,  // for gpio A ~ gpio H
    FT260_GPIO_DRIVE_STRENGTH  = $64
  );
  {$ELSE}
  FT260_PARAM_2 = Byte;
  {$ENDIF}

  PUartConfig = ^UartConfig;
  UartConfig = record
    flow_ctrl: Byte;
    baud_rate: DWord;
    data_bit, parity, stop_bit, breaking: Byte;
  end;

const
  LIB_FT_260 = 'LibFT260.dll';


{ DLL Import }

// FT260 General Functions

function FT260_CreateDeviceList(lpdwNumDevs: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_CreateDeviceList@4'; overload;
function FT260_CreateDeviceList(var lpdwNumDevs: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_CreateDeviceList@4'; overload;
function FT260_GetDevicePath(pDevicePath: PWideChar; bufferLength, deviceIndex: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetDevicePath@12'; overload;
function FT260_GetDevicePath(var pDevicePath: WideChar; bufferLength, deviceIndex: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetDevicePath@12'; overload;
function FT260_Open(iDevice: Integer; pFt260Handle: PFT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_Open@8'; overload;
function FT260_Open(iDevice: Integer; var pFt260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_Open@8'; overload;
function FT260_OpenByVidPid(vid, pid: Word; deviceIndex: DWord; pFt260Handle: PFT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_OpenByVidPid@16'; overload;
function FT260_OpenByVidPid(vid, pid: Word; deviceIndex: DWord; var pFt260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_OpenByVidPid@16'; overload;
function FT260_OpenByDevicePath(pDevicePath: PWideChar; pFt260Handle: PFT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_OpenByDevicePath@8'; overload;
function FT260_OpenByDevicePath(pDevicePath: PWideChar; var pFt260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_OpenByDevicePath@8'; overload;
function FT260_OpenByDevicePath(var pDevicePath: WideChar; pFt260Handle: PFT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_OpenByDevicePath@8'; overload;
function FT260_OpenByDevicePath(var pDevicePath: WideChar; var pFt260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_OpenByDevicePath@8'; overload;
function FT260_Close(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_Close@4';
function FT260_SetClock(ft260Handle: FT260_HANDLE; clk: FT260_Clock_Rate): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetClock@8';
function FT260_SetWakeupInterrupt(ft260Handle: FT260_HANDLE; enable: Boolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetWakeupInterrupt@8';
function FT260_SetInterruptTriggerType(ft260Handle: FT260_HANDLE; typ: FT260_Interrupt_Trigger_Type; delay: FT260_Interrupt_Level_Time_Delay): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetInterruptTriggerType@12';
function FT260_SelectGpio2Function(ft260Handle: FT260_HANDLE; gpio2Function: FT260_GPIO2_Pin): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SelectGpio2Function@8';
function FT260_SelectGpioAFunction(ft260Handle: FT260_HANDLE; gpioAFunction: FT260_GPIOA_Pin): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SelectGpioAFunction@8';
function FT260_SelectGpioGFunction(ft260Handle: FT260_HANDLE; gpioGFunction: FT260_GPIOG_Pin): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SelectGpioGFunction@8';
function FT260_SetSuspendOutPolarity(ft260Handle: FT260_HANDLE; polarity: FT260_Suspend_Out_Polarity): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetSuspendOutPolarity@8';
function FT260_SetParam_U8(ft260Handle: FT260_HANDLE; param: FT260_PARAM_1; value: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetParam_U8@12';
function FT260_SetParam_U16(ft260Handle: FT260_HANDLE; param: FT260_PARAM_2; value: Word): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetParam_U16@12';
function FT260_GetChipVersion(ft260Handle: FT260_HANDLE; lpdwChipVersion: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetChipVersion@8'; overload;
function FT260_GetChipVersion(ft260Handle: FT260_HANDLE; var lpdwChipVersion: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetChipVersion@8'; overload;
function FT260_GetLibVersion(lpdwLibVersion: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetLibVersion@4'; overload;
function FT260_GetLibVersion(var lpdwLibVersion: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetLibVersion@4'; overload;
function FT260_EnableI2CPin(ft260Handle: FT260_HANDLE; enable: Boolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_EnableI2CPin@8';
function FT260_SetUartToGPIOPin(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_SetUartToGPIOPin@4';
function FT260_EnableDcdRiPin(ft260Handle: FT260_HANDLE; enable: Boolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_EnableDcdRiPin@8';

// FT260 I2C Functions

function FT260_I2CMaster_Init(ft260Handle: FT260_HANDLE; kbps: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_Init@8';
function FT260_I2CMaster_Read(ft260Handle: FT260_HANDLE; deviceAddress: Byte; flag: FT260_I2C_FLAG; lpBuffer: Pointer; dwBytesToRead: DWord; lpdwBytesReturned: PDWord;wait_timer:DWORD): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_Read@28'; overload;
function FT260_I2CMaster_Read(ft260Handle: FT260_HANDLE; deviceAddress: Byte; flag: FT260_I2C_FLAG; lpBuffer: Pointer; dwBytesToRead: DWord; var lpdwBytesReturned: DWord;wait_timer:DWORD): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_Read@28'; overload;
function FT260_I2CMaster_Write(ft260Handle: FT260_HANDLE; deviceAddress: Byte; flag: FT260_I2C_FLAG; lpBuffer: Pointer; dwBytesToWrite: DWord; lpdwBytesWritten: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_Write@24'; overload;
function FT260_I2CMaster_Write(ft260Handle: FT260_HANDLE; deviceAddress: Byte; flag: FT260_I2C_FLAG; lpBuffer: Pointer; dwBytesToWrite: DWord; var lpdwBytesWritten: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_Write@24'; overload;
function FT260_I2CMaster_GetStatus(ft260Handle: FT260_HANDLE; status: PByte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_GetStatus@8'; overload;
function FT260_I2CMaster_GetStatus(ft260Handle: FT260_HANDLE; var status: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_GetStatus@8'; overload;
function FT260_I2CMaster_Reset(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_I2CMaster_Reset@4';

// FT260 UART Functions

function FT260_UART_Init(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_Init@4';
function FT260_UART_SetBaudRate(ft260Handle: FT260_HANDLE; baudRate: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetBaudRate@8';
function FT260_UART_SetFlowControl(ft260Handle: FT260_HANDLE; flowControl: FT260_UART_Mode): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetFlowControl@8';
function FT260_UART_SetDataCharacteristics(ft260Handle: FT260_HANDLE; dataBits: FT260_Data_Bit; stopBits: FT260_Stop_Bit; parity: FT260_Parity): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetDataCharacteristics@16';
function FT260_UART_SetBreakOn(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetBreakOn@4';
function FT260_UART_SetBreakOff(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetBreakOff@4';
function FT260_UART_SetXonXoffChar(ft260Handle: FT260_HANDLE; Xon: Byte; Xoff: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetXonXoffChar@12';
function FT260_UART_GetConfig(ft260Handle: FT260_HANDLE; pUartConfig: PUartConfig): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_GetConfig@8'; overload;
function FT260_UART_GetConfig(ft260Handle: FT260_HANDLE; var pUartConfig: UartConfig): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_GetConfig@8'; overload;
function FT260_UART_GetQueueStatus(ft260Handle: FT260_HANDLE; lpdwAmountInRxQueue: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_GetQueueStatus@8'; overload;
function FT260_UART_GetQueueStatus(ft260Handle: FT260_HANDLE; var lpdwAmountInRxQueue: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_GetQueueStatus@8'; overload;
function FT260_UART_Read(ft260Handle: FT260_HANDLE; lpBuffer: Pointer; dwBufferLength, dwBytesToRead: DWord; lpdwBytesReturned: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_Read@20'; overload;
function FT260_UART_Read(ft260Handle: FT260_HANDLE; lpBuffer: Pointer; dwBufferLength, dwBytesToRead: DWord; var lpdwBytesReturned: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_Read@20'; overload;
function FT260_UART_Write(ft260Handle: FT260_HANDLE; lpBuffer: Pointer; dwBufferLength, dwBytesToWrite: DWord; lpdwBytesWritten: PDWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_Write@20'; overload;
function FT260_UART_Write(ft260Handle: FT260_HANDLE; lpBuffer: Pointer; dwBufferLength, dwBytesToWrite: DWord; var lpdwBytesWritten: DWord): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_Write@20'; overload;
function FT260_UART_Reset(ft260Handle: FT260_HANDLE): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_Reset@4';
function FT260_UART_GetDcdRiStatus(ft260Handle: FT260_HANDLE; value: PByte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_GetDcdRiStatus@8'; overload;
function FT260_UART_GetDcdRiStatus(ft260Handle: FT260_HANDLE; var value: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_GetDcdRiStatus@8'; overload;
function FT260_UART_EnableRiWakeup(ft260Handle: FT260_HANDLE; enable: Boolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_EnableRiWakeup@8';
function FT260_UART_SetRiWakeupConfig(ft260Handle: FT260_HANDLE; typ: FT260_RI_Wakeup_Type): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_UART_SetRiWakeupConfig@8';

// Interrupt is transmitted by UART interface

function FT260_GetInterruptFlag(ft260Handle: FT260_HANDLE; pbFlag: PBoolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetInterruptFlag@8'; overload;
function FT260_GetInterruptFlag(ft260Handle: FT260_HANDLE; var pbFlag: Boolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GetInterruptFlag@8'; overload;
function FT260_CleanInterruptFlag(ft260Handle: FT260_HANDLE; pbFlag: PBoolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_CleanInterruptFlag@8'; overload;
function FT260_CleanInterruptFlag(ft260Handle: FT260_HANDLE; var pbFlag: Boolean): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_CleanInterruptFlag@8'; overload;

// FT260 GPIO Functions

function FT260_GPIO_Set(ft260Handle: FT260_HANDLE; report: FT260_GPIO_Report): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_Set@12';
function FT260_GPIO_Get(ft260Handle: FT260_HANDLE; report: PFT260_GPIO_Report): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_Get@8'; overload;
function FT260_GPIO_Get(ft260Handle: FT260_HANDLE; var report: FT260_GPIO_Report): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_Get@8'; overload;
function FT260_GPIO_SetDir(ft260Handle: FT260_HANDLE; pinNum: Word; dir: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_SetDir@12';
function FT260_GPIO_Read(ft260Handle: FT260_HANDLE; pinNum: Word; pValue: PByte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_Read@12'; overload;
function FT260_GPIO_Read(ft260Handle: FT260_HANDLE; pinNum: Word; var pValue: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_Read@12'; overload;
function FT260_GPIO_Write(ft260Handle: FT260_HANDLE; pinNum: Word; value: Byte): FT260_STATUS; stdcall; external LIB_FT_260 name '_FT260_GPIO_Write@12';


{ Macro }

function I2CM_CONTROLLER_BUSY(status: Byte): Boolean;
function I2CM_DATA_NACK(status: Byte): Boolean;
function I2CM_ADDRESS_NACK(status: Byte): Boolean;
function I2CM_ARB_LOST(status: Byte): Boolean;
function I2CM_IDLE(status: Byte): Boolean;
function I2CM_BUS_BUSY(status: Byte): Boolean;

implementation

{ Macro }

(* I2C Master Controller Status
 *   bit 0 = controller busy: all other status bits invalid
 *   bit 1 = error condition
 *   bit 2 = slave address was not acknowledged during last operation
 *   bit 3 = data not acknowledged during last operation
 *   bit 4 = arbitration lost during last operation
 *   bit 5 = controller idle
 *   bit 6 = bus busy
 *)

// #define I2CM_CONTROLLER_BUSY(status) (((status) & 0x01) != 0)
function I2CM_CONTROLLER_BUSY(status: Byte): Boolean;
begin
  result := (Status and 1) <> 0;
end;

// #define I2CM_DATA_NACK(status)       (((status) & 0x0A) != 0)
function I2CM_DATA_NACK(status: Byte): Boolean;
begin
  result := (Status and $A) <> 0;
end;

// #define I2CM_ADDRESS_NACK(status)    (((status) & 0x06) != 0)
function I2CM_ADDRESS_NACK(status: Byte): Boolean;
begin
  result := (Status and 6) <> 0;
end;

// #define I2CM_ARB_LOST(status)        (((status) & 0x12) != 0)
function I2CM_ARB_LOST(status: Byte): Boolean;
begin
  result := (Status and $12) <> 0;
end;

// #define I2CM_IDLE(status)            (((status) & 0x20) != 0)
function I2CM_IDLE(status: Byte): Boolean;
begin
  result := (Status and $20) <> 0;
end;

// #define I2CM_BUS_BUSY(status)        (((status) & 0x40) != 0)
function I2CM_BUS_BUSY(status: Byte): Boolean;
begin
  result := (Status and $40) <> 0;
end;

end.
