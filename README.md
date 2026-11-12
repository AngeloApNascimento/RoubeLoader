# RoubeLoader

**RoubeLoader** is an open-source, modular Luau bootstrap framework for Roblox experiences that you own or are authorized to develop.

> This project is designed for Roblox Studio projects. It is not an executor script, exploit, cheat, anti-cheat bypass, or remote-code downloader. It does not use `loadstring`, `HttpGet`, or execute arbitrary code from GitHub.

## Features

- Single entry point: `Chilli.lua`
- PlaceId-based module registry
- Configurable logging (`INFO`, `WARN`, `ERROR`)
- Bounded in-memory log history
- Retry with exponential backoff
- Duplicate-start protection
- Protected module initialization (`pcall`)
- No third-party dependencies

## Project layout

```text
RoubeLoader/
├── Chilli.lua
├── default.project.json
├── LICENSE
├── README.md
├── CHANGELOG.md
├── .gitignore
├── core/
│   ├── Config.lua
│   ├── Logger.lua
│   ├── Retry.lua
│   ├── Registry.lua
│   └── Loader.lua
└── modules/
    └── Example.lua
```

## Install in Roblox Studio

### Option A — Build the hierarchy manually

Create the following under `ReplicatedStorage`:

```text
ReplicatedStorage
└── RoubeLoader (Folder)
    ├── Chilli (ModuleScript)       <- contents of Chilli.lua
    ├── core (Folder)
    │   ├── Config (ModuleScript)
    │   ├── Logger (ModuleScript)
    │   ├── Retry (ModuleScript)
    │   ├── Registry (ModuleScript)
    │   └── Loader (ModuleScript)
    └── modules (Folder)
        └── Example (ModuleScript)
```

Copy each matching `.lua` file into its ModuleScript. Then create a Script in `ServerScriptService`:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packageFolder = ReplicatedStorage:WaitForChild("RoubeLoader")
local RoubeLoader = require(packageFolder:WaitForChild("Chilli"))

RoubeLoader.Start()
```

### Option B — Rojo

Install [Rojo](https://rojo.space/) and use the included `default.project.json`. From this repository folder run:

```bash
rojo serve
```

Connect Roblox Studio using the Rojo plugin. Review the mapped hierarchy before syncing.

## Configure a module

Open `core/Config.lua` and edit `ModulesByPlaceId`. Replace the sample ID with the PlaceId of an experience you own:

```lua
ModulesByPlaceId = {
    [123456789] = "Example",
}
```

The key is a numeric PlaceId. The value must match a ModuleScript name inside `modules/`.

To add another module:
1. Create a ModuleScript in `modules/`.
2. Return a function accepting the `context` table.
3. Add its name to `ModulesByPlaceId` for the intended PlaceId.

Example module:

```lua
return function(context)
    context.Logger:Info("My module started")
    return true
end
```

A module must return `true` (or another non-false value) to indicate successful initialization. Returning `false` or raising an error is treated as a failed attempt.

## Configuration

`core/Config.lua` contains:
- `Debug`: print INFO entries to the Studio output.
- `Logging.Enabled`: enable/disable log collection.
- `Logging.MaxEntries`: maximum in-memory entries.
- `Retry.Enabled`: enable retries.
- `Retry.MaxAttempts`: total attempts, including the first.
- `Retry.InitialDelay`: initial delay in seconds.
- `Retry.Multiplier`: exponential backoff multiplier.
- `Retry.MaxDelay`: maximum delay between attempts.
- `PreventDuplicate`: prevent a second successful start.

## API

```lua
local RoubeLoader = require(path.To.Chilli)

RoubeLoader.Start()                 -- starts once
RoubeLoader.GetLogs()               -- returns a copy of log entries
RoubeLoader.GetConfig()             -- returns the configuration table
RoubeLoader.GetVersion()            -- returns package version
```

## Security notes

- Only install modules that you wrote or have reviewed and are authorized to use.
- Keep server-authoritative game logic in `ServerScriptService` or server-only containers.
- Do not put secrets, API keys, or private credentials in replicated ModuleScripts.
- Do not treat a GitHub URL as proof that code is safe.
- This package intentionally does not fetch or execute remote code. For updates, review the Git diff and deploy reviewed source through your normal Studio/Rojo workflow.

## License

MIT. See [LICENSE](LICENSE).
