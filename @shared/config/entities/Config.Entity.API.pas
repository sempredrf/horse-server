unit Config.Entity.API;

interface

uses
  System.SysUtils,
  System.JSON,
  Config.Interfaces,
  Log.Messages;

type
  TConfigApi = class(TInterfacedObject, iConfigApi)
  private
    FBaseURL : string;
    FPort : integer;
    FLogLevel : TLogKind;

    [weak]
    FParent : iConfig;
  protected
    function BaseURL(const aValue : string) : iConfigApi; overload;
    function BaseURL() : string; overload;

    function Port(const aValue : integer): iConfigApi; overload;
    function Port: integer; overload;

    function LogLevel(const aValue : TLogKind): iConfigApi; overload;
    function LogLevel: TLogKind; overload;

    constructor Create(const aParent : iConfig;
                       const aBaseURL : string;
                       const aPort : integer;
                       const aLogLevel : TLogKind);

    function ToJson() : TJsonValue;
  public
    destructor Destroy(); override;

    class function New( const aParent : iConfig;
                        const aBaseURL : string;
                        const aPort : integer;
                        const aLogLevel : TLogKind) : iConfigApi; overload;

    class function New( const aParent : iConfig) : iConfigApi; overload;

    class function New( const aParent : iConfig;
                        const aJson : TJSONValue) : iConfigApi; overload;

    function &End(): iConfig;
  end;

implementation

uses
  System.TypInfo,

  Util.Constants.Api;

{ TConfigApi }

function TConfigApi.&End: iConfig;
begin
  result := FParent;
end;

function TConfigApi.LogLevel: TLogKind;
begin
  result := FLogLevel;
end;

function TConfigApi.LogLevel(const aValue: TLogKind): iConfigApi;
begin
  result := self;
  FLogLevel := aValue;
end;

class function TConfigApi.New(const aParent: iConfig;
  const aJson: TJSONValue): iConfigApi;
var
  logKind : TLogKind;
begin
  logKind := TLogKind.logWarning;

  {$IFDEF DEBUG}
  logKind := TLogKind.logDebug;
  {$ENDIF}

  result := self.Create(aParent,
                        aJson.GetValue<string>('baseUrl'),
                        aJson.GetValue<integer>('port'),
                        TLogKind(GetEnumValue(TypeInfo(TLogKind),
                                              aJson.GetValue<string>('logLevel',
                                                                     GetEnumName(TypeInfo(TLogKind),
                                                                                 integer(logKind) )))) );
end;

class function TConfigApi.New(const aParent: iConfig): iConfigApi;
var
  logKind : TLogKind;
begin
  logKind := TLogKind.logWarning;

  {$IFDEF DEBUG}
  logKind := TLogKind.logDebug;
  {$ENDIF}

  result := self.Create(aParent,
                        _API_BASE_URL,
                        _API_PORT,
                        logKind);
end;

function TConfigApi.BaseURL: string;
begin
  result := FBaseURL;
end;

function TConfigApi.BaseURL(const aValue: string): iConfigApi;
begin
  result := self;
  FBaseURL := aValue;
end;

constructor TConfigApi.Create( const aParent : iConfig;
                               const aBaseURL : string;
                               const aPort : integer;
                               const aLogLevel : TLogKind);
begin
  FParent := aParent;
  FBaseURL := aBaseURL;
  FPort := aPort;
  FLogLevel := aLogLevel;
end;

destructor TConfigApi.Destroy;
begin

  inherited;
end;

class function TConfigApi.New(const aParent : iConfig;
                              const aBaseURL : string;
                              const aPort : integer;
                              const aLogLevel : TLogKind): iConfigApi;
begin
  result := self.Create(aParent,
                        aBaseURL,
                        aPort,
                        aLogLevel);
end;

function TConfigApi.Port(const aValue: integer): iConfigApi;
begin
  result := self;
  FPort := aValue;
end;

function TConfigApi.Port: integer;
begin
  result := FPort;
end;

function TConfigApi.ToJson: TJsonValue;
var
  json : TJSONObject;
begin
  json := TJSONObject.Create();
  try
    json.AddPair('baseUrl', FBaseURL);
    json.AddPair('port', TJSONNumber.Create(FPort) );
    json.AddPair('logLevel', GetEnumName(TypeInfo(TLogKind), integer(FLogLevel) ) );
  finally
    result := json;
  end;
end;

end.
