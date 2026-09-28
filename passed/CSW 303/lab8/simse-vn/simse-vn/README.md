# SimSE Vietnamese Localized Build

This folder contains a Vietnamese-localized copy of SimSE, the educational
software engineering process simulation environment. The Java source structure
and identifiers remain in English, while player-facing UI text, generated
simulation text, bundled model descriptions, and sample model readme files have
been translated for Vietnamese readers.

Special software engineering terms are intentionally kept close to their
English forms when that is clearer for teaching. The summary glossary is in:

```text
translation_terms.xlsx
```

## Ready-to-run lab simulations

The playable Vietnamese simulations for this lab are built in
`bin/simulations`, one folder per selected software engineering process model:

```text
bin/simulations/waterfall/simse-waterfall-vn.jar
bin/simulations/incremental/simse-incremental-vn.jar
bin/simulations/xp/simse-xp-vn.jar
```

Each simulation folder contains launchers for your platform (`run.bat` and
`run.ps1` on Windows; `run.sh` and `run.ps1` on macOS). For example, to run the
Vietnamese Waterfall simulation:

**Windows (PowerShell):**

```powershell
cd simse-vn\bin\simulations\waterfall
.\run.ps1
```

**macOS (Terminal):**

```bash
cd simse-vn/bin/simulations/waterfall
./run.sh
```

Or run the JAR directly on any platform:

```bash
cd simse-vn/bin/simulations/waterfall
java "-Dfile.encoding=UTF-8" -jar simse-waterfall-vn.jar
```

The startup class is:

```text
simse.SimSE
```

## Rebuild all playable simulations

Requirements:

- JDK installed with `java`, `javac`, and `jar` on `PATH` (or via `JAVA_HOME`)
- UTF-8 source compilation

### Windows

- Windows PowerShell 5.1+ or PowerShell 7+

From this folder:

```powershell
cd simse-vn
.\tools\build-simulations-windows.ps1
```

To stamp a student name and student ID into the simulation window title for
screenshot verification, pass `-StudentName` and `-StudentId`:

```powershell
.\tools\build-simulations-windows.ps1 -StudentName "Khiem Nguyen" -StudentId "SE123456"
```

The simulation window will display a title such as:

```text
SimSE - Khiem Nguyen - SE123456
```

For a custom non-student label, `-WindowTitleSuffix` is still supported:

```powershell
.\tools\build-simulations-windows.ps1 -WindowTitleSuffix InstructorDemo
```

### macOS

- [PowerShell 7+](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-macos) (`pwsh`), for example: `brew install powershell`

From this folder:

```bash
cd simse-vn
chmod +x ./tools/build-simulations-macos.sh
./tools/build-simulations-macos.sh
```

The same student title-stamp options can be forwarded on macOS:

```bash
./tools/build-simulations-macos.sh -StudentName "Khiem Nguyen" -StudentId "SE123456"
```

Both build scripts call the shared logic in `tools/build-simulations-common.ps1`.
That script compiles the localized SimSE generator, generates Java source for
the packaged SimSE-VN models, renders Vietnamese UI images, compiles each
generated simulation, and packages runnable JARs under `bin/simulations`. The
student lab assignment currently uses the Waterfall and XP simulations.

Generated Java source is kept under:

```text
bin/generated
```

## Localized model files

The translated source model files are kept under `res/models`:

```text
res/models/waterfall/Waterfall.mdl
res/models/incremental/incremental.mdl
res/models/inspection/Inspection.mdl
res/models/rapidprototyping/Prototype.mdl
res/models/rup/RUP.mdl
res/models/xp/XP.mdl
```

Model syntax keywords, formulas, and internal object/action identifiers are
preserved where changing them would break parsing or generation. Player-facing
descriptions, narratives, action prompts, and common generated UI messages are
localized for Vietnamese readers.

## Optional Model Builder tool

The localized Model Builder tool is also packaged in `bin`:

```text
bin/simse-vn.jar
bin/run-simse-vn.bat
bin/run-simse-vn.ps1
```

Run it from Windows PowerShell:

```powershell
cd simse-vn\bin
.\run-simse-vn.ps1
```

Or run the JAR directly:

```powershell
cd simse-vn\bin
java "-Dfile.encoding=UTF-8" -jar simse-vn.jar
```

The builder startup class is:

```text
simse.modelbuilder.ModelBuilderGUI
```

Use this tool only if you want to inspect or edit the localized `.mdl` files
manually. The ready-to-run games are the model JARs in `bin/simulations`.

## Rebuild only the Model Builder

Requirements:

- JDK installed with `javac` and `jar` available on `PATH`
- UTF-8 source compilation

From this folder:

```powershell
Remove-Item -Recurse -Force .\bin\classes -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force .\bin\classes | Out-Null

$javaFiles = Get-ChildItem -Path .\src -Recurse -Filter *.java | ForEach-Object { $_.FullName }
javac -encoding UTF-8 -d .\bin\classes $javaFiles

Get-ChildItem -Path .\src -Recurse -Directory -Filter res | ForEach-Object {
  $relative = Resolve-Path -Relative $_.FullName
  $dest = Join-Path .\bin\classes ($relative -replace '^\.\\src\\', '')
  Copy-Item -Recurse -Force -LiteralPath $_.FullName -Destination $dest
}

jar cfm .\bin\simse-vn.jar .\bin\manifest.mf -C .\bin\classes .
```

If `jar` is not on `PATH`, use the executable from your JDK, for example:

```powershell
& "$env:JAVA_HOME\bin\jar.exe" cfm .\bin\simse-vn.jar .\bin\manifest.mf -C .\bin\classes .
```

Run the rebuilt program:

```powershell
java "-Dfile.encoding=UTF-8" -jar .\bin\simse-vn.jar
```

## Notes

- The source code remains Java/Swing and keeps the original package names.
- Model syntax keywords, formulas, and internal object/action identifiers were
  preserved to avoid breaking model parsing and code generation.
- Vietnamese UI GIF labels are generated with `tools/VietnameseImageGenerator.java`
  (Java2D), so the same build works on Windows and macOS without System.Drawing.
