unit Notification.Exception;

interface

uses
  System.SysUtils,
  Notification.Types;

type
  TNotificationException = class (Exception)
  constructor Create(const aErrors : TListNotificationErrorProps); reintroduce;
  end;

implementation

{ TNotificationException }

constructor TNotificationException.Create(
  const aErrors: TListNotificationErrorProps);
begin
  inherited Create( aErrors.AsString() );
end;

end.
