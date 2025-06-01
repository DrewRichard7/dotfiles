-- init.lua
vim.api.nvim_create_autocmd('BufNewFile,BufRead', {
  pattern = '*.ipynb',
  command = 'setlocal filetype=quarto',
})

return {
  {
    -- directly open ipynb files as quarto documents
    -- and convert back behind the scenes
    'GCBallesteros/jupytext.nvim',
    enabled = true,
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
        r = {
          extension = 'qmd',
          style = 'quarto',
          force_ft = 'quarto',
        },
      },
    },
  },
}
