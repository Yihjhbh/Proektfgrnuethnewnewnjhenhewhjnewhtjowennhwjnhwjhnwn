unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, BGRAGraphicControl, BGRABitmap, BCTypes, BCMaterialEdit,
  BCRadialProgressBar, BGRAFlashProgressBar, BGRABitmapTypes, Windows, MMSystem;

type

  Tfloor = record
    X, Y, X1, Y1, Y_background, Y1_background, fallcounter, shift1,
    shift, lifecounter, speed, fallspeed, fallboost, combo, combocounter,
    heightfloor: integer;
    fall, falldown, jobfloor, dublicate1, dublicate2, invisible, wrongfall: boolean;
  end;

  Tcrane = record
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
    IdleTimer_ComboEnable: TIdleTimer;
    Image_Unmute: TImage;
    Image_Mute: TImage;
    Image_PanelUp: TImage;
    Label_Point: TLabel;
    Label_Life: TLabel;
    Label_Combo: TLabel;
    Timer_CraneLeft: TTimer;
    Timer_CraneRight: TTimer;
    Timer_Music: TTimer;
    Timer_GroundFloor: TTimer;
    Timer_HonestFloor: TTimer;
    Timer_DishonestFloor: TTimer;
    Timer_Background: TTimer;
    procedure BGRAGraphicControl1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl2Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl3Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl6Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure IdleTimer_ComboEnableTimer(Sender: TObject);
    procedure Image_UnmuteClick(Sender: TObject);
    procedure Image_MuteClick(Sender: TObject);
    procedure Timer_CraneLeftTimer(Sender: TObject);
    procedure Timer_CraneRightTimer(Sender: TObject);
    procedure Timer_MusicTimer(Sender: TObject);
    procedure Timer_GroundFloorTimer(Sender: TObject);
    procedure Timer_HonestFloorTimer(Sender: TObject);
    procedure Timer_DishonestFloorTimer(Sender: TObject);
    procedure Timer_BackgroundTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    craneImage, backgroundImage, background_dayImage, background_nightImage,
    Copybackground_nightImage, Copybackground_dayImage, floorImage,
    CopyfloorImage1, CopyfloorImage2, background_eveningImage,
    Copybackground_eveningImage: TBGRABitmap;
    timercombo, anglelimit: integer;
    soundswitch, soundplay, nighton, keyuping, stopkey, evening, zapis: boolean;
  end;

var
  Form1: TForm1;
  floor: Tfloor;
  crane: Tcrane;
  maxcounter, maxcombo: integer;

implementation

uses unit1, unit2;
  {$R *.lfm}

  { TForm1 }

procedure TForm1.BGRAGraphicControl1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  bitmap.FillTransparent;
  bitmap.PutImageAngle(Width div 2, -10, craneImage, crane.angle,
    TResampleFilter.rfBestQuality, craneImage.Width div 2, craneImage.Height);
  if floor.invisible = True then
    bitmap.PutImage(floor.X, floor.Y, floorImage, dmDrawWithTransparency, 255);
end;

procedure TForm1.BGRAGraphicControl2Redraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  if floor.dublicate1 = True then
    bitmap.PutImage(floor.X1, floor.Y1, CopyfloorImage1, dmDrawWithTransparency, 255);
end;

procedure TForm1.BGRAGraphicControl3Redraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  if floor.dublicate2 = True then
    bitmap.PutImage(floor.X1, floor.Y1, CopyfloorImage2, dmDrawWithTransparency, 255);
end;

