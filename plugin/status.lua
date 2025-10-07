-- Custom status line
-- format:
-- left: MODE | name | modified?
-- right: encoding | file type | total line numbers: line number: column

-- Color for the '[+]' that pops up when you havnt saved a file
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

function Pos()
  local current = vim.fn.line('.')
  local total = vim.fn.line('$')

  if current == 1 then
    return 'Top'
  elseif current == total then
    return 'Bot'
  else
    return string.format('%d%%', math.floor((current / total) * 100))
  end
end

StatusLine = function()
  local left = string.format('%s | %s %s',
    Mode(),
    FileName(),
    IsModified())

  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or "utf-8"
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"

  local thing = string.format(' %d,%d ',
    vim.fn.line('.'),
    vim.fn.col('.'))

	local right = thing

  return left .. '%=' .. right
end

StatusSetup = function()
	vim.opt.statusline = "%!v:lua.StatusLine()"
	vim.opt.laststatus = 3
end

StatusSetup()
