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

    it('applies kebab transform to name', function()
      local str = '{name}.css'
      local vars = { name = 'MyButton' }

      local result = template.render(str, vars, 'kebab')

      assert.are.equal('my-button.css', result)
    end)

    it('applies snake transform to name', function()
      local str = '{name}.py'
      local vars = { name = 'MyButton' }

      local result = template.render(str, vars, 'snake')

      assert.are.equal('my_button.py', result)
    end)

    it('applies camel transform to name', function()
      local str = '{name}.ts'
      local vars = { name = 'my-button' }

      local result = template.render(str, vars, 'camel')

      assert.are.equal('myButton.ts', result)
    end)

    it('applies pascal transform to name', function()
      local str = '{name}.tsx'
      local vars = { name = 'my-button' }

      local result = template.render(str, vars, 'pascal')

      assert.are.equal('MyButton.tsx', result)
    end)

    it('fails on unknown transform', function()
      local str = '{name}'

      local fail = function()
        template.render(str, { name = 'foo' }, 'unknown')
      end

      assert.has_error(fail, 'alternaut: unknown transform: unknown')
    end)

    it('does not transform ext variable', function()
      local str = '{name}.{ext}'
      local vars = { name = 'MyComponent', ext = 'CSS' }

      local result = template.render(str, vars, 'kebab')

      -- Only name should be transformed, not ext
      assert.are.equal('my-component.CSS', result)
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

    it('applies origin transform to extracted name', function()
      local filename = 'my-button.css'
      local pattern = '{name}.{ext}'

      local result = template.extract_name(filename, pattern, 'pascal')

      assert.are.equal('MyButton', result)
    end)

    it('returns nil when pattern does not match', function()
      local filename = 'something-else.js'
      local pattern = '{name}.css'

      local result = template.extract_name(filename, pattern)

      assert.is_nil(result)
    end)

    it(
      'returns extracted name without transform when none provided',
      function()
        local filename = 'my-button.css'
        local pattern = '{name}.{ext}'

        local result = template.extract_name(filename, pattern)

        assert.are.equal('my-button', result)
      end
    )
  end)
end)
