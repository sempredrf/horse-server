unit Infra.DB.Params.Interfaces;

interface

uses
  System.Classes;

type
  iDBParamsConnection = interface
    ['{50C74616-E991-4D50-B153-D282C9BB49F3}']
    function ConnectionDefName() : string; overload;
    function Pooled() : boolean; overload;
    function HostName() : string; overload;
    function Port() : integer; overload;
    function DriverID() : string; overload;
    function DataBase() : string; overload;
    function UserName() : string; overload;
    function Password() : string; overload;
    function Charset() : string; overload;
    function VendorLib() : string; overload;

    function Params() : TStrings;
  end;

implementation

end.
