unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  ExtCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
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
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  Form1.ShowModal;
  Form1.Show;
  Form3.Hide;
end;

procedure TForm3.Image3Click(Sender: TObject);
begin
  Form3.close;
end;

end.

