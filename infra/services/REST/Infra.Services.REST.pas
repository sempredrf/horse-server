unit Infra.Services.REST;

interface

uses
  System.SysUtils,
  System.IOUtils,
  Domain.Services.Interfaces,
  Horse.Logger.Manager;

type
  TInfraServiceREST = class(TInterfacedObject, iInfraServiceREST)
  private
    [weak]
    FParent : iInfraServices;

  protected
    class var FInstance : iInfraServiceREST;

    constructor Create(const aParent : iInfraServices);
  public
    destructor Destroy(); override;

    class function GetInstance(const aParent : iInfraServices) : iInfraServiceREST;

    function StartListening() : iInfraServiceREST;

    function &End(): iInfraServices;
  end;

implementation

uses
  Horse,
  Horse.Compression,
  Horse.Jhonson,
  Horse.Cors,
  Horse.HandleException,

  Dataset.Serialize,

  Util.Constants.Api,
  Util.Service.Params,

  Logs.Services,
  Logs.Services.Horse.Provider,

  Infra.Services.REST.Routes;

{ THttpServerApi }

function TInfraServiceREST.&End: iInfraServices;
begin
  result := FParent;
end;

constructor TInfraServiceREST.Create(const aParent : iInfraServices);
begin
  FParent := aParent;

  TDataSetSerializeConfig.GetInstance
    .Export
      .ExportNullValues := false;
end;

destructor TInfraServiceREST.Destroy;
begin

  inherited;
end;

class function TInfraServiceREST.GetInstance(const aParent : iInfraServices): iInfraServiceREST;
begin
  if not Assigned(FInstance) then
    FInstance := self.Create(aParent);

  result := FInstance;
end;

function TInfraServiceREST.StartListening: iInfraServiceREST;
begin
  result := self;

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogCustom.New());

  THorse
    .Use(THorseLoggerManager.HorseCallback)
    .Use( Compression() )
    .Use( Jhonson )
    .Use( Cors )
    .Use( HandleException );

  Infra.Services.REST.Routes.Registry();

  THorse.Listen( TUtilServiceParams.GetInstance.Api<integer>('port', 9000) ,
      procedure
      begin
        Log.Debug('THorse.Listen: '
                    +Format('Server started on %s:%d', [THorse.Host, THorse.Port])
                    +'| Versão: '
                    +THorse.Version);

        WriteLn(Format('Serviço Iniciado! Servidor/Porta: %s:%d', [THorse.Host, THorse.Port])
                    +'| Versão: '
                    +THorse.Version);

        Readln;
      end);
end;

end.
