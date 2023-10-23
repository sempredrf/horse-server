unit Notification.Interfaces;

interface

uses
  Generics.Collections,
  Notification.Types;

type
  iNotification = interface
    ['{AA6CBAD0-229D-419B-A9B8-EF2E2EDEBBF5}']
    function AddError(const aError : TNotificationErrorProps) : iNotification; overload;
    function AddError(const aContext : string; const aError : string) : TNotificationErrorProps; overload;
    function ClearErrors() : iNotification;
    function HasErrors() : boolean;
    function GetErrors(): TListNotificationErrorProps;
    function AsString(const aContext : string = '') : string;
  end;

  iNotificationFactory = interface
    ['{F39BE9B3-BECD-4547-9D6C-08BA8565E491}']
    function Notification() : iNotification;
  end;

implementation

end.
