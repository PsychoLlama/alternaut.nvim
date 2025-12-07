local cfg = require('alternaut._.config')

describe('set_config', function()
  before_each(function()
    cfg.set_config()
  end)

  it('ensures required top-level fields exist', function()
    cfg.set_config({})

    assert.are.same({}, cfg.get_config().modes)
  end)

  it('does not mutate the input', function()
    local input = {}
    cfg.set_config(input)

    assert.are.same({}, input)
    assert.are_not.equal(input, cfg.get_config())
  end)

  it('normalizes providers', function()
    cfg.set_config({
      modes = {
        style = {
          css = {
            patterns = { '{name}_spec.{ext}' },
            extensions = { 'py' },
          },
        },
      },
    })

    assert.are.same({
      patterns = { { template = '{name}_spec.{ext}' } },
      directories = { '.' },
      extensions = {
        target = { 'py' },
        origin = { 'py' },
      },
    }, cfg.get_config().modes.style.css)
  end)

  it('trims leading `.` from extensions', function()
    cfg.set_config({
      modes = {
        style = {
          css = {
            patterns = { '{name}_spec.{ext}' },
            extensions = {
              target = { '.py' },
              origin = { '.py' },
            },
          },
        },
      },
    })

    assert.are.same({
      patterns = { { template = '{name}_spec.{ext}' } },
      directories = { '.' },
      extensions = {
        target = { 'py' },
        origin = { 'py' },
      },
    }, cfg.get_config().modes.style.css)
  end)

  it('normalizes directory paths', function()
    cfg.set_config({
      modes = {
        style = {
          css = {
            patterns = { '{name}_spec.{ext}' },
            directories = { './tests' },
            extensions = { 'py' },
          },
        },
      },
    })

    assert.are.same({
      patterns = { { template = '{name}_spec.{ext}' } },
      directories = { 'tests' },
      extensions = {
        target = { 'py' },
        origin = { 'py' },
      },
    }, cfg.get_config().modes.style.css)
  end)

  it('normalizes pattern objects with transforms', function()
    cfg.set_config({
      modes = {
        style = {
          css = {
            patterns = {
              {
                template = '{name}.{ext}',
                transform = { origin = 'pascal', target = 'kebab' },
              },
            },
            extensions = {
              target = { 'css' },
              origin = { 'tsx' },
            },
          },
        },
      },
    })

    assert.are.same({
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
    }, cfg.get_config().modes.style.css)
  end)

  it('supports mixed string and object patterns', function()
    cfg.set_config({
      modes = {
        style = {
          css = {
            patterns = {
              '{name}.{ext}',
              {
                template = '{name}.module.{ext}',
                transform = { origin = 'pascal', target = 'kebab' },
              },
            },
            extensions = { 'css' },
          },
        },
      },
    })

    local result = cfg.get_config().modes.style.css
    assert.are.same({ template = '{name}.{ext}' }, result.patterns[1])
    assert.are.same({
      template = '{name}.module.{ext}',
      transform = { origin = 'pascal', target = 'kebab' },
    }, result.patterns[2])
  end)
end)
