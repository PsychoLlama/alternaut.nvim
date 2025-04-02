<div align="center">
  <h1>alternaut.nvim</h1>
  <p>Jump between related files</p>
</div>

## Overview

Alternaut jumps between sources files and "alternate" files, such as tests, styles, headers, templates, or any co-located file with a predictable naming convention.

> [!NOTE]
> This plugin used to be written in Vimscript. Since v0.6.0 the VimL implementation is deprecated and will be removed in a future release.

## Example

Say you're working in a python project with pytest. Your structure looks like this:

```
project/
  __init__.py
  fibonacci.py
  tests/
    __init__.py
    test_fibonacci.py
```

Tests are usually prefixed `test_` and placed in a `tests/` directory. They could also live in the same directory.

Tell Alternaut about these naming conventions by defining a provider:

```lua
require('alternaut').setup({
  modes = {
    test = {
      -- naming conventions for Pytest
      pytest = {
        patterns = { 'test_{name}.{ext}' },
        directories = { 'tests', '.' },
        extensions = { '.py' },
      },
    },
  },
})
```

When you're editing `project/fibonacci.py` and you run
`alternaut.toggle('test')`, alternaut will look for these paths:

- `project/tests/test_fibonacci.py`
- `project/test_fibonacci.py`

It opens the test file. Toggle again and you're back in `fibonacci.py`.

That's the gist of it. See [:help alternaut](https://github.com/PsychoLlama/alternaut.nvim/blob/main/doc/alternaut.txt) for details and specific examples.

## Non-Goals

Alternaut focuses on **co-located** files. If your conventions put files in wildly different parts of the file system, this plugin won't help you. An example is a project that puts all tests in a `$REPO/test/` directory and all sources under `$REPO/src/`.

## Installation

<details>
  <summary><strong>lazy.nvim</strong></summary>

```lua
{
  "PsychoLlama/alternaut.nvim",
  version = false,
  lazy = false, -- Already optimized for lazy loading
  config = function()
    require('alternaut').setup({
      -- ...
    })
  end,
}
```

</details>

<details>
  <summary><strong>mini.deps</strong></summary>

```lua
add({ source = 'PsychoLlama/alternaut.nvim' })
```

</details>

<details>
  <summary><strong>vim-plug</strong></summary>

```vim
Plug 'PsychoLlama/alternaut.nvim'
```

</details>

<details>
  <summary><strong>home-manager</strong></summary>

Alternaut is available as a flake:

```nix
# flake.nix
{
  inputs.alternaut-nvim.url = "github:PsychoLlama/alternaut.nvim";
}
```

```nix
# home-configuration.nix
programs.neovim = {
  plugins = [
    {
      plugin = flake-inputs.alternaut-nvim.packages.${pkgs.system}.default;
      type = "lua";
      config = ''
        require('alternaut').setup({
          -- ...
        })
      '';
    }
  ];
};
```

</details>

## Keybindings

No keybindings are included by default. Personally I like Alt-number keys but this is up to you.

```lua
-- Alt-0 to toggle between tests
vim.keymap.set('n', '<A-0>', function()
  require('alternaut').toggle('test')
end)

-- Alt-9 to toggle between styles
vim.keymap.set('n', '<A-9>', function()
  require('alternaut').toggle('style')
end)
```

## [Documentation](https://github.com/PsychoLlama/alternaut.nvim/blob/main/doc/alternaut.txt)

The way of our people is help files.

```viml
:help alternaut
```

## Recipes

These are some common configurations:

```lua
require('alternaut').setup({
  modes = {
    test = {
      vitest = {
        patterns = { '{name}.test.{ext}' },
        directories = { '__tests__' },
        extensions = { 'ts', 'tsx', 'js', 'jsx' },
      },

      pytest = {
        patterns = { 'test_{name}.{ext}', '{name}_test.{ext}' },
        directories = { 'tests', '.' },
        extensions = { 'py' },
      },

      rust = {
        patterns = { '{name}_test.{ext}', '{name}.{ext}' },
        directories = { 'tests', '.' },
        extensions = { 'rs' },
      },

      go = {
        patterns = { '{name}_test.{ext}' },
        directories = { '.' },
        extensions = { 'go' },
      },

      busted = {
        patterns = { '{name}_spec.{ext}' },
        directories = { '.', 'spec' },
        extensions = { 'lua' },
      },

      vader = {
        patterns = { '{name}.{ext}' },
        directories = { 'tests', '.' },
        extensions = {
          target = { 'vader' },
          origin = { 'vim' },
        },
      },
    },

    style = {
      css = {
        patterns = { '{name}.{ext}' },
        extensions = {
          target = { 'css', 'less', 'scss' },
          origin = { 'tsx', 'jsx', 'ts', 'js', 'html' },
        },
      },

      vanilla_extract = {
        patterns = { '{name}.css.{ext}' },
        extensions = {
          target = { 'ts', },
          origin = { 'tsx', 'ts' },
        },
      },
    },

    template = {
      vue = {
        patterns = { '{name}.vue' },
        extensions = {
          target = { 'vue' },
          origin = { 'ts', 'js' },
        },
      },

      svelte = {
        patterns = { '{name}.svelte' },
        extensions = {
          target = { 'svelte' },
          origin = { 'ts', 'js' },
        },
      },

      html = {
        patterns = { '{name}.html' },
        extensions = {
          target = { 'html' },
          origin = { 'ts', 'js' },
        },
      },
    },

    header = {
      c = {
        patterns = { '{name}.{ext}' },
        extensions = {
          target = { 'h', 'hpp', 'hh' },
          origin = { 'c', 'cpp', 'cc', 'm', 'mm' },
        },
      },
    },
  },
})
```

Pull requests are welcome for more examples.
