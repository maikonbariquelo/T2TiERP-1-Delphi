{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de Or�amento / Pedido de Venda

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

  @author Albert Eije
  @version 1.0
  ******************************************************************************* }
unit UOrcamentoPedidoVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, DB, DBClient, Generics.Collections,
  WideStrings, DBXMySql, FMTBcd, Provider, SqlExpr, StrUtils, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls;

type
  [TFormDescription(TConstantes.MODULO_VENDAS, 'Or�amento de Venda')]

  TFOrcamentoPedidoVenda = class(TFTelaCadastro)
    DSOrcamentoPedidoVendaDet: TDataSource;
    GroupBoxParcelas: TGroupBox;
    GridParcelas: TJvDBUltimGrid;
    ScrollBox1: TScrollBox;
    BevelEdits: TBevel;
    EditCodigo: TLabeledEdit;
    MemoObservacao: TLabeledMemo;
    EditValorSubtotal: TLabeledCalcEdit;
    EditValorFrete: TLabeledCalcEdit;
    EditValorComissao: TLabeledCalcEdit;
    EditTaxaComissao: TLabeledCalcEdit;
    Panel1: TPanel;
    EditVendedor: TLabeledEdit;
    EditCliente: TLabeledEdit;
    EditCondicoesPagamento: TLabeledEdit;
    EditTransportadora: TLabeledEdit;
    ComboBoxTipoOrcamento: TLabeledComboBox;
    ComboBoxTipoFrete: TLabeledComboBox;
    EditDataCadastro: TLabeledDateEdit;
    EditDataEntrega: TLabeledDateEdit;
    EditDataValidade: TLabeledDateEdit;
    EditValorDesconto: TLabeledCalcEdit;
    EditTaxaDesconto: TLabeledCalcEdit;
    EditValorTotal: TLabeledCalcEdit;
    EditIdVendedor: TLabeledCalcEdit;
    EditIdCliente: TLabeledCalcEdit;
    EditIdCondicoesPagamento: TLabeledCalcEdit;
    EditIdTransportadora: TLabeledCalcEdit;
    CDSOrcamentoPedidoVendaDet: TClientDataSet;
    CDSOrcamentoPedidoVendaDetID: TIntegerField;
    CDSOrcamentoPedidoVendaDetID_PRODUTO: TIntegerField;
    CDSOrcamentoPedidoVendaDetID_VENDA_ORCAMENTO_CABECALHO: TIntegerField;
    CDSOrcamentoPedidoVendaDetQUANTIDADE: TFMTBCDField;
    CDSOrcamentoPedidoVendaDetVALOR_UNITARIO: TFMTBCDField;
    CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL: TFMTBCDField;
    CDSOrcamentoPedidoVendaDetTAXA_DESCONTO: TFMTBCDField;
    CDSOrcamentoPedidoVendaDetVALOR_DESCONTO: TFMTBCDField;
    CDSOrcamentoPedidoVendaDetVALOR_TOTAL: TFMTBCDField;
    CDSOrcamentoPedidoVendaDetPRODUTONOME: TStringField;
    CDSOrcamentoPedidoVendaDetPERSISTE: TStringField;
    ActionManager1: TActionManager;
    ActionAtualizarTotais: TAction;
    ActionToolBar1: TActionToolBar;
    ActionAdicionarProduto: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditIdVendedorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdCondicoesPagamentoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdCondicoesPagamentoExit(Sender: TObject);
    procedure EditTaxaDescontoExit(Sender: TObject);
    procedure EditIdVendedorExit(Sender: TObject);
    procedure EditIdClienteExit(Sender: TObject);
    procedure EditIdTransportadoraExit(Sender: TObject);
    procedure EditIdTransportadoraKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdVendedorKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdClienteKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdCondicoesPagamentoKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdTransportadoraKeyPress(Sender: TObject; var Key: Char);
    procedure GridParcelasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CDSOrcamentoPedidoVendaDetAfterEdit(DataSet: TDataSet);
    procedure ActionAtualizarTotaisExecute(Sender: TObject);
    procedure CDSOrcamentoPedidoVendaDetBeforePost(DataSet: TDataSet);
    procedure ActionAdicionarProdutoExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;
    procedure ControlaBotoes; override;
    procedure ControlaPopupMenu; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FOrcamentoPedidoVenda: TFOrcamentoPedidoVenda;

