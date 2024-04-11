local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local conf = require 'telescope.config'.values
local action_state = require 'telescope.actions.state'
local actions = require 'telescope.actions'
local sorters = require'telescope.sorters'


local open_output_in_buffer = function(output)
    -- Create a new buffer for the output
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(output, "\n"))
    
    -- Create a new window on the right side
    vim.cmd("vsplit")
    vim.api.nvim_win_set_buf(0, bufnr)
end

local function create_buffer()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, "*scratch*")
  vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
  return buf
end

local function main()
  -- print("Showcase::main")
end


local function ExecuteLine()
  local current_line = vim.api.nvim_get_current_line()
  local result = vim.fn.systemlist(current_line)

  if vim.v.shell_error ~= 0 then
    print("Error executing line: ", table.concat(result, "\n"))
  else
    print("Output: ", table.concat(result, "\n"))
  end
end

local execute_command = function(cmd)
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error == 0 then
    return table.concat(output, "\n")
  else
    return "Error executing command: " .. cmd
  end
end

local function Execute_line_picker()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    pickers.new({}, {
        prompt_title = "Execute Line",
        finder = finders.new_table({
            results = lines,
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry)
                -- Optional: Show something in the preview window, or you can choose to leave it blank
                -- For example, you might want to simply display the command that will be executed
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {"Command to execute:", entry.value})
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if not selection then return end
                local output = execute_command(selection.value)
                open_output_in_buffer(output)
            end)
            return true
        end,
    }):find()

end

local function setup()
  -- print("Showcase::Setup")
end

return { setup = setup, ExecuteLine = ExecuteLine, TelescopeExecuteList = Execute_line_picker }
