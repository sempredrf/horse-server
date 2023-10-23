unit Notification;

interface

uses
  System.SysUtils,
  Generics.Collections,
  Notification.Interfaces,
  Notification.Types;

type
  TNotification = class(TInterfacedObject, iNotification)
  private
    FErrors : TListNotificationErrorProps;

    constructor Create();
  public

    destructor Destroy(); override;

    function AddError(const aContext : string; const aError : string) : TNotificationErrorProps; overload;
    function AddError(const aError : TNotificationErrorProps) : iNotification; overload;
    function ClearErrors() : iNotification;
    function HasErrors() : boolean;
    function GetErrors(): TListNotificationErrorProps;
    function AsString(const aContext : string = '') : string;

    class function New() : iNotification;
  end;

implementation

{ TNotification }

function TNotification.AddError(
  const aError: TNotificationErrorProps): iNotification;
begin
  result := self;
  FErrors.Add(aError);
end;

function TNotification.AddError(const aContext : string; const aError : string): TNotificationErrorProps;
begin
  result := FErrors.Add(aContext, aError);
end;

function TNotification.ClearErrors: iNotification;
begin
  FErrors.Clear();
end;

constructor TNotification.Create;
begin
  FErrors := TListNotificationErrorProps.Create();
end;

destructor TNotification.Destroy;
begin
  if Assigned(FErrors) then
    FreeAndNil(FErrors);

  inherited;
end;

function TNotification.GetErrors: TListNotificationErrorProps;
begin
  result := FErrors;
end;

function TNotification.HasErrors: boolean;
begin
  result := FErrors.Count > 0;
end;

class function TNotification.New: iNotification;
begin
  result := self.Create();
end;

function TNotification.AsString(const aContext: string): string;
var
  error : TNotificationErrorProps;
begin
  result := EmptyStr;

  for error in FErrors do
  begin
    if (aContext = EmptyStr) or (aContext = error.Context) then
      result := Format('%s: %s', [error.Context, error.Error]);
  end;
end;

end.
