-- Extends NvChad's default cmp config to add copilot + async path as sources.
local M = {}

M.setup = function()
  local cmp = require "cmp"
  local existing = cmp.get_config()

  -- Build sources: keep existing NvChad sources, add async path + copilot.
  local sources = {}
  for _, source in ipairs(existing.sources or {}) do
    -- Replace cmp-path with cmp-async-path for non-blocking file completion.
    if source.name ~= "path" then
      table.insert(sources, source)
    end
  end
  table.insert(sources, { name = "async_path" })
  table.insert(sources, { name = "copilot", group_index = 2, priority = 100 })

  cmp.setup { sources = sources }
end

return M
