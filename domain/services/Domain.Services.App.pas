unit Domain.Services.App;

interface

uses
  System.SysUtils,
  Domain.Services.Interfaces;

type
  TApp = class(TInterfacedObject, iDomainServicesApp)
  private
    class var FInstance : iDomainServicesApp;
  protected
    constructor Create();
  public
    destructor Destroy(); override;

    class function GetInstance() : iDomainServicesApp;

    function Services : iDomainServices;
    function Infra() : iInfraServices;
  end;

implementation

uses
  Domain.Services,
  Infra.Services;

{ TApp }

constructor TApp.Create;
begin

end;

destructor TApp.Destroy;
begin

  inherited;
end;

class function TApp.GetInstance: iDomainServicesApp;
begin
  if not Assigned(FInstance) then
    FInstance := self.Create();

  result := FInstance;
end;

function TApp.Infra: iInfraServices;
begin
  result := TInfraServices.GetInstance(self);
end;

function TApp.Services: iDomainServices;
begin
  result := TDomainServices.New( self );
end;

end.
