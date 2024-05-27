unit Unit1;

{$mode ObjFPC}{$H+}

interface

uses
  Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ActnList, Buttons, ExtCtrls;

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
end;

procedure TForm2.Image_ExitClick(Sender: TObject);
begin
  form3.Close;
end;

procedure TForm2.Image_AgainClick(Sender: TObject);
begin
  Form2.close;
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form2.Hide;
  floor.shift1:=0;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  Label_MaxPoint.Caption:= 'Количество очков: ' + inttostr(maxcounter);
  Label_MaxCombo.Caption:= 'Лучшее комбо: ' + inttostr(maxcombo);
end;


end.

