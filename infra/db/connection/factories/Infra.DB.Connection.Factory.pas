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
  FireDAC.Stan.Intf,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Option,
  FireDAC.Phys.Intf,
  FireDAC.Comp.DataSet,
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
var
  lConnection: TFDCustomConnection;
  lFDStanDefinition: IFDStanDefinition;
  lFDStanConnectionDef: IFDStanConnectionDef;
  lPGConnectionDefParams: TFDPhysPGConnectionDefParams;
begin
  FParent := aParent;
  FParams := TDBParamsConnections.GetInstance();

  //to change or create, need to close connection of ConnectionDefName
  FDManager.CloseConnectionDef( FParams.ConnectionDefName );
  FDManager.ActiveStoredUsage         := [auRunTime];
  FDManager.ConnectionDefFileAutoLoad := False;
  FDManager.DriverDefFileAutoLoad     := False;
  FDManager.SilentMode                := True; //DESATIVA O CICLO DE MENSAGEM COM O WINDOWS PARA APRESENTAR A AMPULHETA DE PROCESSANDO.

  //DRIVER
  lFDStanDefinition := FDManager.DriverDefs.FindDefinition( FParams.ConnectionDefName );
  if not Assigned(FDManager.DriverDefs.FindDefinition(FParams.DriverID+'_driver')) then
  begin
    lFDStanDefinition       := FDManager.DriverDefs.Add;
    lFDStanDefinition.Name  := FParams.DriverID+'_driver';
  end;
  lFDStanDefinition.AsString['BaseDriverID'] := FParams.DriverID; //DRIVER BASE

  //CONNECTION
  lFDStanConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(FParams.ConnectionDefName);
  if not Assigned(FDManager.ConnectionDefs.FindConnectionDef(FParams.ConnectionDefName)) then
  begin
    lFDStanConnectionDef := FDManager.ConnectionDefs.AddConnectionDef;
    lFDStanConnectionDef.Name := FParams.ConnectionDefName;
  end;

  //DEFINIÇÃO DE CONEXÃO: PRIVADO :: https://docwiki.embarcadero.com/RADStudio/Sydney/en/Defining_Connection_(FireDAC)
  lPGConnectionDefParams := TFDPhysPGConnectionDefParams(lFDStanConnectionDef.Params);
  lPGConnectionDefParams.DriverID := FParams.DriverID;
  lPGConnectionDefParams.Database := FParams.DataBase;
  lPGConnectionDefParams.UserName := FParams.UserName;
  lPGConnectionDefParams.Password := FParams.Password;
  lPGConnectionDefParams.Server   := FParams.HostName;

  lPGConnectionDefParams.Pooled := FParams.Params.ValueFromIndex[ FParams.Params.indexofName('Pooled') ].ToBoolean;
  lPGConnectionDefParams.ApplicationName := FParams.Params.ValueFromIndex[ FParams.Params.indexofName('ApplicationName') ];
  lPGConnectionDefParams.PoolMaximumItems := FParams.Params.ValueFromIndex[FParams.Params.indexofName('POOL_MaximumItems') ].ToInteger;
  lPGConnectionDefParams.PoolCleanupTimeout := FParams.Params.ValueFromIndex[ FParams.Params.indexofName('POOL_CleanupTimeout') ].ToInteger;
  lPGConnectionDefParams.PoolExpireTimeout := FParams.Params.ValueFromIndex[FParams.Params.indexofName('POOL_ExpireTimeout') ].ToInteger;

  lConnection := TFDCustomConnection.Create(nil);
  try
    //WriteOptions
    lConnection.FetchOptions.Mode := TFDFetchMode.fmAll; //fmAll
    lConnection.ResourceOptions.AutoConnect := False;

    with lConnection.FormatOptions.MapRules.Add do
    begin
      SourceDataType := dtDateTime; { TFDParam.DataType }
      TargetDataType := dtDateTimeStamp; { Postgres TIMESTAMP }
    end;

    lFDStanConnectionDef.WriteOptions(lConnection.FormatOptions,
                                      lConnection.UpdateOptions,
                                      lConnection.FetchOptions,
                                      lConnection.ResourceOptions);

    if (FDManager.State <> TFDPhysManagerState.dmsActive) then
      FDManager.Open;
  finally
    lConnection.Free;
  end;
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