procedure TForm1.BGRAGraphicControl6Redraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  if (nighton = False) and (evening = False) then
  begin
    bitmap.PutImage(Width div 2 - 271, floor.Y_background + floor.shift1,
      background_dayImage, dmDrawWithTransparency, 255);
    bitmap.PutImage(Width div 2 - 271, floor.Y1_background + floor.shift1,
      Copybackground_dayImage, dmDrawWithTransparency, 255);
  end;
  if (evening = True) and (nighton = False) then
  begin
    bitmap.PutImage(Width div 2 - 271, floor.Y_background + floor.shift1,
      background_eveningImage, dmDrawWithTransparency, 255);
    bitmap.PutImage(Width div 2 - 271, floor.Y1_background + floor.shift1,
      Copybackground_eveningImage, dmDrawWithTransparency, 255);
  end;
  if (nighton = True) and (evening = False) then
  begin
    bitmap.PutImage(Width div 2 - 271, floor.Y_background + floor.shift1,
      background_nightImage, dmDrawWithTransparency, 255);
    bitmap.PutImage(Width div 2 - 271, floor.Y1_background + floor.shift1,
      Copybackground_nightImage, dmDrawWithTransparency, 255);
  end;
  bitmap.PutImage(Width div 2 - 271, Height div 2 - 418 + floor.shift,
    backgroundImage, dmDrawWithTransparency, 255);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form3.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  craneImage := TBGRABitmap.Create(ProgramDirectory + 'image/crane.png');
  floorImage := TBGRABitmap.Create(ProgramDirectory + 'image/floor.png');
  backgroundImage := TBGRABitmap.Create(ProgramDirectory + 'image/background.png');
  background_dayImage := TBGRABitmap.Create(ProgramDirectory +
    'image/background_day.png');
  background_nightImage := TBGRABitmap.Create(ProgramDirectory +
    'image/background_night.png');
  background_eveningImage := TBGRABitmap.Create(ProgramDirectory +
    'image/background_evening.png');
  CopyfloorImage1 := floorImage;
  CopyfloorImage2 := floorImage;
  Copybackground_nightImage := background_nightImage;
  Copybackground_dayImage := background_dayImage;
  Copybackground_eveningImage:= background_eveningImage;

  floor.Y_background := Height div 2 - 1250;
  floor.Y1_background := Height div 2 - 2082;
  nighton := False;
  evening := False;
  floor.fallcounter := 0;
  floor.fall := False;
  floor.dublicate1 := False;
  floor.dublicate2 := False;
  floor.fallboost := 0;
  floor.combo := 0;
  floor.X := 333;
  floor.Y := 110;
  soundplay := False;
  floor.wrongfall := False;
  floor.combocounter := 0;
  floor.speed := 0;
  crane.speed := 0;
  crane.angle := 135;
  floor.lifecounter := 3;
  floor.shift := 0;
  floor.shift1 := 0;
  zapis:= False;
  maxcombo := -10000;
  floor.falldown := True;
  floor.jobfloor := True;
  crane.jobcrane := True;
  floor.invisible := True;
  floor.heightfloor := copyfloorImage1.Height;
  stopkey := False;
  keyuping := False;
  Label_Point.Caption := 'Счёт: 0';
  Label_Life.Caption := 'Жизни: ' + IntToStr(floor.lifecounter);
  BorderIcons := BorderIcons - [bimaximize];
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  craneImage.Free;
  floorImage.Free;
  background_dayImage.Free;
  backgroundImage.Free;
  background_nightImage.Free;
  background_eveningImage.Free;
end;

//-------------СОБЫТИЯ НАЖАТИЯ КНОПОК И ИХ ОГРАНИЧЕНИЯ--------------\\
procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_Space) and (floor.jobfloor = False) then
  begin
    keyuping := False;
    stopkey := True;
  end;
  if (key = VK_Space) and (floor.jobfloor = True) and (floor.fall = False) and
    (stopkey = False) then
    keyuping := True;
  if (key = VK_Space) and (keyuping = True) then
  begin
    floor.fallspeed := 18 + floor.fallboost;
    floor.fallcounter := floor.fallcounter + 1;
    floor.fall := True;
    keyuping := False;
  end;
  if (key = VK_Escape) then
    form3.Close;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_Space) then
  begin
    keyuping := True;
    stopkey := False;
  end;
end;

procedure TForm1.IdleTimer_ComboEnableTimer(Sender: TObject);
begin
  form1.Label_Combo.Visible:= False;
  IdleTimer_ComboEnable.Interval:=4500;
  IdleTimer_ComboEnable.Enabled:= True;
end;

//-----------------------КНОПКИ ВЫКЛ/ВКЛ МУЗЫКИ----------------------\\
procedure TForm1.Image_UnmuteClick(Sender: TObject);
begin
  PlaySound(nil, 0, SND_PURGE);
  Image_Unmute.Visible := False;
  Image_Mute.Visible := True;
end;

procedure TForm1.Image_MuteClick(Sender: TObject);
begin
  PlaySound('sound/sound_background', 0, SND_ASYNC or SND_LOOP);
  Image_Mute.Visible := False;
  Image_Unmute.Visible := True;
end;

