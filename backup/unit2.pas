unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  ExtCtrls, MMSystem;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
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
  BorderIcons:=BorderIcons-[bimaximize];
  PlaySound('sound/sound_menu',0,SND_ASYNC or SND_LOOP);
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
  Form1.Free;
  Form1.Show;
  Form3.Hide;
  Application.CreateForm(TForm1, Form1);
  PlaySound('sound/sound_press_button',0,SND_ASYNC);
  Form1.soundswitch:=True;
end;

procedure TForm3.Image3Click(Sender: TObject);
begin
  Form3.close;
end;

procedure TForm3.Image4Click(Sender: TObject);
begin
  PlaySound('sound/sound_menu',0,SND_ASYNC or SND_LOOP);
  Image4.Visible:=False;
  Image5.Visible:=True;
end;

procedure TForm3.Image5Click(Sender: TObject);
begin
  PlaySound(nil, 0, SND_PURGE);
  Image5.Visible:=False;
  Image4.Visible:=True;
end;
end.

