unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TActivationSuccess = class(TForm)
    StaticText1: TStaticText;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ActivationSuccess: TActivationSuccess;

implementation

{$R *.dfm}

end.
