vim.o.number = true
vim.o.relativenumber = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.digraph = true
vim.o.tabstop = 4
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"
vim.g.mapleader = "," 

vim.keymap.set('n', '<leader>s', ':w<CR>')
vim.keymap.set('n','<leader>q', ':w<CR> :q<CR>')


--Plugins

vim.pack.add({
	{ src = "git@github.com:vague-theme/vague.nvim.git" },
	{ src = "git@github.com:nvim-mini/mini.pick.git" },
	{ src = "git@github.com:nvim-mini/mini.statusline.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
    { src = "git@github.com:neovim/nvim-lspconfig.git" },
    { src = "git@github.com:chomosuke/typst-preview.nvim.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/Julian/lean.nvim" },
	{ src = "git@github.com:lervag/vimtex.git" },
	{ src = "git@github.com:nvim-treesitter/nvim-treesitter.git" },
	{ src = "git@github.com:nvim-neorg/neorg.git" },
    { src = "git@github.com:nvim-neorg/lua-utils.nvim.git" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/pysan3/pathlib.nvim" },
})

require("lean").setup({
  mappings = true,
  infoview = { autoopen = true },
})

require("mini.pick").setup()
require("mini.statusline").setup()
require("mini.icons").setup()
require("oil").setup()

require("nvim-treesitter.configs").setup({ highlight = { enable = true } })
require("neorg").setup({
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = { notes = "~/notes" },
        default_workspace = "notes",
      },
    },
    ["core.journal"] = { config = { strategy = "flat" } }, -- uses notes/journal/
  },
})

vim.lsp.config("pyright", {})
vim.lsp.enable("pyright")

vim.lsp.config("rust_analyzer", {})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("texlab", {})
vim.lsp.enable("texlab")

vim.lsp.config("tinymist", {})
vim.lsp.enable("tinymist")

vim.lsp.config("lua_ls", {})
vim.lsp.enable("lua_ls")

vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>oil', ':Oil<CR>')

-- Aesthetic options

vim.cmd("colorscheme vague")
vim.opt.fillchars:append({ eob = " " })

--FileType specific commands.

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function()
    vim.keymap.set("n", "<leader>tp", function()
      local inpath = vim.api.nvim_buf_get_name(0)
      local outpath = inpath:gsub("%.typ$", ".pdf")
      vim.system({ "typst", "compile", inpath, outpath })
    end, { buffer = true, silent = true, desc = "Typst: compile to PDF" })

    vim.keymap.set("n", "<leader>tv", "<cmd>TypstPreview<CR>",
      { buffer = true, silent = true, desc = "Typst: live preview" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(ev)
    local tmpl = vim.fn.stdpath("config") .. "/templates/typst_article.typ"
    vim.keymap.set("n", "<leader>tt", function()
      if vim.fn.filereadable(tmpl) == 0 then
        vim.notify("Template not found: " .. tmpl, vim.log.levels.ERROR); return
      end
      vim.cmd("0r " .. vim.fn.fnameescape(tmpl))
      vim.cmd.normal({ args = { "G" }, bang = true })
    end, { buffer = ev.buf, silent = true, desc = "Insert Typst template" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()
    vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>",
      { buffer = true, silent = true, desc = "LaTeX: compile (vimtex)" })
    vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>",
      { buffer = true, silent = true, desc = "LaTeX: view PDF (vimtex)" })
    vim.keymap.set("n", "<leader>lC", "<cmd>VimtexClean<CR>",
      { buffer = true, silent = true, desc = "LaTeX: clean aux (vimtex)" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function(ev)
    local tmpl = vim.fn.stdpath("config") .. "/templates/latex_article.tex"
    vim.keymap.set("n", "<leader>tt", function()
      if vim.fn.filereadable(tmpl) == 0 then
        vim.notify("Template not found: " .. tmpl, vim.log.levels.ERROR); return
      end
      vim.cmd("0r " .. vim.fn.fnameescape(tmpl))
      vim.cmd.normal({ args = { "G" }, bang = true })
    end, { buffer = ev.buf, silent = true, desc = "Insert LaTeX template" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "norg",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
	vim.opt_local.textwidth = 80
	vim.keymap.set("n", "<leader>nn", "<cmd>Neorg index<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>nj", "<cmd>Neorg journal today<CR>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { buffer = ev.buf, silent = true })
    vim.keymap.set("i", "<Tab>",     function() return vim.fn.pumvisible()==1 and "<C-n>" or "<Tab>" end,
      { buffer = ev.buf, expr = true, silent = true })
    vim.keymap.set("i", "<S-Tab>",   function() return vim.fn.pumvisible()==1 and "<C-p>" or "<S-Tab>" end,
      { buffer = ev.buf, expr = true, silent = true })
  end,
})
