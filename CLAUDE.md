## Development

- `just check` - Run all checks. Must pass before committing.

## Documentation

- Update `CHANGELOG.md` under `[Unreleased]` for user-facing changes.
- Keep `doc/alternaut.txt` in sync with API/config changes. Regenerate tags: `nvim --headless -c 'helptags doc' -c quit`
- Vim help syntax reference: `$VIMRUNTIME/doc/` (get path with `nvim --headless -c 'echo $VIMRUNTIME' -c quit 2>&1`)

## Releasing

- Run `just check` first. Abort if it fails.
- Move `[Unreleased]` changelog entries to a new version section with date.
- Update comparison links at the bottom of `CHANGELOG.md`.
- Create annotated tag: `git tag -a v0.X.Y -m "v0.X.Y"`
- Push with tags: `git push && git push --tags`
- Create GitHub release: `gh release create v0.X.Y --title "v0.X.Y" --notes "<changelog content>"`