//---------------------ОГРАНИЧЕНИЯ НА ПАДЕНИЕ ЭТАЖА---------------------\\
procedure FloordropRestrictions;
begin
  // Падение первого этажа
  if (floor.falldown = True) and (floor.fall = True) and (floor.Y <= 600) and
    (floor.fallcounter = 1) and ((floor.X > 150) and (floor.X < 255)) then
  begin
    floor.jobfloor := False;
    crane.jobcrane := False;
    floor.Y := floor.Y + 16;
    form1.BGRAGraphicControl1.DiscardBitmap;
    if floor.Y >= 600 then
      floor.fall := False;
    if floor.Y >= 150 then
      crane.jobcrane := True;
  end;
  // Первый этаж падает мимо
  if (floor.falldown = True) and (floor.fall = True) and (floor.fallcounter = 1) and
    ((floor.X <= 150) or (floor.X >= 255)) then
  begin
    floor.wrongfall := True;
    floor.jobfloor := False;
    crane.jobcrane := False;
    floor.Y := floor.Y + 16;
    form1.BGRAGraphicControl1.DiscardBitmap;
    if floor.Y >= 580 then
    begin
      floor.invisible := False;
      floor.X := 333;
      floor.Y := 600;
      floor.fall := False;
    end;
    if floor.Y >= 150 then
      crane.jobcrane := True;
  end;
  // Этаж падает мимо другого этажа
  if (floor.falldown = False) and (floor.fall = True) and (floor.fallcounter >= 1) and
    ((floor.X <= floor.X1 - 55) or (floor.X >= floor.X1 + 55)) then
  begin
    floor.combo := 0;
    floor.wrongfall := True;
    floor.jobfloor := False;
    crane.jobcrane := False;
    floor.Y := floor.Y + floor.fallspeed;
    form1.BGRAGraphicControl1.DiscardBitmap;
    if floor.Y >= floor.Y1 - floor.heightfloor then
    begin
      floor.invisible := False;
      floor.X := floor.X1;
      floor.Y := floor.Y1;
      floor.fall := False;
    end;
    if floor.Y >= 150 then
      crane.jobcrane := True;
  end;
  // Этаж падает на другой этаж
  if (floor.falldown = False) and (floor.fall = True) and
    (floor.Y <= floor.Y1 - floor.heightfloor) and (floor.fallcounter >= 1) and
    ((floor.X > floor.X1 - 55) and (floor.X < floor.X1 + 55)) then
  begin
    floor.jobfloor := False;
    crane.jobcrane := False;
    floor.Y := floor.Y + floor.fallspeed;
    form1.BGRAGraphicControl1.DiscardBitmap;
    if floor.Y >= floor.Y1 - floor.heightfloor then
      floor.fall := False;
    if floor.Y >= 150 then
      crane.jobcrane := True;
    // Вычисление комбо
    if (floor.X >= floor.X1 - 2) and (floor.X <= floor.X1 + 2) and
      (floor.Y >= floor.Y1 - floor.heightfloor) then
    begin
      if floor.X >= 200 then
      begin
        form1.Label_Combo.Font.Orientation := 225;
        form1.Label_Combo.Left := floor.X - 100;
        form1.Label_Combo.Top := floor.Y - 125;
      end
      else
      begin
        form1.Label_Combo.Font.Orientation := -225;
        form1.Label_Combo.Left := floor.X + 100;
        form1.Label_Combo.Top := floor.Y - 125;
      end;
      form1.label_Combo.Visible := True;
      form1.IdleTimer_ComboEnable.Enabled:= True;
      floor.combo := floor.combo + 1;
      if maxcombo < floor.combo then
        maxcombo := floor.combo;
      if floor.combo = 1 then
      begin
        form1.label_Combo.Caption := 'Идеально!  +2';
        floor.combocounter := floor.combocounter + 1;
      end;
      if floor.combo > 1 then
      begin
        form1.label_Combo.Caption := 'Комбо X' + IntToStr(floor.combo - 1) +
          '  +' + IntToStr(4 * (floor.combo - 1));
        floor.combocounter := floor.combocounter + 4 * (floor.combo - 1) - 1;
      end;
    end
    else if (floor.Y >= floor.Y1 - floor.heightfloor) then
    begin
      floor.combo := 0;
      if form1.label_Combo.Visible = false then
      form1.label_Combo.Caption := 'Идеально!  +2';
    end;
  end;
end;

