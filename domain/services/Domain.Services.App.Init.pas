unit Domain.Services.App.Init;
interface
uses
  System.SysUtils,
  Domain.Services.Interfaces;
type
  TDomainServiceAppInit = class(TInterfacedObject, iDomainServicesAppInit)
  private
    [weak]
    FParent : iDomainServices;
    procedure StartConnection;
  protected
    constructor Create(const aParent : iDomainServices);
  public
    destructor Destroy(); override;
    class function New(const aParent : iDomainServices) : iDomainServicesAppInit;
    function Execute() : iDomainServicesAppInit;
    function &End(): iDomainServices;
  end;

implementation

uses
  Logs.Services;

{ TDomainServiceAppInit }

function TDomainServiceAppInit.&End: iDomainServices;
begin
  result := FParent;
end;

function TDomainServiceAppInit.Execute: iDomainServicesAppInit;
begin
  result := self;
  StartConnection();
  FParent
  .&End
    .Infra
      .REST
        .StartListening()
      .&End
end;

constructor TDomainServiceAppInit.Create(const aParent : iDomainServices);
begin
  FParent := aParent;
end;

destructor TDomainServiceAppInit.Destroy;
begin
  inherited;
end;

class function TDomainServiceAppInit.New(const aParent : iDomainServices): iDomainServicesAppInit;
begin
  result := self.Create(aParent);
end;

procedure TDomainServiceAppInit.StartConnection;
var
  connection : iDBConnection;
begin
  connection := FParent
                  .&End
                    .Infra
                      .Database
                        .Connection();

  if (not Assigned(connection) ) or ( not connection.Connection.Connected ) then
    raise Exception.Create('Invalid Connection');
end;

end.
