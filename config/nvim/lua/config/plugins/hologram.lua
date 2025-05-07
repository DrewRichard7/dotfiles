return {
  {
    'edluffy/hologram.nvim',
    enabled = false,
    config = function()
      require 'hologram'.setup {
        auto_display = true
      }
    end
  }
}
