unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, BGRAGraphicControl, BGRABitmap, BCTypes, BGRABitmapTypes, Windows, MMSystem;

type

  Tfloor=record
  X, Y, X1, Y1, X2, Y2, fallcounter, shift1, shift, shift2, shift3, lifecounter, speed, speed1: integer;
  fall, falldown, fallcounteractive, jobfloor, dublicate1, dublicate2, dublicate3, dublicate4, invisible, wrongfall: boolean;
  heightfloor: real;
  end;

  Tcrane=record
  jobcrane: boolean;
  angle: single;
  speed: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    BGRAGraphicControl1: TBGRAGraphicControl;
    BGRAGraphicControl2: TBGRAGraphicControl;
    BGRAGraphicControl3: TBGRAGraphicControl;
    BGRAGraphicControl6: TBGRAGraphicControl;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    Timer5: TTimer;
    Timer6: TTimer;
    procedure BGRAGraphicControl1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl2Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl3Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl6Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    craneImage, backgroundImage, floorImage, CopyfloorImage1, CopyfloorImage2: TBGRABitmap;
  end;

var
  Form1: TForm1;
 floor:Tfloor;
 crane:Tcrane;

implementation
uses unit1, unit2;
{$R *.lfm}

{ TForm1 }

procedure TForm1.BGRAGraphicControl1Redraw(Sender: TObject; Bitmap: TBGRABitmap
  );
begin
  bitmap.FillTransparent;
  bitmap.PutImageAngle(Width div 2, -10, craneImage, crane.angle, TResampleFilter.rfBestQuality, craneImage.Width div 2, craneImage.Height);
  if floor.invisible = true then
  bitmap.PutImage(floor.X, floor.Y, floorImage, dmDrawWithTransparency, 255);
end;

procedure TForm1.BGRAGraphicControl2Redraw(Sender: TObject; Bitmap: TBGRABitmap
  );
begin
  if floor.dublicate1= true then
  bitmap.PutImage(floor.X1, floor.Y1+floor.shift, CopyfloorImage1, dmDrawWithTransparency, 255);
  end;

procedure TForm1.BGRAGraphicControl3Redraw(Sender: TObject; Bitmap: TBGRABitmap
  );
begin
  if floor.dublicate2= true then
  bitmap.PutImage(floor.X1, floor.Y1+floor.shift2, CopyfloorImage2, dmDrawWithTransparency, 255);
end;

procedure TForm1.BGRAGraphicControl6Redraw(Sender: TObject; Bitmap: TBGRABitmap
  );
begin
  bitmap.PutImage(Width div 2-274, Height div 2-90+floor.shift1, backgroundImage, dmDrawWithTransparency, 255);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form3.close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  craneImage := TBGRABitmap.Create(ProgramDirectory + 'image/crane.png');
  floorImage := TBGRABitmap.Create(ProgramDirectory + 'image/floor.png');
  backgroundImage := TBGRABitmap.Create(ProgramDirectory + 'image/background.png');
  CopyfloorImage1:= floorImage;
  CopyfloorImage2:= floorImage;

  floor.X:=333;
  floor.Y:=110;
  crane.angle := 135;
  floor.fallcounter:=0;
  floor.lifecounter:=3;
  floor.shift:=0;
  crane.speed:=0;
  floor.speed:=0;
  floor.falldown:= True;
  floor.fall := False;
  floor.jobfloor:= True;
  crane.jobcrane:= True;
  floor.dublicate1:= False;
  floor.dublicate2:= False;
  floor.invisible:= true;
  floor.wrongfall:= false;
  label1.Caption:='Счёт: 0';
  label2.Caption:='Жизни: '+ IntToStr(floor.lifecounter);
  BorderIcons:=BorderIcons-[bimaximize];
  PlaySound('sound/sound_background',0,SND_ASYNC or SND_LOOP);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  craneImage.Free;
  floorImage.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if key=VK_Space then
  begin
  if (floor.fall=false) and (floor.jobfloor=true) then
  floor.fallcounter:= floor.fallcounter+1;
  floor.fall:= True;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  PlaySound(nil, 0, SND_PURGE);
  Image1.Visible:=False;
  Image2.Visible:=True;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  PlaySound('sound/sound_background',0,SND_ASYNC or SND_LOOP);
  Image2.Visible:=False;
  Image1.Visible:=True;
