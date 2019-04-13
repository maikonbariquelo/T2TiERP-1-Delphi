{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Cadastro de Unidade de Produto

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
  fabio_thz@yahoo.com.br | t2ti.com@gmail.com</p>

  @author Albert Eije (alberteije@gmail.com)
  @version 1.0
  ******************************************************************************* }

unit UUnidadeProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, UnidadeProdutoController,
  UnidadeProdutoVO, Atributos, Constantes, StrUtils, LabeledCtrls;

type
  [TFormDescription(TConstantes.MODULO_CADASTROS, 'Unidade de Medida')]

  TFUnidadeProduto = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditSigla: TLabeledEdit;
    MemoDescricao: TMemo;
    Label1: TLabel;
    ComboboxPodeFracionar: TLabeledComboBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FUnidadeProduto: TFUnidadeProduto;

implementation

{$R *.dfm}

{$REGION 'Infra'}
procedure TFUnidadeProduto.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TUnidadeProdutoVO;
  ObjetoController := TUnidadeProdutoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFUnidadeProduto.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditSigla.SetFocus;
  end;
end;

function TFUnidadeProduto.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditSigla.SetFocus;
  end;
end;

function TFUnidadeProduto.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TUnidadeProdutoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TUnidadeProdutoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFUnidadeProduto.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TUnidadeProdutoVO.Create;

      TUnidadeProdutoVO(ObjetoVO).Sigla := EditSigla.Text;
      TUnidadeProdutoVO(ObjetoVO).Descricao := MemoDescricao.Text;
      TUnidadeProdutoVO(ObjetoVO).PodeFracionar := IfThen(ComboboxPodeFracionar.ItemIndex = 0, 'S', 'N');

      if StatusTela = stInserindo then
        Result := TUnidadeProdutoController(ObjetoController).Insere(TUnidadeProdutoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TUnidadeProdutoVO(ObjetoVO).ToJSONString <> TUnidadeProdutoVO(ObjetoOldVO).ToJSONString then
        begin
          TUnidadeProdutoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TUnidadeProdutoController(ObjetoController).Altera(TUnidadeProdutoVO(ObjetoVO), TUnidadeProdutoVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFUnidadeProduto.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TUnidadeProdutoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoVO.Clone;
  end;

  if Assigned(ObjetoVO) then
  begin
    EditSigla.Text := TUnidadeProdutoVO(ObjetoVO).Sigla;
    MemoDescricao.Text := TUnidadeProdutoVO(ObjetoVO).Descricao;
    ComboboxPodeFracionar.ItemIndex := AnsiIndexStr(TUnidadeProdutoVO(ObjetoVO).PodeFracionar, ['S', 'N']);
  end;
end;
{$ENDREGION}

end.