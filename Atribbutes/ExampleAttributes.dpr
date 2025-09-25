program ExampleAttributes;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Rtti;

type

  // Definindo classes de atributos
  TTableAttribute = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(pName: string);

    property Name: string read FName write FName;
  end;

  TFieldAttribute = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(pName: string);

    property Name: string read FName write FName;
  end;

  // Definindo atributos na classe
  // É possível suprimir "Attibute" no momento do uso (TTable = TTableAttribute)
  [TTable('CUSTOMER')]
  TCustomer = class
  private
    [TField('NAME')]
    FName: string;
  public
    property Name: string read FName write FName;
  end;

{ TTableAttribute }

constructor TTableAttribute.Create(pName: string);
begin
  FName := pName;
end;

{ TFieldAttribute }

constructor TFieldAttribute.Create(pName: string);
begin
  FName := pName;
end;

begin
  try
    var lContext := TRttiContext.Create;
    var lType := lContext.GetType(TCustomer);

    // Buscando Atributo diretamente pelo tipo da classe do atributo
    var lTableAttribute := lType.GetAttribute<TTableAttribute>;
    if Assigned(lTableAttribute) then
    begin
      WriteLn('Table Name: ' + lTableAttribute.Name);
    end;

    for var lField in lType.GetFields do
    begin
      // Buscando lista de atributos e testando o tipo para usar somente o esperado
      for var lAttribute in lField.GetAttributes do
      begin
        if lAttribute is TFieldAttribute then
          WriteLn('Field Name: ' + TFieldAttribute(lAttribute).Name);
      end;
    end;

    var lText : string;
    Readln(lText);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
