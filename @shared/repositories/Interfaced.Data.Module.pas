unit Interfaced.Data.Module;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TInterfacedDataModule = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
