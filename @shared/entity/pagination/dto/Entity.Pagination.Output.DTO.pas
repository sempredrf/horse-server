unit Entity.Pagination.Output.DTO;

interface

uses
  System.SysUtils;

type
  TPage = class
  private
    FPage : integer;
    FLimit : integer;
  public
    property page  : integer read FPage write FPage;
    property limit : integer read FLimit write FLimit;
  end;

  TPagination= class
  private
    FTotalCount : integer;
    FTotalPage : integer;
    FCurrentPage : integer;
    FIsLastPage : boolean;
    FFirstPage : TPage;
    FNextPage : TPage;
    FPreviousPage : TPage;
    FLastPage : TPage;
    FCurrentCountPerPage : integer;
    FRange : integer;
  public
    property totalCount             : integer     read FTotalCount              write FTotalCount;
    property totalPage              : integer     read FTotalPage               write FTotalPage;
    property currentPage            : integer     read FCurrentPage             write FCurrentPage;
    property isLastPage             : boolean     read FIsLastPage              write FIsLastPage;
    property firstPage              : TPage       read FFirstPage               write FFirstPage;
    property nextPage               : TPage       read FNextPage                write FNextPage;
    property previousPage           : TPage       read FPreviousPage            write FPreviousPage;
    property lastPage               : TPage       read FLastPage                write FLastPage;
    property currentCountPerPage    : integer     read FCurrentCountPerPage     write FCurrentCountPerPage;
    property range                  : integer     read FRange                   write FRange;
  end;

implementation

end.
