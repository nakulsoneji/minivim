local M = {}

function M.require_all(require_path)
  local paths
  if require_path == "" then
    paths = vim.split(vim.fn.glob('~/.config/' .. os.getenv("NVIM_APPNAME") .. '/lua/*.lua'), '\n')
  else
    paths = vim.split(vim.fn.glob('~/.config/' .. os.getenv("NVIM_APPNAME") .. '/lua/' .. require_path .. '/*.lua'), '\n')
  end

  -- Get the filenames and require them
  for _, path in ipairs(paths) do
    local path_split = vim.fn.split(path, '/')  --path is a string path_split is a table
    local file = string.gsub(path_split[#path_split], '%.lua?$', '')  -- trim off .lua\n
    if file ~= 'init' then
      require('plugins.' .. file)
    end
  end
end

return M
