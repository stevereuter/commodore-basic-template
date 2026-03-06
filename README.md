<div align="center">
    <a href="https://steviesaurus-dev.itch.io/">
        <img src="assets/profile-banner.png" alt="Steviesaurus Dev" />
    </a>
</div>

# Commodore BASIC Template

Template repository for building Commodore 64 games in BASIC with VS Code + VS64.

## What This Template Includes

- A BASIC project layout designed for C64 game development.
- A starter game loop structure split across focused source files in `c64/src`.
- Character set setup code that copies the ROM charset to RAM and switches VIC-II to use the RAM charset.
- An Aseprite character template and export script that generates BASIC `data` statements for custom characters.
- VS64 workspace configuration for build and VICE launch/debug.

## Project Structure

```text
commodore-basic-template/
|- assets/
|  |- c64-template.aseprite
|  \- C64 Standard Character Exporter.lua
|- c64/
|  |- .vscode/
|  |  |- launch.json
|  |  |- settings.json
|  |  \- tasks.json
|  \- src/
|     |- characters.bas
|     |- data.bas
|     |- gameLoad.bas
|     |- gameLoop.bas
|     |- gameOver.bas
|     |- intro.bas
|     |- main.bas
|     |- subroutines.bas
|     \- variables.bas
\- README.md
```

## VS64 Development Workflow

1. Open the `c64` folder in VS Code. This is required because the VS64 project file lives in `c64`.
2. If this is a fresh setup, run `VS64: Create C64 BASIC Project` once from the command palette.
3. Run the VS64 start command from the `c64` folder. This creates a watcher that stays running while you work in that folder.
4. Develop your game files in `c64/src`.
5. Use `F5` to launch/debug in VICE.
    - VICE must be available on your system path.

In short: open `c64`, start VS64 (watcher), edit in `c64/src`, and press `F5` to test.

## Source File Responsibilities

- `c64/src/main.bas`: Entry point; includes all modules and drives load -> loop -> game over -> restart.
- `c64/src/variables.bas`: Global variables and array setup.
- `c64/src/characters.bas`: Character memory setup (ROM-to-RAM copy, VIC bank/screen/charset switch).
- `c64/src/intro.bas`: Intro/title screen logic.
- `c64/src/gameLoad.bas`: Game state initialization.
- `c64/src/gameLoop.bas`: Main gameplay loop.
- `c64/src/gameOver.bas`: End-of-game screen/state.
- `c64/src/subroutines.bas`: Shared helper routines.
- `c64/src/data.bas`: `data` statements (text, char bytes, sprite data, etc.).

## Custom Character Set Setup

The template already includes the base plumbing for custom characters in `c64/src/characters.bas`:

- Disables interrupts during copy setup.
- Exposes character ROM to the CPU.
- Copies character data from ROM into RAM (`49152` onward).
- Restores I/O mapping.
- Switches VIC-II bank/screen/character pointers to use RAM charset.
- Updates BASIC screen pointer.

This means you can start from the standard charset and then overwrite specific character bytes with your own data.

## Aseprite Character Workflow

Assets for creating and exporting characters are in `assets/`:

- `assets/c64-template.aseprite`: Starter file for drawing tile-based C64 characters.
- `assets/C64 Standard Character Exporter.lua`: Aseprite script that exports tiles as BASIC `data` lines.

### Using the Export Script

1. In Aseprite, open `File -> Scripts -> Open Scripts Folder`.
2. Copy `C64 Standard Character Exporter.lua` into that scripts folder.
3. Restart Aseprite.
4. Open your `.aseprite` character file and select the tilemap layer.
5. Run the script from `File -> Scripts`.

The script exports one 8-byte character per BASIC `data` line and writes a file named like:

```text
<your-file>.bas
```

### Integrating Exported Character Data

- Include the exported file from `c64/src/data.bas` (typically near the top), for example:

```basic
#include "my_tiles.bas"
```

- You can still paste lines directly if you prefer, but including the exported file keeps data separate and easier to regenerate.
- Read/poke those bytes into your target charset RAM addresses (example loop is already commented in `characters.bas`).
- Keep `data.bas` included at the end of `main.bas` so all data is available to your program.

## Notes

- The template is intentionally minimal so you can shape your own game architecture.
- `gameLoop.bas` uses a `for` loop scaffold as a performance-friendly alternative to tight `goto` loops.
- The default character copy routine copies a large range; optimize it for your game as needed.
