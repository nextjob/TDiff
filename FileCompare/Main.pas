{
  Copyright (c) 2020 Nextjob Solutions, llc
  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,Boston, MA 02110 USA

  This Program Is Built With and or utilizes the following modules / code:
   TDiff, written by  Angus Johnson http://www.angusj.com
   Original download from: http://www.angusj.com/delphi/textdiff.html
   Based on "BasicDiffDemo2" provided with the TDiff  source
   Source Code Can Be Found At: https://github.com/nextjob/TDiff

}

unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Menus, Math, Generics.Collections, Diff_O;

type
  TFrmFileCompare = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open11: TMenuItem;
    Open21: TMenuItem;
    N1: TMenuItem;
    mnuCompare: TMenuItem;
    mnuCancel: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    mnuView: TMenuItem;
    PreviousChanges1: TMenuItem;
    NextChanges1: TMenuItem;
    Options1: TMenuItem;
    mnuIgnoreCase: TMenuItem;
    mnuIgnoreWhiteSpace: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    lblFile1: TLabel;
    lblFile2: TLabel;
    ResultGrid: TStringGrid;
    StatusBar1: TStatusBar;
    About1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Open11Click(Sender: TObject);
    procedure Open21Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuCompareClick(Sender: TObject);
    procedure mnuCancelClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ResultGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure mnuIgnoreCaseClick(Sender: TObject);
    procedure mnuIgnoreWhiteSpaceClick(Sender: TObject);
    procedure PreviousChanges1Click(Sender: TObject);
    procedure NextChanges1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StatusBar1OnDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure About1Click(Sender: TObject);
  private
    Diff: TDiff;
    source1, source2: TStringList;
    result1, result2: TStringList;

    procedure Clear(left, right: boolean);
    procedure BuildHashList(left, right: boolean);
    procedure OpenFile1(const filename: string);
    procedure OpenFile2(const filename: string);
  public
    { Public declarations }
  end;

type TLIntegers = TList<Integer>;

var
  FrmFileCompare: TFrmFileCompare;
   hashlist1, hashlist2: TLIntegers;

implementation

uses HashUnit, About;

{$R *.dfm}

procedure TFrmFileCompare.FormCreate(Sender: TObject);
begin
  Diff := TDiff.Create(self);
  source1 := TStringList.Create;
  source2 := TStringList.Create;
  result1 := TStringList.Create;
  result2 := TStringList.Create;
  hashlist1 := TList<Integer>.Create;
  hashlist2 := TList<Integer>.Create;

  ResultGrid.ColWidths[0] := 40;
  ResultGrid.ColWidths[2] := 40;
  ResultGrid.Canvas.Font := ResultGrid.Font;

end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.FormActivate(Sender: TObject);
begin
  if (paramcount > 0) then
    OpenFile1(paramstr(1));
  if (paramcount > 1) then
    OpenFile2(paramstr(2));
  mnuCompareClick(nil);
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.FormDestroy(Sender: TObject);
begin
  source1.Free;
  source2.Free;
  result1.Free;
  result2.Free;
  hashlist1.Free;
  hashlist2.Free;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.Clear(left, right: boolean);
begin
  if left then
  begin
    source1.Clear;
    result1.Clear;
    hashlist1.Clear;
    lblFile1.Caption := ' File1: ';
  end;
  if right then
  begin
    source2.Clear;
    result2.Clear;
    hashlist2.Clear;
    lblFile2.Caption := ' File2: ';
  end;
  ResultGrid.RowCount := 0;
  Diff.Clear;
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
  StatusBar1.Panels[2].Text := '';
  StatusBar1.Panels[3].Text := '';
  mnuCompare.Enabled := false;
  mnuView.Enabled := false;
end;
// ------------------------------------------------------------------------------

// Because it's SO MUCH EASIER AND FASTER comparing hashes (integers) than
// comparing whole lines of text, we'll build a list of hashes for each line
// in the source files. Each line is represented by a (virtually) unique
// hash that is based on the contents of that line. Also, since the
// likelihood of 2 different lines generating the same hash is so small,
// we can safely ignore that possibility.

procedure TFrmFileCompare.About1Click(Sender: TObject);
begin
   AboutBox.ShowModal;
end;

procedure TFrmFileCompare.BuildHashList(left, right: boolean);
var
  i: Integer;
begin
  if left then
  begin
    hashlist1.Clear;
    for i := 0 to source1.Count - 1 do
    begin
      hashlist1.Add(HashLine(source1[i], mnuIgnoreCase.Checked,
        mnuIgnoreWhiteSpace.Checked));
    end;
  end;
  if right then
  begin
    hashlist2.Clear;
    for i := 0 to source2.Count - 1 do
    begin
      hashlist2.Add(HashLine(source2[i], mnuIgnoreCase.Checked,
        mnuIgnoreWhiteSpace.Checked));
    end;
  end;

  mnuCompare.Enabled := (hashlist1.Count > 0) and (hashlist2.Count > 0);
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.OpenFile1(const filename: string);
var
  i: Integer;
