unit Logs.Services.Horse.Provider;

interface
uses
  Horse.Logger;

type
  THorseLoggerProviderLogCustom = class(TInterfacedObject, IHorseLoggerProvider)
    private
    public
      constructor Create();
      destructor Destroy; override;
      procedure DoReceiveLogCache(ALogCache: THorseLoggerCache);
      class function New(): IHorseLoggerProvider;
    end;

implementation
uses
  System.Json,
  Logs.Services;

{ THorseLoggerProviderLogCustom }

constructor THorseLoggerProviderLogCustom.Create;
begin

end;

destructor THorseLoggerProviderLogCustom.Destroy;
begin

  inherited;
end;

procedure THorseLoggerProviderLogCustom.DoReceiveLogCache(
  ALogCache: THorseLoggerCache);
var
  json : TJsonObject;
begin

  for json in ALogCache do
  begin
    Log.Info(Json.ToString,'api');
  end;

end;

class function THorseLoggerProviderLogCustom.New: IHorseLoggerProvider;
begin
  result:= self.Create();
end;

end.
