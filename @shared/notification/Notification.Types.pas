unit Notification.Types;

interface

uses
  System.SysUtils,
  Generics.Collections;

type
  TNotificationErrorProps = class
  private
    FContext: string;
    FError: string;
  public
    constructor Create(const aContext : string; const aError : string);
    destructor Destroy(); override;

    property Context : string read FContext;
    property Error : string read FError;
  end;

  TListNotificationErrorProps = class(TObjectList<TNotificationErrorProps>)
    function Add(const aContext : string; const aError : string) : TNotificationErrorProps; overload;
    function AsString() : string;
  end;


implementation

{ TNotificationErrorProps }

constructor TNotificationErrorProps.Create(const aContext, aError: string);
begin
  FContext := aContext;
  FError := aError;
end;

destructor TNotificationErrorProps.Destroy;
begin

  inherited;
end;

{ TListNotificationErrorProps }

function TListNotificationErrorProps.Add(const aContext,
  aError: string): TNotificationErrorProps;
begin
  result := TNotificationErrorProps.Create(aContext, aError);
  self.Add(result);
end;

function TListNotificationErrorProps.AsString: string;
var
  error : TNotificationErrorProps;
begin
  result := EmptyStr;

  for error in self do
    result := Format('%s: %s', [error.Context, error.Error]) + sLineBreak;
end;

end.