begin
  if not fileExists(filename) then
    exit;
  Clear(true, false);
  source1.LoadFromFile(filename);
  lblFile1.Caption := ' File1: ' + ExtractFileName(filename);
  hashlist1.Capacity := source1.Count;
  BuildHashList(true, false);

  ResultGrid.RowCount := max(source1.Count, source2.Count);
  for i := 0 to 3 do
    ResultGrid.Cols[i].BeginUpdate;
  try
    for i := 0 to source1.Count - 1 do
    begin
      ResultGrid.Cells[0, i] := IntToStr(i + 1);
      ResultGrid.Cells[1, i] := source1[i];
    end;
  finally
    for i := 0 to 3 do
      ResultGrid.Cols[i].EndUpdate;
  end;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.OpenFile2(const filename: string);
var
  i: Integer;
begin
  if not fileExists(filename) then
    exit;
  Clear(false, true);
  source2.LoadFromFile(filename);
  lblFile2.Caption := ' File2: ' + ExtractFileName(filename);
  BuildHashList(false, true);

  ResultGrid.RowCount := max(source1.Count, source2.Count);
  for i := 0 to 3 do
    ResultGrid.Cols[i].BeginUpdate;
  try
    for i := 0 to source2.Count - 1 do
    begin
      ResultGrid.Cells[2, i] := IntToStr(i + 1);
      ResultGrid.Cells[3, i] := source2[i];
    end;
  finally
    for i := 0 to 3 do
      ResultGrid.Cols[i].EndUpdate;
  end;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.Open11Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    OpenFile1(OpenDialog1.filename);
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.Open21Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    OpenFile2(OpenDialog1.filename);
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.Exit1Click(Sender: TObject);
begin
  close;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.mnuCompareClick(Sender: TObject);
var
  i: Integer;
begin
  if (hashlist1.Count = 0) or (hashlist2.Count = 0) then
    exit;
  mnuCancel.Enabled := true;
  screen.Cursor := crHourGlass;
  try
    // this is where it all happens  ...

    // nb: TList.list is a pointer to the bottom of the list's integer array
    Diff.Execute(PInteger(hashlist1.list), PInteger(hashlist2.list),
      hashlist1.Count, hashlist2.Count);

    if Diff.Cancelled then
      exit;

    // now fill ResultGrid with the differences ...
    for i := 0 to 3 do
    begin
      ResultGrid.Cols[i].BeginUpdate;
      ResultGrid.Cols[i].Clear;
    end;
    try
      ResultGrid.RowCount := Diff.Count;
      for i := 0 to Diff.Count - 1 do
        with Diff.Compares[i], ResultGrid do
        begin
          if Kind <> ckAdd then
          begin
            Cells[0, i] := IntToStr(oldIndex1 + 1);
            Cells[1, i] := source1[oldIndex1];
          end;
          if Kind <> ckDelete then
          begin
            Cells[2, i] := IntToStr(oldIndex2 + 1);
            Cells[3, i] := source2[oldIndex2];
          end;
        end;
    finally
      for i := 0 to 3 do
        ResultGrid.Cols[i].EndUpdate;
    end;

    with Diff.DiffStats do
    begin
      StatusBar1.Panels[0].Text := ' Matches: ' + IntToStr(matches);
      StatusBar1.Panels[1].Text := ' Modifies: ' + IntToStr(modifies);
      StatusBar1.Panels[2].Text := ' Adds: ' + IntToStr(adds);
      StatusBar1.Panels[3].Text := ' Deletes: ' + IntToStr(deletes);
    end;

  finally
    screen.Cursor := crDefault;
    mnuCancel.Enabled := false;
  end;
  mnuView.Enabled := true;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.mnuCancelClick(Sender: TObject);
begin
  Diff.Cancel;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.FormResize(Sender: TObject);
var
  i: Integer;
begin
  with ResultGrid do
  begin
    i := (ClientWidth - 80) div 2;
    ResultGrid.ColWidths[1] := i;
    ResultGrid.ColWidths[3] := i;
  end;
  lblFile2.left := Panel1.ClientWidth div 2;
end;
// ------------------------------------------------------------------------------

procedure AddCharToStr(var s: string; c: char; Kind, lastkind: TChangeKind);
begin
  if (Kind = lastkind) then
    s := s + c
  else
    case Kind of
      ckNone:
        s := s + '<BC:------>' + c;
    else
      s := s + '<BC:33FFFF>' + c;
    end;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.ResultGridDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  PaleGreen: TColor = $AAFFAA;
  PaleRed: TColor = $AAAAFF;
  PaleBlue: TColor = $FFAAAA;
var
  clr: TColor;
