return {
  {
    {
      'saghen/blink.cmp',
      enabled = true,
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      version = '*',

      opts = {
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },

        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },

        signature = { enabled = true },

        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
    }
  }
}