end;

procedure TForm1.Timer1Timer(Sender: TObject); // Код для движения влево
begin
  // Падение первого этажа
  if (floor.fall=True) and (floor.Y<=600) and (floor.falldown=True) then
  begin
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15;
  BGRAGraphicControl1.DiscardBitmap;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Этаж падает мимо другого этажа
  if (floor.fall=True) and (floor.falldown=False) and ((floor.X<= floor.X1-55) or (floor.X>= floor.X1+55)) then
  begin
  floor.wrongfall:= true;
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15+floor.speed;
  BGRAGraphicControl1.DiscardBitmap;
  if (floor.Y >= floor.Y1-10) then
  begin
  floor.invisible:= false;
  floor.X:= floor.X1;
  floor.Y:= floor.Y1;
  end;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Этаж падает на другой этаж
  if (floor.fall=True) and (floor.Y<=floor.Y1-floor.heightfloor) and (floor.falldown=False) and ((floor.X> floor.X1-55) and (floor.X< floor.X1+55)) then
  begin
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15+floor.speed;
  BGRAGraphicControl1.DiscardBitmap;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  if ((floor.Y=110) and (floor.X=333)) then
  floor.jobfloor:= True;
  // Анимация этажа
  if floor.jobfloor= True then
  begin
  floor.invisible:= true;
  if (crane.angle>=135) and (crane.angle<=158)then
  begin
  floor.X:=floor.X-3-floor.speed;
  floor.Y:=floor.Y+1+floor.speed1;
  end;
  if (crane.angle>=158) and (crane.angle<=185) then
  floor.X:=floor.X-3-floor.speed;
  if (crane.angle>=189) and (crane.angle<=225) then
  begin
  floor.X:=floor.X-3-floor.speed;
  floor.Y:=floor.Y-1-floor.speed1;
  end;
  end;
  // Качание крана
  if crane.jobcrane = True then
  begin
  if crane.angle>=135 then
  begin
  crane.angle := crane.angle + 1 + crane.speed;
  BGRAGraphicControl1.DiscardBitmap;
  end;
  if crane.angle=225 then
  begin
  Timer1.Enabled := False;
  Timer2.Enabled := True;
  end;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject); // Код для движения вправо
begin
  // Падение первого этажа
  if (floor.fall=True) and (floor.Y<=600) and (floor.falldown=True) then
  begin
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15;
  BGRAGraphicControl1.DiscardBitmap;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Этаж падает мимо другого этажа
  if (floor.fall=True) and (floor.falldown=False) and ((floor.X<= floor.X1-55) or (floor.X>= floor.X1+55)) then
  begin
  floor.wrongfall:= true;
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15+floor.speed;
  BGRAGraphicControl1.DiscardBitmap;
  if floor.Y >= floor.Y1-10 then
  begin
  floor.invisible:= false;
  floor.X:= floor.X1;
  floor.Y:= floor.Y1;
  end;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Этаж падает на другой этаж
  if (floor.fall=True) and (floor.Y<=floor.Y1-floor.heightfloor) and (floor.falldown=False) and ((floor.X= floor.X1-55) and (floor.X= floor.X1+55)) then
  begin
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15+floor.speed;
  BGRAGraphicControl1.DiscardBitmap;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Анимация этажа
  if floor.jobfloor = True then
  begin
  floor.invisible:= true;
  if (crane.angle<=225) and (crane.angle>=185)then
  begin
  floor.X:=floor.X+3+floor.speed;
  floor.Y:=floor.Y+1+floor.speed1;
  end;
  if (crane.angle<=185) and (crane.angle>=158) then
  floor.X:=floor.X+3+floor.speed;
  if (crane.angle<=158) and (crane.angle>=135) then
  begin
  floor.X:=floor.X+3+floor.speed;
  floor.Y:=floor.Y-2-floor.speed1;
  end;
  end;
  // Качание крана
  if crane.jobcrane=true then
  begin
  if crane.angle<=225 then
  begin
  crane.angle := crane.angle - 1 - crane.speed;
  BGRAGraphicControl1.DiscardBitmap;
  end;
  if crane.angle=135 then
  begin
  Timer2.Enabled := False;
  Timer1.Enabled := True;
  if floor.fall= false then
  begin
  floor.X:=333;
  floor.Y:=110;
  if floor.wrongfall=true then
  begin
  floor.fallcounter:=floor.fallcounter-1;
  floor.lifecounter:=floor.lifecounter-1;
  end;
  if (floor.fallcounter = 5) then
  begin
  crane.speed:= 1;
  floor.speed:= 3;
  floor.speed1:= 1;
  end;
  if (floor.fallcounter = 10) then
  crane.speed:= 2;
  if (floor.fallcounter = 15) then
  crane.speed:= 3;
  if (floor.fallcounter = 20) then
  crane.speed:= 4;
  label1.Caption:='Счёт: '+IntToStr(floor.fallcounter);
  label2.Caption:='Жизни: '+IntToStr(floor.lifecounter);
  if floor.lifecounter=0 then
  begin
  Form1.Hide;
  Form2.Show;
  end;
  floor.wrongfall:=false;
  end;
  end;
  end;
  end;

