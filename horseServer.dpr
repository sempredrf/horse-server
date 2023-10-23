program horseServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Domain.Services.Interfaces in 'domain\services\Domain.Services.Interfaces.pas',
  Config.Interfaces in '@shared\Config.Interfaces.pas',
  Serializable.Interfaces in '@shared\interfaces\Serializable.Interfaces.pas',
  Log.Messages in '@shared\logs\messages\Log.Messages.pas',
  Logs.Services.Core in '@shared\logs\services\Logs.Services.Core.pas',
  Logs.Services.Horse.Provider in '@shared\logs\services\Logs.Services.Horse.Provider.pas',
  Logs.Services.Interfaces in '@shared\logs\services\Logs.Services.Interfaces.pas',
  Logs.Services in '@shared\logs\services\Logs.Services.pas',
  Services.Messages in '@shared\services\Services.Messages.pas',
  Util.Service.Params in '@shared\util\Util.Service.Params.pas',
  Config.Entity.API in '@shared\config\entities\Config.Entity.API.pas',
  Config.Entity in '@shared\config\entities\Config.Entity.pas',
  Util.Constants.Api in '@shared\util\Util.Constants.Api.pas',
  Util.Constants in '@shared\util\Util.Constants.pas',
  Config.Entity.Paths in '@shared\config\entities\Config.Entity.Paths.pas',
  Infra.DB.Connection in 'infra\db\connection\Infra.DB.Connection.pas' {DBConnection: TDataModule},
  Infra.DB.Params.Connection in 'infra\db\connection\Infra.DB.Params.Connection.pas',
  Infra.DB.Params.Interfaces in 'infra\db\connection\Infra.DB.Params.Interfaces.pas',
  Util.Common.Functions in '@shared\util\Util.Common.Functions.pas',
  Util.Constants.DB in '@shared\util\Util.Constants.DB.pas',
  Domain.Services.App in 'domain\services\Domain.Services.App.pas',
  Infra.Services in 'infra\services\Infra.Services.pas',
  Infra.Services.REST in 'infra\services\REST\Infra.Services.REST.pas',
  Infra.DB.Connection.Factory in 'infra\db\connection\factories\Infra.DB.Connection.Factory.pas',
  Infra.Repository.Factory in 'infra\repositories\factories\Infra.Repository.Factory.pas',
  Domain.Services in 'domain\services\Domain.Services.pas',
  Domain.Services.App.Init in 'domain\services\Domain.Services.App.Init.pas',
  Infra.Services.REST.Routes in 'infra\services\REST\Infra.Services.REST.Routes.pas',
  Infra.Services.REST.Routes.Empresa in 'infra\services\REST\Infra.Services.REST.Routes.Empresa.pas';

begin
  try
    {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := DebugHook <> 0;
    IsConsole := false;
    {$ENDIF}

    TApp.GetInstance
      .Services
        .AppInit
          .Execute();
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
