unit Domain.Services.Interfaces;

interface

uses
  System.Classes,
  Data.DB,

  Config.Interfaces;

type
  iDomainServicesApp = interface;
  iDomainServices = interface;

  iInfraServices = interface;

  iDBConnection = interface
    ['{12F3AB9A-F069-4166-9F96-E0498E41ADC9}']
    function Connection : TCustomConnection;
    function Execute(ASql : string) : iDBConnection;
    function GetSqlResult(const ASql : string;
                          const ARecSkip : integer = -1;
                          const ARecMax : integer = -1) : TDataSet;

    function StartTransaction() : iDBConnection;
    function RollbackTransaction() : iDBConnection;
    function CommitTransaction() : iDBConnection;

    function InTransaction() : Boolean;

    function &End() : iInfraServices;
  end;

  iDBConnectionFactory = interface
    ['{EA60733A-63C3-4F47-AEC5-F9801AE4984F}']
    function Connection() : iDBConnection;

    function &End() : iInfraServices;
  end;

  iInfraServiceREST = interface
    ['{AF592406-F01B-4CAA-BCD9-BD4E0AD7CA5D}']
//    function Guardian(const aValue : iHttpAuthServiceGuard) : iHttpServerApi;
    function StartListening() : iInfraServiceREST;
    function &End() : iInfraServices;
  end;

  iRepositoryFactory = interface
    ['{779B6FB2-CD2F-45F2-AB91-39E0CD124C91}']

    function &End() : iInfraServices;
  end;

  iInfraServices = interface
    ['{DE0709EB-D8E8-44B8-9FD1-55ACAF1E4957}']
    function REST : iInfraServiceREST;
    function Database : iDBConnectionFactory;
    function Repository(const aConnection : iDBConnection = nil) : iRepositoryFactory;

    function &End() : iDomainServicesApp;
  end;

  iDomainServicesAppInit = interface
    ['{D48959E8-85B6-4D32-923D-7108D3D095E1}']
    function Execute() : iDomainServicesAppInit;
    function &End() : iDomainServices;
  end;

  iDomainServices = interface
    ['{C721B43D-3E53-4844-AE65-F9AF5CE731A7}']
    function AppInit() : iDomainServicesAppInit;
    function Config() : iConfig;

    function &End() : iDomainServicesApp;
  end;

  iDomainServicesApp = interface
    ['{C474997F-8FC5-45EB-89D7-374A4DF4E72B}']
    function Services : iDomainServices;
    function Infra() : iInfraServices;
  end;

implementation

end.
