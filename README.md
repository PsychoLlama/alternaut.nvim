<div align="center">
  <h1>alternaut.nvim</h1>

  <a href="https://github.com/PsychoLlama/alternaut.nvim/actions?query=workflow%3ATest">
    <img src="https://github.com/PsychoLlama/alternaut.nvim/workflows/Test/badge.svg" alt="Build Status" />
  </a>

  <p>Jump between your test and source files.</p>
</div>

## Example

Say you've got a project structure like this:

```
src/
  __tests__/
    logic.test.js
    foo.test.js
  logic.js
  foo.js
```

and you're editing `src/foo.js`. You want to open the test file.

That's where alternaut comes in. Hit the keybinding and you're in
`src/__tests__/foo.test.js`. Toggle again and you're right back in the other
file.

## Configuration

Alternaut doesn't make any assumptions about your project structure. You need
to tell it your conventions. What do you name your test directories? What do
you name your test files? That kind of thing.

```viml
" A typical JavaScript setup.
let alternaut#conventions = {}
let alternaut#conventions['javascript'] = {
\   'directory_naming_conventions': ['__tests__', 'tests'],
\   'file_naming_conventions': ['{name}.test.{ext}', '{name}.spec.{ext}'],
\   'file_extensions': ['js', 'jsx'],
\ }
```

Once that's registered, create a mapping:

```viml
nmap <leader>a <Plug>(alternaut-toggle)
```

Any time you open a `javascript` file, press `<leader>a` and it'll toggle
between the corresponding test and source file.

## [Documentation](https://github.com/PsychoLlama/alternaut.nvim/blob/main/doc/alternaut.txt)

The way of our people is [help files](https://github.com/PsychoLlama/alternaut.nvim/blob/main/doc/alternaut.txt).

```viml
:help alternaut
```
