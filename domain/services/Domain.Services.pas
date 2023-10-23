unit Domain.Services;

interface

uses
  System.SysUtils,
  Domain.Services.Interfaces,
  Config.Interfaces;

type
  TDomainServices = class(TInterfacedObject, iDomainServices)
  private
    [weak]
    FParent : iDomainServicesApp;

    FConnection : iDBConnection;
  protected
    constructor Create(const aParent : iDomainServicesApp;
                       const aConnection : iDBConnection = nil);
  public
    destructor Destroy(); override;

    class function New(const aParent : iDomainServicesApp;
                       const aConnection : iDBConnection = nil) : iDomainServices;

    function AppInit() : iDomainServicesAppInit;
    function Config() : iConfig;

    function &End(): iDomainServicesApp;
  end;

implementation

uses
  Util.Service.Params,
  Domain.Services.App.Init;

{ TDomainServices }

function TDomainServices.&End: iDomainServicesApp;
begin
  result := FParent;
end;

function TDomainServices.AppInit: iDomainServicesAppInit;
begin
  result := TDomainServiceAppInit.New( self );
end;

function TDomainServices.Config: iConfig;
begin
  result := TUtilServiceParams.GetInstance
              .Config;
end;

constructor TDomainServices.Create(const aParent : iDomainServicesApp;
                                   const aConnection : iDBConnection = nil);
begin
  FParent     := aParent;
  FConnection := aConnection;
end;

destructor TDomainServices.Destroy;
begin

  inherited;
end;

class function TDomainServices.New(const aParent : iDomainServicesApp;
                                    const aConnection : iDBConnection = nil): iDomainServices;
begin
  result := self.Create(aParent,
                        aConnection);
end;

end.
