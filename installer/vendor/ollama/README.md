# Ollama-Bündelung (optional, für den vollständig offline-fähigen Installer)

Diese Dateien fehlen im Repo (mehrere GB, gehören nicht in Git). Um die
"ollama"-Komponente in `installer/traum-planer.iss` tatsächlich zu bauen,
hier lokal befüllen:

## 1. `OllamaSetup.exe`

Von https://ollama.com/download herunterladen, hier ablegen als:

```
installer/vendor/ollama/OllamaSetup.exe
```

## 2. Modellgewichte (`blobs/`) + `Modelfile`

Voraussetzung: Ollama ist lokal installiert und `ollama pull qwen2.5:3b`
wurde einmal ausgeführt (üblicher Cache-Ort: `%USERPROFILE%\.ollama\models`).

```powershell
# Modelfile erzeugen (verweist im Original noch auf den lokalen Blob-Pfad
# dieser Maschine — deshalb vor dem Kopieren die FROM-Zeile durch den
# Dateinamen ersetzen, siehe unten)
ollama show --modelfile qwen2.5:3b > installer\vendor\ollama\Modelfile

# Alle Blobs kopieren, die das Modell referenziert (mehrere Dateien,
# grob 2 GB gesamt — den genauen Satz zeigt "ollama show qwen2.5:3b --modelfile",
# einfach den kompletten blobs-Ordner kopieren ist am einfachsten):
robocopy "%USERPROFILE%\.ollama\models\blobs" installer\vendor\ollama\blobs /E
```

In der kopierten `Modelfile` die Zeile

```
FROM C:\Users\<du>\.ollama\models\blobs\sha256-<hash>
```

ersetzen durch (der Installer kopiert die Blobs zur Laufzeit selbst an den
richtigen Ort, das `Modelfile` muss beim Compilieren nur relativ auf den
Dateinamen zeigen):

```
FROM blobs\sha256-<hash>
```

## 3. Bauen

```powershell
& "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe" installer\traum-planer.iss
```

Solange diese Dateien fehlen, überspringt `traum-planer.iss` die
"ollama"-Komponente automatisch (kein Build-Fehler, aber der Installer bietet
sie dann auch nicht sinnvoll an — die Checkbox erscheint, tut aber nichts).
