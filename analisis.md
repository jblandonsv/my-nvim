# Análisis: `<C-a>` en `Ask opencode` no parece hacer nada

> Archivo generado a partir de la sesión de diagnóstico del 19 de octubre de 2026.
> Contexto: el usuario reportó que al pulsar `<C-a>` (que llega como Cmd+A desde su terminal en macOS) se abre el popup "Ask opencode…", pero al escribir la pregunta y pulsar Enter *no pasa nada* y dice que "el plugin no se abre".

## Pregunta original del usuario

> Hay algo que no está funcionando bien con mi plugin de opencode. Cuando hago un `<cmd>-a` sale el popup de Ask opencode pero cuando introduzco mi pregunta y doy Enter no pasa nada en mi opencode, ni siquiera está abriendo el plugin.

## Investigación realizada

1. **Configuración del plugin**. Leí `~/.config/nvim/lua/plugins/opencode.lua` y el bookmark de versiones en `lazy-lock.json`. El plugin es `NickvanDyke/opencode.nvim` en commit `255a8e444fbe49fcd73c2d3b41a61b5d6ac92c50` (HEAD actual de `main`).
2. **Servicio de opencode**. `opencode service status` devolvió `http://127.0.0.1:49374`; el binario estaba en `/Users/jaime/.opencode/bin/opencode` (`v2.0.32`).
3. **Inspección de procesos**. Con `ps aux` detecté tres procesos relevantes:
   - PID 36724 — `opencode serve --service` (servidor).
   - PID 37187 — `opencode` (cliente TUI corriendo en tty `s005` dentro de Fish).
   - PID 37182 — `curl ... /api/event` (suscripción SSE del cliente TUI al servidor).
4. **API HTTP directa**. Llamé `GET /api/session?directory=…` con las credenciales de `~/.local/state/opencode/service.json` y confirmé que el usuario tiene sesiones vivas con títulos tales como:
   - *"Problema al enviar preguntas con cmd-a en Ask opencode"*
   - *"Problema con plugin OpenCode v2.0 al mostrar cmd-a"*
   - *"Plugin OpenCode en Neovim abre a la izquierda"*
   - *"Error al abrir Neovim por lspconfig y aerial deprecados"*
   Esto confirma que es un problema recurrente y que el usuario ya lo ha discutido con el propio opencode.
5. **Cadena completa de `ask()`**. Instrumenté `vim.ui.input`, `snacks.input`, `opencode.server.discovery.get`, `opencode.api.prompt.prompt` y `vim.notify` con un probe que auto-confirmaba la entrada. Resultado en una sesión headless de Neovim con la configuración real del usuario:
   ```
   [->] opencode.ask('@this: ', { submit = true })
   [discovery.get called]
   [discovery.get RESOLVED] url="http://127.0.0.1:49374"
   [vim.ui.input called] default="@this: "
   [api.prompt.prompt CALLED] input="PROBE-v4" cwd=/Users/jaime/.config/nvim
   [api.prompt.prompt RESOLVED] nil
   ```
   La cadena completa termina sin error: el POST a `/api/session/<id>/prompt` recibe `200 OK`. **No hay bug en el plugin.**

## Causa raíz

### Cambio v1 → v2 en `opencode.nvim`

El commit `d512228 feat!: migrate to OpenCode v2` en `opencode.nvim` reemplazó la lógica de envío. Antes (v1) `prompt.prompt()` hacía:

```lua
context.server:tui_append_prompt(plaintext)
context.server:tui_execute_command("prompt.submit")
```

Es decir, **inyectaba el prompt directamente en una TUI embebida en la terminal de Neovim**, así que el usuario *veía* su pregunta aparecer en el panel de opencode dentro de Neovim.

En v2, hace:

```lua
context.server:resolve_session()                         -- GET /api/session
context.server:prompt(session.id, plaintext)             -- POST /api/session/<id>/prompt
```

Ahora `opencode.nvim` es un **cliente HTTP puro** del servidor compartido: envía el mensaje por HTTP al background service y la respuesta se renderiza en cualquier cliente que esté conectado al servidor (el CLI TUI externo que el usuario tiene abierto en `s005`, el opencode desktop, etc.). Neovim **no recibe** ningún feedback visible.

### Por qué el usuario lo percibe como "no pasa nada"

El usuario tiene **dos clientes corriendo contra el mismo servidor**:

