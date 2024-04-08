unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation
uses umain;
{$R *.lfm}

{ TForm3 }

procedure TForm3.BitBtn1Click(Sender: TObject);
begin
  Form1.Free;
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form3.Hide;
end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin
  Form3.close;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  BorderIcons:=BorderIcons-[bimaximize];
end;

end.

