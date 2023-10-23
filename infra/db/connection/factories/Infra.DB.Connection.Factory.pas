unit Infra.DB.Connection.Factory;

interface

uses
  System.SysUtils,
  System.Classes,

  Domain.Services.Interfaces,
  Infra.DB.Params.Interfaces;

type
  TDBConnectionFactory = class(TInterfacedObject, iDBConnectionFactory)
  strict protected
    class var FInstance : iDBConnectionFactory;
  private
    FParams : iDBParamsConnection;

    [weak]
    FParent : iInfraServices;

    constructor Create(const aParent :  iInfraServices);
  public
    destructor Destroy(); override;

    class function GetInstance(const aParent :  iInfraServices) : iDBConnectionFactory;

    function Connection() : iDBConnection;
    function &End() : iInfraServices;
  end;

implementation

{ TDBConnectionFactory }

uses
  FireDAC.Comp.Client,

  Infra.DB.Params.Connection,
  Infra.DB.Connection;

function TDBConnectionFactory.&End: iInfraServices;
begin
  result := FParent;
end;

function TDBConnectionFactory.Connection: iDBConnection;
begin
  result := TDBConnection.New(  FParent,
                                FParams );
end;

constructor TDBConnectionFactory.Create(const aParent :  iInfraServices);
begin
  FParent := aParent;
  FParams := TDBParamsConnections.GetInstance();

  FDManager.Active := false;
  FDManager.ConnectionDefs.Clear();
  FDManager.AddConnectionDef(FParams.ConnectionDefName,
                             FParams.DriverID,
                             FParams.Params);
  FDManager.Active := true;
end;

destructor TDBConnectionFactory.Destroy;
begin
  inherited;
end;

class function TDBConnectionFactory.GetInstance(const aParent :  iInfraServices): iDBConnectionFactory;
begin
  if not Assigned(FInstance) then
    FInstance := self.Create(aParent);

  result := FInstance;
end;

end.
