; TRAUM Planer — Windows-Installer (Inno Setup 6)
;
; Baut aus dem Release-Build (build\windows\x64\runner\Release) einen
; klassischen Windows-Installer. Zwei Komponenten:
;
;   1. "app"    — TRAUM Planer selbst, inkl. lokal gebündeltem
;                 Whisper-STT-Modell (bereits Teil von
;                 build\windows\x64\runner\Release\data\flutter_assets\assets\whisper\,
;                 da als Flutter-Asset deklariert — kein Extraschritt nötig).
;                 Immer installiert, das ist die eigentliche App.
;
;   2. "ollama" — optional, standardmäßig ABGEWÄHLT (Installer-Größe!).
;                 Bündelt Ollama selbst (OllamaSetup.exe) und die
;                 Modellgewichte für qwen2.5:3b vollständig offline, wie
;                 in docs/spec.md Abschnitt 8 (offene Frage 2) entschieden.
;                 Erfordert vorab befüllte Dateien unter installer\vendor\ollama\,
;                 siehe installer\vendor\ollama\README.md — Platzhalter, so
;                 lange diese Dateien fehlen, überspringt die Komponente sich
;                 selbst (kein Build-Fehler).
;
; Build: "C:\Users\<du>\AppData\Local\Programs\Inno Setup 6\ISCC.exe" installer\traum-planer.iss
; Ergebnis landet in installer\output\traum-planer-setup-<version>.exe

#define AppVersion "1.0.0"
#define ReleaseDir "..\build\windows\x64\runner\Release"
#define VendorOllamaDir "vendor\ollama"

[Setup]
AppId={{6C8EF5B2-1B1E-4A26-9C0A-54A1F0F0E2C1}
AppName=TRAUM Planer
AppVersion={#AppVersion}
AppPublisher=TRAUM Planer
; Installation pro Nutzerkonto, kein Admin/UAC nötig — passend zu Ollamas
; eigener Konvention (installiert ebenfalls nach {localappdata}) und
; angemessen für ein persönliches Desktop-Tool ohne systemweite Änderungen.
DefaultDirName={localappdata}\Programs\TRAUM Planer
DefaultGroupName=TRAUM Planer
UninstallDisplayIcon={app}\traum_planer.exe
OutputDir=output
OutputBaseFilename=traum-planer-setup-{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Types]
Name: "full"; Description: "Vollständig (mit lokalem KI-Assistenten)"
Name: "compact"; Description: "Nur die App (Assistent später optional nachrüstbar)"
Name: "custom"; Description: "Benutzerdefiniert"; Flags: iscustom

[Components]
Name: "app"; Description: "TRAUM Planer (inkl. lokalem Spracherkennungs-Modell, ~500 MB)"; Types: full compact custom; Flags: fixed
Name: "ollama"; Description: "Lokaler KI-Assistent — Ollama + Sprachmodell offline (~3,5 GB zusätzlich)"; Types: full

[Files]
; Kernanwendung — alles aus dem Release-Build, inkl. gebündeltem
; Whisper-Modell unter data\flutter_assets\assets\whisper\.
Source: "{#ReleaseDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: app

; Optionale Ollama-/LLM-Komponente. "skipifsourcedoesntexist" sorgt dafür,
; dass der Build nicht bricht, solange installer\vendor\ollama\ noch leer ist
; (siehe installer\vendor\ollama\README.md für die Befüll-Anleitung).
Source: "{#VendorOllamaDir}\OllamaSetup.exe"; DestDir: "{tmp}"; Flags: dontcopy skipifsourcedoesntexist; Components: ollama
Source: "{#VendorOllamaDir}\Modelfile"; DestDir: "{tmp}"; Flags: dontcopy skipifsourcedoesntexist; Components: ollama
Source: "{#VendorOllamaDir}\blobs\*"; DestDir: "{tmp}\ollama-blobs"; Flags: dontcopy skipifsourcedoesntexist recursesubdirs; Components: ollama

[Icons]
Name: "{group}\TRAUM Planer"; Filename: "{app}\traum_planer.exe"
Name: "{autodesktop}\TRAUM Planer"; Filename: "{app}\traum_planer.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Run]
Filename: "{app}\traum_planer.exe"; Description: "{cm:LaunchProgram,TRAUM Planer}"; Flags: nowait postinstall skipifsilent

[Code]
{ Extrahiert die Ollama-Komponente (falls ausgewählt und die Vendor-Dateien
  beim Compilieren vorhanden waren) und richtet das Modell rein lokal ein
  — kein "ollama pull", also kein Netzwerkzugriff bei der Ersteinrichtung. }
procedure InstallOllamaComponent();
var
  ResultCode: Integer;
  OllamaSetupPath, ModelfilePath, BlobsDestDir, OllamaModelsDir: String;
begin
  if not WizardIsComponentSelected('ollama') then
    exit;

  { Wenn installer\vendor\ollama\ beim Compilieren leer war, wurde die
    Datei gar nicht erst ins Setup aufgenommen — ExtractTemporaryFile
    wirft dann einen Laufzeitfehler statt einfach nichts zu tun. Sauber
    abfangen und die Komponente still überspringen, statt die Installation
    mit einer Fehlermeldung zu unterbrechen. }
  try
    ExtractTemporaryFile('OllamaSetup.exe');
  except
    exit;
  end;

  OllamaSetupPath := ExpandConstant('{tmp}\OllamaSetup.exe');
  if not FileExists(OllamaSetupPath) then
    exit;

  { 1) Ollama selbst still installieren. }
  Exec(OllamaSetupPath, '/VERYSILENT /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  { 2) Modell-Blobs an den Ort legen, den Ollama erwartet (Inhalt-adressiert
        über den Dateinamen, sha256-<hash>) — danach "ollama create" rein
        lokal, ohne jeden Netzwerkzugriff. }
  OllamaModelsDir := ExpandConstant('{%USERPROFILE}\.ollama\models\blobs');
  ForceDirectories(OllamaModelsDir);
  BlobsDestDir := ExpandConstant('{tmp}\ollama-blobs');
  Exec(ExpandConstant('{cmd}'), '/C xcopy /Y /I "' + BlobsDestDir + '\*" "' + OllamaModelsDir + '"',
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  try
    ExtractTemporaryFile('Modelfile');
  except
    exit;
  end;
  ModelfilePath := ExpandConstant('{tmp}\Modelfile');
  { Arbeitsverzeichnis = ...\.ollama\models\, damit die relative
    "FROM blobs\sha256-..."-Zeile im Modelfile (siehe vendor\ollama\README.md)
    auf die soeben dorthin kopierten Blobs auflöst.
    Ollamas eigener Installer legt ollama.exe immer hierhin, unabhängig
    vom Installationsort von TRAUM Planer. }
  Exec(ExpandConstant('{localappdata}\Programs\Ollama\ollama.exe'), 'create qwen2.5:3b -f "' + ModelfilePath + '"',
    ExpandConstant('{%USERPROFILE}\.ollama\models'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    InstallOllamaComponent();
end;
