return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
        "-DCMAKE_C_COMPILER=/opt/homebrew/bin/gcc-16",
        "-DCMAKE_CXX_COMPILER=/opt/homebrew/bin/g++-16",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local clangd = opts.servers.clangd
      clangd.cmd = clangd.cmd or { "clangd" }
      table.insert(clangd.cmd, "--query-driver=/opt/homebrew/bin/gcc-16,/opt/homebrew/bin/g++-16")
    end,
  },
}
