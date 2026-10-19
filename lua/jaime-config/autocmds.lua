-- ----------------------------------------------------------------------
-- autocmds.lua
-- Autocomandos globales de Neovim (no asociados a un plugin en concreto).
-- Se carga desde init.lua con `require("jaime-config.autocmds")`.
-- ----------------------------------------------------------------------

-- Recarga buffers modificados en disco al recuperar foco o al volver
-- a un buffer. Evita tener que lanzar `:checktime` manualmente cuando
-- un proceso externo (git pull, formateador, agente, etc.) modifica
-- un archivo abierto.
vim.api.nvim_create_augroup("JaimeAutoReload", { clear = true })

vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "WinEnter", "CursorHold" },
  {
    group = "JaimeAutoReload",
    callback = function()
      vim.cmd("checktime")
    end,
    desc = "Recarga buffers modificados fuera de Neovim",
  }
)

-- Para que `autoread` tenga efecto combinado con las autocmds de arriba.
-- Sin esto, `:checktime` detecta el cambio pero el buffer no se recarga
-- automáticamente.
vim.opt.autoread = true
