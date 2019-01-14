unit i2cmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uLibFT260, Vcl.ExtCtrls,math;

type
  TMain = class(TForm)
    Button_Check: TButton;
    Memo1: TMemo;
    Button7: TButton;
    Button_Set_Pos: TButton;
    Edit1: TEdit;
    ButtonSpeed: TButton;
    ButtonTarget: TButton;
    Edit2: TEdit;
    Timer1: TTimer;
    Label1: TLabel;
    CheckBox_poll: TCheckBox;
    Label2: TLabel;
    Button_goto: TButton;
    Button1: TButton;
    Edit_hz: TEdit;
    Buttonhz: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button_CheckClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button_Set_PosClick(Sender: TObject);
    procedure ButtonSpeedClick(Sender: TObject);
    procedure ButtonTargetClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox_pollClick(Sender: TObject);
    procedure Button_gotoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonhzClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  initData1: array[0..1] of Byte = ( $F0,$55);
  initData2: array[0..1] of Byte = ($FB,$00 );
  initData3: array[0..4] of Byte = (03,0,0,0,0);

//Set Commands
 MYSLAVE_SET_REG:byte= $01;
//GET commands
 MOTOR_GET_COUNT: byte= $02;
 MOTOR_SET_COUNT:byte =$03;
 MOTOR_SET_TARGET:byte =$04;
 MOTOR_GET_TARGET:byte= $05;
 MOTOR_SET_SPEED:byte= $06;
 MOTOR_SET_DIR_RES= $07;
 MOTOR_SET_SPEEDF=$0A;
 STM_ADDRESS=$32;
var
  Main: TMain;
  mhandle1: FT260_HANDLE;
  ftStatus: FT260_STATUS;
  devNum: DWord;
  chandle: FT260_HANDLE;
  n_data:array[0..5] of byte;
   n3_data:array[0..4] of byte;
  count:DWORD;
  pos,lastpos:integer;
implementation

{$R *.dfm}

 function read_integer(cmd:byte;address:byte):integer;
 var p:pointer;
data:integer;

begin
data:=0;

  ftStatus:=FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@cmd,1,count) ;
    // sleep(5);
   ftStatus:=FT260_I2CMaster_Read (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@data,4,count,50000) ;
result:=data

end;
procedure set_float(cmd:byte;address:byte;value:single);
var p:^single;
  n_data:array[0..4] of byte;
begin
n_data[0]:=cmd;
p:=@n_data[1];
p^:=value;

   FT260_I2CMaster_Write (mhandle1,address ,FT260_I2C_START_AND_STOP,@n_data,5,count) ;
end;

procedure set_integer(cmd:byte;address:byte;value:integer);
var p:^integer;
  n_data:array[0..4] of byte;
begin
n_data[0]:=cmd;
p:=@n_data[1];
p^:=value;
   FT260_I2CMaster_Write (mhandle1,address ,FT260_I2C_START_AND_STOP,@n_data,5,count) ;
end;
procedure TMain.ButtonSpeedClick(Sender: TObject);

var speed:integer;
begin
speed:=strtoint(Edit1.Text);
   set_integer(MOTOR_SET_SPEED,STM_ADDRESS,speed);
end;

procedure TMain.ButtonTargetClick(Sender: TObject);
 var target:integer;
begin
   target:=strtoint(Edit2.Text);
   set_integer( MOTOR_SET_TARGET,STM_ADDRESS,target);
end;

procedure TMain.Button_CheckClick(Sender: TObject);

var
devNum : dword;
i:integer;
begin
devnum:= 10;
for i:=0 to 12 do
begin
FT260_Open(i,mhandle1);
ftStatus:=FT260_I2CMaster_Init(mhandle1, 100);
memo1.Lines.Add(IntToStr(dword(ftStatus)));
//ShowMessage(IntToStr(D2xxunit.Create_USB_Device_List));
//ShowMessage(IntToStr(FT260_CreateDeviceList(devnum)));
end;

end;








procedure TMain.Button_gotoClick(Sender: TObject);
var speed,sgn:integer;
begin
 sgn:=sign(strtoint(Edit2.Text)-pos );
 if sgn<>0 then begin
    speed:=abs(strtoint(Edit1.Text));
    set_integer(MOTOR_SET_TARGET,STM_ADDRESS,strtoint(Edit2.Text));

   set_integer(MOTOR_SET_SPEED,STM_ADDRESS,speed*sgn);
 end;
end;

procedure TMain.Button1Click(Sender: TObject);
begin
     set_integer($44,STM_ADDRESS,0);
end;

procedure TMain.Button7Click(Sender: TObject);


begin

pos:=read_integer($2,STM_ADDRESS)  ;
 label1.Caption:=inttostr(pos);
    memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttoHEX(pos)+'  '+inttostr(pos)+
    ' '+inttostr(count));

end;

procedure TMain.ButtonhzClick(Sender: TObject);
var speed:single;
 var p:^dword;
 pos:dword;
begin
speed:=strtofloat(Edit_Hz.Text);

            p:=@speed;
            pos:=p^;
    memo1.Lines.Add(inttoHEX(pos));

   set_float(MOTOR_SET_SPEEDF,STM_ADDRESS,speed);
end;

procedure TMain.Button_Set_PosClick(Sender: TObject);
 var pos:integer;
begin
   pos:=strtoint(Edit2.Text);
   set_integer(MOTOR_SET_COUNT,STM_ADDRESS,pos);
end;



procedure TMain.CheckBox_pollClick(Sender: TObject);
begin
timer1.Enabled:=checkbox_Poll.checked;
end;

procedure TMain.FormCreate(Sender: TObject);
 begin
  FT260_CreateDeviceList(devNum);
  FT260_Open(0, mhandle1);
  ftStatus := FT260_I2CMaster_Init(mhandle1, 100);


end;



procedure TMain.Timer1Timer(Sender: TObject);


begin

pos:=read_integer( MOTOR_GET_COUNT,STM_ADDRESS)  ;

 label1.Caption:='Position:'+inttostr(pos);
 label2.Caption:='Speed:'+floattostr(1000.0*((pos-lastpos))/(timer1.Interval))+' mstp/s' ;
 lastpos:=pos
end;


end.
