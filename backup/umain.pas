unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, BGRAGraphicControl, BGRABitmap, BCTypes, BCMaterialEdit,
  BCRadialProgressBar, BGRAFlashProgressBar, BGRABitmapTypes, Windows, MMSystem;

type

  Tfloor=record
  X, Y, X1, Y1, Y_background, Y1_background, fallcounter, shift1, shift, lifecounter, speed, fallspeed, combo, combocounter, maxcounter, maxcombo, dropdistance, heightfloor: integer;
  fall, falldown, fallcounteractive, jobfloor, dublicate1, dublicate2, dublicate3, dublicate4, invisible, wrongfall: boolean;
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
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    Timer5: TTimer;
    Timer6: TTimer;
    Timer7: TTimer;
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
    procedure Timer7Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    craneImage, backgroundImage, background_dayImage, background_nightImage, Copybackground_nightImage, Copybackground_dayImage, floorImage, CopyfloorImage1, CopyfloorImage2: TBGRABitmap;
    soundswitch: boolean;
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
  bitmap.PutImage(floor.X1, floor.Y1, CopyfloorImage1, dmDrawWithTransparency, 255);
  end;

procedure TForm1.BGRAGraphicControl3Redraw(Sender: TObject; Bitmap: TBGRABitmap
  );
begin
  if floor.dublicate2= true then
  bitmap.PutImage(floor.X1, floor.Y1, CopyfloorImage2, dmDrawWithTransparency, 255);
end;

procedure TForm1.BGRAGraphicControl6Redraw(Sender: TObject; Bitmap: TBGRABitmap
  );
begin
  //bitmap.PutImage(Width div 2-271, Height div 2-1248+floor.shift1, background_nightImage, dmDrawWithTransparency, 255);
  //bitmap.PutImage(Width div 2-271, floor.Y1_background+floor.shift1, Copybackground_nightImage, dmDrawWithTransparency, 255);
  bitmap.PutImage(Width div 2-271, floor.Y_background+floor.shift1, background_dayImage, dmDrawWithTransparency, 255);
  bitmap.PutImage(Width div 2-271, floor.Y1_background+floor.shift1, Copybackground_dayImage, dmDrawWithTransparency, 255);
  bitmap.PutImage(Width div 2-271, Height div 2-418+floor.shift, backgroundImage, dmDrawWithTransparency, 255);
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
  background_dayImage := TBGRABitmap.Create(ProgramDirectory + 'image/background_day.png');
  background_nightImage := TBGRABitmap.Create(ProgramDirectory + 'image/background_night.png');
  CopyfloorImage1:= floorImage;
  CopyfloorImage2:= floorImage;
  Copybackground_nightImage:= background_nightImage;
  Copybackground_dayImage:= background_dayImage;

  floor.Y_background:= Height div 2-1250;
  floor.Y1_background:= Height div 2-2082;
  floor.X:=333;
  floor.Y:=110;
  crane.angle := 135;
  floor.lifecounter:=3;
  floor.falldown:= True;
  floor.jobfloor:= True;
  crane.jobcrane:= True;
  floor.invisible:= True;
  label1.Caption:='Счёт: 0';
  label2.Caption:='Жизни: '+ IntToStr(floor.lifecounter);
  BorderIcons:=BorderIcons-[bimaximize];
  label3.Font.Orientation:=300;
  Image2.Visible:=Form3.Image4.Visible;
  Image1.Visible:=Form3.Image5.Visible;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  craneImage.Free;
  floorImage.Free;
  background_dayImage.Free;
  backgroundImage.Free;
  background_nightImage.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (key=VK_Space) and (floor.fall=false) and (floor.jobfloor=true) then
  begin
  floor.fallcounter:= floor.fallcounter+1;
  floor.fall:= True;
  floor.fallspeed:=18+floor.speed;
  end;
end;

//-----------------------КНОПКА ВЫКЛЮЧЕНИЯ МУЗЫКИ----------------------\\
procedure TForm1.Image1Click(Sender: TObject);
begin
  PlaySound(nil, 0, SND_PURGE);
  Image1.Visible:=False;
  Image2.Visible:=True;
end;

//-----------------------КНОПКА ВКЛЮЧЕНИЯ МУЗЫКИ-----------------------\\
procedure TForm1.Image2Click(Sender: TObject);
begin
  PlaySound('sound/sound_background',0,SND_ASYNC or SND_LOOP);
  Image2.Visible:=False;
  Image1.Visible:=True;
end;

