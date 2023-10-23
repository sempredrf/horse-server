unit Util.Constants.Api;

interface

uses
  System.SysUtils,
  Util.Constants;

const
  _API_TITLE                = 'Api - Title';
  _API_DESCRIPTION          = 'API description';

  _API_BASE_URL             = 'http://localhost/manager-dfe/api/v1';
  _API_ROOT                 = '/api/v1';
  _API_PORT                 = 9000;

  _CLOUD_URL                =  'http://localhost:9000';

  _KEYCLOACK_BASE_URL       = 'http://localhost:8080';
  _KEYCLOACK_AUTH_URL       = 'http://localhost:8080/auth';
  _KEYCLOACK_AUTH_TOKEN     = '/realms/%S/protocol/openid-connect/token';
  _KEYCLOACK_CLIENT_ID      = 'keycloack_client_id';

  _SWAGGER_BASE_URL         = '/manager-dfe/api/v1';
  _SWAGGER_CONTACT_NAME     = _COMPANY_NAME;
  _SWAGGER_CONTACT_EMAIL    = _COMPANY_EMAIL;
  _SWAGGER_CONTACT_URL      = _COMPANY_URL;


implementation

end.

