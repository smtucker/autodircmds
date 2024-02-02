local M = {}

M.config = {}

local function create_autocmds(event, path, commands)
	if type(commands) ~= "table" then
		commands = { commands }
	end

	for _, cmd in ipairs(commands) do
		local cmd_table = { pattern = path }
    cmd_table.group = M.augroup
		if type(cmd) == "string" then
			cmd_table.command = cmd
		elseif type(cmd) == "function" then
			cmd_table.callback = cmd
		else
			error("Wrong command type for " .. path .. ": " .. type(cmd))
		end
		vim.api.nvim_create_autocmd({ event }, cmd_table)
	end
end

local function parse_path_config(dir)
	local path = dir[1] or dir.path
	path = vim.fn.expand(path)
	if path:sub(-1) == "/" then
		path = path .. "*"
	elseif path:sub(-2) ~= "/*" then
		path = path .. "/*"
	end

	if not path then
		vim.notify("No path specified for autocmds")
		return
	end

	if dir.postwrite then
		create_autocmds("BufWritePost", path, dir.postwrite)
	end

	if dir.preopen then
		create_autocmds("BufReadPre", path, dir.preopen)
	end
end

function M.disable()
  vim.api.nvim_del_augroup_by_id(M.augroup)
  M.augroup = nil
end

function M.run_without(cmd, ...)
  if not M.augroup then
    error("AutoDirCmds is not enabled")
    return
  end
  M.disable()
  if type(cmd) == "function" then
    cmd(...)
  else
    vim.cmd(cmd)
  end
  M.setup()
end

function M.setup(user_opts)

	M.config = vim.tbl_deep_extend("force", M.config, user_opts or {})

  M.augroup = vim.api.nvim_create_augroup("AutoDirCmds", {clear = true})

	if M.config.dirs then
		for _, dir in ipairs(M.config.dirs) do
			parse_path_config(dir)
		end
	end
end

return M