implementation

uses VendaOrcamentoCabecalhoController, VendaOrcamentoCabecalhoVO,
  VendaOrcamentoDetalheVO, ULookup, VendedorController, VendaCondicoesPagamentoController,
  ClienteVO, ClienteController, TransportadoraVO, TransportadoraController, PessoaVO,
  VendedorVO, VendaCondicoesPagamentoVO, ColaboradorVO, ProdutoVO, ProdutoController,
  UDataModule;
{$R *.dfm}

{$REGION 'Infra'}
procedure TFOrcamentoPedidoVenda.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TVendaOrcamentoCabecalhoVO;
  ObjetoController := TVendaOrcamentoCabecalhoController.Create;

  inherited;
end;

procedure TFOrcamentoPedidoVenda.LimparCampos;
begin
  inherited;
  CDSOrcamentoPedidoVendaDet.EmptyDataSet;
end;

procedure TFOrcamentoPedidoVenda.EditTaxaDescontoExit(Sender: TObject);
begin
  EditValorDesconto.Value := EditValorSubtotal.Value * (EditTaxaDesconto.Value / 100);
  EditValorTotal.Value := EditValorSubtotal.Value - EditValorDesconto.Value;
end;

procedure TFOrcamentoPedidoVenda.ControlaBotoes;
begin
  inherited;

  BotaoImprimir.Visible := False;
end;

procedure TFOrcamentoPedidoVenda.ControlaPopupMenu;
begin
  inherited;

  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFOrcamentoPedidoVenda.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdVendedor.SetFocus;
  end;
end;

function TFOrcamentoPedidoVenda.DoEditar: Boolean;
var
  Mensagem: String;
