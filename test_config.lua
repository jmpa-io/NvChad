-- test_nvim_config.lua
-- Validates Jordan's nvim config changes are correctly wired up.
-- Run with: nvim --headless -l /tmp/test_nvim_config.lua

local pass = 0
local fail = 0
local results = {}

local function ok(name, condition, detail)
  if condition then
    pass = pass + 1
    table.insert(results, { status = "PASS", name = name })
  else
    fail = fail + 1
    table.insert(results, { status = "FAIL", name = name, detail = detail or "" })
  end
end

-- ── mason.lua ────────────────────────────────────────────────────────────────

local mason_ok, mason = pcall(dofile, vim.fn.expand "~/.config/nvim/lua/configs/mason.lua")
ok("mason.lua loads without error", mason_ok, tostring(mason))

if mason_ok then
  local tools = {}
  for _, t in ipairs(mason.ensure_installed) do tools[t] = true end

  -- Ansible
  ok("mason: ansible-language-server present", tools["ansible-language-server"])
  ok("mason: ansible-lint present",            tools["ansible-lint"])

  -- Java
  ok("mason: jdtls present",               tools["jdtls"])
  ok("mason: java-debug-adapter present",  tools["java-debug-adapter"])
  ok("mason: java-test present",           tools["java-test"])
  ok("mason: google-java-format present",  tools["google-java-format"])
  ok("mason: checkstyle present",          tools["checkstyle"])

  -- Existing languages still present
  ok("mason: bash-language-server present",      tools["bash-language-server"])
  ok("mason: gopls present",                     tools["gopls"])
  ok("mason: pyright present",                   tools["pyright"])
  ok("mason: typescript-language-server present",tools["typescript-language-server"])
  ok("mason: rust-analyzer present",             tools["rust-analyzer"])
end

-- ── conform.lua ──────────────────────────────────────────────────────────────

local conform_ok, conform = pcall(dofile, vim.fn.expand "~/.config/nvim/lua/configs/conform.lua")
ok("conform.lua loads without error", conform_ok, tostring(conform))

if conform_ok then
  local fmts = conform.formatters_by_ft
  ok("conform: yaml.ansible formatted",        fmts["yaml.ansible"] ~= nil)
  ok("conform: ansible_lint in yaml.ansible",  vim.tbl_contains(fmts["yaml.ansible"] or {}, "ansible_lint"))
  ok("conform: prettier in yaml.ansible",      vim.tbl_contains(fmts["yaml.ansible"] or {}, "prettier"))
  ok("conform: java formatted",                fmts["java"] ~= nil)
  ok("conform: google_java_format in java",    vim.tbl_contains(fmts["java"] or {}, "google_java_format"))
  -- Existing formatters still intact
  ok("conform: go still formatted",     fmts["go"] ~= nil)
  ok("conform: python still formatted", fmts["python"] ~= nil)
  ok("conform: shell still formatted",  fmts["sh"] ~= nil)
end

-- ── lint.lua ─────────────────────────────────────────────────────────────────
-- lint.lua calls require("lint") which needs the plugin loaded — we parse it as text instead.

