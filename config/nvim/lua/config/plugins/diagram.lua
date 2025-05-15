return {
    {
        "3rd/diagram.nvim",
        enabled = false,
        dependencies = {
            "3rd/image.nvim",
        },
        config = function()
            require("diagram").setup({
                integrations = {
                    require("diagram.integrations.markdown"),
                    require("diagram.integrations.neorg"),
                },
                events = {
                    render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
                    clear_buffer = { "BufLeave" },
                },
                renderer_options = {
                    mermaid = {
                        background = "#001423", -- nil | "transparent" | "white" | "#hex"
                        theme = "dark",         -- nil | "default" | "dark" | "forest" | "neutral"
                        scale = 2,              -- nil | 1 (default) | 2  | 3 | ...
                        width = nil,            -- nil | 800 | 400 | ...
                        height = nil,           -- nil | 600 | 300 | ...
                    },
                    plantuml = {
                        charset = "utf-8",
                    },
                    d2 = {
                        theme_id = 1,
                    },
                    gnuplot = {
                        theme = "dark",
                        size = "800,600",
                    },
                },
            })
        end
    },
}
