-- Custom status line
-- format:
-- left: MODE | name | modified?
-- right: encoding | file type | total line numbers: line number: column
--
-- Color for the '[+]'
vim.api.nvim_set_hl(0, "StatusLineModified", { fg = "#f38ba8", bold = true })

local mode_map = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	R = "REPLACE",
	r = "PROMPT",
	["!"] = "SHELL",
	t = "TERMINAL",
	d = "DELETE",
}

IsModified = function()
  if vim.bo.modified then
    return "%#StatusLineModified# [+] %*"
  else
    return ""
  end
end

Mode = function()
	local mode = vim.api.nvim_get_mode().mode

	-- Check letter with hash map for example: n to NORMAL.
	-- If unreconized set to UNKNOWN
	local mode_name = mode_map[mode] or "UNKNOWN"

	return mode_name
end

FileName = function()
	local filepath = vim.fn.expand('%:~:.')
	if filepath == "" then
		filepath = "[No Name]"
	end
	return filepath
end

function Encoding()
  local encoding
  if vim.bo.fileencoding ~= "" then
	encoding = vim.bo.fileencoding
  else
	encoding = vim.o.encoding
  end
  return encoding
end

function Git()
  local branch = vim.fn.FugitiveHead()
  if branch == '' then
	return ''
  else
	return '       git(' .. branch .. ')'
  end
end

StatusLine = function()
  local left = string.format(' %s %s',
--    Mode(), -- disable mode for no
    FileName(),
    IsModified())

--  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or "utf-8"
  local encoding = Encoding()
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"

  local thing = string.format(' %d,%d %s',
    vim.fn.line('.'),
    vim.fn.col('.'),
	Git())

	local right = thing

  return left .. '%=' .. right
end

StatusSetup = function()
	vim.opt.statusline = "%!v:lua.StatusLine()"
	vim.opt.laststatus = 3
end

StatusSetup()
