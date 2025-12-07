local provider = require('alternaut._.provider')

describe('provider', function()
  describe('get_matching_providers', function()
    --- @type alternaut.Provider
    local pytest = {
      patterns = { { template = '{name}_test.{ext}' } },
      directories = { 'tests', '.' },
      extensions = {
        origin = { 'py' },
        target = { 'py' },
      },
    }

    --- @type alternaut.Provider
    local vitest = {
      patterns = { { template = '{name}.test.{ext}' } },
      directories = { '__tests__' },
      extensions = {
        origin = { 'ts', 'tsx' },
        target = { 'ts', 'tsx' },
      },
    }

    it('returns plausible alternates', function()
      local matches =
        provider.get_matching_providers('/foo/bar/baz.py', { pytest, vitest })

      assert.are.same({ pytest }, matches.alternates)
      assert.are.same({}, matches.sources)
    end)

    it('infers test files from the name structure', function()
      local matches = provider.get_matching_providers(
        '/foo/bar/baz_test.py',
        { pytest, vitest }
      )

      assert.are.same({ pytest }, matches.sources)
      assert.are.same({}, matches.alternates)
    end)

    -- For example: if we're in a folder named `tests/`, it's a good bet we're
    -- in an alternate file not the source.
    it('clues from the directory to determine src vs target', function()
      local matches = provider.get_matching_providers(
        '/foo/bar/__tests__/baz.test.ts',
        { pytest, vitest }
      )

      assert.are.same({}, matches.alternates)
      assert.are.same({ vitest }, matches.sources)
    end)

    it('only considers a provider if the file extension matches', function()
      local matches = provider.get_matching_providers(
        '/foo/bar/__tests__/baz.test.js',
        { pytest, vitest }
      )

      assert.are.same({}, matches.alternates)
      assert.are.same({}, matches.sources)
    end)
  end)
end)
