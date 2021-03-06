{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [FIN_CHEQUE_EMITIDO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2010 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com                                                   
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 1.0                                                                    
*******************************************************************************}
unit FinChequeEmitidoVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect,
  SysUtils, ChequeVO;

type
  [TEntity]
  [TTable('FIN_CHEQUE_EMITIDO')]
  TFinChequeEmitidoVO = class(TJsonVO)
  private
    FID: Integer;
    FID_CHEQUE: Integer;
    FDATA_EMISSAO: TDateTime;
    FDATA_COMPENSACAO: TDateTime;
    FBOM_PARA: TDateTime;
    FVALOR: Extended;
    FNOMINAL_A: String;

    FChequeVO: TChequeVO;

  public
    destructor Destroy; override;

    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_CHEQUE','Id Cheque',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdCheque: Integer  read FID_CHEQUE write FID_CHEQUE;
    [TColumn('DATA_EMISSAO','Data Emissao',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataEmissao: TDateTime  read FDATA_EMISSAO write FDATA_EMISSAO;
    [TColumn('DATA_COMPENSACAO','Data Compensacao',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataCompensacao: TDateTime  read FDATA_COMPENSACAO write FDATA_COMPENSACAO;
    [TColumn('BOM_PARA','Data Prevista para Compensa��o',80,[ldGrid, ldLookup, ldCombobox], False)]
    property BomPara: TDateTime  read FBOM_PARA write FBOM_PARA;
    [TColumn('VALOR','Valor',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property Valor: Extended  read FVALOR write FVALOR;
    [TColumn('NOMINAL_A','Nominal A',450,[ldGrid, ldLookup, ldCombobox], False)]
    property NominalA: String  read FNOMINAL_A write FNOMINAL_A;

    [TAssociation(False, 'ID', 'ID_CHEQUE', 'CHEQUE')]
    property ChequeVO: TChequeVO read FChequeVO write FChequeVO;

  end;

implementation

destructor TFinChequeEmitidoVO.Destroy;
begin
  if Assigned(FChequeVO) then
    FChequeVO.Free;

  inherited;
end;


end.
