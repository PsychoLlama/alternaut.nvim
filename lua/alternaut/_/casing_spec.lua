local casing = require('alternaut._.casing')

describe('casing', function()
  describe('split_words', function()
    it('splits camelCase', function()
      assert.are.same({ 'my', 'Button' }, casing.split_words('myButton'))
    end)

    it('splits PascalCase', function()
      assert.are.same({ 'My', 'Button' }, casing.split_words('MyButton'))
    end)

    it('splits snake_case', function()
      assert.are.same({ 'my', 'button' }, casing.split_words('my_button'))
    end)

    it('splits kebab-case', function()
      assert.are.same({ 'my', 'button' }, casing.split_words('my-button'))
    end)

    it('handles acronyms in PascalCase', function()
      assert.are.same({ 'HTTP', 'Server' }, casing.split_words('HTTPServer'))
    end)

    it('handles acronyms at end', function()
      assert.are.same({ 'parse', 'XML' }, casing.split_words('parseXML'))
    end)

    it('handles single word', function()
      assert.are.same({ 'button' }, casing.split_words('button'))
    end)

    it('handles multiple consecutive delimiters', function()
      assert.are.same({ 'my', 'button' }, casing.split_words('my__button'))
    end)

    it('handles mixed delimiters', function()
      assert.are.same(
        { 'my', 'cool', 'button' },
        casing.split_words('my-cool_button')
      )
    end)

    it('handles numbers', function()
      assert.are.same({ 'button2' }, casing.split_words('button2'))
    end)
  end)

  describe('to_kebab', function()
    it('converts PascalCase to kebab-case', function()
      assert.are.equal('my-button', casing.to_kebab('MyButton'))
    end)

    it('converts camelCase to kebab-case', function()
      assert.are.equal('my-button', casing.to_kebab('myButton'))
    end)

    it('converts snake_case to kebab-case', function()
      assert.are.equal('my-button', casing.to_kebab('my_button'))
    end)

    it('keeps kebab-case unchanged', function()
      assert.are.equal('my-button', casing.to_kebab('my-button'))
    end)

    it('handles acronyms', function()
      assert.are.equal('http-server', casing.to_kebab('HTTPServer'))
    end)
  end)

  describe('to_snake', function()
    it('converts PascalCase to snake_case', function()
      assert.are.equal('my_button', casing.to_snake('MyButton'))
    end)

    it('converts camelCase to snake_case', function()
      assert.are.equal('my_button', casing.to_snake('myButton'))
    end)

    it('converts kebab-case to snake_case', function()
      assert.are.equal('my_button', casing.to_snake('my-button'))
    end)

    it('keeps snake_case unchanged', function()
      assert.are.equal('my_button', casing.to_snake('my_button'))
    end)
  end)

  describe('to_camel', function()
    it('converts PascalCase to camelCase', function()
      assert.are.equal('myButton', casing.to_camel('MyButton'))
    end)

    it('converts snake_case to camelCase', function()
      assert.are.equal('myButton', casing.to_camel('my_button'))
    end)

    it('converts kebab-case to camelCase', function()
      assert.are.equal('myButton', casing.to_camel('my-button'))
    end)

    it('keeps camelCase unchanged', function()
      assert.are.equal('myButton', casing.to_camel('myButton'))
    end)
  end)

  describe('to_pascal', function()
    it('converts camelCase to PascalCase', function()
      assert.are.equal('MyButton', casing.to_pascal('myButton'))
    end)

    it('converts snake_case to PascalCase', function()
      assert.are.equal('MyButton', casing.to_pascal('my_button'))
    end)

    it('converts kebab-case to PascalCase', function()
      assert.are.equal('MyButton', casing.to_pascal('my-button'))
    end)

    it('keeps PascalCase unchanged', function()
      assert.are.equal('MyButton', casing.to_pascal('MyButton'))
    end)
  end)

  describe('transforms table', function()
    it('contains all expected transforms', function()
      assert.is_not_nil(casing.transforms.kebab)
      assert.is_not_nil(casing.transforms.snake)
      assert.is_not_nil(casing.transforms.camel)
      assert.is_not_nil(casing.transforms.pascal)
    end)
  end)

  describe('get_transform_names', function()
    it('returns sorted list of transform names', function()
      local names = casing.get_transform_names()
      assert.are.same({ 'camel', 'kebab', 'pascal', 'snake' }, names)
    end)
  end)
end)
