unit Infra.Repository.Factory;

interface

uses
  System.SysUtils,
  Domain.Services.Interfaces;

type
  TRepositoryFactory = class(TInterfacedObject, iRepositoryFactory)
  private
    FDbConnection : iDBConnection;

    [weak]
    FParent : iInfraServices;
  protected
    constructor Create(const aParent : iInfraServices;
                       const aConnection : iDBConnection = nil);

    function &End(): iInfraServices;
  public
    destructor Destroy(); override;

    class function New(const aParent : iInfraServices;
                       const aConnection : iDBConnection = nil) : iRepositoryFactory;
  end;

implementation

{ TRepositoryFactory }

function TRepositoryFactory.&End: iInfraServices;
begin
  result := FParent;
end;

constructor TRepositoryFactory.Create(const aParent : iInfraServices;
                                      const aConnection : iDBConnection = nil);
begin
  FParent := aParent;
  FDbConnection := aConnection;

  if not Assigned(FDbConnection ) then
    FDbConnection := FParent
                      .Database
                        .Connection();
end;

destructor TRepositoryFactory.Destroy;
begin

  inherited;
end;

class function TRepositoryFactory.New(const aParent : iInfraServices;
                                      const aConnection : iDBConnection = nil): iRepositoryFactory;
begin
  result := self.Create(aParent,
                        aConnection);
end;

end.
