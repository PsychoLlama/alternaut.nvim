local cfg = require('alternaut._.config')

describe('set_config', function()
  before_each(function()
    cfg.set_config()
  end)

  it('ensures required top-level fields exist', function()
    cfg.set_config({})

    assert.are.same({}, cfg.get_config().modes)
    assert.are.same({}, cfg.get_config().modes_by_ft)
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
      patterns = { '{name}_spec.{ext}' },
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
      patterns = { '{name}_spec.{ext}' },
      directories = { '.' },
      extensions = {
        target = { 'py' },
        origin = { 'py' },
      },
    }, cfg.get_config().modes.style.css)
  end)
end)
