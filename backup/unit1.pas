unit Unit1;

{$mode ObjFPC}{$H+}

interface

uses
  Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ActnList, Buttons, ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
uses umain, unit2;
{$R *.lfm}

{ TForm2 }

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caNone;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  BorderIcons:=BorderIcons-[bimaximize];
  label2.Caption:= 'Количество очков: ' + inttostr(floor.maxcounter);
end;

procedure TForm2.Image3Click(Sender: TObject);
begin
  form3.Close;
end;

procedure TForm2.Image4Click(Sender: TObject);
begin
  Form2.close;
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form2.Hide;
  floor.shift1:=0;
end;


end.

