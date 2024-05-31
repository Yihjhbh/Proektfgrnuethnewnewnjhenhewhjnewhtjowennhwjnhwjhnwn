unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  ExtCtrls, MMSystem;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image_Background: TImage;
    Image_Start: TImage;
    Image_Exit: TImage;
    Image_Unmute: TImage;
    Image_Mute: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image_StartClick(Sender: TObject);
    procedure Image_ExitClick(Sender: TObject);
    procedure Image_UnmuteClick(Sender: TObject);
    procedure Image_MuteClick(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

uses umain;
  {$R *.lfm}

  { TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
begin
  BorderIcons := BorderIcons - [bimaximize];
  PlaySound('sound/sound_menu', 0, SND_ASYNC or SND_LOOP);
end;

procedure TForm3.Image_StartClick(Sender: TObject);
begin
  Form1.Show;
  Form3.Hide;
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  PlaySound('sound/sound_press_button', 0, SND_ASYNC);
  Form1.soundswitch := True;
  Form1.Image_Mute.Visible := Image_Unmute.Visible;
  Form1.Image_Unmute.Visible := Image_Mute.Visible;
end;

procedure TForm3.Image_ExitClick(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.Image_UnmuteClick(Sender: TObject);
begin
  PlaySound('sound/sound_menu', 0, SND_ASYNC or SND_LOOP);
  Image_Unmute.Visible := False;
  Image_Mute.Visible := True;
end;

procedure TForm3.Image_MuteClick(Sender: TObject);
begin
  PlaySound(nil, 0, SND_PURGE);
  Image_Mute.Visible := False;
  Image_Unmute.Visible := True;
end;

end.
