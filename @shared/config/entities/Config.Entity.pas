unit Config.Entity;

interface

uses
  System.SysUtils,
  System.JSON,
  Config.Interfaces;

type
  TConfig = class(TInterfacedObject, iConfig)
  private
    FApi : iConfigApi;
    FPaths : iConfigPaths;
  protected
    constructor Create(); overload;
    constructor Create( const aApi : iConfigApi); overload;

    function Api(const aValue : iConfigApi) : iConfig; overload;
    function Api : iConfigApi; overload;

    function Paths() : iConfigPaths;

    function ToJson() : TJSONValue;
  public
    destructor Destroy(); override;

    class function New( const aApi : iConfigApi) : iConfig; overload;

    class function New() : iConfig; overload;

    class function New(const aJson : TJsonValue) : iConfig; overload;
  end;

implementation

uses
  Config.Entity.API,
  Config.Entity.Paths;

{ TConfig }

function TConfig.Api: iConfigApi;
begin
  result := FApi;
end;

function TConfig.Api(const aValue: iConfigApi): iConfig;
begin
  result := self;
  FApi := aValue;
end;

constructor TConfig.Create;
begin
  FPaths := TConfigPaths.New(self);
end;

constructor TConfig.Create( const aApi : iConfigApi);
begin
  FApi        := aApi;
  FPaths      := TConfigPaths.New(self);
end;

destructor TConfig.Destroy;
begin

  inherited;
end;

class function TConfig.New: iConfig;
begin
  result := self.Create();

  result.Api( TConfigApi.New(result) );
end;

class function TConfig.New(const aJson: TJsonValue): iConfig;
begin
  result := self.Create();

  result.Api( TConfigApi.New(result, aJson.P['api'] ) );

end;

function TConfig.Paths: iConfigPaths;
begin
  result := FPaths;
end;

class function TConfig.New(const aApi : iConfigApi): iConfig;
begin
  result := self.Create(aApi);
end;

function TConfig.ToJson: TJSONValue;
var
  json : TJSONObject;
begin
  json := TJSONObject.Create();
  try
    json.AddPair('api', FApi.ToJson() );
  finally
    result := json;
  end;
end;

end.
