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
  protected
    constructor Create(const aParent : iDomainServices);
  public
    destructor Destroy(); override;

    class function New(const aParent : iDomainServices) : iDomainServicesAppInit;
    function Execute() : iDomainServicesAppInit;
    function &End(): iDomainServices;
  end;

implementation

{ TDomainServiceAppInit }

function TDomainServiceAppInit.&End: iDomainServices;
begin
  result := FParent;
end;

function TDomainServiceAppInit.Execute: iDomainServicesAppInit;
begin
  result := self;

  FParent
  .&End

    .Infra
      .Database
        .Connection()
      .&End
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

end.
