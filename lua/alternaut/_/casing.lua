local M = {}

--- Splits a string into words based on casing boundaries.
--- Handles camelCase, PascalCase, snake_case, kebab-case, and mixed formats.
--- @param str string
--- @return string[]
function M.split_words(str)
  local words = {}

  -- First, split on explicit delimiters (underscores, hyphens, spaces)
  local segments = {}
  for segment in str:gmatch('[^_%-  ]+') do
    table.insert(segments, segment)
  end

  -- Then split each segment on case boundaries
  for _, segment in ipairs(segments) do
    -- Handle transitions: lowercase->uppercase, uppercase->lowercase (for acronyms)
    local current_word = ''
    local prev_char_type = nil -- 'upper', 'lower', 'digit', 'other'

    for i = 1, #segment do
      local char = segment:sub(i, i)
      local char_type

      if char:match('%u') then
        char_type = 'upper'
      elseif char:match('%l') then
        char_type = 'lower'
      elseif char:match('%d') then
        char_type = 'digit'
      else
        char_type = 'other'
      end

      -- Start a new word on these transitions:
      -- 1. lower -> upper (camelCase boundary)
      -- 2. upper -> lower when current word has multiple uppercase chars (acronym end: HTTPServer -> HTTP + Server)
      local should_split = false

      if prev_char_type == 'lower' and char_type == 'upper' then
        should_split = true
      elseif
        prev_char_type == 'upper'
        and char_type == 'lower'
        and #current_word > 1
      then
        -- Split before the last uppercase char (e.g., "HTTPServer" -> "HTTP" + "Server")
        local last_char = current_word:sub(-1)
        current_word = current_word:sub(1, -2)
        if #current_word > 0 then
          table.insert(words, current_word)
        end
        current_word = last_char
        should_split = false
      end

      if should_split and #current_word > 0 then
        table.insert(words, current_word)
        current_word = ''
      end

      current_word = current_word .. char
      prev_char_type = char_type
    end

    if #current_word > 0 then
      table.insert(words, current_word)
    end
  end

  return words
end

--- Converts a string to kebab-case (lowercase with hyphens).
--- @param str string
--- @return string
function M.to_kebab(str)
  local words = M.split_words(str)
  local result = {}
  for _, word in ipairs(words) do
    table.insert(result, word:lower())
  end
  return table.concat(result, '-')
end

--- Converts a string to snake_case (lowercase with underscores).
--- @param str string
--- @return string
function M.to_snake(str)
  local words = M.split_words(str)
  local result = {}
  for _, word in ipairs(words) do
    table.insert(result, word:lower())
  end
  return table.concat(result, '_')
end

--- Converts a string to camelCase (first word lowercase, rest capitalized).
--- @param str string
--- @return string
function M.to_camel(str)
  local words = M.split_words(str)
  local result = {}
  for i, word in ipairs(words) do
    if i == 1 then
      table.insert(result, word:lower())
    else
      table.insert(result, word:sub(1, 1):upper() .. word:sub(2):lower())
    end
  end
  return table.concat(result, '')
end

--- Converts a string to PascalCase (all words capitalized).
--- @param str string
--- @return string
function M.to_pascal(str)
  local words = M.split_words(str)
  local result = {}
  for _, word in ipairs(words) do
    table.insert(result, word:sub(1, 1):upper() .. word:sub(2):lower())
  end
  return table.concat(result, '')
end

--- Map of transform names to their functions.
--- @type table<string, fun(str: string): string>
M.transforms = {
  kebab = M.to_kebab,
  snake = M.to_snake,
  camel = M.to_camel,
  pascal = M.to_pascal,
}

--- Get a list of all available transform names.
--- @return string[]
function M.get_transform_names()
  local names = {}
  for name, _ in pairs(M.transforms) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

return M
