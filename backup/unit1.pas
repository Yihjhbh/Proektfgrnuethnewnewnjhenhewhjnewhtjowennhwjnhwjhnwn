unit Unit1;

{$mode ObjFPC}{$H+}

interface

uses
  Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ActnList, Buttons;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
uses umain, unit2;
{$R *.lfm}

{ TForm2 }

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  form3.Close;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caNone;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  BorderIcons:=BorderIcons-[bimaximize];
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  Form2.close;
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form2.Hide;
  floor.shift1:=0;
end;

end.

