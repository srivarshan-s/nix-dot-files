{ config, pkgs, ... }:

{
  home.username = "sri";
  home.homeDirectory = "/home/sri";

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = [

    # Python
    pkgs.python3

    # Sys utils
    pkgs.wget
    pkgs.htop
    pkgs.exa
    pkgs.bat
    pkgs.ripgrep
    pkgs.gcc
    pkgs.zip
    pkgs.unzip

    # Terminal prompt
    pkgs.starship

    # Rust
    pkgs.rustup

  ];

  # Automatically set environment variables on non-NixOS linux
  targets.genericLinux.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
  	enable = true;
	userName = "srivarshan-s";
	userEmail = "srivarshan02@gmail.com";
	extraConfig = {
		core = { editor = "nvim"; };
	};
  };

  programs.tmux = {
	enable = true;
	sensibleOnTop = false;
	shortcut = "a";
	mouse = true;
	escapeTime = 0;
	baseIndex = 1;
	historyLimit = 3000;
	clock24 = true;
	keyMode = "vi";
	terminal = "xterm-256color";
	extraConfig = ''
# SWITCH PANES SING Alt-arrow WITHOUT PREFIX
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# SWITCH WINDOWS WITH ALT-NUM, WITHOUT PREFIX
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3
bind-key -n M-4 select-window -t 4
bind-key -n M-5 select-window -t 5
bind-key -n M-6 select-window -t 6
bind-key -n M-7 select-window -t 7
bind-key -n M-8 select-window -t 8
bind-key -n M-9 select-window -t 9
	'';
  };

  programs.neovim = {
	enable = true;
	viAlias = true;
	vimAlias = true;
	withNodeJs = true;
	withRuby = true;
	withPython3 = true;
	extraLuaConfig = ''

-- Install packer.nvim if not installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local first_install = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    first_install = true
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end

-- REMAPS
-- Set leader key (space)
vim.g.mapleader = " "
-- Set space+e to open netrw (the file explorer)
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
-- Set space+y to copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
-- Paste without copying highlighted region
vim.keymap.set("x", "<leader>p", "\"_dP")

-- SET OPTIONS
-- Set local variable for conciseness
local opt = vim.opt
-- Line numbers
opt.nu = true
opt.relativenumber = true
-- 4 space indents
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
-- Smart indents
opt.smartindent = true
-- Line wrap
opt.wrap = false
-- Undo
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
-- Word search
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
-- opt.isfname:append("@-@")
opt.updatetime = 50
-- Colorcolumn to serve as boundary for lengthy lines
opt.colorcolumn = "80"
-- Cursorline
opt.cursorline = true
-- Set the leader key to <space>
vim.g.mapleader = " "

-- PACKER
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
    -- Telescope (fuzzy file finder)
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
	-- Fancy statusline
	use 'nvim-lualine/lualine.nvim'
    -- Gruvbox color scheme
    use 'sainnhe/gruvbox-material'
    -- Treesitter
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    -- Undo tree
    use 'mbbill/undotree'
    -- Auto commenter
    use 'numToStr/Comment.nvim'
    -- Auto brackets
    use "windwp/nvim-autopairs"
    -- Git plugins
    use 'lewis6991/gitsigns.nvim' -- Git signs display on buffer
    -- Zen mode
    use 'folke/zen-mode.nvim'
    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
end)

-- LSP
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.ensure_installed({
    'lua_ls',
    'tsserver',
    'eslint',
    'rust_analyzer',
})
-- Fix Undefined global 'vim'
lsp.nvim_workspace()
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})
lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end
    -- Press "gd" in normal mode to go to definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    -- Press "K" in normal mode to dispay information on the object
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    -- Press "<space>vd" in normal mode to dispay error and warning 
    -- diagnostics
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    -- Press "]d" in normal mode to goto next warning or error
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    -- Press "[d" in normal mode to goto next warning or error
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    -- Press "<space>vca" in normal mode to dispay code actions for
    -- warning or error
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    -- Press "<space>vrr" in normal mode to dispay all references for
    -- selected object
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    -- Press "<space>vrn" in normal mode to rename all references for
    -- selected object
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    -- Apply code formatting for the current buffer
    vim.keymap.set("n", "<leader>ft", "<cmd>LspZeroFormat<CR>") 
end)
lsp.setup()
vim.diagnostic.config({
    virtual_text = true
})


-- ZEN-MODE
-- Zen mode setup
require("zen-mode").setup {
    window = {
        width = 90,
        options = {
            number = true,
            relativenumber = true,
        }
    },
}
-- Zen mode keymap
vim.keymap.set("n", "<leader>zm", function()
    require("zen-mode").toggle()
    vim.wo.wrap = false
end)


-- GIT-SIGNS
require('gitsigns').setup {
    signs                        = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil, -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm                         = {
        enable = false
    },
}

-- AUTO-BRACKETS
require('nvim-autopairs').setup()

-- TELESCOPE
local builtin = require('telescope.builtin')
-- Search among all files
vim.keymap.set('n', '<leader>pp', builtin.find_files, {})
-- Grep search among all files
vim.keymap.set('n', '<leader>ff', builtin.live_grep, {})
-- Search among all git files
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- COLORSCHEME
vim.cmd.colorscheme("gruvbox-material")

-- TREESITTER
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "javascript", "typescript", "bash", "cpp", "dockerfile", "fish", "go", "html", "java", "python" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- UNDOTREE
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- COMMENTS
require('Comment').setup(
{
    -- Add a space b/w comment and the line
    padding = true,
    -- Whether the cursor should stay at its position
    sticky = true,
    -- Lines to be ignored while (un)comment
    ignore = nil,
    -- LHS of toggle mappings in NORMAL mode
    toggler = {
        -- Line-comment toggle keymap
        line = '<C-_>',
        -- Block-comment toggle keymap
        block = 'gbc',
    },
    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        -- Line-comment keymap
        line = '<C-_>',
        -- Block-comment keymap
        block = 'gb',
    },
    -- LHS of extra mappings
    extra = {
        -- Add comment on the line above
        above = 'gcO',
        -- Add comment on the line below
        below = 'gco',
        -- Add comment at the end of line
        eol = 'gcA',
    },
    -- Enable keybindings
    -- NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        -- Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    -- Function to call before (un)comment
    pre_hook = nil,
    -- Function to call after (un)comment
    post_hook = nil,
}
)

-- LUALINE
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}


	'';
  };

  # Bash config
  home.file.".bashrc".text = ''
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History Customization
export HISTCONTROL="erasedups:ignorespace"

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# History Completion
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    fi
fi

# Replacing vi and vim with neovim
export VISUAL="nvim"
export EDITOR="nvim"

# Add ~/.local/bin/ to path
export PATH="$HOME/.local/bin/:$PATH"

# Add ~/.cargo/bin/ to path
export PATH="$HOME/.cargo/bin:$PATH"

# Customize prompt
PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W\[\033[00m\] % '

# Starship Prompt
if which starship > /dev/null 2>&1
then
    eval "$(starship init bash)"
fi

# Custom functions
git-credential-store () {
    git config credential.helper store
}

# Allow for non-free nix packages
export NIXPKGS_ALLOW_UNFREE=1
  '';

  # Bash aliases
  home.file.".bash_aliases".text = ''
# ls
alias ls='exa --color=auto'
alias ll='exa -alF'

# grep
alias grep='rg'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# tmux
alias tmux="tmux -u"
  '';
}
