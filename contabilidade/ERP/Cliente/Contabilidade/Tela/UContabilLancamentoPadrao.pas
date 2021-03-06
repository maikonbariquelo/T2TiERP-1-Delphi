{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de Lan�amento Padr�o do M�dulo Contabilidade

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
  t2ti.com@gmail.com</p>

  @author Albert Eije (alberteije@gmail.com)
  @version 1.0
  ******************************************************************************* }
unit UContabilLancamentoPadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, ContabilLancamentoPadraoVO,
  ContabilLancamentoPadraoController, Tipos, Atributos, Constantes, LabeledCtrls, Mask, JvExMask,
  JvToolEdit, JvMaskEdit, JvExStdCtrls, JvEdit, JvValidateEdit, JvBaseEdits;

type
  [TFormDescription(TConstantes.MODULO_CONTABILIDADE, 'Lan�amento Padr�o')]

  TFContabilLancamentoPadrao = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditDescricao: TLabeledEdit;
    MemoHistorico: TLabeledMemo;
    EditContaDebito: TLabeledEdit;
    EditIdContaDebito: TLabeledCalcEdit;
    EditContaCredito: TLabeledEdit;
    EditIdContaCredito: TLabeledCalcEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditIdContaDebitoExit(Sender: TObject);
    procedure EditIdContaDebitoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdContaDebitoKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdContaCreditoExit(Sender: TObject);
    procedure EditIdContaCreditoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdContaCreditoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure ControlaBotoes; override;
    procedure ControlaPopupMenu; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FContabilLancamentoPadrao: TFContabilLancamentoPadrao;

implementation

uses ULookup, Biblioteca, UDataModule, ContabilContaVO, ContabilContaController;
{$R *.dfm}

{$REGION 'Controles Infra'}
procedure TFContabilLancamentoPadrao.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TContabilLancamentoPadraoVO;
  ObjetoController := TContabilLancamentoPadraoController.Create;
  inherited;
end;

procedure TFContabilLancamentoPadrao.ControlaBotoes;
begin
  inherited;

  BotaoImprimir.Visible := False;
end;

procedure TFContabilLancamentoPadrao.ControlaPopupMenu;
begin
  inherited;

  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFContabilLancamentoPadrao.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditDescricao.SetFocus;
  end;
end;

function TFContabilLancamentoPadrao.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditDescricao.SetFocus;
  end;
end;

function TFContabilLancamentoPadrao.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TContabilLancamentoPadraoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TContabilLancamentoPadraoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFContabilLancamentoPadrao.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TContabilLancamentoPadraoVO.Create;

      TContabilLancamentoPadraoVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TContabilLancamentoPadraoVO(ObjetoVO).Descricao := EditDescricao.Text;
      TContabilLancamentoPadraoVO(ObjetoVO).Historico := MemoHistorico.Text;
      TContabilLancamentoPadraoVO(ObjetoVO).IdContaDebito := EditIdContaDebito.AsInteger;
      TContabilLancamentoPadraoVO(ObjetoVO).IdContaCredito := EditIdContaCredito.AsInteger;

      if StatusTela = stInserindo then
        Result := TContabilLancamentoPadraoController(ObjetoController).Insere(TContabilLancamentoPadraoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TContabilLancamentoPadraoVO(ObjetoVO).ToJSONString <> TContabilLancamentoPadraoVO(ObjetoOldVO).ToJSONString then
        begin
          TContabilLancamentoPadraoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TContabilLancamentoPadraoController(ObjetoController).Altera(TContabilLancamentoPadraoVO(ObjetoVO), TContabilLancamentoPadraoVO(ObjetoOldVO));
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

{$REGION 'Campos Transientes'}
procedure TFContabilLancamentoPadrao.EditIdContaCreditoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdContaCredito.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdContaCredito.Text;
      EditIdContaCredito.Clear;
      EditContaCredito.Clear;
      if not PopulaCamposTransientes(Filtro, TContabilContaVO, TContabilContaController) then
        PopulaCamposTransientesLookup(TContabilContaVO, TContabilContaController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdContaCredito.Text := CDSTransiente.FieldByName('ID').AsString;
        EditContaCredito.Text := CDSTransiente.FieldByName('DESCRICAO').AsString;
      end
      else
      begin
        Exit;
        EditIdContaCredito.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditContaCredito.Clear;
  end;
end;

procedure TFContabilLancamentoPadrao.EditIdContaCreditoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdContaCredito.Value := -1;
    EditDescricao.SetFocus;
  end;
end;

procedure TFContabilLancamentoPadrao.EditIdContaCreditoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditDescricao.SetFocus;
  end;
end;

procedure TFContabilLancamentoPadrao.EditIdContaDebitoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdContaDebito.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdContaDebito.Text;
      EditIdContaDebito.Clear;
      EditContaDebito.Clear;
      if not PopulaCamposTransientes(Filtro, TContabilContaVO, TContabilContaController) then
        PopulaCamposTransientesLookup(TContabilContaVO, TContabilContaController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdContaDebito.Text := CDSTransiente.FieldByName('ID').AsString;
        EditContaDebito.Text := CDSTransiente.FieldByName('DESCRICAO').AsString;
      end
      else
      begin
        Exit;
        EditIdContaDebito.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditContaDebito.Clear;
  end;
end;

procedure TFContabilLancamentoPadrao.EditIdContaDebitoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdContaDebito.Value := -1;
    EditIdContaCredito.SetFocus;
  end;
end;

procedure TFContabilLancamentoPadrao.EditIdContaDebitoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdContaCredito.SetFocus;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFContabilLancamentoPadrao.GridParaEdits;
var
  ContabilContaVO: TContabilContaVO;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TContabilLancamentoPadraoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TContabilLancamentoPadraoVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditDescricao.Text := TContabilLancamentoPadraoVO(ObjetoVO).Descricao;
    MemoHistorico.Text := TContabilLancamentoPadraoVO(ObjetoVO).Historico;

    EditIdContaDebito.AsInteger := TContabilLancamentoPadraoVO(ObjetoVO).IdContaDebito;
    if EditIdContaDebito.AsInteger > 0 then
    begin
      ContabilContaVO := TContabilContaController.VO<TContabilContaVO>('ID', EditIdContaDebito.Text);
      if Assigned(ContabilContaVO) then
        EditContaDebito.Text := ContabilContaVO.Descricao;
    end;

    EditIdContaCredito.AsInteger := TContabilLancamentoPadraoVO(ObjetoVO).IdContaCredito;
    if EditIdContaCredito.AsInteger > 0 then
    begin
      ContabilContaVO := TContabilContaController.VO<TContabilContaVO>('ID', EditIdContaCredito.Text);
      if Assigned(ContabilContaVO) then
        EditContaCredito.Text := ContabilContaVO.Descricao;
    end;
  end;
end;
{$ENDREGION}

end.
