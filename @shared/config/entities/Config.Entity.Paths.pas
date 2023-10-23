unit Config.Entity.Paths;

interface

uses
  System.SysUtils,
  Config.Interfaces;

type
  TConfigPaths = class(TInterfacedObject, iConfigPaths)
  private
    FConfig : string;
    FLog    : string;
    FTemp   : string;
    FHome   : string;

    [weak]
    FParent : iConfig;
  protected
    constructor Create(const aParent : iConfig);

    function Config(const aValue : string) : iConfigPaths; overload;
    function Config() : string; overload;

    function Log(const aValue : string) : iConfigPaths; overload;
    function Log() : string; overload;

    function Temp(const aValue : string) : iConfigPaths; overload;
    function Temp() : string; overload;

    function Home(const aValue : string) : iConfigPaths; overload;
    function Home() : string; overload;

    function &End(): iConfig;
  public
    destructor Destroy(); override;

    class function New(const aParent : iConfig) : iConfigPaths;
  end;

implementation

uses
  Util.Common.Functions;

{ TConfigPaths }

function TConfigPaths.&End: iConfig;
begin
  result := FParent;
end;

function TConfigPaths.Home(const aValue: string): iConfigPaths;
begin
  result := self;
  FHome := aValue;
end;

function TConfigPaths.Config: string;
begin
  result := FConfig;
end;

function TConfigPaths.Home: string;
begin
  result := FHome;
end;

function TConfigPaths.Log(const aValue: string): iConfigPaths;
begin
  result := self;
  FLog := aValue;
end;

function TConfigPaths.Log: string;
begin
  result := FLog;
end;

function TConfigPaths.Config(const aValue: string): iConfigPaths;
begin
  result := self;
  FConfig := aValue;
end;

constructor TConfigPaths.Create(const aParent : iConfig);
begin
  FParent := aParent;

  FHome := GetAppPath();

  FConfig := IncludeTrailingPathDelimiter(FHome) + 'config';
  if not DirectoryExists(FConfig) then
    ForceDirectories(FConfig);

  FLog := IncludeTrailingPathDelimiter(FHome) + 'log';
  if not DirectoryExists(FLog) then
    ForceDirectories(FLog);

  FTemp := IncludeTrailingPathDelimiter(FHome) + 'temp';
  if not DirectoryExists(FTemp) then
    ForceDirectories(FTemp);
end;

destructor TConfigPaths.Destroy;
begin

  inherited;
end;

class function TConfigPaths.New(const aParent : iConfig): iConfigPaths;
begin
  result := self.Create(aParent);
end;

function TConfigPaths.Temp(const aValue: string): iConfigPaths;
begin
  result := self;
  FTemp := aValue;
end;

function TConfigPaths.Temp: string;
begin
  result := FTemp;
end;

end.