1. La TUI del CLI (`PID 37187`, tty `s005`).
2. Su Neovim, que sólo manda mensajes por HTTP.

Como la TUI externa no es la que él mira cuando está programando — mira Neovim — siente que `<C-a>` se pierde. En realidad el mensaje sale y el servidor lo procesa, pero el resultado aparece en otra ventana.

### `submit = true` está obsoleto

En el `opencode/lua/opencode.lua` de la versión instalada, la firma es:

```lua
function M.ask(default)
```

sólo acepta el texto pre-rellenado. El segundo argumento `{ submit = true }` que el usuario tenía en su mapeo es ignorado silenciosamente por Lua. Esto viene del commit `f6e1efd feat(prompt): replace opts.submit with ending space` (en v1), que eliminó la opción `submit` en favor de la convención "termina en espacio para no enviar". En v2 ya no existe.

## Limpieza cosmética aplicada

`~/.config/nvim/lua/plugins/opencode.lua`, línea 26:

```diff
- require("opencode").ask("@this: ", { submit = true })
+ require("opencode").ask("@this: ")
```

El resto del mapeo queda intacto.

## Opción B aplicada: `server.url` como función

Se añadió a `vim.g.opencode_opts.server` un campo `url` que el plugin reconoce como punto de entrada directo al servidor. La función se llama en cada `ask()` / cada toggle, así no se quedan pegados el puerto ni el password después de un restart del servicio.

```lua
local function resolve_running_service()
    local path = vim.fs.joinpath(vim.fn.stdpath("state"), "opencode", "service.json")
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok or not lines or #lines == 0 then
        return nil
    end
    local decoded_ok, decoded = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
    if not decoded_ok or type(decoded) ~= "table" or type(decoded.url) ~= "string" then
        return nil
    end
    return decoded
end

vim.g.opencode_opts = {
    server = {
        url = function(callback)
            local svc = resolve_running_service()
            if not svc then
                return callback(nil)
            end
            local cfg_ok, cfg = pcall(require, "opencode.config")
            if cfg_ok and cfg.opts and cfg.opts.server and svc.password then
                cfg.opts.server.password = svc.password
            end
            callback(svc.url)
        end,
        start = function()
            require("snacks.terminal").open(opencode_cmd, opencode_term_opts)
        end,
    },
}
```

### Qué cambia en el flujo

- `<C-.>` (toggle): al configurar `url`, `opencode.nvim` descubre el servidor vía `service.json` directamente, sin pasar por `start()`. Esto significa que tu `start` que abre snacks.terminal ya **no** se invocará mientras el servicio esté vivo, lo cual era exactamente el problema conceptual: querías que la TUI viva dentro de Neovim, pero `start` solo se ejecutaba al primer arranque.
- `<C-a>` (ask): la promesa sigue resolviendo contra ese mismo servidor, así que las respuestas aparecerán donde sea que esté el cliente TUI conectado.
- Reinicio del servicio: `service.json` se sobrescribe en cada restart con un puerto y password nuevos. Como la función los relee cada vez, no hay que tocar nada manualmente.

### Por qué mutar `cfg.opts.server.password`

`Server.new` (`opencode/server/init.lua`, línea 75) hace:

```lua
self.password = creds.password or config.password
```

Si no tenemos credenciales explícitas y `config.password` es `nil`, la autenticación básica contra el servidor v2 (`http://127.0.0.1:<port>`) rechaza con 401. La mutación del campo password en el `opts` cacheado se hace antes de cada `callback`, así garantizamos que `Server.new` siempre use el password más reciente.

## Nota sobre reiniciar la terminal

Sí, cerrar y reabrir la terminal basta para que `lazy.nvim` recargue `opencode.nvim` con el cambio de la línea 26 (necesita un restart de Neovim, no del shell). Pero el problema *conceptual* (que `<C-a>` ya no abre la TUI dentro de Neovim) **no se resuelve sólo con reiniciar**, porque:

- Sigue habiendo un proceso `opencode serve` corriendo como background service — para arrancarlo de nuevo tienes que iniciarlo en alguna parte (la snacks.terminal con `<C-.>` o desde la línea de comandos en otra ventana).
- Si reiniciás la shell, el PID 37187 (la TUI standalone) también muere, así que tenés que decidir *dónde* querés que viva la TUI. Lo más limpio: mantenerla dentro de Neovim (con `<C-.>` + el ajuste de `start`) y olvidarte de la ventana externa.
