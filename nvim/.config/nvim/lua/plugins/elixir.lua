return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        elixirls = {
          cmd = { "elixir-ls" }, -- if installed via mise or Mason
        },
      },
    },
  },
}
