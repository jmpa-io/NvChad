local null_ls = require "null-ls"

return {
  sources = {
    -- C++: diagnostics only (formatting handled by clangd via lspconfig).
    null_ls.builtins.diagnostics.cppcheck,
  },
}
