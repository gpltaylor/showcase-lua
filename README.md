# Showcase
A Neovim plugin designed to help produce demos, presentations and showcases!

## Setup

```
return {
  dir = "gpltaylor/showcase-vim"
  name = "showcase",
  config = function ()
    local showcase = require('showcase')
    showcase.setup()
    vim.keymap.set("n", "<leader>px", function() showcase:TelescopeExecuteList() end, { desc = "Showcase: Execute lines using Teliscope"})
  end
}
```

Create a file with a list of commands you wish to execute during your presentation. Then run the command 

```
<leader>px
```

# Coming Soon
The goal is to extend this to provide over useful features that can be used during a presentation.


