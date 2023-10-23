unit Config.Interfaces;

interface

uses
  Serializable.Interfaces,
  Log.Messages;

type
  iConfig = interface;

  iConfigApi = interface(iSerializable)
    ['{22DBCB0E-63AC-4794-91AE-E5B064C82F04}']
    function BaseURL(const aValue : string) : iConfigApi; overload;
    function BaseURL() : string; overload;

    function Port(const aValue : integer): iConfigApi; overload;
    function Port: integer; overload;

    function LogLevel(const aValue : TLogKind): iConfigApi; overload;
    function LogLevel: TLogKind; overload;

    function &End() : iConfig;
  end;

  iConfigPaths = interface
    ['{9332E6F1-8626-4A3F-91D5-81A3CA189ABA}']
    function Config(const aValue : string) : iConfigPaths; overload;
    function Config() : string; overload;

    function Log(const aValue : string) : iConfigPaths; overload;
    function Log() : string; overload;

    function Temp(const aValue : string) : iConfigPaths; overload;
    function Temp() : string; overload;

    function Home(const aValue : string) : iConfigPaths; overload;
    function Home() : string; overload;

    function &End() : iConfig;
  end;

  iConfig = interface(iSerializable)
    ['{2A9E8533-91A0-43E1-963D-3347DAF2DCC3}']
    function Api(const aValue : iConfigApi) : iConfig; overload;
    function Api : iConfigApi; overload;

    function Paths() : iConfigPaths;
  end;

implementation

end.
