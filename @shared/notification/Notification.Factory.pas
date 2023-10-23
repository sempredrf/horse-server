unit Notification.Factory;

interface

uses
  Notification.Interfaces;

type
  TNotificationFactory = class(TInterfacedObject, iNotificationFactory)
  private
    constructor Create();
  public
    class function New() : iNotificationFactory;
    function Notification() : iNotification;
  end;

implementation

uses
  Notification;

{ TNotificationFactory }

constructor TNotificationFactory.Create;
begin

end;

class function TNotificationFactory.New: iNotificationFactory;
begin
  result := self.Create();
end;

function TNotificationFactory.Notification: iNotification;
begin
  result := TNotification.New();
end;

end.
