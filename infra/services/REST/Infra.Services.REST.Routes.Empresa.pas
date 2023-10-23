unit Infra.Services.REST.Routes.Empresa;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON;


procedure Registry();

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure FindAll(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure FindOne(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Remove(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  Util.Service.Params,
  Util.Constants.Api;

procedure Registry();
begin
  THorse.Group.Prefix(_API_ROOT + '/empresas')
    .Get( '/', FindAll)
    .Get( '/:id', FindOne)
    .Post('/', Create)
    .Put( '/:id', Update)
    .Patch( '/:id', Update)
    .Delete( '/:id', Remove)
end;

procedure Create(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
   Res.Send(TJSONString.Create('Create'));
end;

procedure FindAll(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(TJSONString.Create('FindAll'));
end;

procedure FindOne(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
   Res.Send(TJSONString.Create('FindOne'));
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
   Res.Send(TJSONString.Create('Update'));
end;

procedure Remove(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
   Res.Send(TJSONString.Create('Remove'));
end;

end.