local lint_path = vim.fn.expand "~/.config/nvim/lua/configs/lint.lua"
local lint_src  = io.open(lint_path):read "*a"
ok("lint.lua exists and is readable",          lint_src ~= nil and #lint_src > 0)
ok("lint: yaml.ansible entry present",         lint_src:find('"yaml.ansible"') ~= nil)
ok("lint: ansible_lint referenced",            lint_src:find('"ansible_lint"') ~= nil or lint_src:find("ansible_lint") ~= nil)
ok("lint: java entry present", lint_src:find("[^a-z]java%s*=") ~= nil)
ok("lint: checkstyle referenced",              lint_src:find("checkstyle") ~= nil)

-- ── lazy.lua ─────────────────────────────────────────────────────────────────

local lazy_ok, lazy = pcall(dofile, vim.fn.expand "~/.config/nvim/lua/configs/lazy.lua")
ok("lazy.lua loads without error", lazy_ok, tostring(lazy))

if lazy_ok then
  local disabled = (lazy.performance and lazy.performance.rtp and lazy.performance.rtp.disabled_plugins) or {}
  local disabled_set = {}
  for _, p in ipairs(disabled) do disabled_set[p] = true end
  ok("lazy: ftplugin NOT in disabled_plugins", not disabled_set["ftplugin"],
    "ftplugin is still disabled — breaks per-filetype settings")
end

-- ── plugins/init.lua — text checks ───────────────────────────────────────────

local plugins_path = vim.fn.expand "~/.config/nvim/lua/plugins/init.lua"
local plugins_src  = io.open(plugins_path):read "*a"
ok("plugins/init.lua exists and is readable", plugins_src ~= nil and #plugins_src > 0)

ok("plugins: telescope-fzf-native present",   plugins_src:find("telescope%-fzf%-native") ~= nil)
ok("plugins: fzf extension loaded",           plugins_src:find('load_extension.*fzf') ~= nil or plugins_src:find('load_extension "fzf"') ~= nil)
ok("plugins: nvim-spectre present",           plugins_src:find("nvim%-spectre") ~= nil or plugins_src:find("nvim-spectre") ~= nil)
ok("plugins: spectre leader>S keybind",       plugins_src:find("<leader>S") ~= nil)
ok("plugins: todo-comments present",          plugins_src:find("todo%-comments") ~= nil or plugins_src:find("todo-comments") ~= nil)
ok("plugins: todo ]t keybind",                plugins_src:find("%]t") ~= nil)
ok("plugins: java DAP config present",        plugins_src:find("dap.configurations.java") ~= nil)
ok("plugins: java attach config present",     plugins_src:find('"attach"') ~= nil)
ok("plugins: groovy treesitter present",      plugins_src:find('"groovy"') ~= nil)
ok("plugins: jinja treesitter present",       plugins_src:find('"jinja"') ~= nil)
ok("plugins: jinja_inline treesitter present",plugins_src:find('"jinja_inline"') ~= nil)

-- ── lspconfig — text checks ───────────────────────────────────────────────────

local lsp_path = vim.fn.expand "~/.config/nvim/lua/configs/nvim-lspconfig.lua"
local lsp_src  = io.open(lsp_path):read "*a"
ok("nvim-lspconfig.lua exists and is readable", lsp_src ~= nil and #lsp_src > 0)

ok("lspconfig: ansiblels configured", lsp_src:find("ansiblels") ~= nil)
ok("lspconfig: ansiblels enabled",    lsp_src:find('enable "ansiblels"') ~= nil)
ok("lspconfig: jdtls configured",     lsp_src:find("jdtls") ~= nil)
ok("lspconfig: jdtls enabled",        lsp_src:find('enable "jdtls"') ~= nil)
ok("lspconfig: jdtls bundles wired",  lsp_src:find("java%-debug%-adapter") ~= nil)
ok("lspconfig: jdtls workspace set",  lsp_src:find("jdtls%-workspace") ~= nil)
ok("lspconfig: groovyls configured",  lsp_src:find("groovyls") ~= nil)
ok("lspconfig: groovyls enabled",     lsp_src:find('enable "groovyls"') ~= nil)
-- Existing servers still present
ok("lspconfig: gopls still present",  lsp_src:find("gopls") ~= nil)
ok("lspconfig: yamlls still present", lsp_src:find("yamlls") ~= nil)
ok("lspconfig: bashls still present", lsp_src:find("bashls") ~= nil)
ok("lspconfig: pyright still present",lsp_src:find("pyright") ~= nil)
ok("lspconfig: ts_ls still present",  lsp_src:find("ts_ls") ~= nil)

-- ── options.lua — text checks ─────────────────────────────────────────────────

local opts_path = vim.fn.expand "~/.config/nvim/lua/options.lua"
local opts_src  = io.open(opts_path):read "*a"
ok("options.lua exists and is readable",          opts_src ~= nil and #opts_src > 0)
ok("options: .j2 → jinja filetype detection",     opts_src:find("j2.*jinja") ~= nil)
ok("options: ansible yaml pattern detection",     opts_src:find("yaml%.ansible") ~= nil)
ok("options: roles/ pattern present",             opts_src:find("roles") ~= nil)
ok("options: tasks/ pattern present",             opts_src:find("tasks") ~= nil)
ok("options: playbooks/ pattern present",         opts_src:find("playbooks") ~= nil)

-- ── mason.lua — groovy ────────────────────────────────────────────────────────

if mason_ok then
  local tools = {}
  for _, t in ipairs(mason.ensure_installed) do tools[t] = true end
  ok("mason: groovy-language-server present", tools["groovy-language-server"])
end

-- ── Print results ─────────────────────────────────────────────────────────────

print ""
print "══════════════════════════════════════════════════"
print "  nvim config test results"
print "══════════════════════════════════════════════════"
for _, r in ipairs(results) do
  if r.status == "PASS" then
    print(string.format("  ✓  %s", r.name))
  else
    print(string.format("  ✗  %s", r.name))
    if r.detail and r.detail ~= "" then
      print(string.format("     → %s", r.detail))
    end
  end
end
print "══════════════════════════════════════════════════"
print(string.format("  %d passed, %d failed", pass, fail))
print "══════════════════════════════════════════════════"
print ""

vim.cmd "qa!"
