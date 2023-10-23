unit Log.Messages;

interface
uses
  System.Messaging;

type
  TLogKind = (logDebug = 0, logInfo, logWarning, logError);

  TLogMessage = class(TMessage)
    private
      FMessage : string;
      FKind    : TLogKind;
      FTag     : string;

    public
      constructor Create( const aMessage : string;
                          const aKind : TLogKind;
                          const aTag : string ='' );

      property Message : string   read FMessage;
      property Kind    : TLogKind read FKind;
      property Tag     : string   read FTag;

  end;


  TLogMessageDebug = class(TLogMessage)
  private

  public
    constructor Create( const aMessage : string;
                        const aTag : string ='' ); reintroduce;
  end;

  TLogMessageInfo = class(TLogMessage)
  private

  public
    constructor Create( const aMessage : string;
                        const aTag : string ='' ); reintroduce;

  end;

  TLogMessageWarning = class(TLogMessage)
  private

  public
    constructor Create( const aMessage : string;
                        const aTag : string ='' ); reintroduce;

  end;

  TLogMessageError = class(TLogMessage)
  private

  public
    constructor Create( const aMessage : string;
                        const aTag : string ='' ); reintroduce;

  end;

implementation

{ TLogMessage }

constructor TLogMessage.Create(const aMessage: string; const aKind: TLogKind;
  const aTag: string);
begin
  FKind     := aKind;
  FMessage  := aMessage;
  FTag      := aTag;
end;

{ TLogMessageDebug }

constructor TLogMessageDebug.Create(const aMessage, aTag: string);
begin
 inherited Create( aMessage, TLogKind.logDebug,aTag );
end;

{ TLogMessageInfo }

constructor TLogMessageInfo.Create(const aMessage, aTag: string);
begin
  inherited Create( aMessage, TLogKind.logInfo,aTag );
end;

{ TLogMessageWarning }

constructor TLogMessageWarning.Create(const aMessage, aTag: string);
begin
  inherited Create( aMessage, TLogKind.logWarning,aTag );
end;

{ TLogMessageError }

constructor TLogMessageError.Create(const aMessage, aTag: string);
begin
  inherited Create( aMessage, TLogKind.logError,aTag );
end;

end.