begin

  if (Diff.Count = 0) then
    clr := clWhite
  else
    clr := clBtnFace;
  if (ACol in [1, 3]) and (ARow < Diff.Count) then
    case Diff.Compares[ARow].Kind of
      ckNone:
        clr := clWhite;
      ckModify:
        clr := PaleGreen;
      ckDelete:
        clr := PaleRed;
      ckAdd:
        clr := PaleBlue;
    end;
  with ResultGrid.Canvas do
  begin
    Brush.Color := clr;
    FillRect(Rect);
    TextRect(Rect, Rect.left + 3, Rect.Top + 2, ResultGrid.Cells[ACol, ARow]);

    if (source1.Count = 0) and (source2.Count = 0) then
      exit;

    // now just some fancy coloring ...
    if (ACol in [0, 2]) then
    begin
      Pen.Color := clWhite;
      MoveTo(Rect.right - 1, 0);
      LineTo(Rect.right - 1, Rect.Bottom);
    end
    else
    begin
      if (ACol = 1) then
      begin
        Pen.Color := $333333;
        MoveTo(Rect.right - 1, 0);
        LineTo(Rect.right - 1, Rect.Bottom);
      end;
      Pen.Color := clSilver;
      MoveTo(Rect.left, 0);
      LineTo(Rect.left, Rect.Bottom);
    end;
    // finally, draw the focusRect ...
    if (gdSelected in State) and (ACol = 3) then
    begin
      Rect.left := 0;
      DrawFocusRect(Rect);
    end;
  end;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.mnuIgnoreCaseClick(Sender: TObject);
begin
  mnuIgnoreCase.Checked := not mnuIgnoreCase.Checked;
  Clear(false, false);
  BuildHashList(true, true);
  mnuCompareClick(nil);
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.mnuIgnoreWhiteSpaceClick(Sender: TObject);
begin
  mnuIgnoreWhiteSpace.Checked := not mnuIgnoreWhiteSpace.Checked;
  Clear(false, false);
  BuildHashList(true, true);
  mnuCompareClick(nil);
end;
// ------------------------------------------------------------------------------

function GridRect(Coord1, Coord2: TGridCoord): TGridRect;
begin
  with Result do
  begin
    left := Coord2.X;
    if Coord1.X < Coord2.X then
      left := Coord1.X;
    right := Coord1.X;
    if Coord1.X < Coord2.X then
      right := Coord2.X;
    Top := Coord2.Y;
    if Coord1.Y < Coord2.Y then
      Top := Coord1.Y;
    Bottom := Coord1.Y;
    if Coord1.Y < Coord2.Y then
      Bottom := Coord2.Y;
  end;
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.PreviousChanges1Click(Sender: TObject);
var
  row: Integer;
  Kind: TChangeKind;
begin
  row := ResultGrid.Selection.Top;
  if row = 0 then
    exit;
  Kind := Diff.Compares[row].Kind;
  while (row > 0) and (Diff.Compares[row].Kind = Kind) do
    dec(row);
  if Diff.Compares[row].Kind = ckNone then
  begin
    Kind := ckNone;
    while (row > 0) and (Diff.Compares[row].Kind = Kind) do
      dec(row);
  end;
  ResultGrid.Selection := TGridRect(Rect(0, row, 3, row));
  If row < ResultGrid.TopRow then
    ResultGrid.TopRow := max(0, row - ResultGrid.VisibleRowCount + 1);
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.NextChanges1Click(Sender: TObject);
var
  row: Integer;
  Kind: TChangeKind;
begin
  row := ResultGrid.Selection.Top;
  if row = ResultGrid.RowCount - 1 then
    exit;
  Kind := Diff.Compares[row].Kind;
  while (row < ResultGrid.RowCount - 1) and (Diff.Compares[row].Kind = Kind) do
    inc(row);
  if Diff.Compares[row].Kind = ckNone then
  begin
    Kind := ckNone;
    while (row < ResultGrid.RowCount - 1) and
      (Diff.Compares[row].Kind = Kind) do
      inc(row);
  end;
  ResultGrid.Selection := TGridRect(Rect(0, row, 3, row));
  if row > ResultGrid.TopRow + ResultGrid.VisibleRowCount - 1 then
    ResultGrid.TopRow :=
      max(0, min(row, ResultGrid.RowCount - ResultGrid.VisibleRowCount));
end;
// ------------------------------------------------------------------------------

procedure TFrmFileCompare.StatusBar1OnDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
const
  PaleGreen: TColor = $AAFFAA;
  PaleRed: TColor = $AAAAFF;
  PaleBlue: TColor = $FFAAAA;

begin
  with StatusBar.Canvas do
  begin
    case Panel.Index of
      0: // fist panel matches
        begin
          Brush.Color := clWhite;
        end;
      1: // second panel modified
        begin
          Brush.Color := PaleGreen;
        end;
      2: // thrid panel adds
        begin
          Brush.Color := PaleBlue;
        end;
      3: // forth panel deletes
        begin
          Brush.Color := PaleRed;
        end;
    end;
    // Panel background color
    FillRect(Rect);
    // Panel Text
    TextRect(Rect, 2 + Rect.left, 2 + Rect.Top, Panel.Text);

  end;
end;

end.