//-------------------------ДВИЖЕНИЕ КРАНА ВЛЕВО-------------------------\\
procedure TForm1.Timer_CraneLeftTimer(Sender: TObject);
begin
  FloordropRestrictions;
  if (floor.Y = 110) and (floor.X = 333) then
    floor.jobfloor := True;
  // Анимация этажа
  if floor.jobfloor = True then
  begin
    floor.invisible := True;
    if ((crane.angle >= 135) or (crane.angle >= 145)) and (crane.angle <= 158) then
    begin
      floor.X := floor.X - 3 - floor.speed;
      floor.Y := floor.Y + 1 + crane.speed;
    end;
    if (crane.angle >= 158) and (crane.angle <= 202) then
      floor.X := floor.X - 3 - floor.speed;
    if (crane.angle >= 202) and (crane.angle <= 225) then
    begin
      floor.X := floor.X - 2 - floor.speed;
      floor.Y := floor.Y - 1 - crane.speed;
    end;
  end;
  // Качание крана
  if crane.jobcrane = True then
  begin
    if crane.angle >= 135 then
    begin
      crane.angle := crane.angle + 1 + crane.speed;
      BGRAGraphicControl1.DiscardBitmap;
    end;
    if crane.angle = 225 then
    begin
      Timer_CraneLeft.Enabled := False;
      Timer_CraneRight.Enabled := True;
    end;
  end;
end;

//------------------------ДВИЖЕНИЕ КРАНА ВПРАВО------------------------\\
procedure TForm1.Timer_CraneRightTimer(Sender: TObject);
begin
  FloordropRestrictions;
  // Анимация этажа
  if floor.jobfloor = True then
  begin
    floor.invisible := True;
    if (crane.angle <= 225) and (crane.angle >= 202) then
    begin
      floor.X := floor.X + 2 + floor.speed;
      floor.Y := floor.Y + 1 + crane.speed;
    end;
    if (crane.angle <= 202) and (crane.angle >= 158) then
      floor.X := floor.X + 3 + floor.speed;
    if (crane.angle <= 158) and ((crane.angle >= 135) or (crane.angle >= 145)) then
    begin
      floor.X := floor.X + 3 + floor.speed;
      floor.Y := floor.Y - 1 - crane.speed;
    end;
  end;
  // Качание крана
  if crane.jobcrane = True then
  begin
    if crane.angle <= 225 then
    begin
      crane.angle := crane.angle - 1 - crane.speed;
      BGRAGraphicControl1.DiscardBitmap;
    end;
    if crane.angle = 135 then
    begin
      Timer_CraneRight.Enabled := False;
      Timer_CraneLeft.Enabled := True;
      if floor.fall = False then
      begin
        floor.X := 333;
        floor.Y := 110;
        if (floor.wrongfall = False) and (floor.fallcounter = 1) then
          floor.falldown := False;
        if floor.wrongfall = True then
        begin
          floor.fallcounter := floor.fallcounter - 1;
          floor.lifecounter := floor.lifecounter - 1;
        end;
        //Увеличение скорости качания крана и падения этажа
        if floor.fallcounter = 3 then
        begin
          crane.speed := 1;
          floor.speed := 3;
          floor.fallboost := 20;
          anglelimit := 5;
        end;
        if floor.fallcounter = 10 then
        begin
          crane.speed := 2;
          floor.speed := 6;
          floor.fallboost := 40;
          anglelimit := 10;
        end;
        if floor.fallcounter = 21 then
        begin
          crane.speed := 4;
          floor.speed := 12;
          floor.fallboost := 60;
          anglelimit := 20;
        end;
        if floor.fallcounter = 42 then
        begin
          crane.speed := 8;
          floor.speed := 24;
          floor.fallboost := 80;
          anglelimit := 34;
        end;
        if ((floor.fallcounter mod 77 = 0) or (floor.fallcounter mod 112 = 0) or
          (floor.fallcounter = 21)) and (floor.fallcounter <> 0) then
        begin
          nighton := False;
          evening := True;
          BGRAGraphicControl6.DiscardBitmap;
        end;
        if (floor.fallcounter mod 91 = 0) and (floor.fallcounter <> 0) then
        begin
          evening := False;
          nighton := False;
          BGRAGraphicControl6.DiscardBitmap;
        end;
        if ((floor.fallcounter mod 133 = 0) or (floor.fallcounter = 42)) and
          (floor.fallcounter <> 0) then
        begin
          nighton := True;
          evening := False;
          BGRAGraphicControl6.DiscardBitmap;
        end;
        //Подсчет жизней и очков
        Label_Life.Caption := 'Жизни: ' + IntToStr(floor.lifecounter);
        maxcounter := floor.fallcounter + floor.combocounter;
        Label_Point.Caption := 'Счёт: ' + IntToStr(maxcounter);
        if maxcounter >= 10 then
          Label_Point.Left := 414;
        if maxcounter >= 100 then
          Label_Point.Left := 408;
        if floor.lifecounter = 0 then
        begin
          if form1.soundplay = False then
          begin
            PlaySound('sound/sound_game_over', 0, SND_ASYNC);
            Form3.Image_Mute.Visible := Form1.Image_UnMute.Visible;
            Form3.Image_UnMute.Visible := Form1.Image_Mute.Visible;
            form1.soundplay := True;
          end;
          Form1.Hide;
          Form2.Show;
        end;
        floor.wrongfall := False;
      end;
    end;
  end;
