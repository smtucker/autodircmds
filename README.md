# AutoDirCmds

A very simple Neovim plugin to help keep your configurations clean by creating
autocmds for files in folders specified from your plugin configuration.

## Current Features

- Creates autocmds from plugin configuration
- Autocmds are trigged for all files/subfolders within given directory
- Can specify lua function or vim command to be trigged
- Supported events:
  - BufReadPre - "preopen"
  - BuffWritePost - "postwrite"

## Planned Features

- Enable/Disable autocmds during runtime
- Add more configurable events

## Example Configuration

Lazy:

```lua
{
  "smtucker/autodircmds"
  opts = {
    dirs = {
      {
        "~/notes",
        preopen = "!sync-notes down %", -- External script to rsync file
        postwrite = function(event)
            -- your code here
        end,
      },
    },
  },
  lazy = false,
},
```
