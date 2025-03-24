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
end)
