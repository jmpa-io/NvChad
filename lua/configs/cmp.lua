-- Extends NvChad's default cmp config to add copilot as a source.
local M = {}

M.setup = function()
  local cmp = require "cmp"
  local existing = cmp.get_config()

  -- Prepend copilot to the existing sources.
  local sources = {
    { name = "copilot", group_index = 1 },
  }
  for _, source in ipairs(existing.sources or {}) do
    table.insert(sources, source)
  end

  cmp.setup { sources = sources }
end

return M
