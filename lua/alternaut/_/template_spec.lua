local template = require('alternaut._.template')

describe('template', function()
  describe('render', function()
    it('renders variables into a string', function()
      local str = 'Hello, {name}!'
      local vars = { name = 'world' }

      local result = template.render(str, vars)

      assert.are.equal('Hello, world!', result)
    end)

    it('renders multiple variables into a string', function()
      local str = '{name}_spec.{ext}'
      local vars = { name = 'foo', ext = 'py' }

      local result = template.render(str, vars)

      assert.are.equal('foo_spec.py', result)
    end)

    it('can render the same variable multiple times', function()
      local str = '{name} {name} {name}'
      local vars = { name = 'foo' }

      local result = template.render(str, vars)

      assert.are.equal('foo foo foo', result)
    end)

    it('fails if a variable is missing', function()
      local str = '{no_such_var}'

      local fail = function()
        template.render(str, {})
      end

      assert.has_error(
        fail,
        'alternaut: pattern contains unknown variable: {no_such_var}'
      )
    end)
  end)

  describe('extract_name', function()
    it('extracts the name from a filename', function()
      local filename = 'foo_spec.py'
      local pattern = '{name}_spec.{ext}'

      local result = template.extract_name(filename, pattern)

      assert.are.equal('foo', result)
    end)

    it('extracts the name from a filename with multiple parts', function()
      local filename = 'foo_bar_spec.py'
      local pattern = '{name}_spec.{ext}'

      local result = template.extract_name(filename, pattern)

      assert.are.equal('foo_bar', result)
    end)

    it('extracts the name when using a prefix', function()
      local filename = 'test_foo.py'
      local pattern = 'test_{name}.{ext}'

      local result = template.extract_name(filename, pattern)

      assert.are.equal('foo', result)
    end)

    it('extracts the name when using a prefix and suffix', function()
      local filename = 'test_foo_bar.unit.py'
      local pattern = 'test_{name}.unit.{ext}'

      local result = template.extract_name(filename, pattern)

      assert.are.equal('foo_bar', result)
    end)

    it('parses the name from cursed filenames', function()
      local filename = '+?[]()..foo-bar+?[]().py'
      local pattern = '+?[]()..{name}+?[]().{ext}'

      local result = template.extract_name(filename, pattern)

      assert.are.equal('foo-bar', result)
    end)
  end)
end)
