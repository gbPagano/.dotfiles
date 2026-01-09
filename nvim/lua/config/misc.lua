vim.filetype.add({
  extension = {
    gitconfig = "gitconfig",
  },
  filename = {
    [".gitconfig"] = "gitconfig",
    ["gitconfig"] = "gitconfig",
  },
})
