unit Infra.Services.REST.Routes;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON;


procedure Registry();

procedure GetApiRoot(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetApiHome(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  Util.Service.Params,

  Infra.Services.REST.Routes.Empresa,
  Util.Constants.Api;

procedure Registry();
begin
  THorse.Get('/', GetApiRoot);
  THorse.Get( _API_ROOT , GetApiHome);

  Infra.Services.REST.Routes.Empresa.Registry();
end;

procedure GetApiRoot(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(TJSONString.Create('Servidor Ativo!'));
end;

procedure GetApiHome(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(TJSONString.Create('API Ativa!'));
end;

end.
