object DBConnection: TDBConnection
  OldCreateOrder = False
  Height = 339
  Width = 512
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 72
    Top = 88
  end
  object FDTransaction: TFDTransaction
    Options.DisconnectAction = xdRollback
    Left = 72
    Top = 152
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 400
    Top = 16
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 
      'D:\Desenv\UniSystem\Delphi10_4\managerDFe\branches\dev\dlls\libp' +
      'q.dll'
    Left = 400
    Top = 72
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=Manager_DFe'
      'User_Name=postgres'
      'Password=mastersys#258459'
      'Server=localhost'
      'DriverID=PG')
    OnError = FDConnectionError
    Left = 77
    Top = 21
  end
end
