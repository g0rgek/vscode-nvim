# Sidebar Flicker-Free Enhancement Plan

## Problem

Switching sidebar tools causes flicker because of the **window destroy + recreate cycle**:

1. `sidebar.close_all()` — calls `nvim_win_close` on the current panel's window
2. `panel.open()` — the new tool creates a brand new window via `NuiSplit:mount`, `vertical new`, `sbuffer`, or `nvim_open_win`
3. Neovim recomputes the entire window layout between these operations → visible flash

## Root Cause

Each tool plugin insists on owning its own window. There is no single persistent sidebar container — every tool switch destroys one window and creates another.

## Proposed Solution: Persistent Container Window

**Create ONE persistent window on the left at startup.** When switching tools, capture the content buffer from the new tool and swap it into the container window via `nvim_win_set_buf`. No windows are destroyed or created during tool switches.

## Per-Tool Strategy

| Tool | Method |
|------|--------|
| **Neo-tree** | Easiest. Pre-register the container window in neo-tree's `windows.get_location("left")` table. Neo-tree already has a reuse path in `renderer.lua:1237` that calls `nvim_win_set_buf()` on an existing window instead of creating a new `NuiSplit`. |
| **grpc-ui** | Medium. Lua plugin, `drawer.lua:115`. After it opens, capture its buffer (`nvim_win_get_buf`) and swap into container window, close the temporary window. |
| **DBUI** | Hardest. Pure Vimscript, `vertical new dbui` always creates a window. After it opens, capture buffer + swap into container, close temporary window. Both ops in same redraw cycle = no visible flicker. |
| **TimeMachine** | Hard. `sbuffer` always creates a new split. Same buffer-capture + swap technique as DBUI. |

## Implementation Steps

1. **Create persistent container window** — `nvim_open_win` once at module load, positioned left, `winfixwidth=true`
2. **Implement `swap_buffer(source_win)` helper** — captures buffer from source window, sets it into container, closes source window
3. **Refactor each `panel.open()`** to render the tool (accepting it creates a temporary window), then swap its buffer into the container
4. **Remove `sidebar.close_all()`** — no windows to close, just swap content
5. **Use placeholder buffers** (`sidebar://files` etc.) as the "empty/closed" state when sidebar is hidden

## Key Technical Details

- `nvim_win_set_buf` is instant — no layout recomputation
- All temporary window creation and cleanup happens in the same redraw cycle via `vim.schedule`
- The container window is only created once at startup and never destroyed
- Neo-tree's `windows.get_location("left")` provides a clean hook for the easiest path