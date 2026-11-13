vim.o.number = true
vim.o.relativenumber = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"
vim.o.autoread = true
vim.g.mapleader = ","
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")
local profile = vim.fn.stdpath("config") .. "/profile"
vim.g.profile = vim.env.NVIM_PROFILE or (vim.fn.filereadable(profile) == 1 and vim.fn.readfile(profile)[1]) or "personal"

vim.keymap.set('n', '<leader>s', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':wq<CR>')
vim.keymap.set('n', '<leader>di', ':set digraph<CR>')
vim.keymap.set('n', '<leader>id', ':set nodigraph<CR>')
vim.keymap.set('n', '<leader>[', ':bprevious<CR>')
vim.keymap.set('n', '<leader>]', ':bnext<CR>')
vim.keymap.set('n', '<leader>x', ':bdelete<CR>')

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, { command = "checktime" })

--Plugins

vim.pack.add({
	{ src = "git@github.com:vague-theme/vague.nvim.git" },
	{ src = "git@github.com:nvim-mini/mini.pick.git" },
	{ src = "git@github.com:nvim-mini/mini.statusline.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/echasnovski/mini.completion" },
	{ src = "git@github.com:neovim/nvim-lspconfig.git" },
	{ src = "git@github.com:nvim-treesitter/nvim-treesitter.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "git@github.com:lervag/vimtex.git" },
	{ src = "git@github.com:chomosuke/typst-preview.nvim.git" },
	{ src = "https://github.com/Julian/lean.nvim" },
	{ src = "https://github.com/benlubas/molten-nvim" },
	{ src = "https://github.com/3rd/image.nvim" },
})

-- Default latexmk to LuaLaTeX (trbdoc.cls requires it); override per file with `%! TEX program = pdflatex`.
vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_image_location = "float"
vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = true
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true

require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  integrations = {},
  max_width = 100,
  max_height = 12,
  max_width_window_percentage = math.huge,
  max_height_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})

require("lean").setup({
  mappings = true,
  infoview = { autoopen = true },
})

require("mini.pick").setup()
require("mini.statusline").setup()
require("mini.icons").setup()
require("mini.completion").setup()
require("oil").setup()
require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

vim.lsp.config("rust_analyzer", {
  settings = { ["rust-analyzer"] = { inlayHints = { enable = true } } },
})
vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
vim.lsp.enable({ "pyright", "rust_analyzer", "texlab", "tinymist", "lua_ls", "clangd" })

vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>,', ':Oil<CR>')

-- Aesthetic options

vim.cmd("colorscheme vague")
vim.opt.fillchars:append({ eob = " " })

--Molten commands--

vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true })
vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { silent = true })
vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>ip", { silent = true })
vim.keymap.set("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true })
vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { silent = true })
vim.keymap.set("n", "<leader>mO", ":noautocmd MoltenEnterOutput<CR>", { silent = true })
vim.keymap.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { silent = true })

--LSPs--

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

--FileType specific commands.

local function template(name)
  return function()
    vim.cmd("0r " .. vim.fn.fnameescape(vim.fn.stdpath("config") .. "/templates/" .. name))
    vim.cmd.normal({ args = { "G" }, bang = true })
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function()
    vim.keymap.set("n", "<leader>tp", function()
      local inpath = vim.api.nvim_buf_get_name(0)
      vim.system({ "typst", "compile", inpath, (inpath:gsub("%.typ$", ".pdf")) })
    end, { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>tv", "<cmd>TypstPreview<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>tt", template("typst_article.typ"), { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>lC", "<cmd>VimtexClean<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>tt", template("latex_article.tex"), { buffer = true, silent = true })
    if vim.g.profile == "work" then
      vim.keymap.set("n", "<leader>tn", template("trb_note.tex"), { buffer = true, silent = true })
    end
  end,
})
