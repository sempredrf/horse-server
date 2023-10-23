unit Api.Exception;

interface

uses
  System.SysUtils,
  System.JSON,
  Horse.Commons,
  Notification.Types;

type
  THttpStatus = Horse.Commons.THTTPStatus;

  TApiException = class (Exception)
    private
      FStatus : THttpStatus;
      FError : string;
    public
      constructor Create(const aStatusCode : THttpStatus;
                         const aError : string ); reintroduce;

    function ToJson() : TJsonObject;

    property status : THttpStatus   read FStatus write FStatus;
    property error : string     read FError  write FError;
  end;

implementation


{ TApiException }

constructor TApiException.Create(const aStatusCode: THttpStatus;
                                 const aError: string);
begin
  inherited Create(aError);

  FStatus := aStatusCode;
  FError  := aError;

end;

function TApiException.ToJson: TJsonObject;
begin
  result := TJSONObject.Create();

  result.AddPair('status', TJSONNumber.Create(FStatus.ToInteger));
  result.AddPair('messageError', FError);
end;

end.
