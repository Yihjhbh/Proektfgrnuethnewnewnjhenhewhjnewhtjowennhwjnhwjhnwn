unit Unit1;

{$mode ObjFPC}{$H+}

interface

uses
  Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ActnList, Buttons, ExtCtrls, MMSystem;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image_Background: TImage;
    Image_Exit: TImage;
    Image_Again: TImage;
    Label_Result1: TLabel;
    Label_MaxPoint: TLabel;
    Label_MaxCombo: TLabel;
    Label_Result: TLabel;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image_ExitClick(Sender: TObject);
    procedure Image_AgainClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    soundplay: boolean;
  end;

var
  Form2: TForm2;

implementation

uses umain, unit2;
  {$R *.lfm}

  { TForm2 }

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  form3.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  BorderIcons := BorderIcons - [bimaximize];
end;

procedure TForm2.Image_ExitClick(Sender: TObject);
begin
  form3.Close;
end;

procedure TForm2.Image_AgainClick(Sender: TObject);
begin
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form2.Hide;
  PlaySound('sound/sound_press_button', 0, SND_ASYNC);
  Form1.soundswitch := True;
  Form1.Image_Mute.Visible := Form3.Image_UnMute.Visible;
  Form1.Image_UnMute.Visible := Form3.Image_Mute.Visible;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  Label_MaxPoint.Caption := 'Количество очков: ' + IntToStr(maxcounter);
  if maxcombo < 0 then
    Label_MaxCombo.Caption := 'Лучшее комбо: X0';
  if maxcombo >= 0 then
    Label_MaxCombo.Caption := 'Лучшее комбо: X' + IntToStr(maxcombo - 1);
end;


end.
