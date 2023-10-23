unit Infra.DB.Params.Connection;

interface

uses
  System.SysUtils,
  System.Classes,
  Infra.DB.Params.Interfaces;

type
  TDBParamsConnections = class(TInterfacedObject, iDBParamsConnection)
  private
    FConnectionDefName : string;
    FPooled : boolean;
    FDataBase : string;
    FUserName : string;
    FPassword : string;
    FCharset : string;
    FVendorLib : string;
    FDriverID : string;
    FHostName : string;
    FPort : integer;
    FParams : TStrings;

    class var FInstance : iDBParamsConnection;
  protected
    constructor Create( const aConnectionDefName : string;
                        const aPooled : boolean;
                        const aDriverID : string;
                        const aDataBase : string;
                        const aHostName : string;
                        const aPort : integer;
                        const aUserName : string;
                        const aPassword : string;
                        const aCharset : string;
                        const aVendorLib : string );
  public
    destructor Destroy(); override;

    class function GetInstance() : iDBParamsConnection;

    class procedure SaveParamsConnection(const aParams : iDBParamsConnection);
    class function LoadParamsConnection() : iDBParamsConnection;

    class function New( const aConnectionDefName : string;
                        const aPooled : boolean;
                        const aDriverID : string;
                        const aDataBase : string;
                        const aHostName : string;
                        const aPort : integer;
                        const aUserName : string;
                        const aPassword : string;
                        const aCharset : string;
                        const aVendorLib : string ) : iDBParamsConnection;

    function ConnectionDefName() : string; overload;
    function DriverID() : string; overload;
    function Pooled() : boolean; overload;
    function DataBase() : string; overload;
    function HostName() : string; overload;
    function Port() : integer; overload;
    function UserName() : string; overload;
    function Password() : string; overload;
    function Charset() : string; overload;
    function VendorLib() : string; overload;

    function Params() : TStrings;
  end;

implementation

uses
  System.IniFiles,
  System.IOUtils,

  Util.Constants.DB,
  Util.Common.Functions,
  Logs.Services;

{ TDBParamsConnections }

function TDBParamsConnections.Charset: string;
begin
  result := FCharset;
end;

function TDBParamsConnections.ConnectionDefName: string;
begin
  result := FConnectionDefName;
end;

constructor TDBParamsConnections.Create(const aConnectionDefName : string;
                                        const aPooled : boolean;
                                        const aDriverID : string;
                                        const aDataBase : string;
                                        const aHostName : string;
                                        const aPort : integer;
                                        const aUserName : string;
                                        const aPassword : string;
                                        const aCharset : string;
                                        const aVendorLib : string);
begin
  FConnectionDefName     := aConnectionDefName;
  FPooled                := aPooled;
  FDriverID              := aDriverID;
  FHostName              := aHostName;
  FPort                  := aPort;
  FDataBase              := aDataBase;
  FUserName              := aUserName;
  FPassword              := aPassword;
  FCharset               := aCharset;
  FVendorLib             := aVendorLib;

  FParams := TStringList.Create();
  FParams.AddPair('Pooled', BoolToStr( FPooled, true ));
  FParams.AddPair('Database', FDatabase);
  FParams.AddPair('User_Name', FUserName);
  FParams.AddPair('Password', FPassword);
  FParams.AddPair('Server', FHostName);
  FParams.AddPair('Port', FPort.ToString);

  FParams.AddPair('POOL_CleanupTimeout', '30000');
  FParams.AddPair('POOL_ExpireTimeout', '90000');
  FParams.AddPair('POOL_MaximumItems', '50');

  FParams.AddPair('CharacterSet', FCharset);
  FParams.AddPair('DriverID', FDriverID);
end;

function TDBParamsConnections.DataBase: string;
begin
  result := FDataBase;
end;

destructor TDBParamsConnections.Destroy;
begin
  if Assigned(FParams) then
    FreeAndNil(FParams);

  inherited;
end;

function TDBParamsConnections.DriverID: string;
begin
  result := FDriverID;
end;

class function TDBParamsConnections.GetInstance() : iDBParamsConnection;
begin
  if not Assigned(FInstance) then
    FInstance := self.LoadParamsConnection();

  result := FInstance;
end;

function TDBParamsConnections.HostName: string;
begin
  result := FHostName;
end;

class function TDBParamsConnections.LoadParamsConnection: iDBParamsConnection;
var
  ini : TIniFile;
  sFile : string;
  params : iDBParamsConnection;
