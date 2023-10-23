unit Entity.Pagination;

interface

uses
  System.SysUtils,
  System.JSON,
  Serializable.Interfaces,
  Entity.Pagination.Interfaces,
  Entity.Pagination.Page;

type
  TPage = Entity.Pagination.Page.TPage;

  TPagination<T : iSerializable> = class(TInterfacedObject, iPagination<T>)
  private
    FTotalCount : integer;
    FTotalPage : integer;
    FCurrentPage : integer;
    FIsLastPage : boolean;
    FFirstPage : iPage;
    FNextPage : iPage;
    FPreviousPage : iPage;
    FLastPage : iPage;
    FCurrentCountPerPage : integer;
    FRange : integer;
    FData : TArray<T>;
  protected
     constructor Create(const aTotalCount : integer;
                        const aTotalPage : integer;
                        const aCurrentPage : integer;
                        const aIsLastPage : boolean;
                        const aFirstPage : iPage;
                        const aNextPage : iPage;
                        const aPreviousPage : iPage;
                        const aLastPage : iPage;
                        const aCurrentCountPerPage : integer;
                        const aRange : integer;
                        const aData : TArray<T>);
  public
    destructor Destroy(); override;

    class function New(const aTotalCount : integer;
                        const aTotalPage : integer;
                        const aCurrentPage : integer;
                        const aIsLastPage : boolean;
                        const aFirstPage : iPage;
                        const aNextPage : iPage;
                        const aPreviousPage : iPage;
                        const aLastPage : iPage;
                        const aCurrentCountPerPage : integer;
                        const aRange : integer;
                        const aData : TArray<T>) : iPagination<T>;

    procedure SetTotalCount(const aValue : integer);
    function GetTotalCount() : integer;

    procedure SetTotalPage(const aValue : integer);
    function GetTotalPage() : integer;

    procedure SetCurrentPage(const aValue : integer);
    function GetCurrentPage() : integer;

    procedure SetIsLastPage(const aValue : boolean);
    function GetIsLastPage() : boolean;

    procedure SetFirstPage(const aValue : iPage);
    function GetFirstPage() : iPage;

    procedure SetNextPage(const aValue : iPage);
    function GetNextPage() : iPage;

    procedure SetPreviousPage(const aValue : iPage);
    function GetPreviousPage() : iPage;

    procedure SetLastPage(const aValue : iPage);
    function GetLastPage() : iPage;

    procedure SetCurrentCountPerPage(const aValue : integer);
    function GetCurrentCountPerPage() : integer;

    procedure SetRange(const aValue : integer);
    function GetRange() : integer;

    procedure SetData(const aValue : TArray<T>);
    function GetData() : TArray<T>;

    function ToJson() : TJsonValue;

    property TotalCount             : integer     read GetTotalCount          write SetTotalCount;
    property TotalPage              : integer     read GetTotalPage           write SetTotalPage;
    property CurrentPage            : integer     read GetCurrentPage         write SetCurrentPage;
    property IsLastPage             : boolean     read GetIsLastPage          write SetIsLastPage;
    property FirstPage              : iPage       read GetFirstPage           write SetFirstPage;
    property NextPage               : iPage       read GetNextPage            write SetNextPage;
    property PreviousPage           : iPage       read GetPreviousPage        write SetPreviousPage;
    property LastPage               : iPage       read GetLastPage            write SetLastPage;
    property CurrentCountPerPage    : integer     read GetCurrentCountPerPage write SetCurrentCountPerPage;
    property Range                  : integer     read GetRange               write SetRange;
    property Data                   : TArray<T>   read GetData                write SetData;
  end;

implementation

{ TPagination<T> }

constructor TPagination<T>.Create(const aTotalCount : integer;
                                  const aTotalPage : integer;
                                  const aCurrentPage : integer;
                                  const aIsLastPage : boolean;
                                  const aFirstPage : iPage;
                                  const aNextPage : iPage;
                                  const aPreviousPage : iPage;
                                  const aLastPage : iPage;
                                  const aCurrentCountPerPage : integer;
                                  const aRange : integer;
                                  const aData : TArray<T>);
begin
  FTotalCount            := aTotalCount;
  FTotalPage             := aTotalPage;
  FCurrentPage           := aCurrentPage;
  FIsLastPage            := aIsLastPage;
  FFirstPage             := aFirstPage;
  FNextPage              := aNextPage;
  FPreviousPage          := aPreviousPage;
  FLastPage              := aLastPage;
  FCurrentCountPerPage   := aCurrentCountPerPage;
  FRange                 := aRange;
  FData                  := aData;
