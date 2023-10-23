unit Entity.Abstract;

interface

uses
  System.JSON,
  Entity.Abstract.Interfaces,
  Notification.Interfaces,
  Notification.Types;

type
  TEntity<T> = class abstract(TInterfacedObject, iEntityAbstract<T>)
  private
  protected
    FID : string;
    FNotification : iNotification;

    constructor Create();
  public
    function HasError() : boolean;
    function Errors() : TListNotificationErrorProps;

    function ID() : string; overload;
    function ID(const aValue: string) : iEntityAbstract<T>; overload;

    function Notification() : iNotification;

    function Validate() : iEntityAbstract<T>; virtual; abstract;
    function ToJson() : TJsonValue; virtual; abstract;
  end;


implementation

uses
  Notification.Factory,
  Uni.Common.Util;

{ TEntity }

constructor TEntity<T>.Create;
begin
  FID := GUID();

  FNotification :=  TNotificationFactory
                      .New()
                        .Notification();
end;

function TEntity<T>.Errors: TListNotificationErrorProps;
begin
  result := nil;

  if Assigned(FNotification) and (FNotification.HasErrors) then
    result := FNotification.GetErrors()
end;

function TEntity<T>.HasError: boolean;
begin
  result := Assigned(FNotification) and
            FNotification.HasErrors();
end;

function TEntity<T>.ID: string;
begin
  result := FID;
end;

function TEntity<T>.ID(const aValue: string): iEntityAbstract<T>;
begin
  result := self;
  FID := aValue;
end;

function TEntity<T>.Notification: iNotification;
begin
  result := FNotification;
end;

end.
