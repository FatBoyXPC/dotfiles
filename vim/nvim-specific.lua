local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.phpactor.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
        ["indexer.poll_time"] = 10000,
        ["logging.enabled"] = true,
        ["logging.fingers_crossed"] = false,
        ["logging.path"] = "/tmp/phpactor.log",
        ["logging.level"] = "debug",
        ["logging.formatter"] = "pretty"
    }
}

local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

builtin.lsp_document_methods = function ()
    builtin.lsp_document_symbols({
            prompt_title = 'LSP Document Methods',
            symbols = { 'method' },
            symbol_width = 25,
            symbol_type_width = 0,
            show_line = true,
        })

end

builtin.laravel_picker = function ()
  builtin.find_files({
    prompt_title = 'Laravel Vendor Files',
    no_ignore = true,
    hidden = true,
    search_dirs = { 'vendor/laravel' },
  })
end

local custom_actions = {}
custom_actions.select_file_and_accept_method = function (prompt_bufnr)
  require('telescope.actions').select_default(prompt_bufnr)
  builtin.lsp_document_methods()
end

telescope.setup {
    defaults = {
        prompt_prefix = '  ',
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
        },
        mappings = {
            i = {
                ['<C-a>'] = actions.toggle_all,
                ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
        },
        file_ignore_patterns = { 'node_modules', '.DS_Store', 'resources/dist', '.git', 'storage/framework' },
    },
    pickers = {
        find_files = {
            prompt_title = 'All Files',
            no_ignore = true,
            hidden = true,
        },
        git_files = {
            mappings = {
                i = {
                    ["@"] = custom_actions.select_file_and_accept_method,
                }
            }
        },
        current_buffer_fuzzy_find = {
            prompt_title = 'Current Buffer Lines',
        },
        oldfiles = {
            prompt_title = 'History',
        },
        buffers = {
            mappings = {
                i = {
                    ["<C-x>"] = "delete_buffer",
                }
            }
        },
    },
    extensions = {
        live_grep_args = {
            prompt_title = 'Live Ripgrep',
            mappings = {
                i = {
                    ["<C-k>"] = require('telescope-live-grep-args.actions').quote_prompt(),
                }
            }
        }
    },
}

telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')
telescope.load_extension('ui-select')

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

local cmp = require 'cmp'
local compare = require('cmp.config.compare')

cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            -- ensure detail is shown (e.g. the class FQN)
            -- vim_item.menu = entry.completion_item.detail
            return vim_item
        end
    },
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        compare.sort_text,
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        compare.kind,
        compare.length,
        compare.order,
      },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'path', option = {
                get_cwd = function ()
                    return vim.fn.getcwd()
                end
        } },
        { name = 'buffer' },
    }
}
