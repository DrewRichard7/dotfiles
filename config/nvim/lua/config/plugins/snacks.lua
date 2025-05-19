return {
  "folke/snacks.nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 5000,
    },
    picker = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
        relative = "editor",
      },
    },
  },
  keys = {
    -- {
    -- 	"<leader>n",
    -- 	function()
    -- 		Snacks.picker.notifications()
    -- 	end,
    -- 	desc = "Notification History",
    -- },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        if _G.dd == nil then
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
        end
        if _G.bt == nil then
          _G.bt = function()
            Snacks.debug.backtrace()
          end
        end
        if vim.print == nil or vim.print == print then
          vim.print = _G.dd
        end

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
