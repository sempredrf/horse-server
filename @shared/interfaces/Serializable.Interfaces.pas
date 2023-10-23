unit Serializable.Interfaces;

interface

uses
  System.JSON;

type
  iSerializable = interface
    ['{84F5D0F5-B5CE-4139-B0DE-6652C5A61372}']
    function ToJSON() : TJsonValue;
  end;

implementation

end.
