unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Buttons;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    XPManifest1: TXPManifest;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Registry;

var
 reg:TRegistry;

procedure Scan;
var
 s: string;
 i,j: integer;
 p: TStringList;
begin
 Form1.ListBox1.Clear;
 reg:=TRegistry.Create;
 p:=TStringList.Create;
 reg.RootKey:=HKEY_LOCAL_MACHINE;
 if reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall')
 then
  begin
   reg.GetKeyNames(p);
   reg.CloseKey;
  end;
 Form1.ListBox1.Items.Assign(p);
 p.Free;

 i:=0;
 j:=Form1.ListBox1.Items.Count-1;
 while i<=j do
  begin
   if reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    +Form1.ListBox1.Items.Strings[i])
   then
    begin
     s:=reg.ReadString('UninstallString');
     if s=''
     then
       begin
        Form1.ListBox1.Items.Delete(i);
        dec(j);
       end
      else inc(i);
     end;
    reg.CloseKey;
   end;
 reg.Free;
 Form1.ListBox1.Selected[0]:=true; 
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Scan;
 ListBox1Click(Sender);
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
 reg:=TRegistry.Create;
 reg.RootKey:=HKEY_LOCAL_MACHINE;

 if reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
   +ListBox1.Items.Strings[ListBox1.ItemIndex],false)
 then Edit1.Text:=reg.ReadString('UninstallString');
 reg.CloseKey;
 reg.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Form1.FormCreate(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 WinExec(PChar(Edit1.Text),SW_SHOW);
end;                              


procedure TForm1.Button3Click(Sender: TObject);
begin
 reg:=TRegistry.Create;
 reg.RootKey:=HKEY_LOCAL_MACHINE;

 if reg.DeleteKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
  +ListBox1.Items.Strings[ListBox1.ItemIndex])
 then Showmessage('Раздел удален!')
 else Showmessage('Ошибка!');
 reg.Free;

 Scan;
 ListBox1Click(Sender);
end;

end.
