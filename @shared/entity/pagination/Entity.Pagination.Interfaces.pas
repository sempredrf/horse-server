unit Entity.Pagination.Interfaces;

interface

uses
  Serializable.Interfaces;

type
  iPage = interface(iSerializable)
    ['{808DCD09-2C70-46A2-9CCB-DE084E27AF26}']
    procedure SetPage(const aValue : integer);
    function GetPage() : integer;

    procedure SetLimit(const aValue : integer);
    function GetLimit() : integer;
  end;

  iPagination<T : iSerializable> = interface(iSerializable)
    ['{88AED8A8-0D7E-49CA-938E-B74946540728}']
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
  end;

implementation

end.
