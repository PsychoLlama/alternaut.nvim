local path = require('alternaut._.path')

describe('path', function()
  describe('.parse', function()
    it('can parse an absolute path', function()
      local parsed = path.parse('/home/user/.config/nvim/init.lua')
      assert.are.same({
        parent = '/home/user/.config/nvim',
        name = 'init',
        ext = 'lua',
      }, parsed)
    end)

    it('can parse a relative path', function()
      local parsed = path.parse('init.lua')
      assert.are.same({
        parent = '.',
        name = 'init',
        ext = 'lua',
      }, parsed)
    end)
  end)

  describe('.is_absolute', function()
    it('returns true for an absolute path', function()
      assert.is_true(path.is_absolute('/home/user/.config/nvim/init.lua'))
    end)

    it('returns false for a relative path', function()
      assert.is_false(path.is_absolute('init.lua'))
    end)
  end)

  describe('.is_relative', function()
    it('returns false for an absolute path', function()
      assert.is_false(path.is_relative('/home/user/.config/nvim/init.lua'))
    end)

    it('returns true for a relative path', function()
      assert.is_true(path.is_relative('init.lua'))
    end)
  end)

  describe('.join', function()
    it('can join paths', function()
      assert.are.equal(path.join('a', 'b', 'c'), 'a/b/c')
      assert.are.equal(path.join('a', 'b', 'c', 'd'), 'a/b/c/d')
      assert.are.equal(path.join('a', 'b', 'c', 'd', 'e'), 'a/b/c/d/e')
    end)

    it('can join paths with separators', function()
      assert.are.equal(path.join('a/', 'b/', 'c/'), 'a/b/c/')
      assert.are.equal(path.join('a/', 'b/', 'c/', 'd/'), 'a/b/c/d/')
      assert.are.equal(path.join('a/', 'b/', 'c/', 'd/', 'e/'), 'a/b/c/d/e/')
    end)

    it('can join paths with mixed separators', function()
      assert.are.equal(path.join('a/', 'b', 'c/'), 'a/b/c/')
      assert.are.equal(path.join('a/', 'b', 'c/', 'd'), 'a/b/c/d')
      assert.are.equal(path.join('a/', 'b', 'c/', 'd', 'e/'), 'a/b/c/d/e/')
    end)

    it('can join paths with empty strings', function()
      assert.are.equal(path.join('a', '', 'c'), 'a/c')
      assert.are.equal(path.join('a', '', 'c', ''), 'a/c/')
      assert.are.equal(path.join('a', '', 'c', '', 'e'), 'a/c/e')
    end)

    it('can join absolute paths', function()
      assert.are.equal(path.join('/a', 'b', 'c'), '/a/b/c')
      assert.are.equal(path.join('/a', 'b', 'c', 'd'), '/a/b/c/d')
      assert.are.equal(path.join('/a', 'b', 'c', 'd', 'e'), '/a/b/c/d/e')
    end)
  end)

  describe('.split', function()
    it('can split a path', function()
      assert.are.same(path.split('a/b/c'), { 'a', 'b', 'c' })
      assert.are.same(path.split('a/b/c/'), { 'a', 'b', 'c' })
      assert.are.same(path.split('a/b/c//'), { 'a', 'b', 'c' })
      assert.are.same(path.split('a/b/c///'), { 'a', 'b', 'c' })
      assert.are.same(path.split('a/b/c/d'), { 'a', 'b', 'c', 'd' })
      assert.are.same(path.split('a/b/c/d/'), { 'a', 'b', 'c', 'd' })
      assert.are.same(path.split('a/b/c/d//'), { 'a', 'b', 'c', 'd' })
      assert.are.same(path.split('a/b/c/d///'), { 'a', 'b', 'c', 'd' })
    end)

    it('can split an absolute path', function()
      assert.are.same(path.split('/a/b/c'), { '/', 'a', 'b', 'c' })
      assert.are.same(path.split('/a/b/c/'), { '/', 'a', 'b', 'c' })
      assert.are.same(path.split('/a/b/c//'), { '/', 'a', 'b', 'c' })
      assert.are.same(path.split('/a/b/c///'), { '/', 'a', 'b', 'c' })
      assert.are.same(path.split('/a/b/c/d'), { '/', 'a', 'b', 'c', 'd' })
      assert.are.same(path.split('/a/b/c/d/'), { '/', 'a', 'b', 'c', 'd' })
      assert.are.same(path.split('/a/b/c/d//'), { '/', 'a', 'b', 'c', 'd' })
      assert.are.same(path.split('/a/b/c/d///'), { '/', 'a', 'b', 'c', 'd' })
    end)
  end)
end)
