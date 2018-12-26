unit i2cmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uLibFT260;

type
  TMain = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Button10: TButton;
    Button11: TButton;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  initData1: array[0..1] of Byte = ( $F0,$55);
  initData2: array[0..1] of Byte = ($FB,$00 );
  initData3: array[0..4] of Byte = (01,0,255,0,0);
  NUNCHUK_ADDRESS:byte =$52;
  PRESS_ADDRESS:byte=$77;
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
implementation

{$R *.dfm}


procedure TMain.Button10Click(Sender: TObject);
var p:^DWORD;
speed:DWORD;
begin
speed:=strtoint(Edit1.Text);
n_data[0]:=6;
p:=@n_data[1];
p^:=speed;
   FT260_I2CMaster_Write (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@n_data,5,count) ;
end;

procedure TMain.Button11Click(Sender: TObject);
var p:^integer;
speed:DWORD;
begin
speed:=strtoint(Edit2.Text);
n_data[0]:=7;
p:=@n_data[1];
p^:=speed;
   FT260_I2CMaster_Write (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@n_data,5,count) ;
end;

procedure TMain.Button1Click(Sender: TObject);

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

procedure TMain.Button2Click(Sender: TObject);
var g :DWORD;
begin



     FT260_I2CMaster_Write (mhandle1, NUNCHUK_ADDRESS,FT260_I2C_START_AND_STOP,@initData1,2,g) ;
    ftStatus:= FT260_I2CMaster_Write (mhandle1, NUNCHUK_ADDRESS,FT260_I2C_START_AND_STOP,@initData2,2,g) ;
     memo1.Lines.Add(IntToStr(dword(ftStatus)));
end;

procedure TMain.Button3Click(Sender: TObject);
var snd,add:byte;
w,g :DWORD;
p:pointer;
// mhandle1: FT260_HANDLE;
begin


  FT260_I2CMaster_Write (mhandle1, NUNCHUK_ADDRESS,FT260_I2C_START_AND_STOP,@initData1,2,g) ;
end;

procedure TMain.Button4Click(Sender: TObject);
var p:pointer;
data:Dword;
begin
   ftStatus:=FT260_I2CMaster_Read (mhandle1, NUNCHUK_ADDRESS,FT260_I2C_START_AND_STOP,@n_data,6,count,5000) ;
   memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttostr(count));
end;

procedure TMain.Button5Click(Sender: TObject);
var p:pointer;
data:word;
cmd:byte;
begin
cmd:=$AA;
   ftStatus:=FT260_I2CMaster_Write (mhandle1, PRESS_ADDRESS,FT260_I2C_START_AND_STOP,@cmd,1,count) ;
   memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttostr(count));
   FT260_I2CMaster_Read (mhandle1, PRESS_ADDRESS,FT260_I2C_START_AND_STOP,@data,2,count,5000) ;
    memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttostr(data));
end;

procedure TMain.Button6Click(Sender: TObject);
var p:pointer;
data:word;
cmd,addres:byte;
begin
cmd:=$05;
  FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@initData3,3,count) ;
  ftStatus:=FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@cmd,1,count) ;
 //for addres:=1 to 128 do begin
   ftStatus:=FT260_I2CMaster_Read (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@data,2,count,50000) ;
    memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttostr(data)+'  '+inttostr(count));
 //end;
end;

procedure TMain.Button7Click(Sender: TObject);
var p:pointer;
cmd,addres:byte;
data:integer;

begin
cmd:=$02;
data:=0;
//  FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@initData3,5,count) ;
  ftStatus:=FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@cmd,1,count) ;
     sleep(1);
   ftStatus:=FT260_I2CMaster_Read (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@data,4,count,50000) ;
    memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttoHEX(data)+'  '+inttostr(data)+
    ' '+inttostr(count));


end;

procedure TMain.Button8Click(Sender: TObject);
var p:pointer;
data:dword;
cmd,addres:byte;
begin
cmd:=$03;
data:=0;
  FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@initData3,5,count) ;
    sleep(50);
  ftStatus:=FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@cmd,1,count) ;
    sleep(50);
 //   ftStatus:=FT260_I2CMaster_Read (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@data,4,count,500) ;
 //   memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttoHEX(data)+'  '+inttostr(count));
end;

procedure TMain.Button9Click(Sender: TObject);
var p:pointer;
cmd,addres:byte;
data:Dword;

begin
cmd:=$02;
data:=0;
//  FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@initData3,5,count) ;
  ftStatus:=FT260_I2CMaster_Write (mhandle1, STM_ADDRESS,FT260_I2C_START_AND_STOP,@cmd,1,count) ;
     sleep(150);
   ftStatus:=FT260_I2CMaster_Read (mhandle1,STM_ADDRESS ,FT260_I2C_START_AND_STOP,@n3_data,4,count,500) ;
    memo1.Lines.Add(IntToStr(dword(ftStatus))+' ' +inttoHEX(n3_data[0])+'  '+inttoHEX(n3_data[1])+'  '
   +inttoHEX(n3_data[2])+'  '+inttoHEX(n3_data[3])+'  '+'  ' +inttostr(count));
    FT260_I2CMaster_Reset(mhandle1);

end;

procedure TMain.FormCreate(Sender: TObject);
 begin
  FT260_CreateDeviceList(devNum);
  FT260_Open(0, mhandle1);
  ftStatus := FT260_I2CMaster_Init(mhandle1, 100);


end;



end.
