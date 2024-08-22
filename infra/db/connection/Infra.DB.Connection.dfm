object DBConnection: TDBConnection
  OldCreateOrder = False
  Height = 233
  Width = 512
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    ScreenCursor = gcrNone
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
      'D:\development\projects\delphi\teste\horse-server-main\Win32\lib' +
      'pq.dll'
    Left = 400
    Top = 72
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=orion_salto_130824'
      'User_Name=postgres'
      'Password=mastersys#258459'
      'Server=192.168.1.8'
      'CharacterSet=UTF8'
      'DriverID=PG'
      'Pooled=False')
    ConnectedStoredUsage = []
    LoginPrompt = False
    OnError = FDConnectionError
    Left = 77
    Top = 21
  end
end
