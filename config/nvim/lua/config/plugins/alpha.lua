return {
  'goolord/alpha-nvim',
  enabled = true,
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set header text and assign a custom highlight group
    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                   :andrew richard                   ',
    }
    dashboard.section.header.opts.hl = "AlphaHeader" -- assign custom hl group

    -- Set menu buttons
    dashboard.section.buttons.val = {
      dashboard.button('e', '  > New File', '<cmd>ene<CR>'),
      dashboard.button('SPC ff', '󰱼 > Find File', '<cmd>Telescope find_files<CR>'),
      dashboard.button('c', '  > Config', ':e $MYVIMRC | :cd %:p:h<cr>'),
      dashboard.button('q', ' > Quit NVIM', '<cmd>qa<CR>'),
    }

    -- Setup alpha with the dashboard options
    alpha.setup(dashboard.opts)

    -- Force custom highlight for AlphaHeader immediately.
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#C3E88D", bold = true })

    -- Disable folding on alpha buffer
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  end,
}
