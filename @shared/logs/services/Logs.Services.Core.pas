unit Logs.Services.Core;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.TypInfo,

  LoggerPro,
  Logs.Services.Interfaces,

  Services.Messages;

type
  TLogServicesCore = class(TInterfacedObject, iLogServicesCore)
  private
    class var FInstance : iLogServicesCore;
    FLog: ILogWriter;

    procedure HandleMessages(const Sender: TObject; const M: TMessage);

  protected
     constructor Create();
  public
    destructor Destroy(); override;

    class function GetInstance() : iLogServicesCore;
  end;

implementation

uses
  LoggerPro.FileAppender,
  LoggerPro.ConsoleAppender,
  LoggerPro.OutputDebugStringAppender,
  Log.Messages,

  Util.Service.Params,
  Util.Common.Functions;

{ TLogServices }

constructor TLogServicesCore.Create;
var
  PathLog : string;
  iLevel : TLogType;
  logKind : TLogKind;
begin
  logKind := TLogKind.logWarning;

  {$IFDEF DEBUG}
  logKind := TLogKind.logDebug;
  {$ENDIF}

  PathLog := GetAppPath;
  PathLog := TPath.Combine(PathLog, 'log');

  iLevel:= TLogType( TLogKind(GetEnumValue(TypeInfo(TLogKind),
                                              TUtilServiceParams.GetInstance.Api<string>('logLevel',
                                                                                         GetEnumName(TypeInfo(TLogKind),
                                                                                                     integer(logKind) )))) );

  FLog := BuildLogWriter([TLoggerProFileAppender.Create(5,1000,PathLog),
                          TLoggerProConsoleAppender.Create,
                          TLoggerProOutputDebugStringAppender.Create],nil,iLevel);


  TServiceMessage.SubscribeToMessage(TLogMessage, HandleMessages);
  TServiceMessage.SubscribeToMessage(TLogMessageDebug, HandleMessages);
  TServiceMessage.SubscribeToMessage(TLogMessageInfo, HandleMessages);
  TServiceMessage.SubscribeToMessage(TLogMessageWarning, HandleMessages);

end;

destructor TLogServicesCore.Destroy;
begin

  inherited;
end;

class function TLogServicesCore.GetInstance: iLogServicesCore;
begin
  if not Assigned( FInstance ) then
    FInstance := self.Create();
  result:= FInstance;
end;

procedure TLogServicesCore.HandleMessages(const Sender: TObject; const M: TMessage);
var
  LMessage: TLogMessage;
begin
  LMessage:= TLogMessage( M );
  FLog.Log(TLogType(LMessage.Kind), LMessage.Message, LMessage.Tag);
end;

initialization
  TLogServicesCore.GetInstance;

end.
