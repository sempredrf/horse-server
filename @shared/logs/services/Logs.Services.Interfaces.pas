unit Logs.Services.Interfaces;

interface
uses
  Log.Messages;

type

  iLogServicesCore = interface
    ['{C1BF07B1-9E28-444A-B31D-4A0905DDD514}']

  end;

  iLogServices = interface
    ['{86E2BE71-23D1-453E-866D-177BD4C7EA2D}']
    procedure Log(const AType : TLogKind ; const AMessage: string; const aTag: string ='');
    procedure Debug(const AMessage: string; const aTag: string ='');
    procedure Info(const AMessage: string; const aTag: string ='');
    procedure Warning(const AMessage: string; const aTag: string ='');
    procedure Error(const AMessage: string; const aTag: string ='');

  end;

implementation

end.
