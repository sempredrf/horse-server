unit Logs.Services;

interface

uses
  System.SysUtils,
  Logs.Services.interfaces,
  Log.Messages;

type
  TLogKind  = Log.Messages.TLogKind;

  TLogServices = class(TInterfacedObject, iLogServices)
  private
  class var FInstance : iLogServices;
  protected
     constructor Create();
     procedure Log(const aType : TLogKind ; const AMessage: string; const aTag: string ='');
     procedure Debug(const aMessage: string; const aTag: string ='');
     procedure Info(const aMessage: string; const aTag: string ='');
     procedure Warning(const aMessage: string; const aTag: string ='');
     procedure Error(const aMessage: string; const aTag: string ='');

  public
    destructor Destroy(); override;

    class function GetInstance() : iLogServices;
  end;

  var Log : iLogServices;

implementation

uses
  Services.Messages;


{ TLogServices }

constructor TLogServices.Create;
begin

end;

procedure TLogServices.Debug(const aMessage, aTag: string);
begin
  TServiceMessage.SendMessage(self,
                              TLogMessageDebug.Create(aMessage, aTag));

end;

destructor TLogServices.Destroy;
begin

  inherited;
end;

procedure TLogServices.Error(const aMessage, aTag: string);
begin
  TServiceMessage.SendMessage(self,
                              TLogMessageError.Create(aMessage, aTag));

end;

procedure TLogServices.Info(const aMessage, aTag: string);
begin
  TServiceMessage.SendMessage(self,
                              TLogMessageInfo.Create(aMessage, aTag));

end;

procedure TLogServices.Log(const AType: TLogKind; const aMessage, aTag: string);
begin
  TServiceMessage.SendMessage(self,
                              TLogMessage.Create(aMessage, aType, aTag));

end;

class function TLogServices.GetInstance: iLogServices;
begin
  if not Assigned( FInstance ) then
    FInstance := self.Create();
  result:= FInstance;
end;

procedure TLogServices.Warning(const aMessage, aTag: string);
begin
    TServiceMessage.SendMessage(self,
                              TLogMessageWarning.Create(aMessage, aTag));

end;

initialization
  Log:= TLogServices.GetInstance();

end.
