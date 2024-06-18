return {
    "rcarriga/nvim-dap-ui",
    -- es probable que se necesite dar permisos de lectura, escritura y ejecucion a ~/.local/state/nvim/nio.log
    -- tambien es probable que se tenga que borrar el cache de nvim ~/.cache/nvim
    -- y dar permisos de ejecucion a ~/.local/share/nvim/nvim-nio (todo el folder)
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
}
