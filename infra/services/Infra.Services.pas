unit Infra.Services;

interface

uses
  Domain.Services.Interfaces;

type
  TInfraServices = class(TInterfacedObject, iInfraServices)
  strict protected
    class var FInstance : iInfraServices;
  private
    [weak]
    FParent : iDomainServicesApp;

  protected
    constructor Create(const aParent : iDomainServicesApp);
    function REST : iInfraServiceREST;
    function Database : iDBConnectionFactory;
    function Repository(const aConnection : iDBConnection = nil) : iRepositoryFactory;

    function &End() : iDomainServicesApp;
  public
    destructor Destroy(); override;

    class function GetInstance(const aParent : iDomainServicesApp) : iInfraServices;
  end;

implementation

uses
  Infra.Services.REST,
  Infra.DB.Connection.Factory,
  Infra.Repository.Factory;

{ TInfraFactory }

function TInfraServices.&End: iDomainServicesApp;
begin
  result := FParent;
end;

constructor TInfraServices.Create(const aParent : iDomainServicesApp);
begin
  FParent := aParent;
end;

function TInfraServices.Database: iDBConnectionFactory;
begin
  result := TDBConnectionFactory.GetInstance( self );
end;

destructor TInfraServices.Destroy;
begin

  inherited;
end;

class function TInfraServices.GetInstance(const aParent : iDomainServicesApp): iInfraServices;
begin
  if not Assigned(FInstance) then
    FInstance := self.Create(aParent);

  result := FInstance;
end;

function TInfraServices.REST: iInfraServiceREST;
begin
  result := TInfraServiceREST.GetInstance(self);
end;

function TInfraServices.Repository(const aConnection : iDBConnection = nil) : iRepositoryFactory;
begin
  result := TRepositoryFactory.New( self,
                                    aConnection );
end;

end.