end;

//-------------------------------МУЗЫКА-------------------------------\\
procedure TForm1.Timer_MusicTimer(Sender: TObject);
begin
  if (soundswitch = True) and (Form3.Image_Mute.Visible = True) then
  begin
    PlaySound('sound/sound_background', 0, SND_ASYNC or SND_LOOP);
    soundswitch := False;
  end;

end;

//--------------------ОТРИСОВКА КОПИИ ПЕРВОГО ЭТАЖА--------------------\\
procedure TForm1.Timer_GroundFloorTimer(Sender: TObject);
begin
  if (crane.angle >= 135) and (crane.angle <= 136+anglelimit) and (floor.fallcounter = 1) and
    (floor.wrongfall = False) and (floor.fall = False) then
  begin
    floor.dublicate1 := True;
    floor.Y := 709;
    floor.shift := floor.shift + 119;
    floor.shift1 := floor.shift1 + 119;
    BGRAGraphicControl2.DiscardBitmap;
    BGRAGraphicControl6.DiscardBitmap;
    Timer_HonestFloor.Enabled := True;
    Timer_GroundFloor.Enabled := False;
    floor.X1 := floor.X;
    floor.Y1 := floor.Y;
  end;
end;

//--------------------ОТРИСОВКА КОПИИ ЧЕТНЫХ ЭТАЖЕЙ--------------------\\
procedure TForm1.Timer_HonestFloorTimer(Sender: TObject);
begin
  if (crane.angle >= 100) and (crane.angle <= 136+anglelimit) and (floor.fallcounter mod 2 = 0) and
    (floor.wrongfall = False) and (floor.fall = False) and
    (floor.Y >= floor.Y1 - floor.heightfloor) then
  begin
    floor.dublicate2 := True;
    floor.dublicate1 := False;
    BGRAGraphicControl2.DiscardBitmap;
    floor.Y := 709;
    floor.shift1 := floor.shift1 + 119;
    floor.shift := floor.shift + 119;
    BGRAGraphicControl3.DiscardBitmap;
    BGRAGraphicControl6.DiscardBitmap;
    Timer_HonestFloor.Enabled := False;
    Timer_DishonestFloor.Enabled := True;
    floor.X1 := floor.X;
    floor.Y1 := floor.Y;
  end;
end;

//--------------------ОТРИСОВКА КОПИИ НЕЧЕТНЫХ ЭТАЖЕЙ--------------------\\
procedure TForm1.Timer_DishonestFloorTimer(Sender: TObject);
begin
  if (crane.angle >= 100) and (crane.angle <= 136+anglelimit) and (floor.fallcounter mod 2 = 1) and
    (floor.wrongfall = False) and (floor.fall = False) and
    (floor.Y >= floor.Y1 - floor.heightfloor) then
  begin
    floor.dublicate1 := True;
    floor.dublicate2 := False;
    BGRAGraphicControl2.DiscardBitmap;
    floor.Y := 709;
    floor.shift1 := floor.shift1 + 119;
    floor.shift := floor.shift + 119;
    BGRAGraphicControl3.DiscardBitmap;
    BGRAGraphicControl6.DiscardBitmap;
    Timer_DishonestFloor.Enabled := False;
    Timer_HonestFloor.Enabled := True;
    floor.X1 := floor.X;
    floor.Y1 := floor.Y;
  end;
end;

//------------------------АНИМАЦИЯ ЗАДНЕГО ФОНА------------------------\\
procedure TForm1.Timer_BackgroundTimer(Sender: TObject);
begin
  if (floor.shift1 = 1666) or (floor.shift1 = 833) then
  begin
    ;
    floor.shift1 := 0;
    floor.Y_background := Height div 2 - 418;
    floor.Y1_background := Height div 2 - 1250;
    BGRAGraphicControl6.DiscardBitmap;
  end;

  if ((floor.Y1 - floor.heightfloor / 2) - (floor.Y + floor.heightfloor / 2) < floor.fallspeed) and
    (floor.fallcounter > 1) then
    floor.fallspeed := (floor.Y1 - floor.heightfloor div 2) - (floor.Y + floor.heightfloor div 2);

end;

end.
