if vim.g.loaded_notepad_nvim then
  return
end
vim.g.loaded_notepad_nvim = true

vim.api.nvim_create_user_command("NotepadOpen", function()
  require("notepad").open()
end, { desc = "Open the session notepad" })

vim.api.nvim_create_user_command("NotepadClose", function()
  require("notepad").close()
end, { desc = "Close the session notepad" })

vim.api.nvim_create_user_command("NotepadToggle", function()
  require("notepad").toggle()
end, { desc = "Toggle the session notepad" })

vim.api.nvim_create_user_command("NotepadClear", function()
  require("notepad").clear()
end, { desc = "Clear the session notepad" })
