## Development

- `just check` - Run all checks. Must pass before committing.

## Documentation

- Update `CHANGELOG.md` under `[Unreleased]` for user-facing changes.
- Keep `doc/alternaut.txt` in sync with API/config changes. Regenerate tags: `nvim --headless -c 'helptags doc' -c quit`
- Vim help syntax reference: `$VIMRUNTIME/doc/` (get path with `nvim --headless -c 'echo $VIMRUNTIME' -c quit 2>&1`)
