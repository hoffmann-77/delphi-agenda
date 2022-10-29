unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBCtrls;

type
  Tform_principal = class(TForm)
    pnl_topo: TPanel;
    pnl_cadastro: TPanel;
    label_descricao: TLabel;
    label_data: TLabel;
    label_hora: TLabel;
    label_celular: TLabel;
    pnl_divisao: TPanel;
    pnl_lista: TPanel;
    label_compromissos: TLabel;
    dbg_agendados: TDBGrid;
    fd_conexao: TFDConnection;
    qry_agendados: TFDQuery;
    dts_agendados: TDataSource;
    edt_descricao: TDBEdit;
    edt_data: TDBEdit;
    edt_hora: TDBEdit;
    edt_celular: TDBEdit;
    btn_inserir: TSpeedButton;
    btn_alterar: TSpeedButton;
    btn_gravar: TSpeedButton;
    btn_cancelar: TSpeedButton;
    btn_excluir: TSpeedButton;
    procedure btn_agendarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_inserirClick(Sender: TObject);
    procedure qry_agendadosAfterOpen(DataSet: TDataSet);
    procedure dbg_agendadosDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure InativaCampos;
    procedure AtivarCampos;
    procedure InativarBotoes;
  public
    { Public declarations }
  end;

var
  form_principal: Tform_principal;

implementation

{$R *.dfm}


procedure Tform_principal.AtivarCampos;
begin
  edt_data.Enabled      :=true;
  edt_hora.Enabled      :=true;
  edt_celular.Enabled   :=true;
  edt_descricao.Enabled :=true;
end;

procedure Tform_principal.btn_agendarClick(Sender: TObject);
begin
  qry_agendados.Post;
  fd_conexao.Commit;
end;

procedure Tform_principal.FormCreate(Sender: TObject);
begin
  InativaCampos;
  InativarBotoes;
end;

procedure Tform_principal.InativaCampos;
begin
  edt_data.Enabled      :=false;
  edt_hora.Enabled      :=false;
  edt_celular.Enabled   :=false;
  edt_descricao.Enabled :=false;

end;

procedure Tform_principal.InativarBotoes;
begin
  btn_inserir.Enabled  :=true;
  btn_alterar.Enabled  :=true;
  btn_gravar.Enabled   :=false;
  btn_cancelar.Enabled :=false;
  btn_excluir.Enabled  :=false;
end;

procedure Tform_principal.qry_agendadosAfterOpen(DataSet: TDataSet);
begin
    qry_agendados.FieldByName('data').EditMask :='!99/99/9999;1;_';
    qry_agendados.FieldByName('horario').EditMask :='!99:99;1;_';
    qry_agendados.FieldByName('celular').EditMask :='!(99) 99999 - 9999;1;_';
end;

procedure Tform_principal.btn_alterarClick(Sender: TObject);
begin
  btn_inserir.Enabled  :=false;
  btn_alterar.Enabled  :=false;
  btn_gravar.Enabled   :=true;
  btn_cancelar.Enabled :=true;
  btn_excluir.Enabled  :=true;

  AtivarCampos;
  qry_agendados.Edit;
end;

procedure Tform_principal.btn_gravarClick(Sender: TObject);
begin
  if (edt_data.Text <> '  /  /    ')   and
  (edt_hora.Text <> '  :  ')      and
  (edt_celular.Text <> '(  )       -     ')   and
  (edt_descricao.Text <> '') then begin
    InativaCampos;
    btn_inserir.Enabled  :=true;
    btn_alterar.Enabled  :=true;
    btn_gravar.Enabled   :=false;
    btn_cancelar.Enabled :=false;
    btn_excluir.Enabled  :=false;

    qry_agendados.Post;
    fd_conexao.Commit;

    showmessage('Salvo com Sucesso!');
    dbg_agendados.Refresh;

  end
  else showmessage('Campos obrigatorios Não digitados!');

end;

procedure Tform_principal.btn_inserirClick(Sender: TObject);
begin
  AtivarCampos;
  btn_inserir.Enabled  :=false;
  btn_alterar.Enabled  :=false;
  btn_gravar.Enabled   :=true;
  btn_cancelar.Enabled :=true;

  qry_agendados.Insert;
  edt_data.SetFocus;
end;

procedure Tform_principal.dbg_agendadosDblClick(Sender: TObject);
begin
   btn_inserir.Enabled  :=false;
  btn_alterar.Enabled  :=false;
  btn_gravar.Enabled   :=true;
  btn_cancelar.Enabled :=true;
  btn_excluir.Enabled  :=true;

  AtivarCampos;
  qry_agendados.Edit;
end;

procedure Tform_principal.btn_cancelarClick(Sender: TObject);
begin
  btn_inserir.Enabled  :=true;
  btn_gravar.Enabled   :=false;
  btn_cancelar.Enabled :=false;
  btn_excluir.Enabled  :=false;
  btn_alterar.Enabled  :=true;

  qry_agendados.Cancel;
  InativaCampos;
end;

procedure Tform_principal.btn_excluirClick(Sender: TObject);
begin
  InativaCampos;
  btn_inserir.Enabled  :=true;
  btn_alterar.Enabled  :=true;
  btn_gravar.Enabled   :=false;
  btn_cancelar.Enabled :=false;
  btn_excluir.Enabled  :=false;

  qry_agendados.Delete;

  showmessage('Deletado com sucesso!');
end;

end.
