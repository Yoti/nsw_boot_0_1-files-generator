program template;

{$APPTYPE CONSOLE}

uses
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  WinApi.Windows;

const
  TitleStr: String = 'hextool v0.1 by yoti';

var
  ConsoleTitleStr: String;
  ConsoleTitleArr: Array [0..MAX_PATH] of Char;

procedure PrintHelp;
begin
  WriteLn(ExtractFileName(ParamStr(0)) + ' <command> <options>');
  WriteLn('Command: new'+#13#10+'Options: size out_name');
  WriteLn('Command: insert'+#13#10+'Options: offset in_name out_name');
  ExitCode:=1;
end;

procedure New(const Size: Int64; OutName: String);
var
  outFS: TFileStream;
begin
  if (ExtractFilePath(OutName) = '')
  then OutName:=ExtractFilePath(ParamStr(0)) + OutName;

  if (FileExists(OutName) = True) then begin
    ExitCode:=11;
    Exit;
  end;

  outFS:=TFileStream.Create(OutName, fmCreate or fmOpenWrite or fmShareDenyWrite);
  outFS.Size:=Size;
  outFS.Free;
end;

procedure Insert(const Offset: Int64; InName, OutName: String);
var
  inFS: TFileStream;
  outFS: TFileStream;
begin
  if (ExtractFilePath(InName) = '')
  then InName:=ExtractFilePath(ParamStr(0)) + InName;
  if (FileExists(InName) = False) then begin
    ExitCode:=21;
    Exit;
  end;

  if (ExtractFilePath(OutName) = '')
  then OutName:=ExtractFilePath(ParamStr(0)) + OutName;
  if (FileExists(OutName) = False) then begin
    ExitCode:=22;
    Exit;
  end;

  outFS:=TFileStream.Create(OutName, fmOpenWrite or fmShareDenyWrite);
  inFS:=TFileStream.Create(InName, fmOpenRead or fmShareDenyWrite);

  outFS.Position:=Offset;
  outFS.CopyFrom(inFS, inFS.Size);

  inFS.Free;
  outFS.Free;
end;

begin
  ExitCode:=0;
  GetConsoleTitle(PChar(ConsoleTitleStr), MAX_PATH);
  if (Length(ConsoleTitleStr) = 0)
  then GetConsoleTitle(PChar(@ConsoleTitleArr), MAX_PATH);
  SetConsoleTitle(PChar(ChangeFileExt(ExtractFileName(ParamStr(0)), '')));
  if (TitleStr <> '') then WriteLn(TitleStr);

  if (ParamCount < 2)
  or ((ParamCount = 3) and (ParamStr(1) <> 'new'))
  or ((ParamCount = 4) and (ParamStr(1) <> 'insert'))
  then begin
    PrintHelp;
  end else begin
    case IndexStr(ParamStr(1), ['new', 'insert'] ) of
       0: New(StrToIntDef(ParamStr(2), 0), ParamStr(3));
       1: Insert(StrToIntDef(ParamStr(2), 0), ParamStr(3), ParamStr(4));
       else ExitCode:=2;
    end;
  end;

  if (ExitCode = 0)
  then WriteLn('The job was done with success')
  else WriteLn('The job was done with failure (' + IntToStr(ExitCode) + ')');
//Write('Press ENTER to finish...'); ReadLn;
  if (Length(ConsoleTitleStr) = 0)
  then SetConsoleTitle(ConsoleTitleArr)
  else SetConsoleTitle(PChar(ConsoleTitleStr));
end.