//---------------------ОГРАНИЧЕНИЯ НА ПАДЕНИЕ ЭТАЖА---------------------\\
procedure FloordropRestrictions;
begin
  // Падение первого этажа
  if (floor.falldown=True) and (floor.fall=True) and (floor.Y<=600) and (floor.fallcounter = 1) and ((floor.X>150) and (floor.X< 255)) then
  begin
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15;
  form1.BGRAGraphicControl1.DiscardBitmap;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Первый этаж падает мимо
  if (floor.falldown=True) and (floor.fall=True) and (floor.fallcounter = 1) and ((floor.X<= 150) or (floor.X>= 255)) then
  begin
  floor.wrongfall:= true;
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+15;
  form1.BGRAGraphicControl1.DiscardBitmap;
  if floor.Y >= 580 then
  begin
  floor.invisible:= false;
  floor.X:= 333;
  floor.Y:= 600;
  floor.fall:=False;
  end;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Этаж падает мимо другого этажа
  if (floor.falldown=False) and (floor.fall=True) and (floor.fallcounter>=1) and ((floor.X<= floor.X1-55) or (floor.X>= floor.X1+55)) then
  begin
  floor.combo:=0;
  floor.wrongfall:= true;
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+18;
  form1.BGRAGraphicControl1.DiscardBitmap;
  if floor.Y >= floor.Y1-floor.heightfloor then
  begin
  floor.invisible:= false;
  floor.X:= floor.X1;
  floor.Y:= floor.Y1;
  floor.fall:=False;
  end;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  end;
  // Этаж падает на другой этаж
  if (floor.falldown=False) and (floor.fall=True) and (floor.Y<=floor.Y1-floor.heightfloor) and (floor.fallcounter>=1) and ((floor.X> floor.X1-55) and (floor.X< floor.X1+55)) then
  begin
  floor.jobfloor:= False;
  crane.jobcrane:= False;
  floor.Y:= floor.Y+floor.fallspeed;
  form1.BGRAGraphicControl1.DiscardBitmap;
  if floor.Y>= 150 then
  crane.jobcrane:= True;
  // Вычисление комбо
  if (floor.X>= floor.X1-2) and (floor.X<= floor.X1+2) and (floor.Y>= floor.Y1-floor.heightfloor) then
  begin
  form1.label3.Visible:= True;
  floor.combo:= floor.combo+1;
  if floor.combo=1 then
  floor.combocounter:= floor.combocounter+1;
  if floor.combo> 1 then
  begin
  form1.label3.Caption:= 'Комбо X'+inttostr(floor.combo-1)+'  +'+inttostr(4*(floor.combo-1));
  floor.combocounter:= floor.combocounter+4*(floor.combo-1)-1;
  end;
  end
  else if (floor.Y >= floor.Y1-floor.heightfloor) then
  begin
  floor.combo:=0;
  form1.label3.Caption:='Идеально!  +2'
  end;
  end;
end;

//-------------------------ДВИЖЕНИЕ КРАНА ВЛЕВО-------------------------\\
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  FloordropRestrictions;
  if (floor.Y=110) and (floor.X=333) then
  floor.jobfloor:= True;
  // Анимация этажа
  if floor.jobfloor= True then
  begin
  floor.invisible:= true;
  if (crane.angle>=135) and (crane.angle<=158)then
  begin
  floor.X:=floor.X-3-floor.speed;
  floor.Y:=floor.Y+1+crane.speed;
  end;
  if (crane.angle>=158) and (crane.angle<=202) then
  floor.X:=floor.X-3-floor.speed;
  if (crane.angle>=202) and (crane.angle<=225) then
  begin
  floor.X:=floor.X-2-floor.speed;
  floor.Y:=floor.Y-1-crane.speed;
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

//------------------------ДВИЖЕНИЕ КРАНА ВПРАВО------------------------\\
procedure TForm1.Timer2Timer(Sender: TObject);
begin
  form1.Caption:=inttostr(floor.Y)+', '+inttostr(floor.X)+', '+inttostr(floor.maxcounter)+', '+inttostr(floor.fallcounter)+', '+inttostr(floor.shift1);
  FloordropRestrictions;
  // Анимация этажа
  if floor.jobfloor = True then
  begin
  floor.invisible:= true;
  if (crane.angle<=225) and (crane.angle>=202)then
  begin
  floor.X:=floor.X+2+floor.speed;
  floor.Y:=floor.Y+1+crane.speed;
  end;
  if (crane.angle<=202) and (crane.angle>=158) then
  floor.X:=floor.X+3+floor.speed;
  if (crane.angle<=158) and (crane.angle>=135) then
  begin
  floor.X:=floor.X+3+floor.speed;
  floor.Y:=floor.Y-1-crane.speed;
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
  label3.Visible:= False;
  if floor.fall= false then
  begin
  floor.X:=333;
  floor.Y:=110;
  if (floor.wrongfall=false) and (floor.fallcounter=1) then
  floor.falldown:=False;
  if floor.wrongfall=true then
  begin
  floor.fallcounter:=floor.fallcounter-1;
  floor.lifecounter:=floor.lifecounter-1;
  end;
  //Увеличение скорости качания крана
  if (floor.fallcounter = 5) then
  begin
  crane.speed:= 1;
  floor.speed:= 3;
  end;
  if (floor.fallcounter = 10) then
  begin
  crane.speed:= 2;
  floor.speed:= 6;
  end;
  //Подсчет жизней и очков
  label2.Caption:='Жизни: '+IntToStr(floor.lifecounter);
  label1.Caption:='Счёт: '+IntToStr(floor.fallcounter+floor.combocounter);
  floor.maxcounter:=floor.fallcounter+floor.combocounter;
  if floor.maxcounter>= 10 then
  label1.Left:=416;
  if floor.maxcounter>= 100 then
  label1.Left:=412;
  if floor.lifecounter=0 then
  begin
  maxcounter:=floor.maxcounter;
  Form1.Hide;
  Form2.Show;
  end;
  floor.wrongfall:=false;
  end;
  end;
  end;
  end;

