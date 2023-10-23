unit Services.Messages;

interface

uses
  System.Messaging;

type
  TMessage = System.Messaging.TMessage;

  TServiceMessage = class
    class function SubscribeToMessage(const AMessageClass: TClass; const AListenerMethod: TMessageListenerMethod): Integer;
    class procedure SendMessage(const Sender: TObject; AMessage: TMessage);
  end;

implementation

{ TServiceMessage }

class procedure TServiceMessage.SendMessage(const Sender: TObject;
  AMessage: TMessage);
begin
  TMessageManager.DefaultManager.SendMessage(Sender, AMessage);
end;

class function TServiceMessage.SubscribeToMessage(const AMessageClass: TClass;
  const AListenerMethod: TMessageListenerMethod): Integer;
begin
  result := TMessageManager.DefaultManager.SubscribeToMessage(AMessageClass, AListenerMethod);
end;

end.