begin
  if sFile = EmptyStr then
  begin
    sFile := ExtractFilePath(ParamStr(0)) + 'config';

    if not DirectoryExists(sFile) then
      ForceDirectories(sFile);

    sFile := TPath.Combine( sFile, _CONNECTION_INI );
  end;

  ini := TIniFile.Create(sFile);
  try
    Log.Info('Buscando configuração do banco de dados');
    params := self.New( ini.ReadString( _SESSION_CONNECTION_DB, 'ConnectionDefName', 'db' ),
                        StrToBool( ini.ReadString( _SESSION_CONNECTION_DB, 'Pooled', 'TRUE' ) ),
                        ini.ReadString( _SESSION_CONNECTION_DB, 'DriverID', 'PG' ),
                        ini.ReadString( _SESSION_CONNECTION_DB, 'DataBase', _DB_DEFAULT ),
                        ini.ReadString( _SESSION_CONNECTION_DB, 'Server', 'localhost' ),
                        StrToIntDef(ini.ReadString( _SESSION_CONNECTION_DB, 'Port',     '5432' ), 5432),
                        ini.ReadString( _SESSION_CONNECTION_DB, 'UserName', _USER_DEFAULT_DB ),
                        Decode2( ini.ReadString( _SESSION_CONNECTION_DB, 'Password', Encode2( _PASS_DEFAULT_DB) ) ),
                        ini.ReadString( _SESSION_CONNECTION_DB, 'CharSet', 'UTF8' ) ,
                        ini.ReadString( _SESSION_CONNECTION_DB, 'VendorLib', EmptyStr )  );
  finally
    result := params;

    FreeAndNil(ini);
  end;
end;

class function TDBParamsConnections.New(const aConnectionDefName : string;
                                        const aPooled : boolean;
                                        const aDriverID : string;
                                        const aDataBase : string;
                                        const aHostName : string;
                                        const aPort : integer;
                                        const aUserName : string;
                                        const aPassword : string;
                                        const aCharset : string;
                                        const aVendorLib : string): iDBParamsConnection;
begin
  result := self.Create( aConnectionDefName,
                         aPooled,
                         aDriverID,
                         aDataBase,
                         aHostName,
                         aPort,
                         aUserName,
                         aPassword,
                         aCharset,
                         aVendorLib );
end;

function TDBParamsConnections.Params: TStrings;
begin
  result := FParams;
end;

function TDBParamsConnections.Password: string;
begin
  result := FPassword;
end;

function TDBParamsConnections.Pooled: boolean;
begin
  result := FPooled;
end;

function TDBParamsConnections.Port: integer;
begin
  result := FPort;
end;

class procedure TDBParamsConnections.SaveParamsConnection(const aParams : iDBParamsConnection);
var
  ini : TIniFile;
  sFile : string;
begin
  if sFile = EmptyStr then
  begin
    sFile := ExtractFilePath(ParamStr(0))+ 'config';
    if not DirectoryExists(sFile) then
      ForceDirectories(sFile);

    sFile := TPath.Combine( sFile, _CONNECTION_INI );
  end;

  ini := TIniFile.Create(sFile);
  try
    ini.WriteString( _SESSION_CONNECTION_DB, 'ConnectionDefName', aParams.ConnectionDefName );
    ini.WriteString( _SESSION_CONNECTION_DB, 'Pooled', aParams.Pooled.ToString(true) );
    ini.WriteString( _SESSION_CONNECTION_DB, 'DriverID', aParams.DriverID );
    ini.WriteString( _SESSION_CONNECTION_DB, 'Server', aParams.HostName );
    ini.WriteString( _SESSION_CONNECTION_DB, 'Port',     aParams.Port.ToString() );
    ini.WriteString( _SESSION_CONNECTION_DB, 'DataBase', aParams.DataBase );
    ini.WriteString( _SESSION_CONNECTION_DB, 'UserName', aParams.UserName );
    ini.WriteString( _SESSION_CONNECTION_DB, 'Password', Encode2( aParams.Password) );
    ini.WriteString( _SESSION_CONNECTION_DB, 'VendorLib', aParams.VendorLib );
    ini.WriteString( _SESSION_CONNECTION_DB, 'CharSet', aParams.CharSet );
  finally
    FreeAndNil(ini);
  end;
end;

function TDBParamsConnections.UserName: string;
begin
  result := FUserName;
end;

function TDBParamsConnections.VendorLib: string;
begin
  result := FVendorLib;
end;

end.
