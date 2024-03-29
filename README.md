# My Personal Neovim Configuration
This neovim configuration was heavly inspired by the [LazyVim](https://github.com/LazyVim/LazyVim) neovim configuration.

## Plugin Manager
- The [💤lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

## Autocompletion
This config uses the built in lsp as its autocompletion with luasnip for snippets. ~~Some languages also
use [coc.nvim](https://github.com/neoclide/coc.nvim) instead.~~

### Special languages
```
Java - Currently broken because JDTLS wont work
```

## Theme
I am using a modified [monokai pro](https://monokai.pro/) theme based from the
[monokai.nvim](https://github.com/tanvirtin/monokai.nvim) vim colorscheme.

## Requirements
- Neovim >= **0.9.0**
- Git >= **2.19.0**
- [RipGrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf)
- [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) [Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono) **(optional)**

## Notes

### Windows
- ~~On windows (right now) to use treesitters [**html** and **yaml** parsers](https://github.com/nvim-treesitter/nvim-treesitter/issues/3587)
you need to remove the `libstdc++-6.dll`
file in neovim's installiation files. (This is to make it use the system installed one **MAKE SURE TO HAVE gcc INSTALLED**)~~

### WSL
- I would recommend to install [GWSL](https://opticos.github.io/gwsl/) for its clipboard sync feature

## Installation

- Make a backup of your prevous config
- `git clone` this repository into your neovim config path (Linux: `~/.config/nvim`, Windows: `C:\Users\[Your Name]\AppData\Local\nvim`)
- Start neovim and wait
- 🎉 Congratulations you now have my configuration installed!
