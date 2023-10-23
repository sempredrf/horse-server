unit Validator.Interfaces;

interface

type
  iValidator<T> = interface
    ['{673908A4-4C67-4629-B577-32E5DC91E72F}']
    function Validate(const aObject : T) : T;
  end;

implementation

end.
