unit Infra.DB.Connection;

interface

uses
  System.SysUtils,
  System.Classes,

  Data.DB,

  Domain.Services.Interfaces,
  Infra.DB.Params.Interfaces,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util,
  FireDAC.Comp.Script,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.PG,
  FireDAC.FMXUI.Wait;

type
  TDBConnection = class(TDataModule, iDBConnection)
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDTransaction: TFDTransaction;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDConnection: TFDConnection;
    procedure FDConnectionError(ASender, AInitiator: TObject; var AException: Exception);

  strict private
    {$IFNDEF AUTOREFCOUNT}
    const objDestroyingFlag = Integer($80000000);
    function GetRefCount: Integer; inline;
    {$ENDIF}
  strict protected
    {$IFNDEF AUTOREFCOUNT}
    [Volatile] fRefCount: Integer;
    class procedure __MarkDestroying(const Obj); static; inline;
    {$ENDIF}
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

  private
    { Private declarations }
    [weak]
    FParams : iDBParamsConnection;
    FParent : iInfraServices;

    constructor Create( const aParent : iInfraServices;
                        const aParams : iDBParamsConnection); reintroduce;
  public
    {$IFNDEF AUTOREFCOUNT}
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    property RefCount: Integer read GetRefCount;
    {$ENDIF}

    { Public declarations }
    class function New( const aParent : iInfraServices;
                        const aParams : iDBParamsConnection) : iDBConnection;

    function Connection : TCustomConnection;
    function Execute(ASql : string) : iDBConnection;
    function GetSqlResult(const ASql : string;
                          const ARecSkip : integer = -1;
                          const ARecMax : integer = -1) : TDataSet;

    function StartTransaction() : iDBConnection;
    function RollbackTransaction() : iDBConnection;
    function CommitTransaction() : iDBConnection;

    function InTransaction() : Boolean;

    function &End() : iInfraServices;
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses
  System.IOUtils,
  Logs.Services;

{$R *.dfm}

{ TDBConnection }
{$IFNDEF AUTOREFCOUNT}

function TDBConnection.GetRefCount: Integer;
begin
   Result := fRefCount and not objDestroyingFlag;
end;

class procedure TDBConnection.__MarkDestroying(const Obj);
var
  LRef: Integer;
begin
  repeat
    LRef := TDBConnection(Obj).fRefCount;
  until AtomicCmpExchange(TDBConnection(Obj).fRefCount, LRef or objDestroyingFlag, LRef) = LRef;
end;

procedure TDBConnection.AfterConstruction;
begin
  inherited;
  // Release the constructor's implicit refcount
  AtomicDecrement(fRefCount);
end;

procedure TDBConnection.BeforeDestruction;
begin
  if RefCount <> 0 then
    Error(reInvalidPtr);
  inherited;
end;

class function TDBConnection.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TDBConnection(Result).fRefCount := 1;
end;

{$ENDIF AUTOREFCOUNT}

function TDBConnection.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
   inherited;
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDBConnection._AddRef: Integer;
begin
{$IFNDEF AUTOREFCOUNT}
  Result := AtomicIncrement(FRefCount);
{$ELSE}
  Result := __ObjAddRef;
{$ENDIF}
end;

function TDBConnection._Release: Integer;
begin
{$IFNDEF AUTOREFCOUNT}
  Result := AtomicDecrement(FRefCount);
  if Result = 0 then
  begin
    // Mark the refcount field so that any refcounting during destruction doesn't infinitely recurse.
    __MarkDestroying(Self);
    Destroy;
  end;
{$ELSE}
  Result := __ObjRelease;
{$ENDIF}
end;

function TDBConnection.&End: iInfraServices;
begin
  result := FParent;
end;

function TDBConnection.CommitTransaction(): iDBConnection;
begin
  result := self;

  if FDConnection.InTransaction then
    FDConnection.Commit();
end;

function TDBConnection.Connection: TCustomConnection;
begin
  result := FDConnection;
end;

constructor TDBConnection.Create(const aParent : iInfraServices;
                                 const aParams : iDBParamsConnection);
begin
  inherited Create(nil);

  FParent := aParent;
  FParams := aParams;
  try
    Log.Info('Nome da Conexão: '+FParams.ConnectionDefName);
    Log.Info('HostName: '+FParams.HostName);
    Log.Info('Nome da Conexão: '+FParams.ConnectionDefName);
    Log.Info('VendorLib: '+FParams.VendorLib);

    if (FParams.VendorLib.IsEmpty) or (not FileExists(FParams.VendorLib)) then
      raise Exception.Create('libpq not exists in '+FParams.VendorLib);

    FDConnection.Close();
    FDConnection.ConnectionDefName := FParams.ConnectionDefName;

    FDPhysPgDriverLink.VendorLib   := FParams.VendorLib;

    FDConnection.Connected := true;

  except on E: Exception do
    Log.Error(E.Message);
  end;
end;

function TDBConnection.Execute(ASql: string): iDBConnection;
begin
  result := self;
  FDConnection.ExecSQL( ASql );
end;

procedure TDBConnection.FDConnectionError(ASender, AInitiator: TObject; var AException: Exception);
begin
  Log.Error(AException.Message);
end;

function TDBConnection.GetSqlResult(const ASql: string; const ARecSkip,
  ARecMax: integer): TDataSet;
var
  qryTemp : TFDQuery;
begin
  result := nil;

  qryTemp := TFDQuery.Create(nil);
  try
    qryTemp.Close();
    qryTemp.Connection := FDConnection;
    qryTemp.FetchOptions.RecsSkip := ARecSkip;
    qryTemp.FetchOptions.RecsMax  := ARecMax;
    qryTemp.SQL.Clear();
    qryTemp.SQL.Add( ASql );
    qryTemp.Open();
    qryTemp.FetchAll();

    result := qryTemp;
  except
    FreeAndNil(qryTemp);
  end;
end;

function TDBConnection.InTransaction: Boolean;
begin
  result := FDConnection.InTransaction;
end;

class function TDBConnection.New(const aParent : iInfraServices;
                                  const aParams : iDBParamsConnection): iDBConnection;
begin
  result := self.Create(aParent,
                        aParams);
end;

function TDBConnection.RollbackTransaction(): iDBConnection;
begin
  result := self;

  if FDConnection.InTransaction then
    FDConnection.StartTransaction();
end;

function TDBConnection.StartTransaction(): iDBConnection;
begin
  result := self;

  if not FDConnection.InTransaction then
    FDConnection.StartTransaction();
end;

end.
