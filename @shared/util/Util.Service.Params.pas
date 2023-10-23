unit Util.Service.Params;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Classes,
  System.IOUtils,

  Config.Interfaces;

type
  TUtilServiceParams = class
  private
    class var FInstance : TUtilServiceParams;

    FJsonParams : TJSONObject;
    FConfig : iConfig;

    constructor Create();
    procedure ReloadConfig(const aValue: TJSONValue);
  public
    class function GetInstance() : TUtilServiceParams;

    function Read<T>(const aPath : string) : T; overload;
    function Read<T>(const aPath : string; const aChildren : string) : T; overload;

    function Read<T>(const aPath : string; const aDefaultValue : T) : T; overload;
    function Read<T>(const aPath : string; const aChildren : string; const aDefaultValue : T) : T; overload;

    function Api<T>(const aPath : string; const aDefaultValue : T) : T;

    function Config() : iConfig;
    function Save(const aValue : iConfig) : iConfig;

    destructor Destroy(); override;
  end;

implementation

uses
  Util.Constants.Api,
  Config.Entity;

procedure DestroyInstance() ;
begin
  if Assigned(TUtilServiceParams.FInstance) then
    FreeAndNil(TUtilServiceParams.FInstance);
end;

{ TAppServiceParams }

function TUtilServiceParams.Api<T>(const aPath: string;
  const aDefaultValue: T): T;
begin
  result := FJsonParams.GetValue<T>(Format('api.%s', [aPath]), aDefaultValue);
end;

function TUtilServiceParams.Config: iConfig;
begin
  result := FConfig;
end;

constructor TUtilServiceParams.Create;
var
  sFile : TStringList;
  sFileName : string;
begin
  sFileName := ExtractFilePath(ParamStr(0)) + 'config';

  if not DirectoryExists(sFileName) then
    ForceDirectories(sFileName);

  sFileName := TPath.Combine( sFileName, 'config.dat' );
  sFile := TStringList.Create();
  try
    if FileExists( sFileName ) then
    begin
      sFile.LoadFromFile( sFileName );
      FJsonParams := TJSONObject.ParseJSONValue( sFile.Text ) as TJSONObject;
      ReloadConfig( FJsonParams );


    end
    else
    begin
      FConfig := TConfig.New();
      FJsonParams := FConfig.ToJson() As TJSONObject;

      sFile.Text := FJsonParams.Format();
      sFile.SaveToFile( sFileName );

      ReloadConfig( FJsonParams ) ;
    end;
  finally
    if Assigned(sFile) then
      FreeAndNil(sFile);
  end;
end;

procedure TUtilServiceParams.ReloadConfig(const aValue : TJSONValue) ;
begin
  FConfig := TConfig.New(aValue);
end;

destructor TUtilServiceParams.Destroy;
begin
  if Assigned(FJsonParams) then
    FreeAndNil(FJsonParams);

  inherited;
end;

class function TUtilServiceParams.GetInstance: TUtilServiceParams;
begin
  if not Assigned(FInstance) then
    FInstance := TUtilServiceParams.Create();

  result := FInstance;
end;

function TUtilServiceParams.Read<T>(const aPath, aChildren: string;
  const aDefaultValue: T): T;
begin
  result := FJsonParams.GetValue<T>(Format('%s.%s', [aPath, aChildren]), aDefaultValue);
end;

function TUtilServiceParams.Read<T>(const aPath: string;
  const aDefaultValue: T): T;
begin
  result := FJsonParams.GetValue<T>(aPath, aDefaultValue);
end;

function TUtilServiceParams.Read<T>(const aPath, aChildren: string): T;
begin
  result := FJsonParams.GetValue<T>(Format('%s.%s', [aPath, aChildren]));
end;

function TUtilServiceParams.Read<T>(const aPath: string): T;
begin
  result := FJsonParams.GetValue<T>(aPath);
end;

function TUtilServiceParams.Save(const aValue: iConfig): iConfig;
var
  sFile : TStringList;
  sFileName : string;
begin
  result := aValue;

  sFileName := ExtractFilePath(ParamStr(0)) + 'config';

  if not DirectoryExists(sFileName) then
    ForceDirectories(sFileName);

  sFileName := TPath.Combine( sFileName, 'config.dat' );
  sFile := TStringList.Create();
  try

    with aValue.ToJson do
    begin
      sFile.Text := Format();
      Free;
    end;

    sFile.SaveToFile(sFileName);
  finally
    if Assigned(sFile) then
      FreeAndNil(sFile);
  end;
end;

initialization
  TUtilServiceParams.GetInstance();

finalization
  DestroyInstance();

end.
