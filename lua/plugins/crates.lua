return {
    'saecki/crates.nvim',
    ft = {"rust", "toml"},
    event = { "BufRead Cargo.toml" },
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
        require('crates').setup()
    end,
}
