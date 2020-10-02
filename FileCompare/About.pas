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
}
unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Dialogs,
  Buttons, Vcl.ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Aboutlbl: TLabel;
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;
  AppDir : String;

implementation

{$R *.DFM}


procedure TAboutBox.FormActivate(Sender: TObject);
begin
  Aboutlbl.caption := 'This source is free software; ' + char(10) +
    'you can redistribute it and /or modify it under' + char(10) +
    'the terms of the GNU General Public License as published by the Free' +
    char(10) +
    'Software Foundation; either version 2 of the License, or (at your option) '
    + char(10) + 'any later version. ' + char(10) + char(10) +
    'This code is distributed in the hope that it will be useful, but WITHOUT ANY'
    + char(10) +
    'WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS'
    + char(10) +
    'FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more ' +
    char(10) + 'details. ' + char(10) + char(10) +
    'A copy of the GNU General Public License is available on the World Wide Web'
    + char(10) +
    'at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing'
    + char(10) +
    'to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,Boston, MA 02110 USA'
    + char(10) + char(10) +
    'This Program Is Built With and or utilizes the following modules / code' +
    char(10) + char(10) +
    ' TDiff, written by  Angus Johnson http://www.angusj.com'
     + char(10) +
    ' Based on "BasicDiffDemo2" provided with the TDiff  source'
    + char(10) +
    '   Source Code Can Be Found At: https://github.com/nextjob/TDiff';

end;



end.
