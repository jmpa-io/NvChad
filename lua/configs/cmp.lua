-- Extends NvChad's default cmp config to add copilot as a source.
local M = {}

M.setup = function()
  local cmp = require "cmp"
  local existing = cmp.get_config()

  -- Copilot in group 2 so native LSP completions (group 1) show first.
  -- Copilot suggestions appear below LSP but above snippets.
  local sources = {}
  for _, source in ipairs(existing.sources or {}) do
    table.insert(sources, source)
  end
  table.insert(sources, { name = "copilot", group_index = 2, priority = 100 })

  cmp.setup { sources = sources }
end

return M
