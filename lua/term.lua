-- Terminal functions
vim.env.SHELL = "/bin/bash"

open_terminal_split = function()
  vim.cmd("split term://bash")
  vim.cmd("resize 15")
  vim.cmd("startinsert")
end

open_terminal_vsplit = function()
  vim.cmd("vsplit term://bash")
  vim.cmd("startinsert")
end

floating_term = nil

open_floating_terminal = function()
  if floating_term == nil then
    local buf = vim.api.nvim_create_buf(false, true)
    floating_term = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      col = math.floor(vim.o.columns * 0.1),
      row = math.floor(vim.o.lines * 0.1),
      style = 'minimal',
    })
    vim.cmd('term')
    vim.cmd('startinsert')
  else
    if vim.api.nvim_win_is_valid(floating_term) then
      vim.api.nvim_win_close(floating_term, true)
    end
    floating_term = nil
  end
end



function comment_selection(comment_string)
    local _, srow, scol, _ = unpack(vim.fn.getpos("'<"))
    local _, erow, ecol, _ = unpack(vim.fn.getpos("'>"))

    for i = srow, erow do
        local line = vim.fn.getline(i)
        vim.fn.setline(i, comment_string .. ' ' .. line)
    end
end

function uncomment_selection(comment_string)
    local _, srow, scol, _ = unpack(vim.fn.getpos("'<"))
    local _, erow, ecol, _ = unpack(vim.fn.getpos("'>"))

    for i = srow, erow do
        local line = vim.fn.getline(i)
        -- Remove the comment string if it exists at the start of the line
        vim.fn.setline(i, line:gsub('^' .. vim.pesc(comment_string) .. '%s?', ''))
    end
end



-- Key mappings
vim.api.nvim_set_keymap('n', 'th', ':lua open_terminal_split()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tv', ':lua open_terminal_vsplit()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tt', ':lua open_floating_terminal()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', 'cc', [[:lua comment_selection('//')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'ch', [[:lua comment_selection('#')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'cm', [[:lua comment_selection('--')<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', 'uc', [[:lua uncomment_selection('//')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'um', [[:lua uncomment_selection('--')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'uh', [[:lua uncomment_selection('#')<CR>]], { noremap = true, silent = true })

