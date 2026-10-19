-- =============================================================================
-- sudo-tee/opencode.nvim
-- Migra desde NickvanDyke/opencode.nvim (ver `opencode.lua.disabled`).
--
-- Diferencias que importan para tu flujo:
--   - Panel de chat nativo en el split derecho (no abre tabs nuevos).
--   - Context bar visible encima del input: siempre sabes qué se enviará.
--   - Review de cambios con comentarios inline (<leader>od).
--   - Detecta automáticamente si el servidor OpenCode es v1 o v2.
--
-- Quickstart:
--   1. :Lazy sync
--   2. :checkhealth opencode
--   3. Abrir un archivo → <leader>oi   (abre el panel de chat)
--   4. <CR> envía un prompt.
--   5. V → seleccionar → <leader>oy   (manda selección como contexto)
--   6. <leader>od                     (review del diff del agente)
--
-- Para ver todas las opciones en efecto tras el setup:
--   :lua print(vim.inspect(require('opencode.config').values))
-- =============================================================================

return {
	-- sudo-tee/opencode.nvim es un fork-friendly de goose.nvim. Detecta
	-- automáticamente el servidor OpenCode (V1 o V2) por su protocolo HTTP.
	-- Mantenemos `name = "opencode.nvim"` para reusar el mismo directorio
	-- lazy y minimizar churn en lazy-lock.json.
	{
		"sudo-tee/opencode.nvim",
		name = "opencode.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- snacks ya está en tu lockfile; lo declaramos como dep del
			-- plugin para que sudo-tee lo pueda usar como picker y terminal.
			-- Si snacks no estuviera ya configurado por otro lado, esto
			-- garantiza que esté disponible cuando el plugin lo pida.
			"folke/snacks.nvim",
		},
		opts = {
			-- ------------------------------------------------------------
			-- UI / layout
			-- ------------------------------------------------------------
			ui = {
				-- Tu vieja config tenía el panel a la derecha; mantenemos.
				position = "right",
				window_width = 0.40,         -- ~40% del ancho del editor
				zoom_width = 0.80,           -- ancho cuando haces <leader>oz

				-- Tu hábito es trabajar con varias tabs de opencode/sesión.
				-- Por defecto sudo-tee oculta la tab strip con una sola tab;
				-- forzamos a mostrarla siempre para que veas las otras sesiones.
				hide_single_tab = false,

				-- Si tienes render-markdown.nvim o markview.nvim instalados,
				-- sudo-tee renderizará el output. Si no, cae a treesitter plano,
				-- que ya da una experiencia leíble.
				enable_treesitter_markdown = true,

				-- Aviso si llega una pregunta o permiso mientras estás en
				-- otro buffer (multi-tab en el panel de opencode).
				notify_on_background_prompt = true,
			},

			-- ------------------------------------------------------------
			-- Context bar (lo que ves encima del input)
			-- Apagas esto Y dejas de "ir a ciegas" — la barra muestra, en vivo,
			-- qué archivos / selección / diagnósticos va a recibir el agente.
			-- ------------------------------------------------------------
			context = {
				enabled = true,
				current_file = { enabled = true, show_full_path = true },
				selection    = { enabled = true },                 -- <leader>oy
				diagnostics  = {                                  -- solo los del
					enabled = true,                                -- cursor o la
					only_closest = true,                           -- selección
					warning = true,
					error   = true,
					info    = false,
				},
				-- git_diff es opcional; si lo activas la context bar
				-- muestra el diff staged que enviará junto con el prompt.
				git_diff = { enabled = false },

				-- Cuando hagas <leader>o/ (quick chat) sí quieres todo el buffer;
				-- aqui lo dejamos apagado para que solo afecte el flujo con panel.
				buffer = { enabled = false },
			},

			-- ------------------------------------------------------------
			-- Servidor
			-- ------------------------------------------------------------
			-- sudo-tee autodetecta el servidor OpenCode en localhost (vía los
			-- archivos service.json que OpenCode CLI v2 deja en
			-- $XDG_STATE_HOME/opencode/ o ~/.local/state/opencode/). Si
			-- quieres forzarlo, descomenta y ajusta:
			--
			-- server = {
			--   url = function(callback)
			--     -- p.ej. para un servidor remoto:
			--     -- callback("http://127.0.0.1:4096")
			--     -- callback(nil) hace que el plugin intente descubrir solo.
			--     callback(nil)
			--   end,
			-- },
		},

		config = function(_, opts)
			require("opencode").setup(opts)

			-- ------------------------------------------------------------
			-- Keymaps de compatibilidad
			-- ------------------------------------------------------------
			-- sudo-tee trae por defecto el conjunto completo <leader>o* (lista
			-- completa en :help opencode.nvim-keymaps). Los más importantes:
			--
			--   <leader>oi  → abre el input (insert mode)
			--   <leader>oI  → abre el input en una sesión nueva
			--   <leader>oo  → abre el output
			--   <leader>ot  → salta entre el panel y tu último buffer
			--   <leader>og  → togglea (muestra/oculta) el panel
			--   <leader>oz  → zoom del panel
			--   <leader>oq  → cierra el panel
			--   <leader>o/  → quick chat (línea o selección → edit inplace)
			--
			--   <leader>oy  (visual) → selección como contexto
			--   <leader>oY  (visual) → selección pegada como bloque en el prompt
			--
			--   <leader>os  → selector de sesiones
			--   <leader>o<  o> o1..o9 → navegar tabs del panel
			--   <leader>oN / oI → nueva tab / nueva sesión
			--
			--   <leader>od  → abrir review del diff del agente
			--   <leader>o]  / o[     → siguiente / anterior diff
			--   <leader>oc  → cerrar review
			--
			--   <leader>op  → picker de provider/modelo
			--   <leader>oV  → picker de variante
			--
			-- Si quieres migrar tus viejos hábitos del plugin anterior,
			-- descomenta el bloque siguiente. NO los activamos por default
			-- porque `+`/`-` dependen de que <C-a>/<C-x> sigan libres (los
			-- usas para incrementar/decrementar bajo el cursor).
			--
			-- local map = vim.keymap.set
			--
			-- -- Reemplazo de tu viejo <C-a> "Ask opencode…"
			-- map({ "n", "x" }, "<C-a>", function()
			--   require("opencode").action("open_input")
			-- end, { desc = "OpenCode: pregunta…" })
			--
			-- -- Reemplazo de tu viejo <C-.> "Toggle opencode"
			-- -- (sudo-tee no necesita terminal aparte: togglea el split)
			-- map("n", "<C-.>", "<leader>og", {
			--   desc = "OpenCode: toggle panel", remap = true,
			-- })
			--
			-- -- Reemplazo del operador Vim "go" / "goo": al disparar
			-- -- una motion con `go`, le pedimos a sudo-tee que abra el
			-- -- input con la selección actual como contexto.
			-- map("x", "go", function()
			--   vim.cmd("normal! \\<esc>")
			--   require("opencode.api").add_visual_selection({ open_input = true })
			-- end, { desc = "OpenCode: rango → contexto" })
		end,
	},
}
