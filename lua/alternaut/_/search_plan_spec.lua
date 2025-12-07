local plan = require('alternaut._.search_plan')

describe('search_plan', function()
  describe('get_alternate_search_path', function()
    it('should return a list of search paths', function()
      local result = plan.get_alternate_search_path('foo/bar/baz.c', {
        patterns = { { template = '{name}.{ext}' } },
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
        patterns = {
          { template = '{name}_test.{ext}' },
          { template = '{name}_spec.{ext}' },
        },
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
        patterns = { { template = '{name}.test.{ext}' } },
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
        patterns = {
          { template = '{name}.test.{ext}' },
          { template = '{name}.unit.{ext}' },
        },
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

    it('applies target transform when generating paths', function()
      local result = plan.get_alternate_search_path('/foo/MyButton.tsx', {
        patterns = {
          {
            template = '{name}.{ext}',
            transform = { origin = 'pascal', target = 'kebab' },
          },
        },
        directories = { '.' },
        extensions = {
          target = { 'css' },
          origin = { 'tsx' },
        },
      })

      assert.are.same({
        '/foo/my-button.css',
      }, result)
    end)
  end)

  describe('get_source_search_path', function()
    it('returns a list of possible locations for the source file', function()
      local result = plan.get_source_search_path('/foo/bar_spec.py', {
        patterns = { { template = '{name}_spec.{ext}' } },
        directories = { '.' },
        extensions = {
          target = { 'py' },
          origin = { 'py' },
        },
      })

      assert.are.same({
        '/foo/bar.py',
      }, result)
    end)

    it('searches the correct parent directories', function()
      local result =
        plan.get_source_search_path('/foo/__tests__/bar.test.ts', {
          patterns = { { template = '{name}.test.{ext}' } },
          directories = { '__tests__', '.' },
          extensions = {
            target = { 'ts' },
            origin = { 'ts' },
          },
        })

      assert.are.same({
        '/foo/bar.ts',
        '/foo/__tests__/bar.ts',
      }, result)
    end)

    -- The test could've jumped anywhere in the filesystem. We can't trace it
    -- back to an origin.
    it('skips absolute directories (unsolveable)', function()
      local result =
        plan.get_source_search_path('/foo/__tests__/bar.test.ts', {
          patterns = { { template = '{name}.test.{ext}' } },
          directories = { '/tmp', '__tests__' },
          extensions = {
            target = { 'ts' },
            origin = { 'ts' },
          },
        })

      assert.are.same({
        '/foo/bar.ts',
      }, result)
    end)

    it('applies origin transform when extracting source name', function()
      local result = plan.get_source_search_path('/foo/my-button.css', {
        patterns = {
          {
            template = '{name}.{ext}',
            transform = { origin = 'pascal', target = 'kebab' },
          },
        },
        directories = { '.' },
        extensions = {
          target = { 'css' },
          origin = { 'tsx' },
        },
      })

      assert.are.same({
        '/foo/MyButton.tsx',
      }, result)
    end)
  end)
end)
