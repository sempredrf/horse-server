
unit Util.Common.Functions;

interface

uses
  System.SysUtils,
  System.UITypes,
  System.Classes,
  System.IniFiles,
  System.IOUtils,
  System.Math,
  System.MaskUtils,
  System.Variants,
  System.DateUtils,
  System.StrUtils,
  System.RegularExpressions,
  System.NetEncoding,

  FMX.Forms,
  FMX.Dialogs,
  FMX.DialogService,

  Data.DB

  {$IFDEF MSWINDOWS}
  ,WinApi.Windows
  ,Winapi.ShellAPI
  {$ENDIF}

  ;

const
  DecodeCharSet: array [0 .. 63] of char = ( { 00   01   02   03   04   05   06   07   08   09   0A   0B   0C   0D   0E   0F }
    { 00 } #32, #48, #49, #50, #51, #52, #53, #54, #55, #56, #57, #97, #98, #99, #100, #101,
    { 10 } #102, #103, #104, #105, #106, #107, #108, #109, #110, #111, #112, #113, #114, #115, #116, #117,
    { 20 } #118, #119, #120, #121, #122, #65, #66, #67, #68, #69, #70, #71, #72, #73, #74, #75,
    { 30 } #76, #77, #78, #79, #80, #81, #82, #83, #84, #85, #86, #87, #88, #89, #90, #45);

  EncodeCharSet: array [0 .. 127] of char = ( { 00  01  02  03  04  05  06  07  08  09  0A  0B  0C  0D  0E  0F }
    { 00 } #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0,
    { 10 } #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0,
    { 20 } #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #63, #0, #0,
    { 30 } #01, #02, #03, #04, #05, #06, #07, #08, #09, #0, #0, #0, #0, #0, #0, #0,
    { 40 } #0, #37, #38, #39, #40, #41, #42, #43, #44, #45, #46, #47, #48, #49, #50, #51,
    { 50 } #52, #53, #54, #55, #56, #57, #58, #59, #60, #61, #62, #0, #0, #0, #0, #0,
    { 60 } #0, #11, #12, #13, #14, #15, #16, #17, #18, #19, #20, #21, #22, #23, #24, #25,
    { 70 } #26, #27, #28, #29, #30, #31, #32, #33, #34, #35, #36, #0, #0, #0, #0, #0);

  function StrToEnumerado(var ok: boolean; const s: string; const AString: array of string;
    const AEnumerados: array of variant): variant;

  function EnumeradoToStr(const t: variant; const AString:
    array of string; const AEnumerados: array of variant): variant;

  function IFF(Teste:Boolean;ResultV,ResultF:Variant):Variant;
  function CalculaIdade(DatNasc:TDateTime; DataHoje:TDateTime = 0 ):Integer;
  //function GravarLog(AText: string; APath : string = ''; AFileName : string = '') : boolean;
  function CreateNameComponent(Concatenar: String): String;
  function RemoveFormatacao(Texto:String):String;
  function RemoveAcentos(Texto: String): String; // RFC
  function RemoveTodosCaracteresEspeciais(Texto: string):string;
  function GUID:String;

  function LeIni(pFile,pSecao, pCampo, pDefault:String): string;
  function GravaIni(pFile, pSecao, pCampo, pVAlor: String): Boolean;

  function CriaDiretorio(APath : string ) : boolean;

  function AjustaFormatoJson(AStrJSON: String): String;
  function RemoveQuebraLinha(aText : string): string;

  function StrZero(Texto:string;Quant:integer; Pos:Char):String;

  function Modulo11(N : String):String;
  function Modulo11D2(ANumero: string): string;

  function HorasDecorridas(pDataIni: TDate; pHoraIni: TTime; pDataFim: TDate; pHoraFim: TTime): TTime;

  function BuscaDireita(Busca,Text : string) : integer;
  function BuscaEsquerda(Busca,Text : string) : integer;
  function BuscaTroca(Text,Busca,Troca : string) : string;

  function Encode2(Texto: String): String;
  function Decode2(Key: String): String;
  function DecodeChar(chr: char): char;
  function EncodeChar(chr: char): char;

  function TemLetras(Texto: String): Boolean;

  function GetAppPath() : string;

  {$IFDEF MSWINDOWS}
  function GetComputerName() : string;
  function GetAppVersionStr(const AFileName: string): string;
  function FileVerInfo(Const FileName: String; Var FileInfo: String): Boolean;
  function GetAppVersion() : string;

  function WinActivate(const AWinTitle: string; Restore : boolean): boolean;
  function WinMinimize(const AWinTitle: string): boolean;

  procedure LimparLogs(applicationTitle, CONFIG_INI : string);
  procedure GetDirList(Directory: String; var Result: TStringList; SubPastas: Boolean);
  procedure GetFileList(Directory: String; var Result: TStringList);
  function DeletarPasta(const APath: String): Boolean;
  {$ENDIF}

  function ValidaCpfCnpj(sDocumento: String): Boolean;
  function FormataCpfCnpj(Texto: String): String;

  function RoundNum(Valor:Extended;Decimais:Integer=2):Extended;
  function TruncaValor(pValor: Double; pCasasDecimais: Integer=2): Double;

  function VerificaCamposRequeridos(const ADataSet : TDataSet; ATryFocus : boolean = false; AShowMessage : boolean = true; ARaiseException : boolean = false) : boolean;
  function ConvertToFloat(AValue : double; ADecimais : integer = 2) : double;
  function StrToFloatDef2(const S : string; const Default : Extended) : Extended;

  function BoolToInt(AValue : boolean) : integer;

  function LPAD(s: string; n: Integer): string;
  function RPAD(s: string; n: Integer): string;

  function FormataTelefoneDDD(Texto: String): String;
  function FormataCep(pCep: String): String;

  function GetAppName() : string;

  function DialogYesNo(Mensagem: string): TModalResult;


  function NewMinutesBetween(aNow, aThen :TDateTime) :Int64;

  function GetStringOfArray(AArray: array of string; ACharSeparator: string = ', '; AQuoted: Boolean = true): string;
  function GetStringOfStringList(AArray: TStringList; ACharSeparator: string = ', '; AQuoted: Boolean = true): string;
  function TratarData(data : TDateTime): String;

  function ValidaEmail(const Email: string): Boolean;

  function OnlyNumber(const AValue: String): String;
  function CharIsNum(const C: Char): Boolean;

  function GeraSuperSenha(AValue: String): String;
  function SuperSenha(AValue: String): Boolean;

  function PasswordGenerate(MaxDigit : Byte = 8; OnlyNumber: Boolean = False; UpperELowerCase: Boolean = True): String;

  function ValidateIPRegex(const Value: String): Boolean;

  function Replicate(pCaracter: Char; pString: string; pQuant: integer; pPos: String = 'E-Esquerda, D-Direita'):String;

  function StreamToString(aStream: TStream): string;

  function EncodeBase64(const AValue : string): string;
  function DecodeBase64(const AValue : string): string;

  function TratarDiasUteis(data: TDate): TDate;

  function IsValidUUID(const aValue : string) : boolean;

implementation

{$ZEROBASEDSTRINGS OFF}

function Modulo11D2(ANumero: string): string;
var
  I, V, L, M, Soma, iDigito1, iDigito2: Integer;
begin
  V := 0;
  L := Length(ANumero);
  M := 9;
  Soma := 0;
  for I := L downto 1 do
  begin
    Soma := Soma + (StrToInt(ANumero[L-V]) * M);
    M := M -1;
    if M = 1 then  M := 9;
      inc(v);
  end;
  iDigito1 := Soma mod 11;
  if iDigito1 > 9 then iDigito1 := 0;
  ANumero := ANumero + IntToStr(iDigito1);

  V := 0;
  L := Length(ANumero);
  M := 9;
  Soma := 0;
  for I := L downto 1 do
  begin
    Soma := Soma + (StrToInt(ANumero[L-V]) * M);
    M := M -1;
    if M = 1 then  M := 9;
       inc(v);
  end;
  iDigito2 := Soma mod 11;
  if iDigito2 > 9 then iDigito2 := 0;
  Result := IntToStr(iDigito1)+IntToStr(iDigito2);
end;

function Modulo11(N : String):String;
var
  Somatorio,m,f : Integer;
begin
  m := 2;
  Somatorio := 0;
  for f := Length(N) downto 1 do
    begin
      Somatorio := Somatorio + (StrToInt(N[f]) * m);
      inc(m);
      if m = 10 then m := 2;
    end;
  m := Somatorio div 11;
  m := 11 - (Somatorio - (m * 11));
  if m = 10 then m := 0;
  if m = 11 then m := 1;
  Result := IntToStr(m);
end;

function StrZero(Texto:string;Quant:integer; Pos:Char):String;
begin
  if UpperCase(Pos)='E' then result:= StringOfChar('0',(Quant-length(Texto))) + Texto;
  if UpperCase(Pos)='D' then result:= Texto + StringOfChar('0',(Quant-length(Texto)));
end;

function AjustaFormatoJson(AStrJSON: String): String;
var
  s1, s2 : string;
begin
  s1 := copy(AStrJSON, 0, 1);
  s2 := copy(AStrJSON, Length(AStrJSON), 1);

  if (s1 = '"') and (s2 = '"') then
    AStrJSON := copy(AStrJSON, 2, Length(AStrJSON) - 2);

  AStrJSON :=  StringReplace(AStrJSON, '\"', '"', [rfReplaceAll]);

  Result := AStrJSON;
end;

function RemoveQuebraLinha(aText : string): string;
begin
  { Retirando as quebras de linha em campos blob }
  Result := StringReplace(aText, #$D#$A, '', [rfReplaceAll]);

  { Retirando as quebras de linha em campos blob }
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);
end;


function CriaDiretorio(APath : string ) : boolean;
begin
  if not DirectoryExists(APath) then
    result := ForceDirectories(APath)
  else
    result := true;
end;

function GUID:String;
Var
  xGUID: TGUID;
Begin
  CreateGUID(xGUID);

  Result:=GUIDToString(xGUID);

  xGUID.Empty;
end;

function GravaIni(pFile, pSecao, pCampo, pVAlor: String): Boolean;
var
  ArqParam: TIniFile;
Begin
  ArqParam := TiniFile.Create(pFile);
  try
    ArqParam.WriteString(pSecao, pCampo, pVAlor);
    Result := true;
  finally
    ArqParam.Free;
  end;
end;

function IFF(Teste:Boolean;ResultV,ResultF:Variant):Variant;
begin
  if Teste then
    Result:=ResultV
  else
    Result:=ResultF;
end;

function  LeIni(pFile,pSecao, pCampo, pDefault:String): string;
var
  ArqParam:TIniFile;
  sDir : string;
begin
  sDir := ExtractFileDir(pFile);

  if not DirectoryExists(sDir) then
    ForceDirectories( sDir );

  ArqParam:=TiniFile.Create(pFile);
  try
    if not ArqParam.ValueExists(pSecao,pCampo) then
       ArqParam.WriteString(pSecao, pCampo, pDefault);

    result:=ArqParam.ReadString(pSecao,pCampo,pDefault);

  finally
    ArqParam.Free;
  end;
end;


function CreateNameComponent(Concatenar: String): String;
var
  Buscar: Boolean;
  NomeComp: String;
begin
  Buscar := True;
  while Buscar do
  begin
    NomeComp := Concatenar +  RemoveFormatacao(GUID);

    if Application.FindComponent(NomeComp) = nil then
      Buscar :=  false
    else
      Buscar :=  true;
  end;

  result := NomeComp;
end;


function RemoveFormatacao(Texto:String):String;
var
  x:Integer;
  NaoFormatado: String;
  Letra: Char;
Begin
  NaoFormatado:='';
  For x:=1 To Length(Texto) Do
  Begin
    Letra := Texto[x];
    if (CharInSet(Letra, ['0' .. '9'])) or (CharInSet(Letra, ['A' .. 'Z'])) or (CharInSet(Letra, ['a' .. 'z'])) then
      NaoFormatado := NaoFormatado + Letra;
  End;
  Result:=NaoFormatado;

end;


//procedure CloneObject(Source, Dest: TObject);
//var
//  PropList: PPropList;
//  PropCount, i: integer;
//  Value: variant;
//
//  ObjectPropS, ObjectPropD : TObject;
//  MethodProp : TMethod;
//begin
//  if (Source.ClassType = Dest.ClassType) then
//  begin
//    PropCount := GetPropList(Source, PropList);
//    for i := 0 to PropCount - 1 do
//    begin
//      try
//        if (PropList[i]^.SetProc <> nil) then
//        begin
//          case PropList[i]^.PropType^.Kind of
//
//            tkClass :
//              begin
//                ObjectPropS := GetObjectProp(Source, PropList^[i]);
//                ObjectPropD := GetObjectProp(Dest, PropList^[i]);
//
//                if ObjectPropD <> nil then
//                  CloneObject(ObjectPropS, ObjectPropD)
//                else
//                  SetObjectProp(Dest, PropList^[i], ObjectPropS);
//              end;
//
//            tkMethod :
//              begin
//                MethodProp := GetMethodProp(Source, PropList[i]^.Name);
//                SetMethodProp(Dest, PropList[i]^.Name, MethodProp);
//              end;
//
//            tkRecord :
//              begin
//                //--- estava levantando excecao
//              end;
//
//          else
//            begin
//              Value := GetPropValue(Source, PropList[i]^.Name);
//              SetPropValue(Dest, PropList[i]^.Name, Value);
//            end;
//
//          end;
//
//        end;
//
//      except
//        // propriedade nao foi clonada gera um except mas não faz nada
//      end;
//    end
//  end
//  else
//    if Source is TPersistent then
//      TPersistent(Dest).Assign(TPersistent(Source));
//end;

function CalculaIdade(DatNasc:TDateTime; DataHoje:TDateTime = 0 ):Integer;
begin
  if DataHoje = 0 then
    DataHoje := now;
  try
   strtodate(DateToStr(DatNasc)); //-- Verifica se a data é valida
  except
    abort;
  end;

  result := Trunc((DataHoje - DatNasc)/365.25);
end;

function StrToEnumerado(var ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
        result := AEnumerados[i];

  ok := result <> -1;

  if not ok then
    result := AEnumerados[0];
end;

function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';

  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

function HorasDecorridas(pDataIni: TDate; pHoraIni: TTime; pDataFim: TDate; pHoraFim: TTime): TTime;
var
  dDias, dHorasDias, dHorasIni, dHorasFim: Double;
  sHorario, sHora, sMin, sSeg :String;
begin
  dDias := (pDataFim - pDataIni);
  dHorasDias := (24 * dDias);
  dHorasIni := pHoraIni;
  dHorasFim := pHoraFim;
  sHorario := TimeToStr(dHorasFim - dHorasIni);

  sSeg := Copy(sHorario, BuscaDireita(':',sHorario)+1,2);
  sHorario := Copy(sHorario,1,Length(sHorario)-3);
  sMin := Copy(sHorario, BuscaDireita(':',sHorario)+1,2);
  sHorario := Copy(sHorario,1,Length(sHorario)-3);
  sHora := sHorario;
  Result :=(StrToFloat(sHora)+dHorasDias)+(StrToFloat(sMin)/60)+(StrToFloat(sSeg)/3600);
end;

function BuscaDireita(Busca,Text : string) : integer;
var n,retorno,Tam: integer;
begin
  retorno := 0;
  Tam:=Length(Busca);
  for n := length(Text) downto 1 do
  begin
    if UpperCase(Copy(Text,n,Tam)) = UpperCase(Busca) then
    begin
      retorno := n;
      break;
    end;
  end;
  Result := retorno;

end;

function BuscaEsquerda(Busca,Text : string) : integer;
var n,retorno,Tam: integer;
begin
  retorno := 0;
  Tam:=Length(Busca);
  for n := 1  To length(Text) do
  begin
    if UpperCase(Copy(Text,n,Tam))=UpperCase(Busca) then
    begin
      retorno := n;
      break;
    end;
  end;
  Result := retorno;

end;

function BuscaTroca(Text,Busca,Troca : string) : string;
var n, Tam : integer;
begin
  Tam:=Length(Busca);
  for n := 1 to length(Text) do
    if Copy(Text,n,Tam) = Busca then
    begin
      Delete(Text,n,Tam);
      Insert(Troca,Text,n);
    end;
  Result := Text;
end;

function Encode2(Texto: String): String;
var
  position: Longint;
  temparr: array [1 .. 4] of byte;
begin
  Result := '';
  position := 1;
  while (length(Texto) mod 3) <> 0 do
    Texto := Texto + #0;
  while position + 2 <= length(Texto) do
    begin
      { This is for lower case characters, move them into the 0-64 range. }
      temparr[1] := (ord(Texto[position]) and $3F);
      temparr[2] := ((ord(Texto[position]) and $C0) shr 6) + ((ord(Texto[position + 1]) and $0F) shl 2);
      temparr[3] := ((ord(Texto[position + 1]) and $F0) shr 4) + ((ord(Texto[position + 2]) and $03) shl 4);
      temparr[4] := ((ord(Texto[position + 2]) and $FC) shr 2);

      { Write the output }
      Result := Result + DecodeChar(chr(temparr[1])) + DecodeChar(chr(temparr[2])) + DecodeChar(chr(temparr[3])) + DecodeChar(chr(temparr[4]));

      { Done that colletion of 4 bytes }
      Inc(position, 3);
    end; // while
  Result := Trim(Result);
  // Result := StringToOleStr(Result);
end;

function Decode2(Key: String): String;
var
  position: Longint;
  temparr: array [1 .. 4] of byte;
begin
  while (length(Key) mod 4) <> 0 do
    Key := Key + #0;
  Result := '';
  position := 1; { }
  while position + 3 <= length(Key) do
    begin
      { Subtract 32 so values are 0-95 }
      Key[position + 0] := EncodeChar(Key[position + 0]);
      Key[position + 1] := EncodeChar(Key[position + 1]);
      Key[position + 2] := EncodeChar(Key[position + 2]);
      Key[position + 3] := EncodeChar(Key[position + 3]);
      { Now we have values in the range 0-63, encode them and add them. Basically 4 chars will convert into three
        in the form by bit manipulation }
      temparr[1] := (ord(Key[position]) and $3F) + ((ord(Key[position + 1]) and $03) shl 6);
      temparr[2] := ((ord(Key[position + 1]) and $3C) shr 2) + ((ord(Key[position + 2]) and $0F) shl 4);
      temparr[3] := ((ord(Key[position + 2]) and $30) shr 4) + ((ord(Key[position + 3]) and $3F) shl 2);
      { Write the output }
      Result := Result + chr(temparr[1]) + chr(temparr[2]) + chr(temparr[3]);

      { Done that colletion of 4 bytes }
      Inc(position, 4);
    end; // while
//  Result := StringToOleStr(Result);

  result := Trim(result);
end;

function DecodeChar(chr: char): char;
begin
  if chr > #63 then
    Result := #0
  else
    Result := DecodeCharSet[ord(chr)];
end;

function EncodeChar(chr: char): char;
begin
  if chr > #127 then
    Result := #0
  else
    Result := EncodeCharSet[ord(chr)];
end;

function GetAppPath() : string;
begin
  {$IFDEF ANDROID}
    result := TPath.GetDocumentsPath;

  {$ELSE}
    result := TPath.GetDirectoryName(ParamStr(0));
  {$ENDIF}

end;

function TemLetras(Texto: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i:=1  to length(Texto)  do
  begin
//    if Texto[i] in ['a'..'z','A'..'Z'] then
    if CharInSet(Texto[i], ['a'..'z','A'..'Z']) then
    begin
      Result := True;
      exit;
    end;
  end;
end;

{$IFDEF MSWINDOWS}
function GetComputerName() : string;
var
  buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  WinApi.Windows.GetComputerName(@buffer, Size);
  Result := StrPas(buffer);
end;
{$ENDIF}

function ValidaCpfCnpj(sDocumento: String): Boolean;
var
  soma, somaDig, Pos, resto: smallint;
  sNumeroDocumento, sTipo: String;
const
  ordZero = ord('0');
begin
  Result := False;
  sNumeroDocumento := RemoveFormatacao(sDocumento);
  if length(sNumeroDocumento) = 11 then
    sTipo := 'CNPF';
  if length(sNumeroDocumento) = 14 then
    sTipo := 'CNPJ';

  (* Valida CNPJ *)
  if sTipo = 'CNPF' then
    begin
      soma := 0;
      somaDig := 0;
      { O valor das variáveis soma e somadig é utilizada para fazer
        a verificação dos dois últimos digitos do CPF, pois, eles
        são os dígitos verificadores.
        ord(textoCPF[pos]) - ordZero -> retorna o número que esta na posição pos.
        Foi utilizado o ord porque ele retorna a posição do número na tabela Ascii - a posição
        do zero na tabela ascii, nos temos o número daquela posição.
        ex:  numero      posição tabela asccii
        0            48
        1            49
        2            50
        então se quero obter o número dois
        50 - 48 = 2
        Como o vetor é do tipo string , e preciso de um resultado numérico, não posso
        utilizar o strtoint(textoCPF[pos]), como estou pegando uma posição ele considera
        que o tipo é char e não aceita a conversão, a não ser que jogue este conteúdo para
        uma variável do tipo string e em seguida fazer a conversão. Com o ord o resultado
        fica mais eficiente.
        }

      for Pos := 1 to 9 do
        begin
          soma := soma + (ord(sNumeroDocumento[Pos]) - ordZero) * (11 - Pos);
          somaDig := somaDig + (ord(sNumeroDocumento[Pos]) - ordZero);
        end;

      resto := 11 - soma mod 11; // Obtenho o resto da divisão da variável soma com o número 11
      // o resultado iremos subtrair por 11, se o resultado final for maior
      // que nove , iremos atribuir a ele 0.
      if resto > 9 then
        resto := 0;

      if resto <> ord(sNumeroDocumento[10]) - ordZero then // verifica se o resultado obtido no calculo anterior e igual
        // ao digito da posição 10, pois, se for igual um dígito está correto,
        // é necessário verificar o dígito da posição 11.
        Exit; { primeiro DV errado }

      soma := soma + somaDig + 2 * resto;
      resto := 11 - soma mod 11;
      if resto > 9 then
        resto := 0;

      if resto <> ord(sNumeroDocumento[11]) - ordZero then // se o resultdo do calculo anterior for igual ao dígito da posição 11
        // então o CPF está correto.
        Exit; { segundo DV errado }

      Result := true; { tudo certo }
    end;
  (* *)

  (* Valida CNPJ *)
  if sTipo = 'CNPJ' then
    begin
      { Faz ‘‘Módulo 11’’ dos 12 primeiros dígitos }
      soma := 0;
      for Pos := 12 downto 5 do { mult.: 2,3,..9 }
        soma := soma + (ord(sNumeroDocumento[Pos]) - ordZero) * (14 - Pos);
      for Pos := 4 downto 1 do { mult.: 2,3,..5 }
        soma := soma + (ord(sNumeroDocumento[Pos]) - ordZero) * (6 - Pos);
      resto := 11 - soma mod 11;
      if resto > 9 then
        resto := 0;
      if resto <> ord(sNumeroDocumento[13]) - ordZero then
        Exit; { primeiro DV errado }
      { Faz ‘‘Módulo 11’’ dos 13 primeiros dígitos }
      soma := 0;
      for Pos := 13 downto 6 do { mult.: 2,3,..9 }
        soma := soma + (ord(sNumeroDocumento[Pos]) - ordZero) * (15 - Pos);
      for Pos := 5 downto 1 do { mult.: 2,3,..5 }
        soma := soma + (ord(sNumeroDocumento[Pos]) - ordZero) * (7 - Pos);
      resto := 11 - soma mod 11;
      if resto > 9 then
        resto := 0;
      if resto <> ord(sNumeroDocumento[14]) - ordZero then
        Exit; { segundo DV errado }
      Result := true;
    end;
  (* *)
end;

function FormataCpfCnpj(Texto: String): String;
Var
  sDocumento: String;
begin
  sDocumento := RemoveFormatacao(Texto);

  (* CPF *)
  if length(sDocumento) = 8 then
    begin
      Result := copy(sDocumento, 1, 3) + '.';
      Result := Result + copy(sDocumento, 4, 4) + '-';
      Result := Result + copy(sDocumento, 8, 1);
      Exit;
    end;

  if length(sDocumento) = 11 then
    begin
      Result := copy(sDocumento, 1, 3) + '.';
      Result := Result + copy(sDocumento, 4, 3) + '.';
      Result := Result + copy(sDocumento, 7, 3) + '-';
      Result := Result + copy(sDocumento, 10, 2);
      Exit;
    end;

  (* CGC *)
  if length(sDocumento) = 14 then
    begin
      Result := copy(sDocumento, 1, 2) + '.';
      Result := Result + copy(sDocumento, 3, 3) + '.';
      Result := Result + copy(sDocumento, 6, 3) + '/';
      Result := Result + copy(sDocumento, 9, 4) + '-';
      Result := Result + copy(sDocumento, 13, 2);
      Exit;
    end;

  (* Quanto não Satisfazer as Codições Acima Retorna o Mesmo Valor *)
  Result := Texto;
end;

function RoundNum(Valor:Extended;Decimais:Integer=2):Extended;
var
  Multiplicador:Integer;
  Potencia: Extended;
begin
  if Decimais > 15 then
  begin
    Decimais := 15;
  end
  else
    if Decimais < 0 then
    begin
      Decimais := 0;
    end;
  Potencia:=Decimais;
  Multiplicador:=Round(Power(10,Potencia));
  If Frac(Valor*Multiplicador)>=0.49999999998 Then Valor:=Valor+0.00000000002;
  Result := round(Valor*Multiplicador)/Multiplicador;
end;

function TruncaValor(pValor: Double; pCasasDecimais: Integer=2): Double;
var
  sValor: String;
begin
  Result := pValor;
  sValor := FloatToStr(pValor);

  if (Frac(pValor) <> 0) and (pos(',', sValor)<>0) then
     result:= StrToFloat(Copy(sValor,1,pos(',', sValor)+pCasasDecimais));
end;

function VerificaCamposRequeridos(const ADataSet : TDataSet; ATryFocus, AShowMessage, ARaiseException : boolean) : boolean;
var
  i : integer;
begin
  result := false;

  for i:= 0 to (ADataSet.FieldCount - 1) do
  begin
    if ADataSet.Fields[i].Required then
    begin
      if (ADataSet.Fields[i].IsNull) or (ADataSet.Fields[i].AsString='') then
      begin
//        if ADataSet.Fields[i].ConstraintErrorMessage <> '' then
//        begin
//          msg :=  ADataSet.Fields[i].ConstraintErrorMessage;
//
//          if AShowMessage then
//           Application.MessageBox(PChar(msg), 'Campo Requerido', MB_ICONINFORMATION + MB_OK);
//
//          if ARaiseException then
//            raise Exception.Create(msg);
//        end
//        else
//        begin
//          msg:= 'Preencha o campo "'+ADataSet.Fields[i].DisplayLabel+'"';
//
//          if AShowMessage then
//           Application.MessageBox(PChar(msg), 'Campo Requerido', MB_ICONINFORMATION + MB_OK);
//
//          if ARaiseException then
//            raise Exception.Create(msg);
//        end;

        //--- tenta colocar o foco no controle
        //--- protege dentro de um bloco try except pois pode ser q controle nao possa receber foco
        if ATryFocus then
        begin
          try
            ADataSet.Fields[i].FocusControl;
          except
          end;
        end;

        exit;
      end;
    end;
  end;

  result := true;
end;

function ConvertToFloat(AValue : double; ADecimais : integer) : double;
var
  sAux : string;
  dValue : double;
  dDecimais : double;
begin
  result := AValue;

  if ADecimais <=0 then
    ADecimais := 0;

  dDecimais := Power(10, ADecimais);

  try
    sAux := RemoveFormatacao( FloatToStr(AValue));
    dValue := StrToIntDef(sAux, 0)/dDecimais;
    result := dValue;
  except
  end;
end;

function StrToFloatDef2(const S : string; const Default : Extended) : Extended;
var
  sValue : string;
begin
  sValue := StringReplace(S, '.', '', []);
  result := StrToFloatDef(sValue, Default);
end;

function BoolToInt(AValue : boolean) : integer;
begin
  result := 0;

  if AValue then
    result := 1;
end;

function LPAD(s: string; n: Integer): string;
begin
  Result := Format('%-' + IntToStr(n) + '.' + IntToStr(n) + 's', [s]);
end;

function RPAD(s: string; n: Integer): string;
begin
  Result := Format('%' + IntToStr(n) + '.' + IntToStr(n) + 's', [s]);
end;

function RemoveAcentos(Texto: String): String;
const
  ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
var
  X: Integer;
begin
  for X := 1 to length(Texto) do
    if Pos(Texto[X], ComAcento) <> 0 Then
      Texto[X] := SemAcento[Pos(Texto[X], ComAcento)];
  Result := Texto;
end;

function RemoveTodosCaracteresEspeciais(Texto: string):string;
const
  Char = '~`!@#$%^&*()_-+=|\<>,.?/æ';
var
  x: Integer;
begin
  for x := 1 to Length(texto) do
  begin
    if Pos(texto[x], Char) <> 0 then
       texto[x] := ' ';
  end;
  result := StringReplace(texto, ' ', EmptyStr, [rfReplaceAll]);
end;

function FormataTelefoneDDD(Texto: String): String;
  function SomenteNumero(snum : String) : String;
  VAR s1, s2: STRING;
    i: Integer;
  BEGIN
    s1 := snum;
    s2 := '';
    FOR i := 1 TO Length(s1) DO
      IF CharInSet(s1[i], ['0'..'9'] ) THEN
        s2 := s2 + s1[i];
    result := s2;
  End;

var
  sTel : String;
  bZero : Boolean;
  iDigitos : Integer;
begin
  bZero := false;
  //Obs: mascara prevê tratamento apenas para números brasileiros
  //Obs2: Esta função não leva em conta o código do país (Ex: 55, ou +55)
  sTel := SomenteNumero(Texto); //Remove qualquer formatação que o usuário possa ter colocado.

  if sTel='' then
    Result := ''
  else
  begin
    if sTel[1]='0' then //Verifica se foi adicionado o 0 no início do número
    begin
      bZero:= True;
      sTel := Trim( copy(sTel,2,Length(sTel)) ); //Remove para fazer a formatação depois adiciona
    end
    else
      bZero := False;

    iDigitos := Length(sTel);

    //Formata de acordo com a quantidade de números encontrados.
    case iDigitos of
      8   : Result := FormatMaskText('9999-9999;0;_',sTel); //8 digitos SEM DDD (ex: 34552318)
      9   : Result := FormatMaskText('9 9999-9999;0;_',sTel); //9 digitos SEM DDD (ex: 991916889)
      10  : Result := FormatMaskText('(99) 9999-9999;0;_',sTel); //8 Digitos (convencional, ex: 7734552318)
      11  : Result := FormatMaskText('(99) 9 9999-9999;0;_',sTel); //9 Digitos (novos números, ex: 77991916889)
      12  : Result := FormatMaskText('99(99)9999-9999;0;_',sTel); //Se foram 12 digitos possívelmente digitou a operadora também
      13  : Result := FormatMaskText('99(99)9 9999-9999;0;_',sTel); //Se foram 13 digitos possívelmente digitou a operadora também
    else
      Result := Texto; //Mantém na forma que o usuário digitou
    end;
  end;

  if bZero then //Para ficar com a preferência do usuário, se ele digitou o "0" eu mantenho.
    Result := '0'+Result;
end;

function FormataCep(pCep: String): String;
Var
  sCep: String;
begin
  Result := '';
  sCep := RemoveFormatacao(pCep);

  sCep := copy(sCep, 1, 2) + '.' + copy(sCep, 3, 3) + '-' + copy(sCep, 6, 3);
  Result := sCep;
end;

{$IFDEF MSWINDOWS}
function GetAppVersionStr(const AFileName: string): string;
var
  Rec: LongRec;
begin
  Rec := LongRec(GetFileVersion(AFileName));
  Result := Format('%d.%d', [Rec.Hi, Rec.Lo])
end;
{$ENDIF}

function GetAppName() : string;
begin
  result := ExtractFileName( ParamStr(0) );
end;


{$IFDEF MSWINDOWS}
function FileVerInfo(Const FileName: String; Var FileInfo: String): Boolean;
const
  Key: string = ('FileVersion');
var
  Dummy: Cardinal;
  BufferSize, Len: Integer;
  Buffer: PChar;
  LoCharSet, HiCharSet: Word;
  Translate, Return: Pointer;
  StrFileInfo: String;
Begin
  Result := False;
  { obtendo o tamanho em bytes do 'Version information' }
  BufferSize := GetFileVersionInfoSize( PCHAR(FileName), Dummy);
  if BufferSize <> 0 then
    begin
      getmem(Buffer, Succ(BufferSize));
      try
        if GetFileVersionInfo(PChar(FileName), 0, BufferSize, Buffer) then
          { Executando a função 'VerQueryValue' e conseguimos informações sobre o idioma/character-set }
          begin
            If VerQueryValue(Buffer, '\VarFileInfo\Translation', Translate, UINT(Len)) then
              begin
                LoCharSet := LoWord(Longint(Translate^));
                HiCharSet := HiWord(Longint(Translate^));
                { Montamos a string de pesquisa }
                StrFileInfo := format('\StringFileInfo\0%x0%x\%s', [LoCharSet, HiCharSet, Key]);
                if VerQueryValue(Buffer, PChar(StrFileInfo), Return, UINT(Len)) then
                  FileInfo := PChar(Return);
              end;
          end;
      finally
        Freemem(Buffer, Succ(BufferSize));
        Result := FileInfo <> '';
      end;
    end;
end;

procedure LimparLogs(applicationTitle, CONFIG_INI : string);
var
  sPath: string;
  APath: string;
  sVersion: string;
  APathFile: string;

  diasManter: Integer;
  listDir: TStringList;
  listFile: TStringList;

  I: Integer;
  F: Integer;
begin
  sPath := ExtractFilePath(ParamStr(0)) + 'config';
  diasManter := StrToIntDef(LeIni(TPath.Combine(sPath, CONFIG_INI), 'DIAS_LOG', 'DIAS_APAGAR_LOG', '7'), 0);
  listDir := TStringList.Create;
  listFile := TStringList.Create;
  try
    try
      APath := GetAppPath;
      APath := TPath.Combine(APath, 'log');
      APath := TPath.Combine(APath, applicationTitle);
      GetDirList(APath, listDir, false);
      if listDir.Count > 0 then
      begin
        //    for I := 0 to pred(listDir.Count) do
        //      listDir[i] := ExtractFileName(listDir[i]);
        listDir.Sort;
        if not FileVerInfo(ParamStr(0), sVersion) then
          sVersion := GetAppVersionStr(ParamStr(0));
        for I := pred(listDir.Count) downto 0 do
        begin
          if sVersion > ExtractFileName(listDir[i]) then
          begin
            if DirectoryExists(listDir[I]) then
            begin
              //WinExec(PAnsiChar('cmd.exe /C rd "'+listDir[I]+'" /s /q'), SW_NORMAL);
              DeletarPasta(listDir[I]);
              listDir.Delete(I);
            end;
          end
          else if sVersion = ExtractFileName(listDir[i]) then
          begin
            //          estrucao := 'forfiles /P "'+listDir[i]+'" /c "cmd /c del @path /q & rd @path /s /q /d -2"';
            //          //WinExec(PAnsiChar(estrucao), SW_NORMAL);
            //          //ShellExecute(handle,'runas',PChar(estrucao),'','',SW_HIDE);
            //          //RunAsAdmin(handle, 'c:\Windows\system32\cmd.exe', estrucao);
            //
            //          aux.Add(estrucao);
            //          aux.SaveToFile(APath+'.BAT');
            //          ShellExecute(handle,'open',PChar(APath+'.BAT'),'','',SW_HIDE);
            //          DeleteFile(PChar(APath+'.BAT'));
            //
            GetFileList(listDir[i], listFile);
            if listFile.Count > 0 then
            begin
              for F := Pred(listFile.Count) downto 0 do
              begin
                APathFile := TPath.Combine(listDir[i], listFile[F]);

                if FileExists(APathFile) then
                begin
                  if FileDateToDateTime(FileAge(APathFile)) < IncDay(now, -diasManter) then
                    DeleteFile(PChar(APathFile));
                end;

              end;
              GetFileList(listDir[i], listFile);
              if listFile.Count = 0 then
                RemoveDir(listDir[i]);
            end;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        //GravarLog('LimparLogs - Ocorreu o seguinte erro: '+e.Message);
      end;
    end;
  finally
    if Assigned(listDir) then
      FreeAndNil(listDir);
    if Assigned(listFile) then
      FreeAndNil(listFile);
  end;
end;

procedure GetDirList(Directory: String; var Result: TStringList;
  SubPastas: Boolean);
var
  Sr: TSearchRec;

  procedure Recursive(Dir: String); { Sub Procedure, Recursiva }
  var
    SrAux: TSearchRec;
  begin
    if SrAux.Name = EmptyStr then
      FindFirst(Directory + '\' + Dir + '\*.*', faDirectory, SrAux);
    while FindNext(SrAux) = 0 do
      if SrAux.Name <> '..' then
        if DirectoryExists(Directory + '\' + Dir + '\' + SrAux.Name) then
        begin
          Result.Add(Directory + '\' + Dir + '\' + SrAux.Name);
          Recursive(Dir + '\' + SrAux.Name);
        end;
  end;

begin
  FindFirst(Directory + '\*.*', faDirectory, Sr);
  while FindNext(Sr) = 0 do
    if Sr.Name <> '..' then
      if DirectoryExists(Directory + '\' + Sr.Name) then
      begin
        Result.Add(Directory + '\' + Sr.Name);

        if SubPastas then
          Recursive(Sr.Name);
      end;
end;

procedure GetFileList(Directory: String; var Result: TStringList);
var
  SR: TSearchRec;
begin

  if FindFirst(Directory + '\*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
        Result.Add(SR.Name);

    until FindNext(SR) <> 0;

//    FindClose(SR);
  end;
end;

function DeletarPasta(const APath: String): Boolean;
var
  FileOpStruct: TShFileOpStruct;
  ErrorCode: Integer;
begin
  Result := False;
  if DirectoryExists(APath) then
  begin
    FillChar(FileOpStruct, SizeOf(FileOpStruct), #0);
    FileOpStruct.Wnd := 0;
    FileOpStruct.wFunc := FO_DELETE;
    FileOpStruct.pFrom := PChar(APath + #0#0);
    FileOpStruct.pTo := nil;
    FileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
    FileOpStruct.lpszProgressTitle := nil;
    ErrorCode := ShFileOperation(FileOpStruct);
    Result := ErrorCode = 0;
  end;
end;



{$ENDIF}


function DialogYesNo(Mensagem: string): TModalResult;
var
  mr : TModalResult;
begin
  mr:= mrNone;

  TDialogService.MessageDialog(PCHAR(Mensagem),
                               TMsgDlgType.mtConfirmation,
                               mbYesNo,
                               TMsgDlgBtn.mbNo,
                               0,

                              procedure(const aResult: TModalResult)
                              begin
                                mr := aResult;
                              end);

  while mr = mrNone do // wait for modal result
    Application.ProcessMessages;

  Result := mr;
end;


{$IFDEF MSWINDOWS}
function GetAppVersion() : string;
var
  sVersion : string;
begin
  result := GetAppVersionStr(ParamStr(0));

  if FileVerInfo(ParamStr(0), sVersion) then
    result := sVersion;
end;
{$ENDIF}

function NewMinutesBetween(aNow, aThen :TDateTime) :Int64;
var
  MinDiff :Extended;
begin
  MinDiff := (aThen -aNow) *24 *60;
  if (MinDiff -Trunc(MinDiff)) > 0.9999 then
    MinDiff := Round(MinDiff);

  Result := Trunc(MinDiff);
end;

function GetStringOfArray(AArray: array of string; ACharSeparator: string = ', '; AQuoted: Boolean = true): string;
var
  sList: string;
  I: Integer;
begin
  sList := '';
  try
    if length(AArray) <= 0 then
      Exit;

    sList := VarToStr(IFF(AQuoted, QuotedStr(AArray[0]), AArray[0]));
    for I := 1 to length(AArray) - 1 do
      sList := sList + ACharSeparator + VarToStr(IFF(AQuoted, QuotedStr(AArray[I]), AArray[I]));
  finally
    Result := sList;
  end;
end;

function GetStringOfStringList(AArray: TStringList; ACharSeparator: string = ', '; AQuoted: Boolean = true): string;
var
  sList: string;
  I: Integer;
begin
  sList := '';
  try
    if AArray.Count <= 0 then
      Exit;

    sList := VarToStr(IFF(AQuoted, QuotedStr(AArray[0]), AArray[0]));
    for I := 1 to Pred(AArray.Count) do
      sList := sList + ACharSeparator + VarToStr(IFF(AQuoted, QuotedStr(AArray[I]), AArray[I]));
  finally
    Result := sList;
  end;
end;

function TratarData(data : TDateTime): String;
var
   dataTratada    : String;
   dias, mes, ano : String;
begin
  if data <> null then
  begin
    dias := IntToStr(DayOf(data));
    mes  := IntToStr(MonthOf(data));
    ano  := IntToStr(YearOf(data));

    if Length(dias) < 2 then
      dias := '0'+dias;

    if Length(mes) < 2 then
      mes := '0'+mes;

    dataTratada := dias  + '/' + mes + '/' + ano;
  end
  else
    dataTratada := EmptyStr;

  result := dataTratada;
end;

function ValidaEmail(const Email: string): Boolean;
const
  // InvalidChar = 'àâêôûãõáéíóúçüñýÀÂÊÔÛÃÕÁÉÍÓÚÇÜÑÝ*;:⁄\|#$%&*§!()][{}<>˜ˆ´ªº+¹²³';
  {$IFDEF MSWINDOWS}
  InvalidChar: array [1 .. 40] of string[1] = ('!', '#', '$', '%', '¨', '&', '*', '(', ')', '+', '=', '§', '¬', '¢', '¹', '²', '³', '£', '´', '`', 'ç', 'Ç', ',', ';', ':', '<', '>', '~', '^', '?', '/', '', '|', '[', ']', '{', '}', 'º', 'ª', '°');
  {$ELSE}
  InvalidChar: array [1 .. 40] of string = ('!', '#', '$', '%', '¨', '&', '*', '(', ')', '+', '=', '§', '¬', '¢', '¹', '²', '³', '£', '´', '`', 'ç', 'Ç', ',', ';', ':', '<', '>', '~', '^', '?', '/', '', '|', '[', ']', '{', '}', 'º', 'ª', '°');
  {$ENDIF}
begin
  // Não existe email com menos de 8 caracteres.
  if length(Email) < 8 then
    begin
      Result := False;
      Exit;
    end;

  // Verificando se há somente um @
  if ((Pos('@', Email) = 0) or (PosEx('@', Email, Pos('@', Email) + 1) > 0)) then
    begin
      Result := False;
      Exit;
    end;

  // Verificando se no minimo há um ponto
  if (Pos('.', Email) = 0) then
    begin
      Result := False;
      Exit;
    end;
  // Não pode começar ou terminar com @ ou ponto
  if (Email[1] in ['@', '.']) or (Email[length(Email)] in ['@', '.']) then
    begin
      Result := False;
      Exit;
    end;
  // O @ e o ponto não podem estar juntos
  if (Email[Pos('@', Email) + 1] = '.') or (Email[Pos('@', Email) - 1] = '.') then
    begin
      Result := False;
      Exit;
    end;

  // // Testa se tem algum caracter inválido.
  // for I := 0 to Pred(Length(Email)) do
  // begin
  // for C := 0 to Pred(Length(InvalidChar)) do
  // if (Email[I] = InvalidChar[C]) then
  // begin
  // Result := False;
  // Exit;
  // end;
  // end;
  // Se não encontrou problemas, retorna verdadeiro
  Result := true;

end;

function OnlyNumber(const AValue: String): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result   := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue  do
  begin
     if CharIsNum( AValue[I] ) then
        Result := Result + AValue[I];
  end;
end ;

function CharIsNum(const C: Char): Boolean;
begin
  Result := CharInSet( C, ['0'..'9'] ) ;
end ;




{$IFDEF MSWINDOWS}
function WinMinimize(const AWinTitle: string): boolean;
var
  _WindowHandle: HWND;
  iTentativa : integer;
begin
  Result := true;
  iTentativa := 0;

  repeat
    _WindowHandle := FindWindow(nil, PWideChar(AWinTitle));
    if _WindowHandle <> 0 then
    begin
      //result:= ShowWindow(FindWindow(nil, AWinTitle,SW_MINIMIZE);
      result:= ShowWindow(_WindowHandle,SW_MINIMIZE);
    end;
    Inc(iTentativa);
  until result or (iTentativa >= 2);
end;




function WinActivate(const AWinTitle: string; Restore : boolean): boolean;
var
  _WindowHandle: HWND;
  iTentativa : integer;
begin
  Result := false;
  iTentativa := 0;

  repeat
    _WindowHandle := FindWindow(nil, PWideChar(AWinTitle));
    if _WindowHandle <> 0 then
    begin
      if IsIconic(_WindowHandle) then
      begin
        //if Restore then
          Result := ShowWindow(_WindowHandle, SW_RESTORE);
        //else
        //  Result := SetForegroundWindow(_WindowHandle);
      end
      else
        Result := SetForegroundWindow(_WindowHandle);
    end;
    Inc(iTentativa);

  until result or (iTentativa >= 5);

end;

{$ENDIF}

function GeraSuperSenha(AValue: String): String;
Var
  aPalavra: array [1 .. 1] of string;
  dSenha, dHora: Double;
  dAno, dMes, dDia: Word;
  I: Integer;
  bGerar: Boolean;
begin
  Result := AValue;
  bGerar := False;
  aPalavra[1] := 'Masterkey';
  if AValue <> '' then
  begin
    for I := 1 to length(aPalavra) do
    begin
      if AValue = aPalavra[I] then
        begin
          bGerar := true;
          Break;
        end;
    end;

    if not bGerar then
      Exit;
  end;

  DecodeDate(Date, dAno, dMes, dDia);
  dHora := StrToFloat(copy(FormatDateTime('hh:mm:ss', Time), 1, 2));

  dSenha := dAno + dMes + dDia + dHora;
  if dHora <> 0 then
    dSenha := dSenha * dHora;

  dSenha := dSenha - dAno;

  Result := FloatToStr(dSenha);
end;

function SuperSenha(AValue: String): Boolean;
  Var
  dSenha, dHora: Double;
  dAno, dMes, dDia: Word;
begin
  if (TemLetras(AValue)) or (length(Trim(AValue)) = 0) then
  begin
    Result := False;
    Exit;
  end;

  if (BuscaDireita(',', AValue)) <> 0 then
  begin
    Result := False;
    Exit;
  end;

  DecodeDate(Date, dAno, dMes, dDia);
  dHora := StrToFloat(copy(FormatDateTime('hh:mm:ss', Time), 1, 2));

  dSenha := StrToFloat(AValue);
  dSenha := dSenha + dAno;

  if dHora <> 0 then
    dSenha := dSenha / dHora;

  dSenha := (dSenha - (dAno + dMes + dDia));
  Result := (dSenha = dHora)
end;

function PasswordGenerate(MaxDigit: Byte; OnlyNumber: Boolean; UpperELowerCase: Boolean): String;
const
  Letras: array[0..25] of string = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
var
  PartNumber, I, MaiMin: Byte;
  PartChar: string;
  Inc1: Boolean;

begin
  Result:= '';
  Randomize;
  Inc1:= False;
  for I := 1 to MaxDigit  do
  begin
    if not Inc1 then
    begin
      PartNumber:= Random(9);
      Result:= Result+ IntToStr(PartNumber);


      if not OnlyNumber then
      begin
        PartChar:= Letras[Random(26)];


        if UpperELowerCase then
        begin
          MaiMin:= Random(2);
          case MaiMin of
            0: Result:= Result+ LowerCase( PartChar );
            1: Result:= Result+ UpperCase( PartChar );
          end;
        end
        else
          Result:= Result+ LowerCase( PartChar );
        Inc1:= True;
      end;
    end
    else
      Inc1:= False;
  end;
end;



function Replicate(pCaracter: Char; pString: string; pQuant: integer; pPos: String): String;
begin
  if pPos ='E' Then  Result := StringOfChar(pCaracter, (pQuant - length(pString)))+ pString;
  if pPos ='D' Then  Result := pString + StringOfChar(pCaracter, (pQuant - length(pString)));
end;

function ValidateIPRegex(const Value: String): Boolean;
var
  IpTxt: string;
begin
  IpTxt := '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$\b';
  result := TRegEx.IsMatch(Value, IpTxt);
end;

function StreamToString(aStream: TStream): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      SS.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end else
  begin
    Result := '';
  end;
end;

function EncodeBase64(const AValue : string): string;
var
  base64 : TBase64Encoding;
begin
  base64 := TBase64Encoding.Create();
  try
    result := base64.Encode( AValue );
  finally
    FreeAndNil(base64);
  end;
end;

function DecodeBase64(const AValue : string): string;
var
  base64 : TBase64Encoding;
begin
  base64 := TBase64Encoding.Create();
  try
    result := base64.Decode( AValue );
  finally
    FreeAndNil(base64);
  end;
end;

function TratarDiasUteis(data: TDate): TDate;
  // Tratar final de semana, sabado e domingo jogar para segunda feira
  function TratarFinalSemana(data: TDate): TDate;
  begin
    // Domingo - > + 1 para ir para segunda
    if (DayOfWeek(data) = 1) then
      Result := IncDay(data, 1)

    // Sabado - > + 2 para ir para segunda
    else if (DayOfWeek(data) = 7) then
      Result := IncDay(data, 2)

    // Segunda, terça, quarta, quinta, sexta - feira , resutlar a própria data
    else
      Result := data;
  end;

  // tratar a data da pascoa, pois descobrindo a pascoa chegaremos a sexta feira santa
  function SextaFeiraSanta(data: TDate): String;
  var
    dia,
    mes,
    ano: Word;
    x,
    y,
    resto1,
    resto2,
    resto3,
    resto4,
    resto5 : integer;
    diaMes,
    diaMesAno: String;
  begin
    // Para calcular o dia da Páscoa (Domingo), usa-se a fórmula abaixo,
    // onde o "ANO" deve ser introduzido com 4 dígitos.
    // O operador MOD é o resto da divisão. A fórmula vale para anos entre 1901 e 2099.
    // A fórmula pode ser estendida para outros anos, alterando X e Y conforme a tabela a seguir: olhar no site
    // http://pt.wikipedia.org/wiki/C%C3%A1lculo_da_P%C3%A1scoa
    ano := YearOf(data);

    case ano of
      2000..2099:
        begin
          x := 24;
          Y := 5;
        end;
    2100..2199:
      begin
        x := 24;
        y := 6;
      end;
    2200..2299:
      begin
        x := 25;
        y := 7;
      end;
    end;

    resto1 := ano mod 19;
    resto2 := ano mod 4;
    resto3 := ano mod 7;
    resto4 := ((19 * resto1) + x) mod 30;
    resto5 := ((2 * resto2) + (4 * resto3) + (6 * resto4) + y) mod 7;

    if (resto4 + resto5) < 10 then
    begin
      dia := (resto4 + resto5 + 22);
      mes := 3;
    end
    else
    begin
      dia := (resto4 + resto5 - 9);
      mes := 4;
    end;

    diaMes := FormatFloat('00', dia) + '/' + FormatFloat('00', mes);

    // 1. quando o domingo de Páscoa calculado for em 26 de Abril, corrige-se para uma semana antes, ou seja, 19 de Abril.
    // 2. quando o domingo de Páscoa calculado for em 25 de Abril e d=28 e a>10, então a Páscoa é em 18 de Abril.
    if (diaMes = '26/04') then
      diaMes := '19/04'

    else if (diaMes = '25/04') and (resto4 = 25) and (resto1 > 10) then
      diaMes := '18/04';

    // descobrimos a data da pascoa , agora temos que descontar 2 para chegar na sexta que seria a sexta-feria santa
    diaMesAno := FormatDateTime('dd/mm/yyyy', IncDay(StrToDate(diaMes + '/' + formatFloat('0000', ano)), -2));

    Result := diaMesAno;
  end;

  // corpus christi
  function CorpusChristi(data: TDate): string;
  var
    sextaSanta: string;
  begin
    // Para calcular a Quinta-feira de Corpus Christi, soma-se 60 dias ao Domingo de Páscoa, 58 pois considera-se a sexta feira.
    sextaSanta := SextaFeiraSanta(data);

    Result := FormatDateTime('dd/mm/yyyy', IncDay(StrToDate(sextaSanta), 62));
  end;

  // Carnaval
  function Carnaval(data: TDate): string;
  var
    sextaSanta: string;
  begin
    // Para calcular a Terça-feira de Carnaval, basta subtrair 47 dias do Domingo de Páscoa, 45 pois considera a sexta.
    sextaSanta := SextaFeiraSanta(data);

    Result := FormatDateTime('dd/mm/yyyy', IncDay(StrToDate(sextaSanta), - 45));
  end;

var
  dataAux: string;
begin
  // Rotina que verifica se um determinado dia cai nos feriados relacionados abaixo:
  // Se acaso cair, acrescentar sempre um dia a mais, não considerar sabados e domingos;
  {01/01 - Confraternização Universal
  21/04 - Tiradentes
  01/05 - Dia do Trabalho
  07/09 - Independência do Brasil
  12/10 - Nossa Senhora Aparecida
  02/11 - Finados
  15/11 - Proclamação da República
  25/12 - Natal
  ??/?? - Pascoa (a calcular) // rever (Sesxta-Feira Santa)
  ??/?? - Corpus Christi (a calcular) Para calcular a Quinta-feira de Corpus Christi, soma-se 60 dias ao Domingo de Páscoa.
  ??/?? - Feriado carnaval (a calcular) Para calcular a Terça-feira de Carnaval, basta subtrair 47 dias do Domingo de Páscoa.}

  // Pegar somente o dd/mm
  dataAux := FormatDateTime('dd/mm', data);

  // Confraternização Universal
  if (dataAux = '01/01') then
    result := TratarFinalSemana(IncDay(data, 1))

  // Tiradentes
  else if (dataAux = '21/04') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Dia do Trabalho
  else if (dataAux = '01/05') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Independência do Brasil
  else if (dataAux = '07/09') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Nossa Senhora Aparecida
  else if (dataAux = '12/10') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Finados
  else if (dataAux = '02/11') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Proclamação da República
  else if (dataAux = '15/11') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Natal
  else if (dataAux = '25/12') then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Sexta - Feira Santa = acrescenta + 3 para cair na segunda - feira
  else if FormatDateTime('dd/mm/yyyy', data) = (SextaFeiraSanta(data)) then
    Result := IncDay(data, 3)

  // Corpus Christi
  // Para calcular a Quinta-feira de Corpus Christi, soma-se 60 dias ao Domingo de Páscoa, 62 pois considera-se a sexta feira.
  else if FormatDateTime('dd/mm/yyyy', data) = CorpusChristi(data) then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Terça- Feria de carnaval
  // Para calcular a Terça-feira de Carnaval, basta subtrair 47 dias do Domingo de Páscoa, 45 pois considera a sexta.
  else if FormatDateTime('dd/mm/yyyy', data) = Carnaval(data) then
    Result := TratarFinalSemana(IncDay(data, 1))

  // Nenhuma -> somente verificar o final de semana
  else
    Result := TratarFinalSemana(data)
end;

function IsValidUUID(const aValue : string) : boolean;
const _UUID_REGEX = '^[{]?[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}[}]?$';
begin
  result := TRegEx.IsMatch(aValue, _UUID_REGEX);
end;


end.