end;

destructor TPagination<T>.Destroy;
begin

  inherited;
end;

function TPagination<T>.GetCurrentCountPerPage: integer;
begin
  result := FCurrentCountPerPage;
end;

function TPagination<T>.GetCurrentPage: integer;
begin
  result := FCurrentPage;
end;

function TPagination<T>.GetData: TArray<T>;
begin
  result := FData;
end;

function TPagination<T>.GetFirstPage: iPage;
begin
  result := FFirstPage;
end;

function TPagination<T>.GetIsLastPage: boolean;
begin
  result := FIsLastPage;
end;

function TPagination<T>.GetLastPage: iPage;
begin
  result := FLastPage;
end;

function TPagination<T>.GetNextPage: iPage;
begin
  result := FNextPage;
end;

function TPagination<T>.GetPreviousPage: iPage;
begin
  result := FPreviousPage;
end;

function TPagination<T>.GetRange: integer;
begin
  result := FRange;
end;

function TPagination<T>.GetTotalCount: integer;
begin
  result := FTotalCount;
end;

function TPagination<T>.GetTotalPage: integer;
begin
  result := FTotalPage;
end;

class function TPagination<T>.New(const aTotalCount : integer;
                                  const aTotalPage : integer;
                                  const aCurrentPage : integer;
                                  const aIsLastPage : boolean;
                                  const aFirstPage : iPage;
                                  const aNextPage : iPage;
                                  const aPreviousPage : iPage;
                                  const aLastPage : iPage;
                                  const aCurrentCountPerPage : integer;
                                  const aRange : integer;
                                  const aData : TArray<T>): iPagination<T>;
begin
  result := self.Create(aTotalCount,
                        aTotalPage,
                        aCurrentPage,
                        aIsLastPage,
                        aFirstPage,
                        aNextPage,
                        aPreviousPage,
                        aLastPage,
                        aCurrentCountPerPage,
                        aRange,
                        aData);
end;

procedure TPagination<T>.SetCurrentCountPerPage(const aValue: integer);
begin
  FCurrentCountPerPage := aValue;
end;

procedure TPagination<T>.SetCurrentPage(const aValue: integer);
begin
  FCurrentPage := aValue;
end;

procedure TPagination<T>.SetData(const aValue: TArray<T>);
begin
  FData := aValue;
end;

procedure TPagination<T>.SetFirstPage(const aValue: iPage);
begin
  FFirstPage := aValue;
end;

procedure TPagination<T>.SetIsLastPage(const aValue: boolean);
begin
  FIsLastPage := aValue;
end;

procedure TPagination<T>.SetLastPage(const aValue: iPage);
begin
  FLastPage := aValue;
end;

procedure TPagination<T>.SetNextPage(const aValue: iPage);
begin
  FNextPage := aValue;
end;

procedure TPagination<T>.SetPreviousPage(const aValue: iPage);
begin
  FPreviousPage := aValue;
end;

procedure TPagination<T>.SetRange(const aValue: integer);
begin
  FRange := aValue;
end;

procedure TPagination<T>.SetTotalCount(const aValue: integer);
begin
  FTotalCount := aValue;
end;

procedure TPagination<T>.SetTotalPage(const aValue: integer);
begin
  FTotalPage := aValue;
end;

function TPagination<T>.ToJson: TJsonValue;
var
  json : TJSONObject;
  jsonData : TJSONArray;
  i : integer;
begin
  json := TJSONObject.Create();
  jsonData := TJSONArray.Create();

  for i := Low(FData) to High(FData) do
    jsonData.AddElement( FData[i].ToJson );

  json.AddPair('totalCount', TJSONNumber.Create(FTotalCount) );
  json.AddPair('totalPage', TJSONNumber.Create(FTotalPage) );
  json.AddPair('currentPage', TJSONNumber.Create(FCurrentPage) );
  json.AddPair('lastPage', TJSONBool.Create(FIsLastPage) );

  if Assigned(FFirstPage) then
    json.AddPair('first', FFirstPage.ToJson );

  if Assigned(FNextPage) then
    json.AddPair('next', FNextPage.ToJson );

  if Assigned(FPreviousPage) then
    json.AddPair('previous', FPreviousPage.ToJson );

  if Assigned(FLastPage) then
    json.AddPair('last', FLastPage.ToJson );

  json.AddPair('currentCountPerPage', TJSONNumber.Create(FCurrentCountPerPage) );
  json.AddPair('range', TJsonNumber.Create(FRange) );
  json.AddPair('data', jsonData);

  result := json;
end;

end.
