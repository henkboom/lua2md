--- lua2md
--- ======
---
--- Fun and braindead code documentation. Reads in annotated [lua][1] code and
--- writes out [markdown][2]-formatted documentation. lua2md is documented
--- using itself ;p
---
--- [1]: http://www.lua.org/
--- [2]: http://daringfireball.net/projects/markdown/
---
--- Documenting Code
--- ----------------
---
--- Documentation lines start with `---` followed by a space, except when they
--- are blank lines, in which case you don't need the space. Documentation
--- lines are run through markdown and output directly. Code (everything that's
--- not documentation) is converted into markdown code blocks.
---
---     --- This is a documentation line and will be converted to markdown
---     --- paragraphs
---     This is code which is output as a code block.
---
--- Code blocks have leading and trailing blank lines removed, and code blocks
--- which end up being empty are not output.
---
--- For example, the following:
---
---     --- Empty code blocks
---     
---     
---     --- are omitted.
---
--- outputs as
---
--- > Empty code blocks
--- >
--- > are omitted.
---
--- Note that although the code block is not shown, the break in documentation
--- still acts as a paragraph break.

--- Implementation
--- --------------

--- ### doc(line)
--- If `line` contains documentation, then returns the markdown to output,
--- otherwise returns `false`.
function doc(line)
  return line:match('^%-%-%- (.*)$') or line:match('^%-%-%-$') and ""
end

--- ### code(line)
--- If `line` contains code, then returns the markdown to output, otherwise
--- returns `false`.
function code(line)
  return not doc(line) and '    ' .. line
end

--- ### is_blank(line)
--- Returns `true` if `line` is a blank line, `false` otherwise.
function is_blank(line)
  return line:match('^%s*$') and true
end

--- ### parse_doc(line)
--- Parses a documentation block.
function parse_doc(line)
  local docline = doc(line)
  while docline do
    print(docline)
    line = io.read()
    if not line then return end
    docline = doc(line)
  end
  print()
  return parse_code(line)
end

--- ### parse_code(line)
--- Parses a code block.
function parse_code(line)
  while is_blank(line) do
    line = io.read()
    if not line then return end
  end

  local blanks = {}
  local codeline = code(line)
  while codeline do
    if is_blank(codeline) then
      table.insert(blanks, codeline)
    else
      if #blanks ~= 0 then
        print(table.concat(blanks, '\n'))
        blanks = {}
      end
      print(codeline)
    end

    line = io.read()
    if not line then return end
    codeline = code(line)
  end
  print()
  return parse_doc(line)
end

--- ### initialization
--- Tests whether the lua document starts with documentation or code, then
--- starts the corresponding parser.
local line = io.read()
if not line then return end
if doc(line) then
  parse_doc(line)
else
  parse_code(line)
end

--- totally written by [henk](http://henk.ca/)