procedure TForm1.Timer3Timer(Sender: TObject); // Отрисовка этажей
begin
  // Нулевой этаж
  if (floor.fallcounter = 1) and (floor.Y>=600) then
  begin
  floor.falldown:= False;
  floor.fall:= False;
  BGRAGraphicControl2.DiscardBitmap;
  floor.X1:= floor.X;
  floor.Y1:= floor.Y;
  end;
  // Первый этаж
  if (floor.fallcounter mod 2 = 1) and (floor.Y>=floor.Y1-floor.heightfloor) and (floor.fallcounter <> 0) and (floor.fallcounter <> 1)  then
  begin
  floor.falldown:= False;
  floor.fall:= False;
  BGRAGraphicControl2.DiscardBitmap;
  floor.X1:= floor.X;
  floor.Y1:= floor.Y;
  end;
  // Второй этаж
  if (floor.fallcounter mod 2 = 0) and (floor.Y>=floor.Y1-floor.heightfloor) and (floor.fallcounter <> 0) and (floor.fallcounter <> 1) then
  begin
  floor.falldown:= False;
  floor.fall:= False;
  BGRAGraphicControl3.DiscardBitmap;
  floor.X1:= floor.X;
  floor.Y1:= floor.Y;
  end;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
  if (crane.angle>=135) and (crane.angle<=136) and (floor.fallcounter=1) and (floor.wrongfall=false) and (floor.fall=false) then
  begin
  floor.dublicate1:= True;
  floor.shift:= 95;
  floor.shift1:= floor.shift1+95;
  floor.heightfloor:= copyfloorImage1.Height-96;
  BGRAGraphicControl2.DiscardBitmap;
  BGRAGraphicControl6.DiscardBitmap;
  Timer5.Enabled := True;
  Timer4.Enabled := False;
  end;
  end;

procedure TForm1.Timer5Timer(Sender: TObject);
begin
  if (crane.angle>=135) and (crane.angle<=136) and (floor.fallcounter mod 2 = 0) and (floor.wrongfall=false) and (floor.fall=false)  then
  begin
  floor.dublicate2:= True;
  floor.dublicate1:=false;
  BGRAGraphicControl2.DiscardBitmap;
  floor.shift2:=copyfloorImage1.Height;
  floor.shift1:= floor.shift1+95;
  floor.heightfloor:= copyfloorImage1.Height-122;
  BGRAGraphicControl3.DiscardBitmap;
  BGRAGraphicControl6.DiscardBitmap;
  Timer5.Enabled := False;
  Timer6.Enabled := True;
  end;
end;

procedure TForm1.Timer6Timer(Sender: TObject);
begin
  if (crane.angle>=135) and (crane.angle<=136) and (floor.fallcounter mod 2 = 1) and (floor.wrongfall=false) and (floor.fall=false) then
  begin
  floor.dublicate1:=True;
  floor.dublicate2:= False;
  BGRAGraphicControl2.DiscardBitmap;
  floor.shift:=copyfloorImage1.Height;
  floor.shift1:= floor.shift1+95;
  floor.heightfloor:= copyfloorImage1.Height-122;
  BGRAGraphicControl3.DiscardBitmap;
  BGRAGraphicControl6.DiscardBitmap;
  Timer6.Enabled := False;
  Timer5.Enabled := True;
  end;
  end;

 end.