begin
  if CDSGrid.FieldByName('SITUACAO').AsString <> 'D' then
  begin
    case AnsiIndexStr(CDSGrid.FieldByName('SITUACAO').AsString, ['P', 'X', 'F', 'E']) of
      0:
        Mensagem := ' - Situa��o: Em Produ��o';
      1:
        Mensagem := ' - Situa��o: Em Expedi��o';
      2:
        Mensagem := ' - Situa��o: Faturado';
      3:
        Mensagem := ' - Situa��o: Entregue';
    end;

    Application.MessageBox(PChar('Esse registro n�o pode ser alterado' + Mensagem), 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    Exit(False);
  end;

  Result := inherited DoEditar;

  if Result then
  begin
    EditIdVendedor.SetFocus;
  end;
end;

function TFOrcamentoPedidoVenda.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TVendaOrcamentoCabecalhoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TVendaOrcamentoCabecalhoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFOrcamentoPedidoVenda.DoSalvar: Boolean;
var
  OrcamentoPedidoVendaDet: TVendaOrcamentoDetalheVO;
begin
  DecimalSeparator := '.';
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TVendaOrcamentoCabecalhoVO.Create;

      ActionAtualizarTotais.Execute;

      TVendaOrcamentoCabecalhoVO(ObjetoVO).IdVendedor := EditIdVendedor.AsInteger;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).VendedorNome := EditVendedor.Text;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).IdTransportadora := EditIdTransportadora.AsInteger;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).TransportadoraNome := EditTransportadora.Text;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).IdCliente := EditIdCliente.AsInteger;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ClienteNome := EditCliente.Text;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).IdVendaCondicoesPagamento := EditIdCondicoesPagamento.AsInteger;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).VendaCondicoesPagamentoNome := EditCondicoesPagamento.Text;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).Tipo := IfThen(ComboBoxTipoOrcamento.ItemIndex = 0, 'O', 'P');
      TVendaOrcamentoCabecalhoVO(ObjetoVO).Codigo := EditCodigo.Text;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).DataCadastro := EditDataCadastro.Date;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).DataEntrega := EditDataEntrega.Date;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).Validade := EditDataValidade.Date;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).TipoFrete := IfThen(ComboBoxTipoFrete.ItemIndex = 0, 'C', 'F');
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorSubtotal := EditValorSubtotal.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorFrete := EditValorFrete.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).TaxaComissao := EditTaxaComissao.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorComissao := EditValorComissao.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).TaxaDesconto := EditTaxaDesconto.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorDesconto := EditValorDesconto.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorTotal := EditValorTotal.Value;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).Observacao := MemoObservacao.Text;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).Situacao := 'D';

      if StatusTela = stEditando then
        TVendaOrcamentoCabecalhoVO(ObjetoVO).Id := IdRegistroSelecionado;

      // Itens do or�amento
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ListaVendaOrcamentoDetalheVO := TObjectList<TVendaOrcamentoDetalheVO>.Create;
      CDSOrcamentoPedidoVendaDet.DisableControls;
      CDSOrcamentoPedidoVendaDet.First;
      while not CDSOrcamentoPedidoVendaDet.Eof do
      begin
        if (CDSOrcamentoPedidoVendaDetPERSISTE.AsString = 'S') or (CDSOrcamentoPedidoVendaDetID.AsInteger = 0) then
        begin
          OrcamentoPedidoVendaDet := TVendaOrcamentoDetalheVO.Create;
          OrcamentoPedidoVendaDet.Id := CDSOrcamentoPedidoVendaDetID.AsInteger;
          OrcamentoPedidoVendaDet.IdVendaOrcamentoCabecalho := TVendaOrcamentoCabecalhoVO(ObjetoVO).Id;
          OrcamentoPedidoVendaDet.IdProduto := CDSOrcamentoPedidoVendaDetID_PRODUTO.AsInteger;
          OrcamentoPedidoVendaDet.Quantidade := CDSOrcamentoPedidoVendaDetQUANTIDADE.AsExtended;
          OrcamentoPedidoVendaDet.ValorUnitario := CDSOrcamentoPedidoVendaDetVALOR_UNITARIO.AsExtended;
          OrcamentoPedidoVendaDet.ValorSubtotal := CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL.AsExtended;
          OrcamentoPedidoVendaDet.TaxaDesconto := CDSOrcamentoPedidoVendaDetTAXA_DESCONTO.AsExtended;
          OrcamentoPedidoVendaDet.ValorDesconto := CDSOrcamentoPedidoVendaDetVALOR_DESCONTO.AsExtended;
          OrcamentoPedidoVendaDet.ValorTotal := CDSOrcamentoPedidoVendaDetVALOR_TOTAL.AsExtended;
          TVendaOrcamentoCabecalhoVO(ObjetoVO).ListaVendaOrcamentoDetalheVO.Add(OrcamentoPedidoVendaDet);
        end;

        CDSOrcamentoPedidoVendaDet.Next;
      end;
      CDSOrcamentoPedidoVendaDet.EnableControls;

      // ObjetoVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      TVendaOrcamentoCabecalhoVO(ObjetoVO).VendedorVO := Nil;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).ClienteVO := Nil;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).VendaCondicoesPagamentoVO := Nil;
      TVendaOrcamentoCabecalhoVO(ObjetoVO).TransportadoraVO := Nil;

      // ObjetoOldVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      if Assigned(ObjetoOldVO) then
      begin
        TVendaOrcamentoCabecalhoVO(ObjetoOldVO).VendedorVO := Nil;
        TVendaOrcamentoCabecalhoVO(ObjetoOldVO).ClienteVO := Nil;
        TVendaOrcamentoCabecalhoVO(ObjetoOldVO).VendaCondicoesPagamentoVO := Nil;
        TVendaOrcamentoCabecalhoVO(ObjetoOldVO).TransportadoraVO := Nil;
      end;

      if StatusTela = stInserindo then
        Result := TVendaOrcamentoCabecalhoController(ObjetoController).Insere(TVendaOrcamentoCabecalhoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TVendaOrcamentoCabecalhoVO(ObjetoVO).ToJSONString <> TVendaOrcamentoCabecalhoVO(ObjetoOldVO).ToJSONString then
        begin
          TVendaOrcamentoCabecalhoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TVendaOrcamentoCabecalhoController(ObjetoController).Altera(TVendaOrcamentoCabecalhoVO(ObjetoVO), TVendaOrcamentoCabecalhoVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
  DecimalSeparator := ',';
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
// Vendedor
procedure TFOrcamentoPedidoVenda.EditIdVendedorExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdVendedor.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdVendedor.Text;
      EditIdVendedor.Clear;
      EditVendedor.Clear;
      if not PopulaCamposTransientes(Filtro, TVendedorVO, TVendedorController) then
        PopulaCamposTransientesLookup(TVendedorVO, TVendedorController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdVendedor.Text := CDSTransiente.FieldByName('ID').AsString;
        EditVendedor.Text := CDSTransiente.FieldByName('COLABORADORPESSOA.NOME').AsString;
        EditTaxaComissao.Value := CDSTransiente.FieldByName('COMISSAO').AsExtended;
      end
      else
      begin
        Exit;
        EditIdVendedor.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditVendedor.Clear;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdVendedorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdVendedor.Value := -1;
    EditIdCliente.SetFocus;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdVendedorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdCliente.SetFocus;
  end;
end;

// Cliente
procedure TFOrcamentoPedidoVenda.EditIdClienteExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdCliente.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdCliente.Text;
      EditIdCliente.Clear;
      EditCliente.Clear;
      if not PopulaCamposTransientes(Filtro, TClienteVO, TClienteController) then
        PopulaCamposTransientesLookup(TClienteVO, TClienteController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdCliente.Text := CDSTransiente.FieldByName('ID').AsString;
        EditCliente.Text := CDSTransiente.FieldByName('PESSOA.NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdCliente.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditCliente.Clear;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdCliente.Value := -1;
    EditIdCondicoesPagamento.SetFocus;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdCondicoesPagamento.SetFocus;
  end;
end;

// Condicoes Pagamentos
procedure TFOrcamentoPedidoVenda.EditIdCondicoesPagamentoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdCondicoesPagamento.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdCondicoesPagamento.Text;
      EditIdCondicoesPagamento.Clear;
      EditCondicoesPagamento.Clear;
      if not PopulaCamposTransientes(Filtro, TVendaCondicoesPagamentoVO, TVendaCondicoesPagamentoController) then
        PopulaCamposTransientesLookup(TVendaCondicoesPagamentoVO, TVendaCondicoesPagamentoController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdCondicoesPagamento.Text := CDSTransiente.FieldByName('ID').AsString;
        EditCondicoesPagamento.Text := CDSTransiente.FieldByName('NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdCondicoesPagamento.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditCondicoesPagamento.Clear;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdCondicoesPagamentoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdCondicoesPagamento.Value := -1;
    EditIdTransportadora.SetFocus;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdCondicoesPagamentoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdTransportadora.SetFocus;
  end;
end;

// Transportadora
procedure TFOrcamentoPedidoVenda.EditIdTransportadoraExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdTransportadora.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdTransportadora.Text;
      EditIdTransportadora.Clear;
      EditTransportadora.Clear;
      if not PopulaCamposTransientes(Filtro, TTransportadoraVO, TTransportadoraController) then
        PopulaCamposTransientesLookup(TTransportadoraVO, TTransportadoraController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdTransportadora.Text := CDSTransiente.FieldByName('ID').AsString;
        EditTransportadora.Text := CDSTransiente.FieldByName('PESSOA.NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdTransportadora.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditTransportadora.Clear;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdTransportadoraKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdTransportadora.Value := -1;
    ComboBoxTipoOrcamento.SetFocus;
  end;
end;

procedure TFOrcamentoPedidoVenda.EditIdTransportadoraKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    ComboBoxTipoOrcamento.SetFocus;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFOrcamentoPedidoVenda.GridParaEdits;
var
  OrcamentoPedidoVendaDetEnumerator: TEnumerator<TVendaOrcamentoDetalheVO>;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TVendaOrcamentoCabecalhoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TVendaOrcamentoCabecalhoVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdVendedor.AsInteger := TVendaOrcamentoCabecalhoVO(ObjetoVO).IdVendedor;
    EditVendedor.Text := TVendaOrcamentoCabecalhoVO(ObjetoVO).VendedorVO.ColaboradorVO.PessoaVO.Nome;
    EditIdTransportadora.AsInteger := TVendaOrcamentoCabecalhoVO(ObjetoVO).IdTransportadora;
    EditTransportadora.Text := TVendaOrcamentoCabecalhoVO(ObjetoVO).TransportadoraVO.PessoaVO.Nome;
    EditIdCliente.AsInteger := TVendaOrcamentoCabecalhoVO(ObjetoVO).IdCliente;
    EditCliente.Text := TVendaOrcamentoCabecalhoVO(ObjetoVO).ClienteVO.PessoaVO.Nome;
    EditIdCondicoesPagamento.AsInteger := TVendaOrcamentoCabecalhoVO(ObjetoVO).IdVendaCondicoesPagamento;
    EditCondicoesPagamento.Text := TVendaOrcamentoCabecalhoVO(ObjetoVO).VendaCondicoesPagamentoVO.Nome;

    ComboBoxTipoOrcamento.ItemIndex := AnsiIndexStr(TVendaOrcamentoCabecalhoVO(ObjetoVO).Tipo, ['O', 'P']);

    EditCodigo.Text := TVendaOrcamentoCabecalhoVO(ObjetoVO).Codigo;
    EditDataCadastro.Date := TVendaOrcamentoCabecalhoVO(ObjetoVO).DataCadastro;
    EditDataEntrega.Date := TVendaOrcamentoCabecalhoVO(ObjetoVO).DataEntrega;
    EditDataValidade.Date := TVendaOrcamentoCabecalhoVO(ObjetoVO).Validade;

    ComboBoxTipoFrete.ItemIndex := AnsiIndexStr(TVendaOrcamentoCabecalhoVO(ObjetoVO).TipoFrete, ['C', 'F']);

    EditValorSubtotal.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorSubtotal;
    EditValorFrete.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorFrete;
    EditTaxaComissao.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).TaxaComissao;
    EditValorComissao.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorComissao;
    EditTaxaDesconto.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).TaxaDesconto;
    EditValorDesconto.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorDesconto;
    EditValorTotal.Value := TVendaOrcamentoCabecalhoVO(ObjetoVO).ValorTotal;
    MemoObservacao.Text := TVendaOrcamentoCabecalhoVO(ObjetoVO).Observacao;

    // Itens do or�amento
    OrcamentoPedidoVendaDetEnumerator := TVendaOrcamentoCabecalhoVO(ObjetoVO).ListaVendaOrcamentoDetalheVO.GetEnumerator;
    try
      with OrcamentoPedidoVendaDetEnumerator do
      begin
        while MoveNext do
        begin
          CDSOrcamentoPedidoVendaDet.Append;

          CDSOrcamentoPedidoVendaDetID.AsInteger := Current.Id;
          CDSOrcamentoPedidoVendaDetID_VENDA_ORCAMENTO_CABECALHO.AsInteger := Current.IdVendaOrcamentoCabecalho;
          CDSOrcamentoPedidoVendaDetID_PRODUTO.AsInteger := Current.IdProduto;
          CDSOrcamentoPedidoVendaDetQUANTIDADE.AsExtended := Current.Quantidade;
          CDSOrcamentoPedidoVendaDetVALOR_UNITARIO.AsExtended := Current.ValorUnitario;
          CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL.AsExtended := Current.ValorSubtotal;
          CDSOrcamentoPedidoVendaDetTAXA_DESCONTO.AsExtended := Current.TaxaDesconto;
          CDSOrcamentoPedidoVendaDetVALOR_DESCONTO.AsExtended := Current.ValorDesconto;
          CDSOrcamentoPedidoVendaDetVALOR_TOTAL.AsExtended := Current.ValorTotal;

          CDSOrcamentoPedidoVendaDet.Post;
        end;
      end;
    finally
      OrcamentoPedidoVendaDetEnumerator.Free;
    end;
    TVendaOrcamentoCabecalhoVO(ObjetoVO).ListaVendaOrcamentoDetalheVO := Nil;
    if Assigned(TVendaOrcamentoCabecalhoVO(ObjetoOldVO)) then
      TVendaOrcamentoCabecalhoVO(ObjetoOldVO).ListaVendaOrcamentoDetalheVO := Nil;
  end;
end;

procedure TFOrcamentoPedidoVenda.GridParcelasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
begin
  if Key = VK_F1 then
  begin
    ActionAdicionarProduto.Execute;
  end;
  If Key = VK_RETURN then
    EditIdVendedor.SetFocus;
end;

procedure TFOrcamentoPedidoVenda.CDSOrcamentoPedidoVendaDetAfterEdit(DataSet: TDataSet);
begin
  CDSOrcamentoPedidoVendaDetPERSISTE.AsString := 'S';
end;

procedure TFOrcamentoPedidoVenda.CDSOrcamentoPedidoVendaDetBeforePost(DataSet: TDataSet);
begin
  CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL.AsExtended := CDSOrcamentoPedidoVendaDetQUANTIDADE.AsExtended * CDSOrcamentoPedidoVendaDetVALOR_UNITARIO.AsExtended;
  CDSOrcamentoPedidoVendaDetVALOR_DESCONTO.AsExtended := CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL.AsExtended * (CDSOrcamentoPedidoVendaDetTAXA_DESCONTO.AsExtended / 100);
  CDSOrcamentoPedidoVendaDetVALOR_TOTAL.AsExtended := CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL.AsExtended - CDSOrcamentoPedidoVendaDetVALOR_DESCONTO.AsExtended;
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFOrcamentoPedidoVenda.ActionAdicionarProdutoExecute(Sender: TObject);
begin
  try
    PopulaCamposTransientesLookup(TProdutoVO, TProdutoController);
    if CDSTransiente.RecordCount > 0 then
    begin
      CDSOrcamentoPedidoVendaDet.Append;
      CDSOrcamentoPedidoVendaDetID_PRODUTO.AsInteger := CDSTransiente.FieldByName('ID').AsInteger;
      CDSOrcamentoPedidoVendaDetPRODUTONOME.AsString := CDSTransiente.FieldByName('NOME').AsString;
      CDSOrcamentoPedidoVendaDetVALOR_UNITARIO.AsExtended := CDSTransiente.FieldByName('VALOR_VENDA').AsExtended;
    end;
  finally
    CDSTransiente.Close;
  end;
end;

procedure TFOrcamentoPedidoVenda.ActionAtualizarTotaisExecute(Sender: TObject);
var
  SubTotal, TotalDesconto: Extended;
begin
  SubTotal := 0;
  TotalDesconto := 0;
  //
  CDSOrcamentoPedidoVendaDet.DisableControls;
  CDSOrcamentoPedidoVendaDet.First;
  while not CDSOrcamentoPedidoVendaDet.Eof do
  begin
    SubTotal := SubTotal + CDSOrcamentoPedidoVendaDetVALOR_SUBTOTAL.AsExtended;
    TotalDesconto := TotalDesconto + CDSOrcamentoPedidoVendaDetVALOR_DESCONTO.AsExtended;

    CDSOrcamentoPedidoVendaDet.Next;
  end;
  CDSOrcamentoPedidoVendaDet.First;
  CDSOrcamentoPedidoVendaDet.EnableControls;
  //
  EditValorSubtotal.Value := SubTotal;
  if TotalDesconto > 0 then
  begin
    EditValorDesconto.Value := TotalDesconto;
    EditTaxaDesconto.Value := TotalDesconto / SubTotal * 100;
  end;
  EditValorTotal.Value := SubTotal + EditValorFrete.Value - EditValorDesconto.Value;
  EditValorComissao.Value := SubTotal - EditValorDesconto.Value * EditTaxaComissao.Value / 100;
end;
{$ENDREGION}

end.
