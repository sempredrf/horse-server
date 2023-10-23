unit Entity.Abstract.Interfaces;

interface

uses
  Serializable.Interfaces,
  Notification.Interfaces,
  Notification.Types;

type
  iEntityAbstract<T> = interface(iSerializable)
    ['{05C3FC11-C1EA-47FA-BF64-246BA028C332}']
    function HasError() : boolean;
    function Errors() : TListNotificationErrorProps;

    function ID() : string; overload;
    function ID(const aValue: string) : iEntityAbstract<T>; overload;

    function Notification() : iNotification;

    function Validate() : iEntityAbstract<T>;
  end;

implementation

end.