//-------------------МУЗЫКА И ОГРАНИЧЕНИЯ КОПИЙ ЭТАЖА-------------------\\
procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if (soundswitch= True) and (Form3.Image5.Visible=True) then
  begin
  PlaySound('sound/sound_background',0,SND_ASYNC or SND_LOOP);
  soundswitch:= False;
  end;
  if (floor.fallcounter = 1) and (floor.Y>=600) then
  begin
  floor.fall:= False;
  end;
  if (floor.fallcounter mod 2 = 1) and (floor.Y>=floor.Y1-floor.heightfloor) and (floor.fallcounter <> 0) and (floor.fallcounter <> 1)  then
  begin
  floor.fall:= False;
  end;
  if (floor.fallcounter mod 2 = 0) and (floor.Y>=floor.Y1-floor.heightfloor) and (floor.fallcounter <> 0) and (floor.fallcounter <> 1) then
  begin
  floor.fall:= False;
  end;
end;

//--------------------ОТРИСОВКА КОПИИ ПЕРВОГО ЭТАЖА--------------------\\
procedure TForm1.Timer4Timer(Sender: TObject);
begin
  if (crane.angle>=135) and (crane.angle<=136) and (floor.fallcounter=1) and (floor.wrongfall=false) and (floor.fall=false)  then
  begin
  floor.dublicate1:= True;
  floor.Y:=709;
  floor.shift:= floor.shift+119;
  floor.shift1:= floor.shift1+119;
  floor.heightfloor:= copyfloorImage1.Height;
  BGRAGraphicControl2.DiscardBitmap;
  BGRAGraphicControl6.DiscardBitmap;
  Timer5.Enabled := True;
  Timer4.Enabled := False;
  floor.X1:= floor.X;
  floor.Y1:= floor.Y;
  end;
  end;

//--------------------ОТРИСОВКА КОПИИ ЧЕТНЫХ ЭТАЖЕЙ--------------------\\
procedure TForm1.Timer5Timer(Sender: TObject);
begin
  if (crane.angle>=135) and (crane.angle<=140) and (floor.fallcounter mod 2 = 0) and (floor.wrongfall=false) and (floor.fall=false) then
  begin
  floor.dublicate2:= True;
  floor.dublicate1:=false;
  BGRAGraphicControl2.DiscardBitmap;
  floor.Y:=709;
  floor.shift1:= floor.shift1+119;
  floor.shift:= floor.shift+119;
  floor.heightfloor:= copyfloorImage1.Height;
  BGRAGraphicControl3.DiscardBitmap;
  BGRAGraphicControl6.DiscardBitmap;
  Timer5.Enabled := False;
  Timer6.Enabled := True;
  floor.X1:= floor.X;
  floor.Y1:= floor.Y;
  end;
end;

//--------------------ОТРИСОВКА КОПИИ НЕЧЕТНЫХ ЭТАЖЕЙ--------------------\\
procedure TForm1.Timer6Timer(Sender: TObject);
begin
  if (crane.angle>=135) and (crane.angle<=140) and (floor.fallcounter mod 2 = 1) and (floor.wrongfall=false) and (floor.fall=false) then
  begin
  floor.dublicate1:=True;
  floor.dublicate2:= False;
  BGRAGraphicControl2.DiscardBitmap;
  floor.Y:=709;
  floor.shift1:= floor.shift1+119;
  floor.shift:= floor.shift+119;
  floor.heightfloor:= copyfloorImage1.Height;
  BGRAGraphicControl3.DiscardBitmap;
  BGRAGraphicControl6.DiscardBitmap;
  Timer6.Enabled := False;
  Timer5.Enabled := True;
  floor.X1:= floor.X;
  floor.Y1:= floor.Y;
  end;
  end;

procedure TForm1.Timer7Timer(Sender: TObject);
begin
  if (floor.shift1 = 1666) or (floor.shift1 = 833) then
  begin
  floor.shift1:=0;
  floor.Y_background:= Height div 2-418;
  floor.Y1_background:= Height div 2-1250;
  BGRAGraphicControl6.DiscardBitmap;
  end;

  if (floor.Y1-floor.heightfloor)-floor.Y< 18 then
  floor.fallspeed:=(floor.Y1-floor.heightfloor div 2)-(floor.Y+floor.heightfloor div 2);
end;

 end.
