# notepad.nvim

A tiny Neovim plugin that opens an editable floating notepad over your current UI. Notes live only in memory for the current Neovim session; nothing is written to disk.

## Installation

Use your plugin manager of choice, for example with `lazy.nvim`:

```lua
{
  "your-name/notepad.nvim",
  opts = {},
}
```

## Usage

Commands:

- `:NotepadOpen` - open the notepad
- `:NotepadClose` - close the notepad window
- `:NotepadToggle` - toggle the notepad window
- `:NotepadClear` - clear all notepad text

Example keymap:

```lua
vim.keymap.set("n", "<leader>n", "<cmd>NotepadToggle<cr>", { desc = "Toggle notepad" })
```

## Configuration

Defaults:

```lua
require("notepad").setup({
  width = 0.6,          -- fraction of editor width, or absolute columns
  height = 0.6,         -- fraction of editor height, or absolute rows
  border = "rounded",
  title = " Notepad ",
  title_pos = "center",
  filetype = "markdown",
  winblend = 0,
})
```

The notepad buffer is a scratch `nofile` buffer with `bufhidden=hide`, so closing the floating window keeps your notes available until Neovim exits or `:NotepadClear` is run.
