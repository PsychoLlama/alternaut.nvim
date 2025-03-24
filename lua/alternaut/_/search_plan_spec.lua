local plan = require('alternaut._.search_plan')

describe('search_plan', function()
  describe('get_alternate_search_path', function()
    it('should return a list of search paths', function()
      local result = plan.get_alternate_search_path('foo/bar/baz.c', {
        patterns = { '{name}.{ext}' },
        directories = { '.' },
        extensions = {
          target = { 'h' },
          origin = { 'c' },
        },
      })

      assert.are.same({
        'foo/bar/baz.h',
      }, result)
    end)

    it('can expand many patterns', function()
      local result = plan.get_alternate_search_path('/foo/bar.ts', {
        patterns = { '{name}_test.{ext}', '{name}_spec.{ext}' },
        directories = { '.' },
        extensions = {
          target = { 'ts', 'tsx' },
          origin = { 'ts', 'tsx' },
        },
      })

      assert.are.same({
        '/foo/bar_test.ts',
        '/foo/bar_test.tsx',
        '/foo/bar_spec.ts',
        '/foo/bar_spec.tsx',
      }, result)
    end)

    it('can expand many directories', function()
      local result = plan.get_alternate_search_path('/foo/bar.ts', {
        patterns = { '{name}.test.{ext}' },
        directories = { '__tests__', 'tests' },
        extensions = {
          target = { 'ts', 'tsx' },
          origin = { 'ts', 'tsx' },
        },
      })

      assert.are.same({
        '/foo/__tests__/bar.test.ts',
        '/foo/__tests__/bar.test.tsx',
        '/foo/tests/bar.test.ts',
        '/foo/tests/bar.test.tsx',
      }, result)
    end)

    it('searches patterns>directories>extensions in order', function()
      local result = plan.get_alternate_search_path('/foo/bar.ts', {
        patterns = { '{name}.test.{ext}', '{name}.unit.{ext}' },
        directories = { '__tests__', 'tests' },
        extensions = {
          target = { 'ts', 'tsx' },
          origin = { 'ts', 'tsx' },
        },
      })

      assert.are.same({
        '/foo/__tests__/bar.test.ts',
        '/foo/__tests__/bar.test.tsx',
        '/foo/tests/bar.test.ts',
        '/foo/tests/bar.test.tsx',
        '/foo/__tests__/bar.unit.ts',
        '/foo/__tests__/bar.unit.tsx',
        '/foo/tests/bar.unit.ts',
        '/foo/tests/bar.unit.tsx',
      }, result)
    end)
  end)
end)
