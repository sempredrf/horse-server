unit Entity.Pagination.Page;

interface

uses
  System.SysUtils,
  System.JSON,
  Entity.Pagination.Interfaces;

type
  TPage = class(TInterfacedObject, iPage)
  private
    FPage : integer;
    FLimit : integer;
  protected
     constructor Create(const aPage : integer;
                        const aLimit : integer);
  public
    destructor Destroy(); override;

    class function New(const aPage : integer;
                       const aLimit : integer) : iPage;

    procedure SetPage(const aValue : integer);
    function GetPage() : integer;

    procedure SetLimit(const aValue : integer);
    function GetLimit() : integer;

    function ToJson() : TJsonValue;

    property page  : integer read GetPage write SetPage;
    property limit : integer read GetLimit write SetLimit;


  end;

implementation

{ TPage }

constructor TPage.Create(const aPage : integer;
                         const aLimit : integer);
begin
  FPage := aPage;
  FLimit := aLimit;
end;

destructor TPage.Destroy;
begin

  inherited;
end;

function TPage.GetLimit: integer;
begin
  result := FLimit;
end;

function TPage.GetPage: integer;
begin
  result := FPage;
end;

class function TPage.New(const aPage : integer;
                         const aLimit : integer): iPage;
begin
  result := self.Create(aPage,
                        aLimit);
end;

procedure TPage.SetLimit(const aValue: integer);
begin
  FLimit := aValue;
end;

procedure TPage.SetPage(const aValue: integer);
begin
  FPage := aValue;
end;

function TPage.ToJson: TJsonValue;
var
  json : TJSONObject;
begin
  json := TJSONObject.Create();

  json.AddPair('page', TJSONNumber.Create(FPage));
  json.AddPair('limit', TJSONNumber.Create(FLimit));

  result := json;
end;

end.
